require "rack"

module Alps
  class Web
    def self.run(name)
      new(name).run
    end

    def initialize(name)
      @db = ::Alps::DB.connect(name)
    end

    def run
      fork do
        webrick = Rack::Handler.get('webrick')
        webrick.run(self, :Host => '192.168.0.107', :Port => 3000)
      end
    end

    def call(env)
      c = @db.point.count
      [200, {"Content-Type" => "text/plain"}, ["Hello from Rack -> #{c}"]]
    end
  end
end
