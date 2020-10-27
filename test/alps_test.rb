require "test_helper"

class AlpsTest < Minitest::Test
  def test_casually
    Alps.x(:test)

    a = Class.new do
      def a
        1 + 1
      end
    end

    10.times do
      a.new.a

      sleep 2
    end
  end
end
