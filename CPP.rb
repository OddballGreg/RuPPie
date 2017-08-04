class CPP
	def self.args(line)
		string = ''

		$variables.each_with_index do |var, index|
			string = string + var.join(' ')
			string = string + ', ' if (index + 1) < $variables.count
		end
		$output.puts(line.gsub(/<args>/, string).gsub(/<classname>/, $classname)) if $matched == false
		$matched = true
	end

	def self.constructor
		$variables.each do |var|
			$output.puts("\tthis->_#{var.last} = #{var.last};") if $matched == false
		end
		$matched = true
	end

	def self.copy_constructor
		$variables.each do |var|
			$output.puts("\tthis->_#{var.last} = obj._#{var.last};") if $matched == false
		end
		$matched = true
	end

	def self.equals_operator
		$variables.each do |var|
			$output.puts("\tthis->_#{var.last} = obj._#{var.last};") if $matched == false
		end
		$matched = true
	end

	def self.setters
		$variables.each do |var|
			$output.puts("void\t#{$classname.capitalize}::set#{var.last.capitalize}(#{var.first} #{var.last}) { this->_#{var.last} = #{var.last}; }") if $matched == false
		end
		$matched = true
	end

	def self.getters
		$variables.each do |var|
			$output.puts("#{var.first}\t#{$classname.capitalize}::get#{var.last.capitalize}() { return this->_#{var.last}; }") if $matched == false
		end
		$matched = true
	end

	def self.methods
		$methods.each do |method|
			definition = method.last
			method = method.first.split(' ').map{|x| x.split('@')}
			args = method.count > 2 ? method[2..method.count].map{|x| x.join(' ') }.join(', ') : ''
			$output.puts("#{method[0].first}\t#{$classname.capitalize}::#{method[1].first}(#{args})") if $matched == false
			definition.each do |line|
				$output.puts(line) if $matched == false
			end
			$output.puts ''
		end
		$matched = true
	end

	def self.classname(line)
		$output.puts(line.gsub(/<classname>/, $classname)) if $matched == false
	end
end