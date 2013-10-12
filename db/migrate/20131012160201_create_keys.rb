class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string :keystring
      t.string :claimed_by

      t.timestamps
    end
  end
end
