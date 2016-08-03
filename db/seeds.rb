# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

group = Group.where(name: 'Admins').first_or_create

john = Person.where(name: 'John Doe').first_or_create
jane = Person.where(name: 'Jane Doe').first_or_create

john.memberships.where(group: group).first_or_create
jane.memberships.where(group: group).first_or_create

john.contacts.where(value: 'john@acme.co').first_or_create
john.contacts.where(value: 'john.doe@acme.co').first_or_create

jane.contacts.where(value: 'jane@acme.co').first_or_create
