class ClassReader
	def self.import(classlistfolder)
		require 'digest/sha1'

		`touch .classdigest`
		digestfile = File.open('.classdigest')
		digest = {}
		digestfile.read.each_line{|line| digest[line.split('.').first] = line.split('.').last}
		digestfile.close
		newdigest = {}

		class_info = {}
		files = `ls #{$root + '/classes'}`.split("\n").select{|file| file.split('.')[1] == 'xml'}
		files.each do |filename|
			file = File.read($root + '/classes/' + filename)
			next if Digest::SHA1.digest(file).encode('UTF-8', invalid: :replace, undef: :replace) <=> digest[filename.split('.').first] && $force != true
			newdigest[filename.split('.').first] = Digest::SHA1.digest(file).encode('UTF-8', invalid: :replace, undef: :replace)

			classname = ''

			in_in_method_set = false
			in_in_method_definition = false
			current_method_prototype = nil
			
			in_constructor_set = false
			in_constructor_definition = false
			current_constructor_args = nil

			file.each_line do |line|
				# Detect Start and End Of Constructor Blocks, Store Constructor Prototypes and Defitions
				in_constructor_set = true if line.match(/<constructor>/) 
				if in_constructor_set
					in_constructor_set 													= false												if line.match(/<\/constructor>/)
					current_constructor_args                   							= line.match(/<args>(.*)<\/args>/)[1]				if line.match(/<args>.*<\/args>/)
					class_info[classname]['constructors'][current_constructor_args]		= []												if line.match(/<args>.*<\/args>/) 
					in_constructor_definition											= true												if line.match(/<definition>/)		 
					raise "Constructor defintion without prototype in #{filename}"															if line.match(/<definition>/) && current_constructor_args.nil? 
					if in_constructor_definition
						in_constructor_definition										= false										 		if line.match(/<\/definition>/)
						class_info[classname]['constructors'][current_constructor_args] << line 											if !line.match(/<definition>/) && !line.match(/<\/definition>/)
						next
					end
					next
				end

				# Detect Start and End Of Method Blocks, Store Method Prototypes and Defitions
				in_method_set = true if line.match(/<method>/) 
				if in_method_set
					in_method_set 														= false												if line.match(/<\/method>/) 				
					current_method_prototype                   							= line.match(/<prototype>(.*)<\/prototype>/)[1]		if line.match(/<prototype>.*<\/prototype>/) 
					class_info[classname]['methods'][current_method_prototype]			= []												if line.match(/<prototype>.*<\/prototype>/) 
					in_method_definition												= true												if line.match(/<definition>/)				 
					raise "Method defintion without prototype in #{filename}"																if line.match(/<definition>/) && current_method_prototype.nil? 
					if in_method_definition
						class_info[classname]['methods'][current_method_prototype] 		<< line 											if !line.match(/<definition>/) 	
						in_method_definition											= false									 			if line.match(/<\/definition>/)	
						next
					end
					next
				end

				# Register Classname, initialize hash container
				if line.match(/<classname>.*<\/classname>/)
					classname               =  line.match(/<classname>(.*)<\/classname>/)[1]	 										 
					class_info[classname] 	=  {'variables' => [], 'methods' => {}, 'constructors' => {}, 'headers' => [], 'typedefs' => []}
				end

				# Detect single line variable and header defintions
				class_info[classname]['variables'] 	<< line.match(/<variable>(.*)<\/variable>/)[1] 											if line.match(/<variable>.*<\/variable>/)
				class_info[classname]['headers'] 	<< line.match(/<header>(.*)<\/header>/)[1]	 											if line.match(/<header>.*<\/header>/) 
				class_info[classname]['typedefs'] 	<< line.match(/<typedef>(.*)<\/typedef>/)[1]	 										if line.match(/<typedef>.*<\/typedef>/) 

			end
		end
		unless newdigest.empty?
			digestfile = File.open('.classdigest', 'w')
			newdigest.each{|k,v| digestfile.write("#{k}.#{v}\n") }
		end
		digestfile.close
		return class_info
	end
end