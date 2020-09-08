# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ExecutiveUser.create(:user_id => 'init', :nickname => "init", :admin => true, :email => 'john_appleseed@domain.com', :password => '1', :receive_email => true, :position => 0)