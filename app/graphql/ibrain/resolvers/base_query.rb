# frozen_string_literal: true

class Ibrain::Resolvers::BaseQuery
  include SearchObject.module(:graphql)

  option :filter, type: Ibrain::Types::FilterType, with: :apply_filter
  option :page, type: types.Int, default: 1, with: :apply_page
  option :per_page, type: types.Int, default: 20, with: :apply_per_page
  option :order_by, type: types.String, default: 'created_at DESC', with: :apply_order

  def apply_per_page(scope, value)
    scope.per(value)
  end

  def apply_page(scope, value)
    scope.page(value)
  end

  def apply_filter(_scope, value)
    branches = normalize_filters(value).reduce { |a, e| a.or(e) }

    scope = apply_page(collection.all, params['page'])
    scope = apply_per_page(scope, params['per_page'])
    scope = apply_order(scope, params['order_by'])
    scope.merge branches
  end

  def normalize_filters(value, _branches)
    return {} if value.blank?

    value
  end

  def apply_order(scope, value)
    scope.order(value)
  end

  def current_user
    context[:current_user]
  end

  def collection
    Kernel.const_get(class_name)
  end

  private

  def class_name
    self.class.type.of_type.name.demodulize.split('Type').first
  end
end
