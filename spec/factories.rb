Factory.define :episode do |f|
  f.name         'Foo Bar'
  f.description  'Lorem'
  f.notes        'Ipsum'
  f.published_at Time.now
end

Factory.define :comment do |f|
  f.name     'Foo'
  f.email    'foo@example.com'
  f.site_url 'example.com'
  f.content  'Hello world.'
  f.episode { |c| c.association(:episode) }
end

Factory.define :sponsor do |f|
  f.name      'ACME Inc.'
  f.site_url  'http://example.com'
  f.image_url '/assets/sponsors/example.png'
  f.active    true
end
