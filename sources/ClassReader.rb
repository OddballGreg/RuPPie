class ClassReader
	def self.import(classlistfolder)
		require 'digest/sha1'

		`touch .classdigest`
		digestfile = File.open('.classdigest')
		digest = {}
		digestfile.read.each_line{|line| digest[line.split('.').first] = line.split('.').last}
		digestfile.close
		digestfile = File.open('.classdigest', 'w')
		newdigest = {}

		class_info = {}
		files = `ls classes`.split("\n").select{|file| file.split('.')[1] == 'xml'}
		files.each do |filename|
			file = File.read('classes/' + filename)
			next if Digest::SHA1.digest(file).encode('UTF-8', invalid: :replace, undef: :replace) <=> digest[filename.split('.').first]
			newdigest[filename.split('.').first] = Digest::SHA1.digest(file).encode('UTF-8', invalid: :replace, undef: :replace)

			classname = ''
			method_set = false
			method_definition = false
			current_prototype = nil
			file.each_line do |line|
				# Detect Start and End Of Method Blocks, Store Method Prototypes and Defitions
				method_set 												= false												if line.match(/<\/method>/) 				&& method_set
				method_definition										= false										 		if line.match(/<\/definition>/)				&& method_set && method_definition
				method_set 												= true										 		if line.match(/<method>/) 
				current_prototype                   					= line.match(/<prototype>(.*)<\/prototype>/)[1]		if line.match(/<prototype>.*<\/prototype>/) && method_set
				class_info[classname]['methods'][current_prototype]		= []												if line.match(/<prototype>.*<\/prototype>/) && method_set
				method_definition										= true												if line.match(/<definition>/)				&& method_set 
				raise "Method defintion without prototype in #{filename}"													if line.match(/<definition>/)				&& current_prototype.nil? 
				class_info[classname]['methods'][current_prototype] 	<< line 											if !line.match(/<definition>/) 				&& method_set && method_definition
				next if method_set or method_definition

				# Register Classname, initialize hash container
				classname                        	=  line.match(/<classname>(.*)<\/classname>/)[1]	 					if line.match(/<classname>.*<\/classname>/) 
				class_info[classname] 				=  {'variables' => [], 'methods' => {}, 'headers' => []}				if line.match(/<classname>.*<\/classname>/)

				# Detect single line variable and header defintions
				class_info[classname]['variables'] 	<< line.match(/<variable>(.*)<\/variable>/)[1] 							if line.match(/<variable>.*<\/variable>/)
				class_info[classname]['headers'] 	<< line.match(/<header>(.*)<\/header>/)[1]	 							if line.match(/<header>.*<\/header>/) 
			end
		end
		newdigest.each{|k,v| digestfile.write("#{k}.#{v}\n") } unless newdigest.empty?
		digestfile.close
		return class_info
	end
end