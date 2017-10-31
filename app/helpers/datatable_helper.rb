# frozen_string_literal: true

module DatatableHelper
  def crud_datatable(model_name, *headers)
    DatatableHelper::Builder.table(model_name, *headers)
  end

  class Builder
    include ActionView::Helpers::TagHelper

    attr_accessor :headers, :model_name, :output_buffer
    attr_reader :table_class

    def initialize(model_name = :crud, *headers)
      @model_name = model_name || :crud
      @headers = headers || []
      @table_class = %w[table table-striped table-hover datatable-table]
    end

    def self.table(model_name = nil, *headers)
      model_name ||= :crud
      headers ||= []
      t = new(model_name, *headers)
      t.to_html
    end

    def to_html
      content_tag :div, class: 'container' do
        content_tag(:div, nil, class: "#{model_name}-index-buttons") +
          content_tag(:table, class: table_class, id: "#{model_name}-table") do
            content_tag(:thead) do
              headers.collect { |h| format_header(h) }.join.html_safe
            end
          end
      end
    end

    private

    def format_header(head)
      content_tag(:th, translate(head))
    end

    def translate(head)
      return head if model_name == :crud
      I18n.t(
        "activerecord.attributes.#{model_name}.#{head}",
        default: head
      )
    end
  end
end
