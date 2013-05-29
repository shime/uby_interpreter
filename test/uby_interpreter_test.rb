require "minitest/autorun"
require "uby_interpreter"

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

  def test_if
    assert 42, "if true then 42 else 24 end"
  end

  def test_if_falsey
    assert_eval 24, "if nil then 42 else 24 end"
    assert_eval 24, "if false then 42 else 24 end"
  end

  def test_lvar
    assert_eval 42, "x = 42; x"
  end

  def test_defn
    assert_eval nil, <<-EOM
      def double n
        2 * n
      end
    EOM

    assert_eval 42, "double(21)"
  end

  def define_fib
    assert_eval nil, <<-END
      def fib n
        if n <= 2 then
          1
        else
          fib(n - 2) + fib(n - 1)
        end
      end
    END
  end

  def test_fib
    define_fib

    assert_eval 8, "fib(6)"
  end

  def test_while_sum_of_fibs
    define_fib

    assert_eval 1 + 1 + 2 + 3 + 5 + 8 + 13 + 21 + 34 + 55, <<-EOM
      n = 1
      sum = 0
      while n <= 10
        sum += fib(n)
        n += 1
      end
      sum
    EOM
  end

  def test_strings
    assert_eval "i can has strings", %Q{"i can has strings"}
    assert_eval "I CAN HAS STRINGS", %Q{"i can has strings".upcase}
  end

  def test_arrays
    assert_eval [1, 2, 3],          "[1, 2, 3]"
    assert_eval [1, 2, 3, 4, 5, 6], "[1, 2, 3] + [4, 5, 6]"
    assert_eval 1,                  "[1, 2, 3].first"
  end

  def test_hashes
    hash = {:foo => :bar, :baz => :biz}
    assert_eval hash, "{:foo => :bar, :baz => :biz}"
  end
end
