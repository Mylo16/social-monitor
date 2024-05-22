class CreateMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :metrics do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :likes
      t.integer :comments_count
      t.integer :shares
      t.integer :impressions

      t.timestamps
    end
  end
end
