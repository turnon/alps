require "sequel"

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

          point_model.association_join(:src_file, :calling)
        end
      end

      def event
        Point::Events[event_id]
      end

    end
  end
end
