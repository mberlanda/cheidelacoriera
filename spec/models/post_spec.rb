# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'default post' do
    subject { FactoryBot.build :post }

    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:image_url) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:slug) }
  end

  context 'slug' do
    subject { FactoryBot.create :post, title: 'title' }

    it 'is generated from title if blank' do
      expect(subject.slug).to eq 'title'
    end

    it 'is generated again when title change' do
      expect do
        subject.update! title: 'another title'
      end.to change(subject,
                    :slug).from('title').to('another-title')
    end
  end
end
