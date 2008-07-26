namespace :legacy do
  desc "Migrate database from old railscasts site"
  task :migrate => :environment do
    require 'mysql'
    $db = Mysql.connect('localhost', 'root', ENV['DBPW'], 'railscasts_legacy')
    
    puts "starting episodes"
    migrate_model Episode, 'episodes' do |row|
      notes = row[:notes] || ''
      notes.gsub!(/<code lang="(.+)">/, '@@@ \1')
      notes.gsub!("</code>", "@@@")
      row.slice(:id, :name, :published_at, :position, :description, :permalink).merge(:notes => notes)
    end
    
    puts "starting tags"
    migrate_model Tag, 'tags' do |row|
      row
    end
    
    puts "starting taggings"
    migrate_model Tagging, 'episodes_tags' do |row|
      row
    end
    
    puts "starting downloads"
    migrate_model Download, 'episodes' do |row|
      min, sec = *row[:duration].split(':').map(&:to_i)
      seconds = min*60 + sec
      [
        {
          :episode_id => row[:id],
          :format => 'mov',
          :url => "http://media.railscasts.com/videos/#{row[:file_name]}.mov",
          :seconds => seconds,
          :bytes => row[:file_size]
        },
        {
          :episode_id => row[:id],
          :format => 'm4v',
          :url => "http://media.railscasts.com/ipod_videos/#{row[:file_name]}.m4v",
          :seconds => seconds,
          :bytes => row[:ipod_file_size]
        }
      ]
    end
    
    puts "starting comments"
    migrate_model Comment, "comments WHERE approved='1' AND id NOT IN (39396, 39422)" do |row|
      row.except(:approved)
    end
  end
  
  def migrate_model(model_class, table_name)
    model_class.delete_all
    rows = $db.query("SELECT * FROM #{table_name}")
    rows.each_hash do |row|
      insert_row(model_class, yield(row.symbolize_keys))
    end
  end
  
  def insert_row(model_class, row)
    if row.kind_of? Array
      row.each { |r| insert_row(model_class, r) }
    else
      record = model_class.new
      row.each do |name, value|
        value = Time.parse(value) + 7.hours if name.to_s =~ /_at$/ # convert times to UTC
        record.write_attribute(name, value)
      end
      record.save(false) # skips validation
    end
  end
end
