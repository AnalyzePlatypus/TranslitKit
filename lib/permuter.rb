=begin
  Permuter.rb

   Encapsulates the logic of creating permutations

   Usage:
    p = Permuter.new
    p.add_array [0,1]
    p.add_array [0,1]
    p.permutations
    => ["00","01","10","11"]

   Methods:
    #add_array arr
    #permutations

    #any?
    #empty?
    #clear

  Test Suite:
     Complete
=end

class Permuter
  def initialize
    @arrays = []
  end

  # Add an array to be permuted
  # Raises an error if given nil
  def add_array arr
    raise "Cannot add nil array" if arr == nil
    @arrays << arr
  end

  # Remove all arrays
  def clear
    @arrays = []
  end

  def any?
    @arrays.any?
  end

  def empty?
    @arrays.empty?
  end

  # Get all permutations of the previously registered arrays
  # Returns an array of strings,
  # or an empty array if none were registered
  def permutations
    return [] if @arrays.empty?
    @permutations = []
    permute []
    @permutations
  end

  private
  # permute (indices)
  # Recursively generate every permutation of the arrays (Courtesy of Ari Fordsham)
  #
  # The classic recursive permutation algorithm:
  # Imagine picking a combination lock: [0][0][0]
  # Each cylinder is the index to one of the arrays
  # On each recursion, we add another cylinder [0], [0][0], [0][0][0]
  # When we have enough cylinders, we generate the permutation (base case)
  # and iterate to the next value by dropping a cylinder, [0][0]
  # iterating the loop in else, and recursing again  [0][0][1]
  # Simple and elegant
  def permute indices
    # Base case
    # puts "permute(#{indices})"
    if indices.length == @arrays.length # If the set of indices is complete
      # Build a `String` based on the completed set of indices
      build_permutation indices
    else
      # Otherwise, add a cylinder, iterate through its options;
      # If it's the final cylinder it will trigger the base case on every option and return;
      # If it's not, it will also trigger this case and iterate through the options of the next cylinder.
      @arrays[indices.length].each_with_index do |item,i|
        permute indices.dup << i
      end
    end
  end

  def build_permutation indices
    permutation = []
    indices.each_with_index do |item_code,i|
      permutation << @arrays[i][item_code]
    end
    result = permutation.join('')
    @permutations << result
    result
  end
end
