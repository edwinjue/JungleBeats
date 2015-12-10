require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require_relative 'List'

class JungleBeatsTest < Minitest::Test
  def test_append_an_node_to_the_end_of_the_list
    list = List_Beats.new("bang")
    list.append("ma chow")
    assert_equal "bang ma chow", list.all
  end

  def test_prepend_an_node_at_the_begining_of_the_list_
    list = List_Beats.new("bang")
    list.prepend("ma chow")
    assert_equal "ma chow bang", list.all
  end

  def test_insert_one_or_more_nodes_at_an_abritarty_position_in_the_list
    list = List_Beats.new("bang")
    assert list.insert(0,"ma chow knee")
  end

  def test_returns_count_0_for_invalid_sound_with_new_object
    list = List_Beats.new("SomeInvalidSound")
    assert_equal 0, list.count
  end

  def test_returns_true_for_include?
    list = List_Beats.new("bang")
    assert list.include?("bang")
  end

  def test_returns_false_for_include?
    list = List_Beats.new("bang")
    refute list.include?("boom")
  end

  def test_pop_3_beats_from_link
    list = List_Beats.new("bang")
    list.append("boom boom la chi dop dop de bang la chi")
    assert_equal "bang la chi",list.pop(3)
  end

  def test_count_keeps_track_of_current_size_of_node
    list = List_Beats.new("bang")
    list.append("bang boom la")
    list.prepend("chi ni ma ding")
    assert_equal 7, list.count
  end


  def test_returns_all_elements_in_the_linked_list
    list = List_Beats.new("bang")
    list.append("bang boom la")
    list.prepend("chi ni ma ding")
    assert_equal "chi ni ma ding bang bang la", list.all
  end

  def test_resets_to_orginal_voice_speed
    list = List_Beats.new("bang")
    list.speed = 100
    assert_equal 500, list.reset_speed
  end

  def test_allows_to_set_custom_voice_speed
    list = List_Beats.new("bang")
    list.speed = 100
    assert_equal 100, list.speed
  end

  def test_returns_voice_to_defult_Boing_
    list = List_Beats.new("bang")
    list.voice = 'Alice'
    assert_equal 'Boing', list.reset_voice
  end

  def test_allows_to_set_custom_voice
    list = List_Beats.new("bang")
    list.voice = "Alice"
    assert_equal "Alice", list.voice
  end

  def test_find_word_in_link
    list = List_Beats.new("bang")
    list.append("lo chow madar")
    list.prepend("deep dep")
    assert list.find("chow")
  end

  def test_allows_for_capitalize_or_upcase_words
    list = List_Beats.new("BANG")
    assert_equal 1, list.count
  end

  def test_refutes_non_authorized_words
    list = List_Beats.new("bang junk junk junk")
    assert_equal 1, list.count
  end

  def test_invalid_parameter_in_constructor_yields_count_0
    list = List_Beats.new("Hello")
    assert_equal 0, list.count
  end

  def test_if_only_one_node_insert_5_will_append
    list = List_Beats.new("bang")
    list.insert(5,"ma")
    assert_equal "bang ma", list.all
  end
end