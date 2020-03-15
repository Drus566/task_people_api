# frozen_string_literal: true

domain_one = Domain.create(path: 'www.yandex.ru')
CheckWorker.perform_async(domain_one.id)

domain_two = Domain.create(path: 'otvet.mail.ru')
CheckWorker.perform_async(domain_two.id)

domain_three = Domain.create(path: 'vk.com')
CheckWorker.perform_async(domain_three.id)

puts 'Database was successfully seeded'
