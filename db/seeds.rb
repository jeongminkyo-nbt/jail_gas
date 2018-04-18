# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create( email: 'admin@email.com', password: 'tlsrnd13!@', confirmed_at: Time.now )
admin_user.add_role :admin

Config.create( product_name: '10kg', cost: 0, count: 0)
Config.create( product_name: '20kg', cost: 0, count: 0)
Config.create( product_name: '50kg', cost: 0, count: 0)
Config.create( product_name: 'air', cost: 0, count: 0)
Config.create( product_name: 'butane', cost: 0, count: 0)
Config.create( product_name: 'argon', cost: 0, count: 0)
Config.create( product_name: 'share', cost: 0, count: 0)
Config.create( product_name: 'per_money', cost: 0, count: 0)