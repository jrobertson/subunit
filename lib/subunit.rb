#!/usr/bin/env ruby

# file: subunit.rb

class Subunit
  
  def self.seconds(val)
    new(units={minutes:60, hours:60}, seconds: val)
  end

  attr_reader :to_a, :to_h, :to_i
  
  def initialize(raw_units={}, obj)
    
    @debug = false
    
    @raw_units = raw_units
    
    if obj.is_a? Array then
      
      a = obj[0..-2]
      len = raw_units.to_a.length
      val = ([0]*(len-1) + a).slice(-(len), len).zip(raw_units.values)\
          .inject(0) {|r,x| r + x.inject(:*) }
      @to_i = val + obj[-1]
      
    else
      
      raw_subunit = obj || 0
      method((raw_units.class.to_s.downcase + '_units').to_sym)\
          .call(raw_units, raw_subunit)
      
    end
  end
  
  # usage: Subunit.new(units={minutes:60, hours:60}, seconds: 661)\
  #           .strfunit("%x") #=> 11m 1s
  #
  # %x e.g. 11m 1s
  # %X e.g. 11 minutes 1 second
  # %c e.g. 00:11:01
  #
  def strfunit(s)    
    
    s.sub!('%x') do |x|
      to_h.map {|label, val| val.to_s + label[0]}.join(' ')
    end
    
    s.sub!('%X') do |x|
      
      to_h.map do |label, val| 
        
        next if val == 0
        label2 = val > 1 ? label.to_s : label.to_s.sub(/s$/,'')
        val.to_s + ' ' + label2
        
      end.compact.join(' ')
      
    end    
    
    s.sub!('%c') do |x|
      
      a = @raw_units.values.reverse
      a << a[-1]
      
      fmt = a.map {|v| "%0" + v.to_s.length.to_s + "d"}.join(":")
      fmt % to_a
    end    

    s
  end
  
  def to_s(omit: [], verbose: true)
    
    if not verbose then
      
      r =  self.to_a.reverse.take_while {|x| x > 0}.reverse\
          .map {|x| "%02d" % x}.join(':')
      
      if r.length < 2 then
        return '00:00'
      elsif r.length == 2      
        return '00:' + r
      else
        return r
      end
      
    end
    
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
    puts 'units: ' + units.inspect if @debug
    @to_a  = a = scan_units(units, val).map(&:to_i)   
    
    puts 'a: ' + a.inspect if @debug
    pairs = (raw_units.keys.reverse + [label]).reverse.take(a.length)\
                 .reverse.zip(a).select {|x| x[1] > 0}
    @to_h = Hash[pairs]
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

