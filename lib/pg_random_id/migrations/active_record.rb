require 'active_record'
require 'active_record/migration'
require 'pg_random_id/sql'

module PgRandomId
  module Migrations
    module ActiveRecord
      # Create in the database the function (pri_scramble(bigint, bigint))
      # necessary for this gem to work.
      def create_random_id_functions
        execute PgRandomId::Sql::install
      end
      
      # Apply a random id to a table.
      # If you don't give a key, a random one will be generated.
      # The ids will be based on sequence "#{table}_#{column}_seq".
      # You need to make sure the table is empty; migrating existing records is not implemented.
      def random_id table, column = :id, key = nil
        execute PgRandomId::Sql::apply(table, column, key)
      end

      # Apply a random string id to a table. 
      # Also changes the type of the id column to char(6).
      # If you don't give a key, a random one will be generated.
      # The ids will be based on sequence "#{table}_#{column}_seq", 
      # scrambled and base32-encoded.
      # You need to make sure the table is empty; migrating existing records is not implemented.
      def random_str_id table, column = :id, key = nil
        execute PgRandomId::Sql::apply_str(table, column, key)
      end
    end
  end
end

ActiveRecord::Migration.send :include, PgRandomId::Migrations::ActiveRecord
