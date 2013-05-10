require 'rubygems'
require 'ruby_parser'
require 'sexp_processor'
require 'active_support/inflector'
require 'optparse'
require_relative 'alloy_spec_dynamic'


class MyProcessor < SexpProcessor
	@@alloy_spec = AlloySpecDynamic.new
	@@idgen = 0								 

	def initialize
		super
		@require_empty = false  #it's okay to not process entire parse tree  (just first class encountered)
	end

	def self.print_alloy_spec( property, bound, outfile )
		@@alloy_spec.print_spec( property, bound, outfile )
	end 
	
	def process_class(exp)
		unless @class_called_already then  # only process the first class encountered
			@class_called_already = true
			classs = exp.shift
			class_name = exp.shift
			parentclass = exp.shift
			body = exp.shift
			
			@classname = class_name.to_s
			@@alloy_spec.classes.push(@classname)
			@@alloy_spec.relation_classes[@classname] = []
			@@alloy_spec.relations[@classname] = []
			@@alloy_spec.deletion_info[@classname] = []
			@@alloy_spec.throughrel_info[@classname] = []
			@@alloy_spec.condition_sigs[@classname] = []
			@@alloy_spec.sig_defs[@classname] = ["", ""]

			process(parentclass)			
			@const_called_already = true
			process(body)

			return s(classs, @classname, parentclass, body)
		end
		return exp
	end
	
	def process_const(exp)
		if not @class_called_already
			return exp
		end

		unless @const_called_already   # only process the first class encountered
			@const_called_already = true
			const = exp.shift
			parent_classname = exp.shift
			
			if parent_classname == :ActiveRecord
				@@alloy_spec.sig_defs[@classname][0] = BASE_CLASS
			else
				@parent_classname = parent_classname.to_s 
				@@alloy_spec.sig_defs[@classname] [0] = @parent_classname				
			end
			
			return s(const, parent_classname)
		end
		return exp
	end
	
	def process_call(exp)
		if not @class_called_already
			return exp
		end
		
		call = exp.shift
		param2 = exp.shift
		type = exp.shift
		arglist = exp.shift
		
		if REL_CARDNLTY.has_key?(type)
			@get_relname = true   # process the first lit you come across to get the relation name
			process(arglist)	
			
			relclassname = @specified_classname  # :class_name option is set
			@specified_classname = nil
			if not relclassname #or @conditions_set
				relclassname = @relname.singularize.camelize
			end
		
			if @conditions_set
				@conditions_set = false
				orig_relclassname = relclassname.dup
				relclassname << "_" << @@idgen.to_s
				@@idgen += 1					
				@@alloy_spec.condition_sigs[@classname] << [relclassname, "sig " + relclassname + " in " + orig_relclassname + " { } \n"]
				@@alloy_spec.conditionals[relclassname] = orig_relclassname
				@@alloy_spec.global_factblock << [[relclassname, @classname], @classname.downcase, type] if not @polymorphic_class
			end
				
			if @polymorphic_class		# :as option set, so this is a polymorphic relation
				@@alloy_spec.polymorphic_fact_block << "\t" << @classname<< " in " << @polymorphic_class << "\n"
				
				if @@alloy_spec.polymorphic_classes.has_key?(@polymorphic_class)
					@@alloy_spec.polymorphic_classes[@polymorphic_class].push(@classname)
				else
					@@alloy_spec.polymorphic_classes[@polymorphic_class] = [@classname]
					@@alloy_spec.global_factblock << [[@polymorphic_class, relclassname], @relname, type]
				end
				
				if not @@alloy_spec.polymorphic_sigs.has_key?(@polymorphic_class)
					@@alloy_spec.polymorphic_sigs[@polymorphic_class] = @relname + "': " + REL_CARDNLTY[type] + relclassname	
				end
				@polymorphic_class = nil
							
			else # not polymorphic relation
				if @polymorphic_set   # this is a belongs_to relation with the :polymorphic option set; need to
					@polymorphic_set = false
					@@alloy_spec.polymorphic_option_classes.push(relclassname)  # need to accumulate these polymorphic class names in case there's no corresponding :as option set in any class
				end

				if @hm_thru  # :through option set
					@@alloy_spec.throughrel_info[@classname]  << [@relname, @hm_thru, relclassname]				
					@hm_thru = nil
				else
					@@alloy_spec.global_factblock << [[@classname, relclassname], @relname, type]
				end
				
				@@alloy_spec.sig_defs[@classname][1] << "\t" + @relname + ": set " + relclassname + ",\n"					
				@@alloy_spec.relation_classes[@classname] << relclassname  # save which classes this class has a relation with
				@@alloy_spec.relations[@classname] << [relclassname, @relname]  # save all the relations of this class
			end
			
			if @delete_option
				@@alloy_spec.deletion_info[@classname] << [@delete_option, relclassname, @relname]
				@delete_option = false
			end
			
		end
		
		return s(call, param2, type, arglist)
	end
	
	def process_lit(exp)
		if not @class_called_already
			return exp
		end
		
		lit = exp.shift
		name = exp.shift
	
		if @get_relname
			@relname = name.to_s  # save varname in @relname for process_call() to use
			@get_relname = false
		elsif @get_hmthru
			@hm_thru = name.to_s
			@get_hmthru = false
		elsif @as_set
			@polymorphic_class = name.to_s.capitalize
			@as_set = false		
		elsif @dependent_set
			if name == :destroy
				@delete_option = DESTROY				
			elsif name == :delete or name == :delete_all
				@delete_option = DELETE
			end
			@dependent_set = false
		elsif name == :through
			@get_hmthru = true
		elsif name == :conditions
			@conditions_set = true
		elsif name == :class_name			
			@get_classname = true
		elsif name == :as
			@as_set = true
		elsif name == :polymorphic
			@polymorphic_set = true
		elsif name == :dependent
			@dependent_set = true
		end
		
		return s(lit, name)
	end
	
	def process_str(exp)
		if not @class_called_already
			return exp
		end
		
		key = exp.shift
		str = exp.shift
		if @get_classname			
			@get_classname = false
			@specified_classname = str
		end
		
		return s(key, str)
	end

