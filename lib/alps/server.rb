require "plux"

module Alps
  class Server < ::Plux::Engine
    def prepare
      @stacks = Hash.new{ |h, k| h[k] = [] }
    end

    def process(msg)
      p = Marshal.load(msg)
      stack = @stacks[p.thread_current_id]
      return if p.ending? && stack.empty?

      indent = stack.size
      if p.start?
        stack << p
      else
        stack.pop
        indent -= 1
      end

      puts "#{'  ' * indent}#{p.one_line}"
    end
  end
end
