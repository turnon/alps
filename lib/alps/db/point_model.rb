module Alps
  class DB
    module PointModel

      class << self
        def construct_point_model(points, files, callings)
          file_model = Class.new(Sequel::Model(files)) do
            def self.constantize
              self
            end
          end

          method_model = Class.new(Sequel::Model(callings)) do
            def self.constantize
              self
            end
          end

          point_model = Class.new(Sequel::Model(points)) do
            include PointModel
            many_to_one :src_file, :class => file_model
            many_to_one :calling, :class => method_model
          end

          columns = points.columns.map{ |col| Sequel.qualify(:points, col) } + [:path, :method_call]

          point_model.association_join(:src_file, :calling).select(*columns).order(Sequel.qualify(:points, :id))
        end
      end

      def event
        Point::Events[event_id]
      end

      def method_call
        @method_call ||= values[:method_call]
      end

      def path
        @path ||= values[:path]
      end

    end
  end
end
