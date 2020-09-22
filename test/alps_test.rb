require "test_helper"

class AlpsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Alps::VERSION
  end

  def test_casually
    Alps.x(:test)

    a = Class.new do
      def a
        1 + 1
      end
    end
    a.new.a

    sleep 2
  end
end
