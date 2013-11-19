/* The MIT License (MIT)
 * 
 * Copyright (c) 2013 Jesse Shaffer
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * AbstractFactory
 * 
 * @author jesse.shaffer
 * @license MIT (http://opensource.org/licenses/MIT)
 * @date 11/16/13
 **/
component accessors=true output=false persistent=false {

	public function create(required string class, array args=[]) {
		return this.initializeObject(createObject("java",class),args);
	}

	public function createResolved(required string class, array args=[]) {
		return this.create(resolveClassName(class),args);
	}

	/**
	 * Allows quick object creation using new_<path$to$Class>
	 **/
	public function onMissingMethod(missingMethodName, missingMethodArgs) {
		var class = missingMethodName.replaceAll("^new_","").replaceAll("([^\$])\$([^\$])","$1.$2").replaceAll("\${2,2}","\$");

		if (left(missingMethodName,4) == "new_")
			return this.createResolved(class,missingMethodArgs);
		else
			throw("MissingMethodException","Method does not exist.","The method #missingMethodName# is not defined in this object.");
	}

	private function initializeObject(required object, array args=[]) {
		switch(arraylen(args)) {
			
			case 0: return object;
			case 1	: return object.init(args[1]);
			case 2	: return object.init(args[1],args[2]);
			case 3	: return object.init(args[1],args[2],args[3]);
			case 4	: return object.init(args[1],args[2],args[3],args[4]);
			case 5	: return object.init(args[1],args[2],args[3],args[4],args[5]);
			case 6	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6]);
			case 7	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
			case 8	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
			case 9	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
			case 10	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]);
			case 11	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]);
			case 12	: return object.init(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12]);
			
		}
		
		var argstr = "";
		for (var i = 1; i <= arraylen(args); i++)
			listappend(argstr,"args[#i#]");
		
		evaluate("object = object.init(#argstr#);");

		return object;
	}

	private function resolveClassName(required string class) {
		throw(type="AbstractException",message="This method must be defined by a child class.");
	}

}