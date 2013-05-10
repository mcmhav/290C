require 'logger'

DELETE = 0
DESTROY = 1
BASE_CLASS = "ActiveRecord"
REL_CARDNLTY = {:belongs_to => "one", :has_one => "lone", :has_many => "set", :has_and_belongs_to_many => "set"}
		
class AlloySpecDynamic
	attr_accessor :sig_defs, :condition_sigs, :throughrel_info, :global_factblock,
	:polymorphic_sigs, :polymorphic_fact_block, :classes, :conditionals, :relation_classes, 
	:relations, :polymorphic_classes, :polymorphic_option_classes, :deletion_info
	
	def initialize
		#@log = Logger.new(STDERR)
		# Use the following to create a log file rather than printing to stderr
		file = open('railsAR2alloy.log', File::WRONLY | File::APPEND | File::CREAT)
		@log = Logger.new(file)

		@sig_defs = {}  # @sig_defs[sig_name] => sig_definition
		@condition_sigs = {}  # @condition_sigs[sig_containing_condition] => condition_sig_definitions
		@throughrel_info = {} # @throughrel_info[sig_name] => [[local_var, thru_var, target_classname],... ]
							# so printing: local_var = thru_var.thru_class_var
		@global_factblock = []  # tuples like [[classA, classB], varnameB, cardinality] to represent:
							#  classA belongs_to varnameB (where varnameB is of type classB)
		@polymorphic_sigs = {}  # definitions of polymorphic sigs
		@polymorphic_classes = {}  	# @polymorphic_classes[PolyClass] = array of classes that have a polymorphic 
								#   relation with PolyClass
		@polymorphic_classinv = {} # inverse of @polymorphic_classes, i.e. maps a class to all its polymorphic superclasses
		@polymorphic_fact_block = ""  # list of "\tClass in PolyClass\n" strings
		@polymorphic_option_classes = []  # list of polymorphic classes that have a belongs_to relation with the :polymorphic option set
		@classes = []  # list of all model classes
		@conditionals = {}  #@hash[conditional_subclass] = parent class (maps a conditonal subclass to its parent)
		@relation_classes = {}  # @relation_classes[class] = array of classes with which the key class has a relation with
		@relations = {}  # @relations[class] = array of tuples like [relation_class, relation_name] --> the class name along with the relation variable name		
		@deletion_info = {}		# @deletion_info[Class] stores whether any associated objects also need to be deleted when an object of this Class is deleted
							 #  Based on whether :dependent option is set on the association (relation)
							 # [[delete_option, relation_class, relation_variablename],...]
		@out = nil		# file to output to
	end
	
	
	def print_spec( property, bound, outfile )
		set_output( outfile )
		print_preprocessing
		print_sigs
		print_global_factblock
		print_delete_preds	
		print_property( property, bound ) if property
	end
	
	
	private # all methods that follow are private
	
	def set_output( outfile )
		@out = outfile ? File.new(outfile, "w") : $stdout
	end
	
	def print_property( property, bound )
		
		if property[0] == "alwaysRelated"
			
			classA = property[1]
			classB = property[2]
			switched = false
			
			relname = @class_rels[ [classA, classB] ]
			if not relname
				relname = @class_rels[ [classB, classA] ]
				switched = true
			end
			if not relname
				puts "Error: Could not find a relation between specified classes " +
					"(#{classA} and #{classB})."
				return false
			end
			#elsif (num_matches > 1)
			#	puts "WARNING: Ambiguity encountered about which relation " + 
			#		"this property is referring to.  Randomly choosing one..."
			#end
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, a: #{classA} | some b: #{classB} | "
			
			if not switched
				@out.print "(a.(s.#{relname}) = b)\n"  
				# use "in" keyword instead of "=" if don't want to say "exactly one"
			else
				@out.print "(b.(s.#{relname}) = a)\n"
			end
			@out.print "}\ncheck prop for #{bound}"
		
				
		elsif property[0] == "someUnrelated"
		
			classA = property[1]
			classB = property[2]
			switched = false
			
			relname = @class_rels[ [classA, classB] ]
			if not relname
				relname = @class_rels[ [classB, classA] ]
				switched = true
			end
			if not relname
				puts "Error: Could not find a relation between specified classes " +
					"(#{classA} and #{classB})."
				return false
			end
			
			@out.print "\n\n"
			@out.print "pred prop {\n"
			@out.print "\tall s: PreState | some a: #{classA} | all b: #{classB} | "
			
			if not switched
				@out.print "(b not in a.(s.#{relname}))\n"
			else
				@out.print "(a not in b.(s.#{relname}))\n"
			end
			@out.print "}\nrun prop for #{bound}"
			
					  
		elsif property[0] == "transitive"
				
			classA = property[1]
			classB = property[2]
			classC = property[3]
			switched1 = false
			switched2 = false
			switched3 = false
			
			relname1 = @class_rels[ [classA, classB] ]
			if not relname1
				relname1 = @class_rels[ [classB, classA] ]
				switched1 = true
			end
			relname2 = @class_rels[ [classB, classC] ]
			if not relname2
				relname2 = @class_rels[ [classC, classB] ]
				switched2 = true
			end
			relname3 = @through_rels[[classA, classC]]
			if not relname3
				relname3 = @through_rels[[classC, classA]]
				switched3 = true
			end
			if not relname3
				relname3 = @class_rels[ [classA, classC] ]
				switched3 = false
			end
			if not relname3
				relname3 = @class_rels[ [classC, classA] ]
				switched3 = true
			end
			if not relname1 or not relname2 or not relname3
				puts "Error: Could not find a relations between specified classes " +
					"(#{classA}, #{classB} and #{classC})."
				return false
			end
			
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, a: #{classA}, b: #{classB}, c: #{classC} | \n"
			@out.print "\t(( "
			if not switched1
				@out.print "(b in a.(s.#{relname1}))"  
			else
				@out.print "(a in b.(s.#{relname1}))"
			end
			@out.print " and "
			if not switched2
				@out.print "(c in b.(s.#{relname2}))"  
			else
				@out.print "(b in c.(s.#{relname3}))"
			end
			@out.print " ) =>\n"
			@out.print "\t "
			if not switched3
				@out.print "(c in a.(s.#{relname3}))"  
			else
				@out.print "(a in c.(s.#{relname3}))"
			end
			@out.print " )\n"
			@out.print "}\ncheck prop for #{bound}"	


	elsif property[0] == "noOrphans"
			
			classA = property[1]
			classB = property[2]
			switched = false
			
			relname = @class_rels[ [classA, classB] ]
			if not relname
				relname = @class_rels[ [classB, classA] ]
				switched = true
			end
			if not relname
				puts "Error: Could not find a relation between specified classes " +
					"(#{classA} and #{classB})."
				return false
			end
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, s': PostState, a: #{classA} | \n"
			@out.print "\t    delete#{classA}[s, s', a] => "
			if not switched
				@out.print "a.(s.#{relname}) not in s'.#{classB.downcase.pluralize}'\n"
			else
				@out.print "(s.#{relname}).a not in s'.#{classB.downcase.pluralize}'\n"
			end
			@out.print "}\ncheck prop for #{bound}"
			
			  
		elsif property[0] == "noDangling"
			
			classA = property[1]
			classB = property[2]
			switched = false
			
			relname = @class_rels[ [classA, classB] ]
			if not relname
				relname = @class_rels[ [classB, classA] ]
				switched = true
			end
			if not relname
				puts "Error: Could not find a relation between specified classes " +
					"(#{classA} and #{classB})."
					puts @class_rels
				return false
			end
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, s': PostState, a: #{classA} | \n"
			@out.print "\t    delete#{classA}[s, s', a] => "
			if not switched
				@out.print "( (s'.#{relname}').(s'.#{classB.downcase.pluralize}') "
				@out.print "in s'.#{classA.downcase.pluralize}' )\n"  
			else
				@out.print "( (s'.#{classB.downcase.pluralize}').(s'.#{relname}') "
				@out.print "in s'.#{classA.downcase.pluralize}' )\n"  
			end
			@out.print "}\ncheck prop for #{bound}"
			
		
		elsif property[0] == "deletePropagates2"
				
			classA = property[1]
			classB = property[2]
			classC = property[3]
			switched1 = false
			switched2 = false
			
			relname1 = @class_rels[ [classA, classB] ]
			if not relname1
				relname1 = @class_rels[ [classB, classA] ]
				switched1 = true
			end
			relname2 = @class_rels[ [classB, classC] ]
			if not relname2
				relname2 = @class_rels[ [classC, classB] ]
				switched2 = true
			end
			if not relname3
				relname3 = @class_rels[ [classC, classA] ]
				switched3 = true
			end
			if not relname1 or not relname2
				puts "Error: Could not find a relations between specified classes " +
					"(#{classA}, #{classB} and #{classC})."
				return false
			end
			
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, s': PostState, a: #{classA}, "
			@out.print "b: #{classB}, c: #{classC} | \n"
			@out.print "\t  ( delete#{classA}[s, s', a] and "
			if not switched1
				@out.print "(b in a.(s.#{relname1}))"  
			else
				@out.print "(b in (s.#{relname1}).a)"
			end
			@out.print " and "
			if not switched2
				@out.print "(c in b.(s.#{relname2}))"  
			else
				@out.print "(c in (s.#{relname3}).b)"
			end
			@out.print " ) =>\n"
			@out.print "\t   (c not in s'.#{classC.downcase.pluralize}')\n"
			@out.print "}\ncheck prop for #{bound}"	
			
		
		elsif property[0] == "deletePropagates"
			
			classA = property[1]
			classB = property[2]
			relname = nil			
			switched = false
			
			relname = @class_rels[ [classA, classB] ]
			if not relname
				relname = @class_rels[ [classB, classA] ]
				switched = true
			end
			if not relname
				puts "Error: Could not find a relations between specified classes " +
					"(#{classA} and #{classB})."
				return false
			end
			
			
			@out.print "\n\n"
			@out.print "assert prop {\n"
			@out.print "\tall s: PreState, s': PostState,"
			@out.print " a: #{classA}, b: #{classB} | \n"
			@out.print "\t  ( delete#{classA}[s, s', a] and "
			if not switched
				@out.print "(b in a.(s.#{relname}))"  
			else
				@out.print "(b in (s.#{relname}).a)"
			end
			@out.print " ) =>\n"
			@out.print "\t   (b not in s'.#{classB.downcase.pluralize}')\n"
			@out.print "}\ncheck prop for #{bound}"	
		end
		
	end
	
	
	# If 'hash' doesn't contain 'key' then sets 'hash[key] = value'
	#  Else concatenates 'value' (using '<<') to existing entry
	def hash_add (hash, key, value)
		if hash.has_key? key
			hash[key] << value
		else
			hash[key] = value
		end
	end
	
	
	def print_preprocessing
		# Pre-processing using @throughrel_info
		#  cuz got to go into the target class and see what the name of the actual 
		#  variable name is (i.e. is it singular or plural)
		
		@through_relations_pre = ""	  # text 
		@through_relations_post = ""
		@through_rels = {}  # store through relation names (@throug_rels[[classA, classB]] = relname)
		thru_var_classname = ""
		targetclass_var = ""
			
		@throughrel_info.keys.each do |klass|			
			class_rels = @relations[klass]  #relation names and their classes
			class_names = (class_rels.transpose)[0]  #just the relation classes
			rel_names = (class_rels.transpose)[1]  #just the relation names
			
			@throughrel_info[klass].each do |thru_rel| 
				local_var = thru_rel[0]
				thru_var = thru_rel[1]				
				thruvar_index = rel_names.index(thru_var)
				if thruvar_index.nil?
					@log.error("Error 1 while setting up transitive relation for " + klass + " (relation: " + local_var + ") in local factblock ")
					next
				end				
				thruvar_classname = class_names.at(thruvar_index)
				thruclass_rels = @relations[thruvar_classname]  #relation names and their classes	

				print "\n"
				print "\n"
				
				if thruclass_rels.nil? # 'thruvar_classname' was a conditional subclass
					print thruvar_classname
					print "\n"
					print "NIL!-------------------------"
					print "\n"
					thruclass_rels = @relations[ @conditionals[thruvar_classname] ]
					print thruclass_rels
					print "\n"
				end

				print "\n"
				print "\n"

				thruclass_rels = (thruclass_rels.transpose)[1]  #just the relation names
				
				if thruclass_rels.include?(local_var.singularize)
					targetclass_var = local_var.singularize
				elsif thruclass_rels.include?(local_var.pluralize)
					targetclass_var = local_var.pluralize
				else					
					@log.error("Error 2 while setting up transitive relation for " + klass + " (relation: " + local_var + ") in local factblock ")
					next
				end
				
				#Finding and creating the :through relations.
				
				#Setup:
				# ClassA
				#  -relationA, typeof classB
				#  -thru_relation:, typeof classC
				#
				# ClassB
				#  -relationB, typeof classA
				#  -relationB2, typeof classC
				# 
				# ClassC
				#  -relationC, typeof classB
				
				classA = klass
				relationA = thru_var
				thru_relationA = local_var
				classB = thruvar_classname
				relB_candidates = @global_factblock.select {|r| r[0] == [classB, classA] } # [[classB, classA], varnameA, cardinality],...]				
				relationB2 = targetclass_var
				classC = local_var.singularize.camelize
				relC_candidates = @global_factblock.select {|r| r[0] == [classC, classB] } 				
				
				if relB_candidates == nil or relB_candidates[0] == nil or relC_candidates == nil or relC_candidates[0] == nil
					@log.error("Error 3 while setting up transitive relation for " + klass + " (relation: " + local_var + ")")
					next
				end

				relationB = relB_candidates[0][1]  #assume first one found, altho there should only be one
				relationC = relC_candidates[0][1]  #assume first one found, altho there should only be one


				relB_A = relationB.singularize < relationA.singularize ? relationB + "_" + relationA : "~(" + relationA + "_" +relationB + ")"
				relC_B2 = relationC.singularize < relationB2.singularize ? relationC + "_" + relationB2 : "~(" + relationB2 + "_" +relationC + ")"
				thru_relation_pre  = "\t" +  classA + "_" + thru_relationA + " = " + 
					relB_A + "." + relC_B2 + ",\n"   #thru_relation = relationB_relationA.relationC_relationB2
					
				relB_A = relationB.singularize < relationA.singularize ? relationB + "_" + relationA + "'" : "~(" + relationA + "_" +relationB + "')"
				relC_B2 = relationC.singularize < relationB2.singularize ? relationC + "_" + relationB2 + "'" : "~(" + relationB2 + "_" +relationC + "')"
				thru_relation_post  = "\t" +  classA + "_" + thru_relationA + "' = " + 
					relB_A + "." + relC_B2 + ",\n" 
					
				@through_relations_pre << thru_relation_pre
				@through_relations_post << thru_relation_post
				@through_rels[[classA, classC]] = classA + "_" + thru_relationA
			
			end
		end	
		
		#Pre-processing of polymorphic classes
		#   If there are any classes containing a :belongs_to relation with the :polymorphic option set
		#   (i.e. a polymorphic interface has been created) but no there are no classes with a 
		#   corresponding :as option set in another class (i.e. there are no classes using the interface)
		#   then make sure to print it by adding it to @polymorphic_sigs  
		#   (the railsAR2alloy translator only adds those that actually have corresponding :as option set)
		@polymorphic_option_classes.each do |poly_class|
			if not @polymorphic_sigs.has_key?(poly_class)
				@polymorphic_sigs[poly_class] = ""
			end
		end
		
	end #print_preprocessing()


	def print_sigs
		# Begin printing
		@out.print "abstract sig " + BASE_CLASS + " { } \n"
		
		#print normal sigs
		complete_class_list = []
		classes_to_delete = []
		@state_rels_list = []   # list of relation names in the State sig
		@state_rels_LHS = {}
			# @state_rels_LHS[classname] = [rel1, rel2, ...] --> all relations with 'classname' as LHS
		@state_rels_RHS = {}
			# @state_rels_RHS[classname] = [rel1, rel2, ...] --> all relations with 'classname' as RHS
		@class_rels = {}  
			# @class_rels[[classA, classB]] = relname --> 1st relation encountered btw classA and classB
		@rels_class = {}
			# @rels_class[relname] = [classA, classB] --> maps a relation to its classes
			
			
		@classes.each do |klass|			
			parentclass = @sig_defs[klass][0]
			#print only ActiveRecord classes
			if parentclass != BASE_CLASS and not @classes.include?(parentclass)
				classes_to_delete.push(klass)
				next
			end
			
			#print sig definition
			@out.print "sig " + klass.to_s + " extends " + parentclass + " { }\n"
			complete_class_list.push(klass.to_s)
			
			#print sigs corresponding to :condition option
			@condition_sigs[klass].each do |sig|	
				@out.print sig[1]
				complete_class_list.push( sig[0] )
			end
		end
		
		#update @classes to reflect active classes
		classes_to_delete.each { |c| @classes.delete(c) }
		
		#print polymorphic sigs
		@polymorphic_sigs.each do |polyclass, relation|
			@out.print "sig ", polyclass, " in ActiveRecord { }\n"
			complete_class_list.push(polyclass)
		end
		
		#print State sigs
		@out.print "\none sig PreState { \n"
		postStatesig = "one sig PostState { \n"
		complete_class_list.each do |klass|
			@out.print "\t", klass.downcase.pluralize, ": set ", klass, ", \n"
			postStatesig << "\t" << klass.downcase.pluralize << "': set " << klass << ", \n"
		end
		@out.print "\n"
		postStatesig << "\n"
		
		#print relations	
		normal_relations = @global_factblock.clone  # create a copy that we can destroy
				#@global_factblock = []  # tuples like [[classA, classB], varnameB, cardinality]
		belto_relations = []  # processed belongs_to relations; stored in case multiple conditional relations with it

		while elem = normal_relations.pop do
			
			matching_elem = normal_relations.delete normal_relations.assoc(elem[0].reverse)
			if elem[2] == :belongs_to
				belto_relations.push elem
			end
			
			if matching_elem.nil? and @conditionals.has_key? elem[0][0]
				elem00 = @conditionals[ elem[0][0] ]
				matching_elem = normal_relations.assoc [elem[0][1], elem00]
				if matching_elem.nil?
					matching_elem = belto_relations.assoc [elem[0][1], elem00]
				end
				if not matching_elem.nil? and @polymorphic_option_classes.include? elem[0][1]
					# necessary??  (TODO)
				end
			elsif matching_elem.nil? and @conditionals.has_key? elem[0][1]
				elem01 = @conditionals[ elem[0][1] ]
				matching_elem = normal_relations.assoc [elem01, elem[0][0]]
				if matching_elem.nil?
					matching_elem = belto_relations.assoc [elem01, elem[0][0]]
				end
				if not matching_elem.nil? and @polymorphic_option_classes.include? elem[0][0]
					elem[1] = elem01.downcase
					elem[1].pluralize if elem[2] == :has_many
				end
			end

			if matching_elem.nil? and elem[2] == :belongs_to  and @polymorphic_option_classes.include? elem[0][1]
				next  # okay to have no matching element with a polymorphic :belongs_to relation
			elsif matching_elem.nil? and elem[2] == :belongs_to  
				# this is a belongs_to relation missing the matching has_many (the default)
				matching_elem = [elem[0].reverse, elem[0][0].downcase.pluralize, :has_many]
			end
			
			if matching_elem.nil?
				@log.warn("Warning: Failed to find a matching relation for " + elem[0][0] +  "." + elem[1] + " in " + elem[0][1])
			else		
				if matching_elem[2] == :belongs_to
					belto_relations.push matching_elem
				end
				
				rel_name = elem[1] + "_" + matching_elem[1]
				class1 = matching_elem[0][0]
				cardnlty1 = REL_CARDNLTY[matching_elem[2]]
				class2 = elem[0][0]
				cardnlty2 = REL_CARDNLTY[elem[2]]
				
				@out.print "\t",  rel_name, ": ", class1, " ", cardnlty2, " -> ", cardnlty1, " ", class2, ",\n"
				postStatesig << "\t" <<  rel_name << "': " << class1 << " set -> set " << class2 << ",\n"
				
				@state_rels_list << rel_name 
				@state_rels_LHS[class1] ?  @state_rels_LHS[class1] << [matching_elem[2], rel_name] : @state_rels_LHS[class1] = [[matching_elem[2], rel_name]] 
				@state_rels_RHS[class2] ? @state_rels_RHS[class2] << [elem[2], rel_name] : @state_rels_RHS[class2] = [[elem[2], rel_name]]
				@class_rels[ [class1, class2] ] = rel_name  if not @class_rels[ [class1, class2] ]
				@rels_class[ rel_name ] = [class1, class2]
			end
		end	
		
		@out.print "\n", @through_relations_pre, "}"
		postStatesig << "\n" << @through_relations_post << "}"
		
		# print local factblock stating Prestate points to all objects in world 
		@out.print "{\n"
		complete_class_list.each do |klass|
			@out.print "\tall x: ", klass, " | x in ", klass.downcase.pluralize, "\n"
		end	
		@out.print "}\n\n"
		
		@out.print postStatesig, "\n\n"
		
	end
	
	
	def print_global_factblock
		@classes.each do |c|  # initialize @polymorphic_classinv
			@polymorphic_classinv[c] = []
		end
		
		return if @polymorphic_fact_block.empty?
		
		@out.print "fact {   \n"
		
		#print polymorphic association-related facts
		@out.print @polymorphic_fact_block   #multiple inheritance part, to make polymorphic rels possible
		polyvarid = 0
		@polymorphic_classes.each do |polyclass, relatedclasses|
			relatedclasses.each do |r| #populate @polymorphic_classinv
				@polymorphic_classinv[r].push polyclass
			end
			
			polyval = "x" + polyvarid.to_s
			polyvarid  += 1
			
			# to make Polyclass empty (objects instantiated are of child classes only)
			@out.print "\tall ", polyval, ":", polyclass, " | "
			relatedclasses.each do |relclass|
				@out.print polyval, " in ", relclass
				if relclass != relatedclasses.last
					@out.print " or "
				end
			end
			@out.print "\n"
			
			# to make Polyclass disjoint from from all other objects in ActiveRecord
			@classes.each do |aclass|  
				if not relatedclasses.include?(aclass)
					@out.print "\tno ", aclass, " & ", polyclass, "\n"
				end
			end
		end
		
		@out.print "}   \n"		
	end
	
	
	def print_delete_preds	
		@classes.each do |aclass|
			#if not ["Note", "Property", "Owner", "RentableItem", "Tenant", "Unit", "User", "WorkOrder"].include?(aclass)
			#	next
			#end
			
			@vars_to_delete = {}  #related objects to delete, i.e. vars_to_delete[relation_class] = relation_variableName
			@rels_to_delete = {}
			
			@out.print "\npred delete", aclass, " [s: PreState, s': PostState, x:", aclass, "] { \n"

			# initialize @rels_to_delete
			if @state_rels_LHS[aclass]
				@state_rels_LHS[aclass].each do |rel|
					if rel[0] ==:belongs_to or rel[0] == :has_and_belongs_to_many						
						hash_add @rels_to_delete, rel[1], " - (x <: s." + rel[1] + ")"
					end
				end
			end			
			if @state_rels_RHS[aclass]
				@state_rels_RHS[aclass].each do |rel|
					if rel[0] ==:belongs_to or rel[0] == :has_and_belongs_to_many
						hash_add @rels_to_delete, rel[1], " - (s." + rel[1] + " :> x)"
					end
				end
			end

			#initialize @vars_to_delete
			hash_add @vars_to_delete, aclass, " - x"
			
			destroy_search(aclass, "x", [aclass]) #finishes populating @vars_to_delete and @rels_to_delete
			
			@classes.each do |klass|
				@out.print "\ts'.", klass.downcase.pluralize, "' = s.", klass.downcase.pluralize, @vars_to_delete[klass], "\n"
			end
			@out.print "\n"
			
			@state_rels_list.each do |rel| 
				@out.print "\ts'.", rel, "' = s.", rel, @rels_to_delete[rel], "\n"
			end

			@out.print "\n}\n"
		end
		
	end
	
	
	# Helper to print_delete_preds()
	# If any of the 'classname's relations are set to DESTROY, then besides deleting it, 
	#  look at it's associated vars and repeat
	# -'prefix'  looks like "x", or "x.(s.rel_name)", etc.
	# -Accumulates 'searched_classes' to ensure end of recursion
	# Sample initial call: destroy_search(aclass, "x", [aclass])
	def destroy_search(classname, prefix, searched_classes) 		
		delete_info = @deletion_info[classname]  # get relations to delete for this class
		return if not delete_info
		
		#for each :dependent relation, delete 
		#  (1) all corresponding objects, and
		#  (2) obj's rels tat are belongs_to or habtm
		delete_info.each do |del_info|  # add phrase to delete these relations
				 #[[delete_option, relation_class, relation_variablename],...]
			deloption = del_info[0]
			relclass = del_info[1]
			relvarname = del_info[2]
			alt_relvarname = nil
			rel_candidates_LHS = []
			rel_candidates_RHS = []
			new_prefix = ""
			
			if @conditionals.has_key? relclass
				relclass = @conditionals[relclass] 
				alt_relvarname = relclass.downcase   # since we can't handle polymorphic+conditional relations, 
				                         # (since conditional relations are one-way and we model relations as two-way)
							 # use the two-way relation and ignore condition
			end
				
			# (1) populate @vars_to_delete	
			if @state_rels_LHS[classname]  # first look at relations declared as classname -> otherclass
				rel_candidates_LHS = @state_rels_LHS[classname].select {|rel| rel[1].end_with? "_" + relvarname }
			end
			if rel_candidates_LHS.empty? and not alt_relvarname.nil?
				rel_candidates_LHS = @state_rels_LHS[classname].select {|rel| rel[1].end_with? "_" + alt_relvarname }
			end
			if rel_candidates_LHS.empty?  # may also need to look at relations with classname's superclasses
				@polymorphic_classinv[classname].each do |supclass| 
					if @state_rels_LHS[supclass]
						rel_candidates_LHS = @state_rels_LHS[supclass].select {|rel| rel[1].end_with? "_" + relvarname }
						if rel_candidates_LHS.empty? and not alt_relvarname.nil?
							rel_candidates_LHS = @state_rels_LHS[supclass].select {|rel| rel[1].end_with? "_" + alt_relvarname }
						end
					end
					break if not rel_candidates_LHS.empty? 
				end
			end
			if not rel_candidates_LHS.empty?	
				new_prefix = prefix + ".(s." + rel_candidates_LHS[0][1] + ")"
				hash_add @vars_to_delete, relclass, " - " + new_prefix		
			end
			
			
			if new_prefix.empty?  #if rel not found look at relations declared as otherclass -> classname
				if @state_rels_RHS[classname]
					rel_candidates_RHS = @state_rels_RHS[classname].select {|rel| rel[1].start_with? relvarname + "_" }
				end
				if rel_candidates_RHS.empty? and not alt_relvarname.nil?
					rel_candidates_RHS = @state_rels_RHS[classname].select {|rel| rel[1].start_with? alt_relvarname + "_" }
				end
				if rel_candidates_RHS.empty?  # may also need to look at relations with classname's superclasses
					@polymorphic_classinv[classname].each do |supclass| 
						if @state_rels_RHS[supclass]
							rel_candidates_RHS = @state_rels_RHS[supclass].select {|rel| rel[1].start_with? relvarname + "_" }
							if rel_candidates_RHS.empty? and not alt_relvarname.nil?
								rel_candidates_RHS = @state_rels_RHS[supclass].select {|rel| rel[1].start_with? alt_relvarname + "_" }
							end
						end
						break if not rel_candidates_RHS.empty? 
					end
				end
				if not rel_candidates_RHS.empty?
					new_prefix = "(s." + rel_candidates_RHS[0][1] + ")." + prefix
					hash_add @vars_to_delete, relclass, " - " + new_prefix
				end
			end
			
			if new_prefix.empty?
				@log.error("Error 4 while creating delete predicate for " + classname + " " + del_info.to_s)
				next
			elsif rel_candidates_LHS.length > 1 or rel_candidates_RHS.length > 1 
				@log.warn("Error 5: Some ambiguitity while creating delete predicate for " + classname)
				# found multiple matching relations...
			end
			
			
			# (2) populate @rels_to_delete
			if @state_rels_LHS[relclass]
				@state_rels_LHS[relclass].each do |rel|				
					if rel[0] ==:belongs_to or rel[0] == :has_and_belongs_to_many
						hash_add @rels_to_delete, rel[1], " - (" + new_prefix + " <: s." + rel[1] + ")"
					end
				end
			end
			
			if @state_rels_RHS[relclass]
				@state_rels_RHS[relclass].each do |rel|
					if rel[0] ==:belongs_to or rel[0] == :has_and_belongs_to_many
						hash_add @rels_to_delete, rel[1], " - (s." + rel[1] + " :> " + new_prefix + ")"
					end
				end
			end
			
			if deloption == DESTROY and not searched_classes.include?(relclass)  #relations with :dependent option set to DESTROY
				# recursively add phrases to delete relations of the DESTROY relations
				searched_classes << del_info[1]
				destroy_search(del_info[1], "(" + new_prefix + ")", searched_classes)
			end
		
		end
		
	end #destroy_search()


end #end-class