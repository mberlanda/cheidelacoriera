# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'default post' do
    subject { FactoryGirl.build :post }

    it { should respond_to(:title) }
    it { should respond_to(:image_url) }
    it { should respond_to(:content) }
    it { should respond_to(:date) }
  end
end
