# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Metrics/MethodLength

module Enumerable
  def range_return_array(elements)
    if self.class == Range
      self
    else
      elements
    end
  end

  def my_each
    return to_enum unless block_given?

    elements = to_a
    elements.size.times do |index|
      yield elements[index]
    end
    range_return_array(elements)
  end

  def my_each_with_index
    return to_enum unless block_given?

    elements = to_a
    elements.size.times do |index|
      yield elements[index], index
    end
    range_return_array(elements)
  end

  def my_select
    return to_enum unless block_given?

    elements = to_a
    result = []
    elements.my_each do |element|
      result.push(element) if yield element
    end
    result
  end

  def my_all?(arg = nil)
    elements = to_a
    if arg == Numeric
      elements.my_each do |element|
        return false unless element.class == Integer || element.class == Float || element.class == Complex
      end
      true
    elsif arg.class == Class
      elements.my_each do |element|
        return false unless element.class == arg
      end
      true
    elsif arg.class == Regexp
      elements.my_each do |element|
        return false unless element =~ arg
      end
      true
    elsif block_given?
      elements.my_each do |element|
        return false unless yield element
      end
      true
    elsif !block_given? && !arg
      elements.my_each do |element|
        return false unless element
      end
      true
    elsif arg.class != Regexp && arg.class != Class
      elements.my_each do |element|
        return false unless element == arg
      end
      true
    end
  end

  def my_any?(arg = nil)
    elements = to_a
    if arg == Numeric
      elements.my_each do |element|
        return true if element.class == Integer || element.class == Float || element.class == Complex
      end
      false
    elsif arg.class == Class
      elements.my_each do |element|
        return true if element.class == arg
      end
      false
    elsif arg.class == Regexp
      elements.my_each do |element|
        return true if element =~ arg
      end
      false
    elsif block_given?
      elements.my_each do |element|
        return true if yield element
      end
      false
    elsif !block_given? && !arg
      elements.my_each do |element|
        return true if element
      end
      false
    elsif arg.class != Regexp && arg.class != Class
      elements.my_each do |element|
        return true if element == arg
      end
      false
    end
  end

  def my_none?(arg = nil)
    elements = to_a
    if arg == Numeric
      elements.my_each do |element|
        return true unless element.class == Integer || element.class == Float || element.class == Complex
      end
      false
    elsif arg.class == Class
      elements.my_each do |element|
        return false if element.class == arg
      end
      true
    elsif arg.class == Regexp
      elements.my_each do |element|
        return false if element =~ arg
      end
      true
    elsif block_given?
      elements.my_each do |element|
        return false if yield element
      end
      true
    elsif !block_given? && !arg
      elements.my_each do |element|
        return false if element
      end
      true
    elsif arg.class != Regexp && arg.class != Class
      elements.my_each do |element|
        return false if element == arg
      end
      true
    end
  end

  def my_count(arg = nil)
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
      elements.my_each do
        count += 1
      end
    end
    count
  end

  def my_map(arg = nil)
    return to_enum if !block_given? && !arg

    elements = clone.to_a
    elements.my_each_with_index do |element, i|
      elements[i] = if arg
                      arg.call(element)
                    else
                      yield element
                    end
    end
    elements
  end

  def my_inject(arg_first = nil, sym = nil)
    elements = to_a
    if arg_first && sym
      arg = sym
      accum = arg_first
      elements.my_each_with_index do |element, _i|
        accum = accum.send(arg, element)
      end
      return accum
    elsif arg_first && !sym
      arg = arg_first
    elsif !arg_first && !sym
      accum = nil
      elements.my_each do |element|
        accum = if accum.nil?
                  element
                else
                  yield accum, element
                end
      end
    end
    if arg.class == Symbol
      accum = nil
      elements.my_each do |element|
        accum = if accum.nil?
                  element
                else
                  accum.send(arg, element)
                end
      end
    elsif block_given? && arg
      accum = arg
      elements.my_each do |element|
        accum = yield accum, element
      end
    end
    accum
  end
end

def multiply_els(arr)
  arr.my_inject(:*)
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Metrics/MethodLength
