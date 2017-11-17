# frozen_string_literal: true

class AddMailSentToReservations < ActiveRecord::Migration[5.0]
  def up
    add_column :reservations, :mail_sent, :date
  end

  def down
    remove_column :reservations, :mail_sent, :date
  end
end
