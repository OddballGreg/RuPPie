# RuPPie
A templating engine for C++ classes powered by Ruby.

## Basic Usage
* git clone this repository to the working directory of your C++ project.
* Register your class files according to the example given in "classes/classfiles.xml"
* Define your classes in the style defined by "classes/example.xml" 
* run 'ruby ClassGenerator.rb' or add it's execution to your makefile.

## Notes

### Arguements
* -f
	* Using this flag will force a full regeneration of classfiles, as RuPPie caches a hash of your classfiles in a .classdigest file to save time not regenerating unchanged files.
* /path/to/classfiles
	* You can designate a path for RuPPie to look for classfiles in as an arguement

This generator was coded using ruby version 2.0.0. 

The TC.cpp and TC.hpp are template files which the script uses to discern the layout of the file. Modify this to change the layout of the resultant cpp and hpp files. 

The script determines where to place the necessary code by way for looking for xml like tags such as '\<classname\>'. Some tags like '\<classname\>' and '\<args\>' only replace the tag while leaving the other text on the line, while tags such as '\<methods\>' will remove the line it was matched on and replace it with the methods stipulated during the prompts.

RuPPie was written with certain assumptions regarding the way you've structured your C++ project and expects a "srcs" and "includes" directories in the directory above where you've cloned RuPPie to.

## To Do
* Templates
* Interfaces
* Adaptors
* Non class C++ files, functions and headers
* Use yml instead of XML for class definition.
* Better arguement handling to define the location of classfiles and where to output to. This will allow a user to completely remove RuPPie from their project directory
