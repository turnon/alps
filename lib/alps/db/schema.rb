module Alps
  class DB
    module Schema
      class << self
        def create(db)
          create_table_unless(db, :points) do
            primary_key :id
            column :calling_id, Integer
            column :event_id, Integer
            column :tid, Integer
            column :pid, Integer
            column :src_file_id, Integer
            column :lineno, Integer
            column :catch_time, DateTime
          end

          add_index_unless(db, :points, [:tid, :catch_time])

          create_table_unless(db, :src_files) do
            primary_key :id
            column :path, String
          end

          create_table_unless(db, :callings) do
            primary_key :id
            column :method_call, String
          end
        end

        def create_table_unless(db, name, &block)
          db.create_table(name, &block) unless db.table_exists?(name)
        end

        def add_index_unless(db, table, columns)
          return if db.indexes(table).values.any?{ |cfg| cfg[:columns] == columns }
          db.add_index(table, columns)
        end
      end
    end
  end
end
