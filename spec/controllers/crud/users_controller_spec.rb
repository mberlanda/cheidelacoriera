# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crud::UsersController, type: :controller do
  describe 'GET index with user not logger' do
    it 'has http status 302' do
      get :index
      expect(response).to have_http_status(:found)
    end

    it 'renders no template' do
      get :index
      expect(response).to render_template(nil)
    end
  end

  describe 'GET index with admin user' do
    it 'has http status 200' do
      sign_in admin_user
      get :index
      expect(response).to have_http_status(:ok)
      sign_out admin_user
    end
  end

  describe 'GET index with fan user' do
    it 'has http status 302' do
      sign_in fan_user
      get :index
      expect(response).to have_http_status(:found)
      sign_out fan_user
    end
  end

  def admin_user
    @admin_user ||= FactoryBot.create(:user, role: 'admin', status: 'active')
  end

  def fan_user
    @fan_user ||= FactoryBot.create(:user, role: 'fan', status: 'active')
  end
end
