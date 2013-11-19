CFCassandra
===========

## Getting started
Load the dependencies:

* Requires Apache Ivy to load the dependencies
* Build the project:
    * For Railo, run **ant railo-archive**
    * For ACF, run **ant resolve**
* Copy all the jars from **build/dependencies/astyanax/** to a location where they are on the CFML server's classpath.  Examples:
    * your servlet container's libs (making sure they are included in the classpath)
    * your webapp's WEB-INF/(railo/)libs directory
    * ACF's <cfusion>/lib directory
* Copy the CFML components:
    * For Railo, copy the **build/CFCassandra.ra** file to your project, and add to your Railo mappings as an archive mapping.
    * For ACF, copy the components beneath **src** to your project
    
### Future goals
I plan on automating the installation portion of the above steps soon.
