require "alps/version"
require "alps/point"
require "alps/server"

module Alps

  Events = Point::StartEvents + Point::EndEvents

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
