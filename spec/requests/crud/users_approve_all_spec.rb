# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crud::UsersController#approve_all', type: :request do
  let(:fan) { FactoryGirl.create(:user, role: :fan, status: :active) }
  let(:admin) { FactoryGirl.create(:user, role: :admin, status: :active) }

  context 'when logged user is not admin' do
    it 'redirects to another page' do
      sign_in fan

      get '/admin/users/approve_all'

      expect(response.status).to eq(302)
    end
  end

  context 'when no pending reservation' do
    it 'does not change anything' do
      sign_in admin

      count_before = User.where(status: :pending).count

      get '/admin/users/approve_all'

      expect(User.where(status: :pending).count).to eq(count_before)
    end
  end

  context 'when a single user is pending' do
    let(:user_1) { FactoryGirl.create(:user) }

    it 'prevents n+1 queries' do
      sign_in admin

      aggregate_failures do
        expect(user_1.status).to eq('pending')
        expect(User.where(status: :pending).count).to eq(1)
      end

      get '/admin/users/approve_all'

      aggregate_failures do
        expect(user_1.reload.status).to eq('active')
        expect(User.where(status: :pending).count).to eq(0)
      end
    end
  end

  context 'when multiple pending reservations' do
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }

    it 'prevents n+1 queries' do
      sign_in admin

      aggregate_failures do
        expect(user_1.status).to eq('pending')
        expect(user_2.status).to eq('pending')
        expect(User.where(status: :pending).count).to eq(2)
      end

      get '/admin/users/approve_all'

      aggregate_failures do
        expect(user_1.reload.status).to eq('active')
        expect(user_2.reload.status).to eq('active')
        expect(User.where(status: :pending).count).to eq(0)
      end
    end
  end
end
