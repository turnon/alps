require "plux"

module Alps
  class Server < ::Plux::Engine
    def process(msg)
      pp Marshal.load(msg)
    end
  end
end
