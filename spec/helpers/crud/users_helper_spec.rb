# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crud::UsersHelper do
  describe 'should perform update params validation' do
    it 'filters blank passwords' do
      blank_password = controller_params(password: '').permit!
      actual = filter_password_params(blank_password)
      expect(actual.keys).not_to include(:password)
    end

    it 'keeps valid passwords' do
      valid_password = controller_params(password: 'valid123').permit!
      actual = filter_password_params(valid_password)
      expect(actual.keys).to include('password')
    end
  end

  def controller_params(options)
    ActionController::Parameters.new(options)
  end
end
