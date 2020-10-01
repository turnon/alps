require "fileutils"
require "sequel"
require "alps/point"
require "alps/db/schema"
require "alps/db/point_model"

module Alps
  class DB

    DefaultDir = File.join(Dir.home, '.alps')
    FileUtils.mkdir_p(DefaultDir)

    class << self
      def connect(name)
        path = File.join(DefaultDir, "#{name}.db")
        db = Sequel.sqlite(path)
        new(db)
      end
    end

    EventIds = Point::Events.each_with_index.to_a.to_h

    attr_reader :point

    def initialize(db)
      Schema.create(db)
      @db = db

      @callings = db[:callings]
      @cache_callings = {}

      @files = db[:src_files]
      @cache_files = {}

      @points = db[:points]
      @point = PointModel.construct_point_model(@points, @files, @callings)
    end

    def append(point)
      @db.transaction do
        @points.insert(
          calling_id: fetch_calling_id(point),
          event_id: EventIds[point.event],
          tid: point.tid,
          pid: point.pid,
          src_file_id: fetch_file_id(point),
          lineno: point.lineno,
          current_time: point.current_time,
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

  end
end
