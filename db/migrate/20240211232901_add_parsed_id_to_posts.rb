class AddParsedIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :parsed_id, :string
  end
end
