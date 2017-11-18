# frozen_string_literal: true

class AddMailingListedToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :mailing_listed, :boolean, default: false
  end

  def down
    remove_column :users, :mailing_listed
  end
end
