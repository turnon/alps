module Alps
  class Point

    SingletonMethodSym = '.'.freeze
    InstanceMethodSym = '#'.freeze


    StartEvents = [:call, :c_call, :b_call, :class, :thread_begin]
    EndEvents = [:return, :c_return, :b_return, :end, :thread_end]

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

    def one_line
      "#{method_call} #{event} #{location} #{tid}<#{pid}"
    end

    def method_call
      "#{klass}#{singleton_class ? SingletonMethodSym : InstanceMethodSym}#{method_id}"
    end

    def location
      "#{file}:#{lineno}"
    end

    def start?
      StartEvents.any?{ |e| e == event }
    end

    def ending?
      EndEvents.any?{ |e| e == event }
    end

  end
end
