# frozen_string_literal: true

module Crud
  module UsersHelper
    def filter_password_params(options)
      options.to_h.tap do |o|
        if o[:password].blank?
          o.delete(:password)
          o.delete(:password_confirmation)
        end
      end
    end
  end
end
