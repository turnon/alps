module Alps
  module Server

    class << self
      def start(name)
        Plux.worker(name) do
          def work(msg)
            pp Marshal.load(msg)
          end
        end
      end
    end

  end
end
