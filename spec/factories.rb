Factory.define :episode do |f|
  f.name         'Foo Bar'
  f.permalink    'foo-bar'
  f.description  'Lorem'
  f.notes        'Ipsum'
  f.published_at Time.now
end
