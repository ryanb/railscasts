Factory.define :episode do |f|
  f.name         'Foo Bar'
  f.description  'Lorem'
  f.notes        'Ipsum'
  f.seconds      600
  f.published_at Time.now
end

Factory.define :tag do |f|
  f.name "Bar"
end

Factory.define :comment do |f|
  f.name     'Foo'
  f.email    'foo@example.com'
  f.site_url 'example.com'
  f.content  'Hello world.'
  f.episode { |c| c.association(:episode) }
end

Factory.define :user do |f|
  f.name "Foo Bar"
  f.sequence(:github_username) { |n| "foo#{n}" }
  f.sequence(:github_uid) { |n| n }
end
