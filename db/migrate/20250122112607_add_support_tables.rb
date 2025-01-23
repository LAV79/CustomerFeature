class AddSupportTables < ActiveRecord::Migration[7.2]
  def change
    create_table :skills_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :skill
    end  

    create_table :interests_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :interest
    end  
  end
end
