require "alps/version"
require "alps/point"
require "alps/db"
require "alps/server"

module Alps

  class << self
    def x(name)
      server = Server.new(name)

      tp = TracePoint.new(*Point::Events) do |p|
        p = Point.new(p)
        client = (Thread.current[p.thread_current_id] ||= server.connect)
        client.puts(Marshal.dump(p))
      end

      tp.enable
    end
  end

end
