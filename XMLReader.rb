class XMLReader
	def self.import(classlistfile)
		class_info = {}
		files = []
		File.read(classlistfile).each_line{|line| files << line.match(/<file>(.*)<\/file>/)[1]}
		files.each do |file|
			file = File.read('classes/' + file + '.xml')
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
				raise "Method defintion without prototype for #{file}"														if line.match(/<definition>/)				&& current_prototype.nil? 
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
		return class_info
	end
end