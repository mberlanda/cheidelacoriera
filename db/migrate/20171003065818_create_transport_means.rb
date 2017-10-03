# frozen_string_literal: true

class CreateTransportMeans < ActiveRecord::Migration[5.0]
  def up
    create_table :transport_means do |t|
      t.string :kind
      t.string :company
      t.string :phone_number
      t.string :email
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :transport_means
  end
end
