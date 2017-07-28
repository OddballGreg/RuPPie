require './CPP.rb'
require './HPP.rb'

$variables = []
$methods = []

puts 'Please describe the classname:'
$classname = STDIN.gets.chomp.capitalize

puts 'Please describe the variables you want as follows:'
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
	CPP.args(line)									and next if line.match(/<args>/)
	CPP.constructor                                 and next if line.match(/<constructor>/)
	CPP.setters   			                        and next if line.match(/<setters>/)
	CPP.getters             			       		and next if line.match(/<getters>/)
	CPP.methods                                  	and next if line.match(/<methods>/)
	CPP.copy_constructor               	            and next if line.match(/<copy constructor>/)
	CPP.equals_operator                             and next if line.match(/<= operator>/)
	CPP.classname(line)  	                        and next
end

$template.close
$output.close
$template = File.open('TC.hpp')
$output = File.open("../includes/#{$classname}.hpp", 'w')

$matched = false
$template.each do |line|
	$matched = false
	HPP.args(line)	 								and next if line.match(/<args>/)
	HPP.classnamecapital(line)                      and next if line.match(/<classnamecapital>/)
	HPP.setters                                     and next if line.match(/<setters>/)
	HPP.getters                                     and next if line.match(/<getters>/)
	HPP.methods                                     and next if line.match(/<methods>/)
	HPP.headerargs                                  and next if line.match(/<headerargs>/)
	HPP.classname(line)                             and next
end
