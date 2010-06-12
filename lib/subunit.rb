#!/usr/bin/ruby
# file: subunit.rb

class Subunit

  def initialize(raw_units=[], subunit=0)
    units = multiply_units(raw_units.clone).reverse
    @a = scan_units(units, subunit)    
  end

  def to_a()
    @a.map{|x| x >= 1 ? x : 0}
  end

  private

  def multiply_units(x)
    if x.length > 1 then
      y, k = x.shift 2
      r = y.to_i * k.to_i
      [r] + multiply_units([r] + x)
    else
      []
    end
  end

  def scan_units(unit_list,seconds)
    n = unit_list.shift    
    unit, subunit = [:/,:%].map{|x| seconds.send x, n}  
    unit_list.length > 0 ? [unit] + scan_units(unit_list, subunit) : [unit, subunit]
  end
end
