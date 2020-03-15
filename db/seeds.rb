# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
domain_one = Domain.create(path: 'www.yandex.ru')
CheckWorker.perform_async(domain_one.id)

domain_two = Domain.create(path: 'otvet.mail.ru')
CheckWorker.perform_async(domain_two.id)

domain_three = Domain.create(path: 'vk.com')
CheckWorker.perform_async(domain_three.id)

puts 'Database was successfully seeded'
