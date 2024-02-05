class Post < ApplicationRecord
  has_one_attached :image_file
  validates_presence_of :title
  has_rich_text :content
  has_many :comments, dependent: :destroy
end
