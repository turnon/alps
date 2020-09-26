require "fileutils"
require "sequel"
require "alps/point"

module Alps
  class DB

    Dir = File.join(Dir.home, '.alps')
    FileUtils.mkdir_p(Dir)

    class << self
      def connect(name)
        path = File.join(Dir, "#{name}.db")
        db = Sequel.sqlite(path)

        db.table_exists?(:points) || db.create_table(:points) do
          primary_key :id
          column :calling_id, Integer
          column :event, Integer
          column :tid, Integer
          column :pid, Integer
          column :src_file_id, Integer
          column :lineno, Integer
        end

        db.table_exists?(:src_files) || db.create_table(:src_files) do
          primary_key :id
          column :path, String
        end

        db.table_exists?(:callings) || db.create_table(:callings) do
          primary_key :id
          column :method_call, String
        end

        new(db)
      end
    end

    EventIds = Point::Events.each_with_index.to_a.to_h

    attr_reader :point

    def initialize(db)
      @db = db

      @callings = db[:callings]
      @cache_callings = {}

      @files = db[:src_files]
      @cache_files = {}

      @points = db[:points]
      construct_point_model
    end

    def append(point)
      @db.transaction do
        @points.insert(
          calling_id: fetch_calling_id(point),
          event: EventIds[point.event],
          tid: point.tid,
          pid: point.pid,
          src_file_id: fetch_file_id(point),
          lineno: point.lineno,
        )
      end
    end

    def fetch_calling_id(point)
      method_call = point.method_call
      @cache_callings[method_call] ||= (
        @callings.where(method_call: method_call).get(:id) ||
        @callings.insert(method_call: method_call)
      )
    end

    def fetch_file_id(point)
      path = point.file
      @cache_files[path] ||= (
        @files.where(path: path).get(:id) ||
        @files.insert(path: path)
      )
    end

    def construct_point_model
      file_model = Class.new(Sequel::Model(@files)) do
        def self.constantize
          self
        end
      end

      method_model = Class.new(Sequel::Model(@callings)) do
        def self.constantize
          self
        end
      end

      point_model = Class.new(Sequel::Model(@points)) do
        many_to_one :src_file, :class => file_model
        many_to_one :calling, :class => method_model
      end

      @point = point_model.association_join(:src_file, :calling)
    end

  end
end
