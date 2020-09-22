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
end