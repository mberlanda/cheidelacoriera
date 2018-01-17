# frozen_string_literal: true

require 'rails_helper'

describe DatatableHelper do
  include DatatableHelper

  context 'default empty Builder' do
    before do
      @b = DatatableHelper::Builder.new
    end

    it '.model_name' do
      expect(@b.model_name).to eq(:crud)
    end

    it '.headers' do
      expect(@b.headers).to eq([])
    end

    it '.table_class' do
      expect(@b.table_class).to eq(
        %w[
          table table-striped table-hover datatable-table
        ]
      )
    end

    it '.to_html' do
      expect(@b.to_html).to eq(
        '<div class="container">'\
        '<div class="crud-index-buttons"></div>'\
        '<table class="table table-striped table-hover datatable-table"'\
        ' id="crud-table">'\
        '<thead></thead>'\
        '</table></div>'
      )
    end
  end

  context 'some values Builder' do
    it '#table' do
      actual = DatatableHelper::Builder.table(nil, 'a', 'b', 'c')
      expect(actual).to eq(
        '<div class="container">'\
        '<div class="crud-index-buttons"></div>'\
        '<table class="table table-striped table-hover datatable-table"'\
        ' id="crud-table">'\
        '<thead><th>a</th><th>b</th><th>c</th></thead>'\
        '</table></div>'
      )
    end
  end

  it 'crud_datatable' do
    actual = crud_datatable(nil, 'a', 'b', 'c')
    expect(actual).to eq(
      '<div class="container">'\
      '<div class="crud-index-buttons"></div>'\
      '<table class="table table-striped table-hover datatable-table"'\
      ' id="crud-table">'\
      '<thead><th>a</th><th>b</th><th>c</th></thead>'\
      '</table></div>'
    )
  end
end
