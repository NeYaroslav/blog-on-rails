require "httparty"
require "nokogiri"

class ParsePostsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    root_link = "http://csbc.edu.ua/"

    ParsePosts.perform(root_link: root_link)
  end
end
