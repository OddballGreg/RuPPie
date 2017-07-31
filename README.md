# cpp_class_generator
A generator for Coplien form C++ classes

## Usage
* git clone this repository to the working directory of your C++ project.
* run 'ruby ClassGenerator.rb'
* Follow the prompts as directed

## Notes
This generator was coded using ruby version 2.0.0. 

The TC.cpp and TC.hpp are template files which the script uses to discern the layout of the file. Modify this to change the layout of the resultant cpp and hpp files. 

The script determines where to place the necessary code by way for looking for xml like tags such as '\<classname\>'. Some tags like '\<classname\>' and '\<args\>' only replace the tag while leaving the other text on the line, while tags such as '\<methods\>' will remove the line it was matched on and replace it with the methods stipulated during the prompts.

## To Do
* Templates
* Interfaces
* Adaptors
* .yml configurable tags for custom content
