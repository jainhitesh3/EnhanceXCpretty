# EnhanceXCpretty

This uses REXML to parse an existing xcpretty HTML report, and then add a pie-chart to it. This also checks for the correct number of tests and will update it in the report.

To start using EnhanceXCpretty : 
    
    gem install EnhanceXCpretty
    
Once installed successfully : 
    
    EnhanceXCpretty "<HTML_FILE_PATH>"
    
    eg: EnhanceXCpretty "/Users/hitesh/report.html"

NOTE: This modifies the existing report.html file. So in case you need the original copy, please keep a copy of that.


Thanks [Lyndsey](https://github.com/lyndsey-ferguson) for suggesting me to create this as gem, and helping me with with my first gem.
