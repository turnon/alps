require "active_record"

module Alps
  module Query
    class Point < ActiveRecord::Base
      belongs_to :src_file, class_name: '::Alps::Query::SrcFile'
      belongs_to :calling, class_name: '::Alps::Query::Calling'

      def event
        ::Alps::Point::Events[event_id]
      end
    end

    class SrcFile < ActiveRecord::Base
    end

    class Calling < ActiveRecord::Base
    end

    class << self
      def connect(name)
        db_path = ::Alps::DB.path(name)
        ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_path)
        ActiveRecord::Base.logger = Logger.new(STDOUT)
      end
    end
  end
end
