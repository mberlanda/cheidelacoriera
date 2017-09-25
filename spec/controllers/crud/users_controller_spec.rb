# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crud::UsersController, type: :controller do
  include Devise::Test::IntegrationHelpers

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

  describe 'GET index with logged user' do
    it 'has http status 200' do
      authenticate_user!
      get :index
      expect(response).to have_http_status(:found)
    end
  end

  def authenticate_user!
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
end
