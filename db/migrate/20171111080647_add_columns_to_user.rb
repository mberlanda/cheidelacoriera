# frozen_string_literal: true

class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :place_of_birth, :string
    add_column :users, :phone_number, :string
    add_column :users, :newsletter, :boolean, default: true
    add_column :users, :activation_date, :date
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :date_of_birth
    remove_column :users, :place_of_birth
    remove_column :users, :phone_number
    remove_column :users, :newsletter
    remove_column :users, :activation_date
  end
end
