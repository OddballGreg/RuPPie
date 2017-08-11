#!/usr/bin/env ruby

require_relative './CPP.rb'
require_relative './HPP.rb'
require_relative './ClassReader.rb'

classes = ClassReader.import('classes')
classes.each do |classname, class_info|
	$classname = classname.chomp.capitalize
	$variables = []
	$methods = []
	$typedefs = class_info['typedefs'] || []
	$headers = class_info['headers'] || []

	class_info['variables'].each do |var|
		$variables << var.split(' ')
	end

	class_info['methods'].each do |method|
		$methods << method
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
		HPP.headers 	                                and next if line.match(/<headers>/)
		HPP.typedefs	                                and next if line.match(/<typedefs>/)
		HPP.classname(line)                             and next
	end
end
