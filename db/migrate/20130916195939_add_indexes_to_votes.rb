class AddIndexesToVotes < ActiveRecord::Migration
  def change
    add_index :votes, :value
  end
end
