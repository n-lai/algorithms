require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity, @length, @start_idx, @store = 8, 0, 0, StaticArray.new(8)
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if index >= length
    store[(index + start_idx) % capacity]
  end

  # O(1)
  def []=(index, val)
    raise "index out of bounds" if index >= length
    store[(index + start_idx) % capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if length < 1

    removed_el = self[length - 1]
    self.length -= 1
    removed_el
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity

    self.length += 1
    self[length - 1] = val
  end

  # O(1)
  def shift
    raise "index out of bounds" if length < 1

    val = self[0]
    self.length -= 1
    self.start_idx = (start_idx + 1) % capacity
    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity

    self.start_idx = (start_idx - 1) % capacity
    self.length += 1
    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    new_capacity = capacity * 2
    new_store = StaticArray.new(new_capacity)

    (0...length).each do |idx|
      new_store[idx] = self[idx]
    end

    self.store = new_store
    self.capacity = new_capacity
    self.start_idx = 0
  end
end
