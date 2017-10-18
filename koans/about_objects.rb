require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutObjects < Neo::Koan
  def test_everything_is_an_object
    assert_equal true, 1.is_a?(Object)
    assert_equal true, 1.5.is_a?(Object)
    assert_equal true, "string".is_a?(Object)
    assert_equal true, nil.is_a?(Object)
    assert_equal true, Object.is_a?(Object)
    #It's raining the truth as everything in Ruby is an object.
  end

  def test_objects_can_be_converted_to_strings
    assert_equal "123", 123.to_s
    assert_equal "", nil.to_s
  end

  def test_objects_can_be_inspected
    assert_equal "123", 123.inspect
    assert_equal "nil", nil.inspect
  end

  def test_every_object_has_an_id
    obj = Object.new
    assert_equal Fixnum, obj.object_id.class
    #The an object's ID is of the class-type Fixnum
  end

  def test_every_object_has_different_id
    obj = Object.new
    another_obj = Object.new
    assert_equal true, obj.object_id != another_obj.object_id
    #Should come out as true as long as both have different IDs
  end

  def test_small_integers_have_fixed_ids
    assert_equal 1, 0.object_id
    assert_equal 3, 1.object_id
    assert_equal 5, 2.object_id
    assert_equal 201, 100.object_id

    # THINK ABOUT IT:
    # What pattern do the object IDs for small integers follow?
    # The pattern used to set the ID for a Number object is 2n+1, where n = the number
  end

  def test_clone_creates_a_different_object
    obj = Object.new
    copy = obj.clone
    org = String.new;
    cloned = org.clone
    puts("OBJ [TYPE: OBJECT] as a String", obj.to_s)
    puts("COPY [Clone of OBJ] as a String", copy.to_s)
    puts("ORG [TYPE: STRING] as a String", org.to_s)
    puts("CLONED [Clone of ORG] as a String", cloned.to_s)
    puts("Org and Clone have the same content. So are they considered equal?", org == cloned)
    puts("Then are they NOT equal?", org != cloned)

    assert_equal true, obj           != copy
    #true because the content of the super (duper) class Object, when output with
    #to_s returns its memory ID, which is different for the original and the clone.
    # HOWEVER, any child of Object and its clone would come out as false here as their content
    # would be compared and resolved to equal.
    assert_equal true, obj.object_id != copy.object_id #true as the the clone is a deep-clone and hence has a different ID
  end
end
