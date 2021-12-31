class CreatePosts < ActiveRecord::Migration[4.2]
  def change
    create_table(:posts) do |t|
      t.text :title
      t.text :body
      t.timestamps
    end
  end
end
