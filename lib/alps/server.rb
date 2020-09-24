require "plux"

module Alps
  class Server < ::Plux::Engine
    def prepare
      @db = ::Alps::DB.connect(:alps)
    end

    def process(msg)
      p = Marshal.load(msg)
      @db.append(p)
    end
  end
end
