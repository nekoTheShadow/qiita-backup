require 'pathname'
require 'json'
require 'yaml'
require 'open-uri'
require 'fileutils'

class Convert
  def initialize
    @root_dir = Pathname(__dir__).parent
    @backup_dir = @root_dir.join('backup')
    @content_dir = @root_dir.join("content/blog")
    FileUtils::Verbose.rm_rf @content_dir
  end

  def run
    @backup_dir.glob("*/item.json") do |path|
      item = JSON.load(path.read)
    
      id = item["id"]
      title = item["title"]
      date = item["created_at"]
      tags = item["tags"].map{|tag| tag["name"]}
      body = item["body"]
    
      path = @content_dir.join("#{id}/index.md")
      FileUtils::Verbose.mkdir_p path.parent
      path.open("w") do |file|
        YAML.dump({"title" => title, "date" => date, "tags" => tags}, file)
        file << "---"
        file << escape(id, body)
      end
    end

    @backup_dir.glob("*/*.png").each do |image|
    end
  end

  def escape(id, body)
    body.scan(/\!\[.+\]\(.+\)/).each_with_index do |s, i|
      caption = s[s.index('[')+1...s.index("]")]
      filename = "#{i}.png"

      t = "![#{caption}](#{filename})"
      body.sub!(s, t)

      FileUtils::Verbose.cp @backup_dir.join("#{id}/#{filename}"), @content_dir.join("#{id}/#{filename}")
    end

    body.scan(/__.+__/).each do |s|
      next if s =~ /__[[:ascii:]]+__/
      body.sub!(s, s.sub("__", "**"))
    end
    return body
  end
end

Convert.new.run





