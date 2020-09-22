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
end