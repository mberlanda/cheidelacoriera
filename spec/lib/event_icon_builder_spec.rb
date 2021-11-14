# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventIconBuilder do
  %i[available fully_booked preferred gold].each do |icon_type|
    context "when #{icon_type}" do
      it 'generates a valid html widget' do
        expect(EventIconBuilder.build(icon_type)).to be_a_valid_html
      end
    end
  end
end
