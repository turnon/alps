require "alps/version"
require "alps/point"
require "alps/server"

module Alps

  Events = [
    :b_call, :b_return,
    :c_call, :c_return,
    :call, :return,
    :class, :end,
    :thread_begin, :thread_end
  ]

  class << self
    def x(name)
      server = Server.new(name)

      tp = TracePoint.new(*Events) do |p|
        p = Point.new(p)
        client = (Thread.current[p.thread_current_id] ||= server.connect)
        client.puts(Marshal.dump(p))
      end

      tp.enable
    end
  end

end
