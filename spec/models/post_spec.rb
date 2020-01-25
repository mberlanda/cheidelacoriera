# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'default post' do
    subject { FactoryBot.build :post }

    it { should respond_to(:title) }
    it { should respond_to(:image_url) }
    it { should respond_to(:content) }
    it { should respond_to(:date) }
    it { should respond_to(:slug) }
  end

  context 'slug' do
    subject { FactoryBot.create :post, title: 'title' }

    it 'should be generated from title if blank' do
      expect(subject.slug).to eq 'title'
    end

    it 'should be generated again when title change' do
      expect { subject.update! title: 'another title' }.to change {
        subject.slug
      }.from('title').to('another-title')
    end
  end
end
