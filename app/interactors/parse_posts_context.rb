# frozen_string_literal: true

class ParsePostsContext < ApplicationContext
  attributes :root_link, :news_ids
  validates :root_link, presence: true, on: :calling
end
