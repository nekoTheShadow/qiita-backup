require 'open-uri'
require 'json'
require 'pathname'
require 'fileutils'

class Backup
  def initialize
    @backup_dir = Pathname.new(__dir__) + "../backup"
    @qiita_access_token = ENV["QIITA_ACCESS_TOKEN"]
    @backup_dir.glob("*"){|path| FileUtils::Verbose.rm_rf path}
  end

  def fetch_json(uri)
    header = {'Authorization' => "Bearer #{@qiita_access_token}"}
    OpenURI.open_uri(uri, header) do |response|
      return JSON.load(response)
    end
  end

  def run
    (1..).each do |page|
      items = fetch_json("https://qiita.com/api/v2/authenticated_user/items?page=#{page}")
      break if items.empty?

      items.each do |item|
        id = item["id"]
        body = item["body"]

        dir = @backup_dir + "#{id}"
        FileUtils::Verbose.mkdir_p dir

        dir.join("item.json").open('w'){|file| JSON.dump(item, file)}

        comments = fetch_json("https://qiita.com/api/v2/items/#{id}/comments")
        dir.join("comments.json").open('w'){|file| JSON.dump(comments, file)} unless comments.empty?

        body.scan(/\!\[(.+)\]\((.+)\)/).each_with_index do |(caption, uri), i|
          OpenURI.open_uri(uri) do |image|
            dir.join("#{i}.png").open('wb'){|file| file.write(image.read)}
          end
        end
      end
    end
  end
end

Backup.new.run





