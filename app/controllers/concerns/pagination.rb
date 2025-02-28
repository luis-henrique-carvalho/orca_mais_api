# frozen_string_literal: true

module Pagination
  extend ActiveSupport::Concern

  def paginate(data, serializer, serializer_config = {})
    {
      meta: {
        current_page: page,
        total_pages: data.page(page).per(page_size).total_pages,
        current_page_size: page_size,
        total: data.unscope(:select, :order, :includes).count
      },
      data: paginated_data(data, serializer, serializer_config)
    }
  end

  def paginated_data(data, serializer, serializer_config)
    serializer_method = serializer_config.delete(:sti) ? 'render_sti' : 'render_as_hash'

    serializer.send(serializer_method, data.paginate(page, page_size, order), serializer_config)
  end

  private

  def default_order_direction
    'DESC'
  end

  def default_page_size
    50
  end

  def order
    params[:order] || default_order_direction
  end

  def page
    params[:page]&.to_i || 1
  end

  def page_size
    params[:page_size]&.to_i || default_page_size
  end
end
