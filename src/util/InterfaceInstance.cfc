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
 * InterfaceInstance
 * =================
 * Get an instance of a java interface (so long as it is loaded into the classpath accessible by createdynamicproxy)
 * Can be used to wrap a CFC by instance or path, or a struct of closures
 * 
 * Example (quick runnable instance):
 * 
 * runnable = new InterfaceInstance("java.lang.Runnable",{
 *    run : function() {
 *       writeoutput("ran with it!");
 *    }
 * });
 * 
 * @author jesse.shaffer
 * @license MIT (http://opensource.org/licenses/MIT)
 * @date 11/16/13
 **/
component accessors=true output=false persistent=false {
	
	public function init(required any interface, required wrapped) {
		if (!isObject(wrapped) && isStruct(wrapped)) {
			structAppend(this,wrapped);
			wrapped = this;
		} else if (isValid("string",wrapped) && fileExists(ExpandPath("/" & wrapped.replaceAll("\.","/") & ".cfc"))) {
			wrapped = createObject("component",wrapped);
		}

		if (!isObject(wrapped))
			wrapped = this;
			
		return createDynamicProxy(wrapped,interface);
	}

}