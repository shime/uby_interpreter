require "minitest/autorun"

class UbyInterpreterTest < MiniTest::Test
  attr_accessor :int

  def setup
    self.int = UbyInterpreter.new
  end

  def assert_eval exp, src, msg = nil
    assert_equal exp, int.eval(src), msg
  end

  def test_sanity
    assert_eval 3, "3"
    assert_eval 7, "3 + 4"
  end
end
