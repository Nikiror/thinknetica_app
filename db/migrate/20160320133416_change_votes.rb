class ChangeVotes < ActiveRecord::Migration
  def change
    change_table :votes do |t|
    t.integer :value
    t.integer :votable_id, index: true
    t.string :votable_type, index: true
    t.belongs_to :user, index: true, foreign_key: true

    end
  end
end
