class AddImageColumnsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :image_url, :string
    add_column :posts, :image_file, :binary
  end
end
