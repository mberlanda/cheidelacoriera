# frozen_string_literal: true

require 'rails_helper'

class FormMock
  include ActionView::Helpers::FormHelper
  include SimpleForm::ActionViewExtensions::FormHelper

  attr_accessor :output_buffer, :controller

  def initialize
    @output_buffer = ''
    @controller = OpenStruct.new(action_name: :foo)
  end

  # def dom_class(*_args, **_kwargs); end
  # def form_for(*_args, **_kwargs); end
  def polymorphic_path(*_args, **_kwargs); end

  def url_for(*_args, **_kwargs); end
end

RSpec.describe 'CustomInputs' do
  let(:current_user) { FactoryBot.build(:user) }
  let(:reservation) { FactoryBot.build(:reservation) }

  it 'loads the form with empty array fields' do
    form = FormMock.new
    form.simple_form_for(reservation) do |f|
      f.input :fan_names, as: :array, label: 'Elenco Partecipanti', readonly: true
      f.input :fan_names, as: :remove_array, label: 'Elenco Partecipanti', readonly: true
      f.input :fan_last_name, as: :fake, label: false, placeholder: 'Cognome',
                              input_html: { value: current_user.last_name }
    end
  end

  it 'loads the form with empty array fields' do
    form = FormMock.new
    non_empty_reservation = FactoryBot.build(:reservation, fan_names: %w[foo bar])
    form.simple_form_for(non_empty_reservation) do |f|
      f.input :fan_names, as: :array
      f.input :fan_names, as: :remove_array
      f.input :fan_last_name, as: :fake, label: false, placeholder: 'Cognome',
                              input_html: { value: current_user.last_name }
    end
  end
end
