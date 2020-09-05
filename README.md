# Subunit: Formatting seconds to hours, minutes and seconds

    require 'subunit'

    Subunit.new(units={minutes:60, hours:60}, seconds: 661).strfunit("%x") #=> "11m 1s"

In the above example, using the method *strfunit*, seconds is converted to hours, minutes and seconds.

subunit

----------------------------

# Using the Subunit gem to fracture seconds to hours, minutes, and seconds

    require 'subunit'
    Subunit.new(units={minutes:60, hours:60}, seconds: 1802).to_h
    #=> {:hours=>0, :minutes=>30, :seconds=>2}

    a[0..-2].map {|x|"%d %s" % x.reverse}.join + ", and %d %s" % a[-1].reverse

    #=> "30 minutes, and 2 seconds" 

Note: I don't know why but this gem is only available for Ruby 1.9.2 or above.

## Resources
* [jrobertson/subunit - GitHub](https://github.com/jrobertson/subunit)
