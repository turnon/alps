module Alps
  class Point
    Methods = [:file, :lineno, :klass, :singleton_class, :method_id, :event, :tid, :pid]

    Methods.each do |method|
      class_eval <<-EOM
        def #{method}
          @#{method.to_s[0]}
        end
      EOM
    end

    def initialize(p)
      @f = p.path
      @l = p.lineno
      @k = p.defined_class.to_s
      @s = p.defined_class && p.defined_class.singleton_class?
      @m = p.method_id
      @e = p.event
      @t = Thread.current.object_id
      @p = Process.pid
    end

    def thread_current_id
      "alps_#{pid}_#{tid}"
    end
  end
end
