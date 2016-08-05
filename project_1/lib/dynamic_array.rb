require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity, @length, @store = 8, 0, StaticArray.new(8)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index >= length
    store[index]
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" if index >= length
    store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" if length < 1
    removed_el = store[length - 1]
    self.length -= 1
    removed_el
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity
    store[length] = val
    self.length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if length < 1

    removed_el = store[0]

    (1...length).each do |idx|
      store[idx - 1] = store[idx]
    end

    self.length -= 1

    removed_el
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity

    length.downto(0).each do |idx|
      store[idx] = store[idx - 1]
    end

    store[0] = val

    self.length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_capacity = capacity * 2

    new_store = StaticArray.new(new_capacity)

    (0...length).each do |idx|
      new_store[idx] = store[idx]
    end

    @capacity = new_capacity
    @store = new_store
  end
end
