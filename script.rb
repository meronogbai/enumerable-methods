module Enumerable
  def my_each
    elements = to_a
    elements.each do |element|
      yield element
    end
  end

  def my_each_with_index
    elements = to_a
    i = 0
    elements.each do |element|
      yield element, i
      i += 1
    end
  end

  def my_select
    elements = to_a
    result = []
    elements.my_each do |element|
      result.push(element) if yield element
    end
    result
  end

  def my_all?
    elements = to_a
    result = true
    elements.my_each do |element|
      result = false unless (yield element) == false
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
