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
			$output.puts("\tthis->_#{var.last} = obj.#{var.last};") if $matched == false
		end
		$matched = true
	end

	def self.equals_operator
		$variables.each do |var|
			$output.puts("\tthis->_#{var.last} = obj.#{var.last};") if $matched == false
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
			args = method.count > 2 ? method[2..method.count].map{|x| x.join(' ') }.join(', ') : ''
			$output.puts("#{method[0].first}\t#{$classname.capitalize}::#{method[1].first}(#{args})") if $matched == false
			$output.puts("{") if $matched == false
			$output.puts("")  if $matched == false
			$output.puts("}") if $matched == false
			$output.puts("") if $matched == false
		end
		$matched = true
	end

	def self.classname(line)
		$output.puts(line.gsub(/<classname>/, $classname)) if $matched == false
	end
end

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
		$methods.each do |method|
			args = method.count > 2 ? method[2..method.count].map{|x| x.join(' ') }.join(', ') : ''
			$output.puts("\t\t#{method[0].first}\t#{method[1].first}(#{args});") if $matched == false
		end
		$matched = true
	end

	def self.headerargs
		$variables.each do |var|
			$output.puts("\t\t#{var.first}\t_#{var.last.capitalize};") if $matched == false
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

$variables = []
$methods = []

puts 'Please describe the methods classname:'
$classname = STDIN.gets.chomp.capitalize

puts 'Please describe the methods you want as follows:'
puts 'type name'
puts "Type ';;' to stop" 

loop do
	input = STDIN.gets.chomp
	break if input == ';;'
	$variables << input.split(' ')
end

puts 'Please describe the methods you want as follows:'
puts 'returnValue methodName type1@arg1 type2@arg2 typeN@argN'
puts "Type ';;' to stop" 

loop do
	input = STDIN.gets.chomp
	break if input == ';;'
	$methods << input.split(' ').map{|x| x.split('@')}
end

puts "Generating #{$classname}.cpp and #{$classname}.hpp"

$template = File.open('TC.cpp')
$output = File.open("../srcs/#{$classname}.cpp", 'w')

$matched = false
$template.each do |line|
	$matched = false
	CPP.args(line)						 and next if line.match(/<args>/)
	CPP.constructor                                          and next if line.match(/<constructor>/)
	CPP.setters   			                         and next if line.match(/<setters>/)
	CPP.getters             			         and next if line.match(/<getters>/)
	CPP.methods                                     	 and next if line.match(/<methods>/)
	CPP.copy_constructor                                     and next if line.match(/<copy constructor>/)
	CPP.equals_operator                         	         and next if line.match(/<= operator>/)
	CPP.classname(line)  	                                 and next
end

$template.close
$output.close
$template = File.open('TC.hpp')
$output = File.open("../includes/#{$classname}.hpp", 'w')

$matched = false
$template.each do |line|
	$matched = false
	HPP.args(line)	 				and next if line.match(/<args>/)
	HPP.classnamecapital(line)                      and next if line.match(/<classnamecapital>/)
	HPP.setters                                     and next if line.match(/<setters>/)
	HPP.getters                                     and next if line.match(/<getters>/)
	HPP.methods                                     and next if line.match(/<methods>/)
	HPP.headerargs                                  and next if line.match(/<headerargs>/)
	HPP.classname(line)                             and next
end
