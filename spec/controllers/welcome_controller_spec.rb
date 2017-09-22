require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

  describe 'GET index' do
    it 'has http status OK' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
