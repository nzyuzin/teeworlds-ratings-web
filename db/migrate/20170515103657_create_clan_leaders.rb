class CreateClanLeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :clan_leaders do |t|
      t.references :clan, foreign_key: true
      t.references :player, foreign_key: true
    end
  end
end
