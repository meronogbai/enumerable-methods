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
    elsif arg.class == Regexp
      elements.my_each do |element|
        return false unless element =~ arg
      end
      return true
    elsif block_given?
      elements.my_each do |element|
        return false unless (yield element)
      end
      return true
    elsif !block_given? && !arg
      elements.my_each do |element|
        unless element
          return false
        end
      end
      return true
    elsif !(arg.class == Regexp) && !(arg.class == Class)
      elements.my_each do |element|
        return false unless element == arg
      end
      return true
    end
  end

  def my_any?(arg=nil)
    elements = to_a
    if arg == Numeric
      elements.my_each do |element|
        return true if element.class == Integer || element.class == Float
      end
      return false
    elsif arg.class == Class
      elements.my_each do |element|
        return true if element.class == arg
      end
      return false
    elsif arg.class == Regexp
      elements.my_each do |element|
        return true if element =~ arg
      end
      return false
    elsif block_given?
      elements.my_each do |element|
        return true if (yield element)
      end
      return false
    elsif !block_given? && !arg
      elements.my_each do |element|
        if element
          return true
        end
      end
      return false
    elsif !(arg.class == Regexp) && !(arg.class == Class)
      elements.my_each do |element|
        return true if element == arg
      end
      return false
    end
  end

  def my_none?
    elements = to_a
    result = true
    elements.my_each do |element|
      result = false if (yield element) == true
    end
    result
  end

  def my_count(arg=nil)
    elements = to_a
    count = 0
    if arg
      elements.my_each do |element|
        count += 1 if element == arg
      end
    elsif block_given?
      elements.my_each do |element|
        count += 1 if (yield element) == true
      end
    else
      elements.my_each do |element|
        count += 1
      end
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

# my each
# p [1,2,3].my_each.class == Enumerator
# p [1,2,3].my_each(&proc{|x| x>2}) == [1,2,3]
# p [1,2,3].my_each_with_index.class == Enumerator
# p (1..3).my_each_with_index(&proc{|x| x>2}) == (1..3)
# my all
# p [1,2,3].all?(&proc{|x| x>x/5}) == [1,2,3].my_all?(&proc{|x| x>x/5})
# p [1,2,3].all?(&proc{|x| x%2==0}) == [1,2,3].my_all?(&proc{|x| x%2==0})
# p [true, [false]].all? == [true, [false]].my_all?
# p [true,[true],false].all? == [true,[true],false].my_all?
# p [1,2,3].all?(Integer) == [1,2,3].my_all?(Integer)
# p [1,-2,3.4].all?(Numeric) == [1,-2,3.4].my_all?(Numeric)
# p ['word',1,2,3].all?(Integer) == ['word',1,2,3].my_all?(Integer)
# p ['word',1,2,3].all?(Integer) == ['word',1,2,3].my_all?(Integer)
# p [1,2,3].count(&proc{|num|num%2==0}) == [1,2,3].my_count(&proc{|num|num%2==0})
# p ['car', 'cat'].all?(/a/) == ['car', 'cat'].my_all?(/a/)
# p ['car', 'cat'].all?(/t/) == ['car', 'cat'].my_all?(/t/)
# p [5,5,5].all?(5) == [5,5,5].my_all?(5)
# p [5,5,[5]].all?(5) == [5,5,[5]].my_all?(5)
# p [1,2,3].my_all?{|x| x>0.1}
# p [0,[]].any? == [0,[]].my_any?
# p [false, 0].any? == [false, 0].my_any?
# p [1.1,'',[]].any?(Numeric) == [1.1,'',[]].my_any?(Numeric)
# p [1,'',[]].any?(Numeric) == [1,'',[]].my_any?(Integer)
# p ['dog', 'cat'].any?(/d/) == ['dog', 'cat'].my_any?(/d/)
# p ['dog', 'cat'].any?(/z/) == ['dog', 'cat'].my_any?(/z/)
# p ['dog','car'].any?('cat') == ['dog','car'].my_any?('cat')
# p ['cat', 'dog','car'].any?('cat') == ['cat', 'dog','car'].my_any?('cat')
