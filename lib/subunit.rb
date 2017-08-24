#!/usr/bin/env ruby

# file: subunit.rb

class Subunit

  attr_reader :to_a, :to_h
  
  def initialize(raw_units=nil, raw_subunit=0)
    method((raw_units.class.to_s.downcase + '_units').to_sym).call(raw_units, raw_subunit)
  end
  
  def to_s(omit: [])
    
    h = @to_h
    omit.each {|x| h.delete x}

    list = h.to_a
    n = list.find {|_,v| v > 0 }
    a = list[list.index(n)..-1].map {|x|"%d %s" % x.reverse}        
        
    duration = case a.length

    when 1
      a.first  
    when 2
      a.join ' and '
    else                   
      "%s and %s" % [a[0..-2].join(', '), a[-1]]
    end
    
    duration.gsub(/(\b1 \w+)s/, '\1')

  end

  private

  def hash_subunit(h)
    [h.values.first, h.keys.first]
  end

  def fixnum_subunit(v)
    [v, :remainder]
  end
  
  def integer_subunit(v)
    [v, :remainder]
  end  
  
  def hash_units(raw_units={}, u=nil)
    val, label = method((u.class.to_s.downcase + '_subunit').to_sym).call(u)
    units = multiply_units(raw_units.values).reverse
    @to_a = scan_units(units, val).map(&:to_i)
    @to_h = Hash[(raw_units.keys.reverse + [label]).zip(@to_a)]
  end

  def array_units(raw_units=[], u=nil)
    val, label = method((u.class.to_s.downcase + '_subunit').to_sym).call(u)
    units = multiply_units(raw_units).reverse
    @to_a = scan_units(units, val).map(&:to_i)
  end

  def multiply_units(x) x.inject([]){|r,x| r + [x.to_i * (r[-1] || 1)]} end

  def scan_units(unit_list,raw_subunit)
    n = unit_list.shift    
    unit, subunit = [:/,:%].map{|x| raw_subunit.send x, n}  
    unit_list.length > 0 ? [unit] + scan_units(unit_list, subunit) : [unit, subunit]
  end
end

