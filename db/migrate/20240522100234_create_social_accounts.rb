class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :platform
      t.string :username
      t.string :access_token

      t.timestamps
    end
  end
end
