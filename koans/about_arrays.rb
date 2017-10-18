require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrays < Neo::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
    #Haha that was a little trivial
  end

  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333 #shift-operator will add 333 to the end of the array
    assert_equal [1, 2, 333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]
    #elements are symbols
    #hence symbols will be returned
    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1] #Reverse with -1 being the last element as -0 does not exist
    assert_equal :butter, array[-3] #Hence this will return the second element as the first would be -4
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]
    # Slicing returns an array in the following format [from index, amount of positions to count up to]
    # If there are too many steps the result only contains actual elements no nils etc.
    assert_equal [:peanut], array[0,1]
    assert_equal [:peanut, :butter], array[0,2]
    assert_equal [:and, :jelly], array[2,2]
    assert_equal [:and, :jelly], array[2,20]
    assert_equal [], array[4,0]
    #This returns an empty array because the element between 3 and 4 can be given back,
    # hence 4 HAS TO EXIST and return an empty array although there is only nil in that position
    assert_equal [], array[4,100] #this is valid (see above)
    assert_equal nil, array[5,0] #Returns nil as position 5 does not exist.
  end

  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5) #Makes sense because it's a range
    assert_equal [1,2,3,4,5], (1..5).to_a #.. counts all the way to the final number
    assert_equal [1,2,3,4], (1...5).to_a #... counts upto, but not including, the final number
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut, :butter, :and], array[0..2]
    assert_equal [:peanut, :butter], array[0...2]
    assert_equal [:and, :jelly], array[2..-1] #Still counts forwards to the reversed index
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1, 2, :last], array #Because we can mix types in Ruby!

    popped_value = array.pop
    assert_equal :last, popped_value #FILO principle
    assert_equal [1,2], array
  end

  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first)

    assert_equal __, array

    shifted_value = array.shift
    assert_equal __, shifted_value
    assert_equal __, array
  end

end
