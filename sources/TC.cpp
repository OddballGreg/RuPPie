#include "<classname>.hpp" 

//Constructors
<classname>::<classname>(<args>)
{
	Log log("<classname>", "Constructor", CRITICAL);
	<constructor>
}

<customconstructors>

<classname>::<classname>(const <classname> &obj)
{
	Log log("<classname>", "Copy Constructor", CRITICAL);
	<copy constructor>
}

<classname>::~<classname>()
{
	Log log("<classname>", "Deconstructor", CRITICAL);
}

<classname> &<classname>::operator =(const <classname> &obj)
{ 
	Log log("<classname>", "= Operator", CRITICAL);
	<= operator>
	return *this; 
}

// Setters
<setters>

// Getters
<getters>

// Methods
<methods>
