module Enumerable
  def my_each
    elements = self.to_a
    for element in elements
      yield element
    end
  end
end