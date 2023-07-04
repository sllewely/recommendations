# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(name: "React Client", redirect_uri: "", scopes: "", confidential: false)
  Doorkeeper::Application.create!(name: "iOS Client", redirect_uri: "", scopes: "", confidential: false)
  Doorkeeper::Application.create!(name: "Android Client", redirect_uri: "", scopes: "", confidential: false)
end

Test.first_or_create(cat_name: 'Ziggy', legs: 3)
Test.first_or_create(cat_name: 'Ion', legs: 4)


ziggy = User.find_or_create_by(first_name: 'Ziggy', last_name: 'Boy', email: 'ziggy@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
ion = User.find_or_create_by(first_name: 'Ion', last_name: 'Princess', email: 'ion@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
giles = User.find_or_create_by(first_name: 'Giles', last_name: 'Baby', email: 'giles@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end


Friendship.find_or_create_by(requestor: ziggy, requested: ion) { |f| f.accepted_at = DateTime.now }
Friendship.find_or_create_by(requestor: ziggy, requested: giles)
Friendship.find_or_create_by(requestor: ion, requested: giles)
