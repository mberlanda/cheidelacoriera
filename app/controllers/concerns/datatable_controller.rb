# frozen_string_literal: true

module DatatableController
  extend ActiveSupport::Concern

  included do
    helper_method :model_name, :datatable_columns

    private

    delegate :model_name, :model_class, :decorator_name, to: 'self.class'
  end

  def datatable_columns
    []
  end

  def index
    render 'crud/datatable_index'
  end

  def datatable_index
    model_datatable_index(model_scope)
  end

  def model_datatable_index(model_result)
    @response = model_result
    @data = @response.map do |r|
      decorator_name.send(:new, r).send(:datatable_index)
    end
    render_datatable_response
  end

  def render_datatable_response
    respond_to do |format|
      format.json { render 'shared/search' }
    end
  end

  module ClassMethods
    def model_name
      @model_name ||= model_class.name.underscore
    end

    def model_class
      @model_class ||= controller_name.classify.constantize
    end

    def decorator_name
      @decorator_name ||= "#{model_name.camelize}Decorator".constantize
    end
  end
end
