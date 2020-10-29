require "rack"
require "alps/query"

module Alps
  class Web
    def self.run(name)
      new(name).run
    end

    def initialize(name)
      @name = name
    end

    def run
      fork do
        Query.connect(@name)

        webrick = Rack::Handler.get('webrick')
        webrick.run(self, :Host => '192.168.0.107', :Port => 3000)
      end
    end

    def call(env)
      c = Query::Point.joins(:src_file, :calling).count
      [200, {"Content-Type" => "text/plain"}, ["Hello from Rack -> #{c}"]]
    end
  end
end
