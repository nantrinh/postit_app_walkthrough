class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.belongs_to :user
      t.string :voteable_type
      t.integer :voteable_id
      t.timestamps
    end

    add_index :votes, [:voteable_type, :voteable_id]
  end
end
