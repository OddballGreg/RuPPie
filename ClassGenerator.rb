#!/usr/bin/env ruby

require_relative './sources/CPP.rb'
require_relative './sources/HPP.rb'
require_relative './sources/ClassReader.rb'

$dir   = ARGV[0] || __dir__
$force = true if ARGV[1] == '-f' || ARGV[0] == '-f'
$root  = File.expand_path(__dir__)
$parent_dir = $root.split('/')
$parent_dir.pop
$parent_dir = $parent_dir.join('/')

classes = ClassReader.import(File.expand_path('classes', $root))
classes.each do |classname, class_info|
	$classname 	= classname.chomp.capitalize
	$variables 	= []
	class_info['variables'].each { |var| $variables << var.split(' ') }
	$methods 	= []
	class_info['methods'].each   { |method| $methods << method }
	$constructors 	= []
	class_info['constructors'].each   { |constructor| $constructors << constructor }
	$typedefs 	= class_info['typedefs'] || []
	$headers 	= class_info['headers']  || []

	puts "Generating #{$classname}.cpp and #{$classname}.hpp"

	$template = File.open(File.expand_path('sources/TC.cpp', $root))
	$output   = File.open($parent_dir + "/srcs/#{$classname}.cpp", 'w')

	$matched = false
	$template.each do |line|
		$matched = false
		CPP.args(line)									and next if line.match(/<args>/)
		CPP.constructor                                 and next if line.match(/<constructor>/)
		CPP.customconstructors                          and next if line.match(/<customconstructors>/)
		CPP.setters   			                        and next if line.match(/<setters>/)
		CPP.getters             			       		and next if line.match(/<getters>/)
		CPP.methods                                  	and next if line.match(/<methods>/)
		CPP.copy_constructor               	            and next if line.match(/<copy constructor>/)
		CPP.equals_operator                             and next if line.match(/<= operator>/)
		CPP.classname(line)  	                        and next
	end

	$template.close
	$output.close
	$template = File.open(File.expand_path('sources/TC.hpp', $root))
	$output = File.open($parent_dir + "/includes/#{$classname}.hpp", 'w')

	$matched = false
	$template.each do |line|
		$matched = false
		HPP.args(line)	 								and next if line.match(/<args>/)
		HPP.customconstructors                          and next if line.match(/<customconstructors>/)
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
