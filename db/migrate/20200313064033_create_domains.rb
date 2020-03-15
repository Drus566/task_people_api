# frozen_string_literal: true

class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string :path, null: false
      t.string :status
      t.string :error

      t.timestamps
    end
    add_index :domains, :path, unique: true
  end
end
