class HPP
	def self.args(line)
		string = ''

		$variables.each_with_index do |var, index|
			string = string + var.join(' ')
			string = string + ', ' if (index + 1) < $variables.count
		end
		$output.puts(line.gsub(/<args>/, string).gsub(/<classname>/, $classname)) if $matched == false
		$matched = true
	end

	def self.customconstructors
		$constructors.each do |constructor|
			definition = constructor.last
			args = constructor.first.split(' ').map{|x| x.split('@')}
			args = args.map{|x| x.join(' ') }.join(', ')
			$output.puts("\t\t#{$classname.capitalize}(#{args});") if $matched == false
		end
		$matched = true
	end

	def self.typedefs
		$typedefs.each do |type|
			$output.puts("typedef #{type};") if $matched == false
		end
		$matched = true
	end

	def self.headers
		$headers.each do |header|
			$output.puts("# include #{header}") if $matched == false
		end
		$matched = true
	end

	def self.setters
		$variables.each do |var|
			$output.puts("\t\tvoid\tset#{var.last.capitalize}(#{var.first} #{var.last});") if $matched == false
		end
		$matched = true
	end

	def self.getters
		$variables.each do |var|
			$output.puts("\t\t#{var.first}\tget#{var.last.capitalize}();") if $matched == false
		end
		$matched = true
	end

	def self.methods
		$methods.each do |method, definition|
			method = method.split(' ').map{|x| x.split('@')}
			args = method.count > 2 ? method[2..method.count].map{|x| x.join(' ') }.join(', ') : ''
			$output.puts("\t\t#{method[0].first}\t#{method[1].first}(#{args});") if $matched == false
		end
		$matched = true
	end

	def self.headerargs
		$variables.each do |var|
			$output.puts("\t\t#{var.first}\t_#{var.last};") if $matched == false
		end
		$matched = true
	end

	def self.classnamecapital(line)
		$output.puts line.gsub(/<classnamecapital>/, $classname.upcase) if $matched == false
		$matched = true
	end

	def self.classname(line)
		$output.puts(line.gsub(/<classname>/, $classname)) if $matched == false
	end
end