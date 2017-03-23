# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

  User.create(
    [
      {
        id: 1,
        name: "Petr"
      },
      {
        id: 2,
        name: "Andy"
      },
      {
        id: 3,
        name: "Clark"
      },
      {
        id: 4,
        name: "Artem"
      }
    ]
  )

  # SELECT setval('your_table_id_seq', (SELECT MAX(id) FROM your_table));
  # ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaStatements#reset_pk_sequence!
  # reset_pk_sequence!(table, pk = nil, sequence = nil)
  ActiveRecord::Base.connection.reset_pk_sequence!('users')
  # ActiveRecord::Base.connection.tables
