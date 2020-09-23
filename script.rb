module Enumerable
  def my_each
    return self.to_enum unless block_given?
    elements = to_a
    elements.each do |element|
      yield element
    end
    if self.class == Range
      self
    else
      elements
    end
  end

  def my_each_with_index
    return self.to_enum unless block_given?
    elements = to_a
    i = 0
    elements.each do |element|
      yield element, i
      i += 1
    end
    if self.class == Range
      self
    else
      elements
    end
  end

  def my_select
    return self.to_enum unless block_given?
    elements = to_a
    result = []
    elements.my_each do |element|
      result.push(element) if yield element
    end
    result
  end

  def my_all?(arg=nil)
    elements = to_a
    if arg == Numeric
      elements.my_each do |element|
        return false unless element.class == Integer || element.class == Float
      end
      return true
    elsif arg.class == Class
      elements.my_each do |element|
        return false unless element.class == arg
      end
      return true
    elsif !block_given? && !arg
      elements.my_each do |element|
        unless element
          return false
        end
      end
      return true
    end
    result = true
    elements.my_each do |element|
      result = false unless (yield element)
    end
    result
  end

  def my_any?
    elements = to_a
    result = false
    elements.my_each do |element|
      result = true if (yield element) == true
    end
    result
  end

  def my_none?
    elements = to_a
    result = true
    elements.my_each do |element|
      result = false if (yield element) == true
    end
    result
  end

  def my_count
    elements = to_a
    count = 0
    elements.my_each do |_element|
      count += 1
    end
    count
  end

  def my_map(proc = nil)
    elements = to_a
    elements.my_each_with_index do |element, i|
      elements[i] = if proc
                      proc.call(element)
                    else
                      yield element
                    end
    end
    elements
  end

  def my_inject
    elements = to_a
    accum = nil
    elements.my_each do |element|
      accum = if accum
                yield accum, element
              else
                element
              end
    end
    accum
  end

  def multiply_els
    elements = to_a
    elements.my_inject { |product, number| product * number }
  end
end

# p [1,2,3].my_each.class == Enumerator
# p [1,2,3].my_each(&proc{|x| x>2}) == [1,2,3]
# p [1,2,3].my_each_with_index.class == Enumerator
# p (1..3).my_each_with_index(&proc{|x| x>2}) == (1..3)
p [1,2,3].all?(&proc{|x| x>x/5}) == [1,2,3].my_all?(&proc{|x| x>x/5})
p [1,2,3].all?(&proc{|x| x%2==0}) == [1,2,3].my_all?(&proc{|x| x%2==0})
p [true, [false]].all? == [true, [false]].my_all?
p [true,[true],false].all? == [true,[true],false].my_all?
p [1,2,3].all?(Integer) == [1,2,3].my_all?(Integer)
p [1,-2,3.4].all?(Numeric) == [1,-2,3.4].my_all?(Numeric)
p ['word',1,2,3].all?(Integer) == ['word',1,2,3].my_all?(Integer)
