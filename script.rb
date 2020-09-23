module Enumerable

  def my_each
    elements = self.to_a
    for element in elements
      yield element
    end
  end

  def my_each_with_index
    elements = self.to_a
    i = 0
    for element in elements
      yield element, i
      i+=1
    end
  end

  def my_select
    elements = self.to_a
    result = []
    elements.my_each do |element|
      if yield element
        result.push(element)
      end
    end
    result
  end

  def my_all?
    elements = self.to_a
    result = true
    elements.my_each do |element|
      unless yield element
        result = false
      end
    end
    result
  end

  def my_any?
    elements = self.to_a
    result = false
    elements.my_each do |element|
      if yield element
        result = true
      end
    end
    result
  end

  def my_none?
    elements = self.to_a
    result = true
    elements.my_each do |element|
      if yield element
        result = false
      end
    end
    result
  end
  
  def my_count
    elements = self.to_a
    count = 0
    elements.my_each do |element|
      count += 1
    end
    count
  end

  def my_map
    elements = self.to_a
    elements.my_each_with_index do |element, i|
      elements[i] = yield element
    end
    elements
  end

  def my_inject
    elements = self.to_a
    accum = nil
    elements.my_each do |element| 
      if !accum
        accum = element
      else
        accum = yield accum, element
      end
    end
    accum
  end

  def multiply_els
    elements = self.to_a
    elements.my_inject {|product, number| product * number}
  end
  
end

p [3, 6, 10].multiply_els 