end # end-class MyProcessor
 
 
 if __FILE__ == $0 then
	  # Variables
	options = {} 
	model_directory = nil
        start_directory = Dir.getwd

	 
	# Set up OptionParser
	optparser = OptionParser.new do|opts|
		opts.banner = "Usage: ruby #{$0} [options] path\\to\\models\\folder"
			"\n  This program translates a Ruby on Rails data model"
			"\n  to an Alloy specification." 
		 
		# Define the options								
		options[:outfile] = nil
		opts.on( '-o', '--output FILE', 'The name of the file to write Alloy specification to' ) do |file|
		     options[:outfile] = file
		end
	
		# This displays the help screen
		opts.on( '-h', 'Display this screen' ) do
			puts opts
			exit
		end
	end
	
	# Parse options off of command line
	optparser.parse!
	
	
	 # Get models folder
	if ARGV.length == 1  #model directory should be the only thing left on the command line
		model_directory = ARGV[0]
	else
		puts "  Tool invoked incorrectly.  Use the -h option for more information."
		exit
	end
	
	
	
 	 # Navigate to models folder
	 begin
		 Dir.chdir(model_directory)
	 rescue SystemCallError => e
		print "Error navigating to directory: " + e.to_s + "\n"
		exit
	end
	
	 # Process each model file in the models folder
	 Dir.foreach(".") do |filename| 
		if filename=~ /\.rb$/ and File.file?(filename) then
			# Get contents of model files
			file = File.open(filename, 'r')
			file_contents = ""
			file.each {|line| file_contents << line }
			file.close

			# Parse and Translate
			s_exp = RubyParser.new.parse file_contents
			# print s_exp  # print the s-expression generated
			MyProcessor.new.process(s_exp)
		end
	end	
	Dir.chdir start_directory
	
	split_property = nil  # ignore this feature
	
	MyProcessor.print_alloy_spec( split_property, nil, options[:outfile] )

end
