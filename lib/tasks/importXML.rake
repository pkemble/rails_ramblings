#imports xml from an exported blogger feed
require 'rss'
namespace :db do
  task :import, [:filename] => [:environment] do | task, args |
  xml = File.read(args[:filename])
    feed = RSS::Parser.parse xml
    feed.items.each do | item |
      Post.create( [:body => item.description, :title => item.title, :created_at => item.pubDate, :user_id => 1 ])
    end
  end
end