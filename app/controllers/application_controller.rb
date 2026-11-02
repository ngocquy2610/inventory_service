class ApplicationController < ActionController::API

  # rescue_from ActiveRecord::RecordNotFound do |e|
  #   render_error("not_found", e.message, :not_found)
  # end # 404

  # rescue_from ArgumentError, StockService::Error do |e|
  #   render_error("invalid_request", e.message, :unprocessable_content)
  # end # 422

  # rescue_from StockService::InsufficientStock do |e|
  #   render_error("insufficient_stock", e.message, :unprocessable_content)
  # end # 422

  # rescue_from ActiveRecord::RecordInvalid do |e|
  #   render_error("validation_failed", e.record.errors.full_messages.to_sentence,
  #                :unprocessable_content, details: e.record.errors.to_hash)
  # end # 422

  # rescue_from ActiveRecord::DeleteRestrictionError do |e|
  #   render_error("validation_failed", e.message, :unprocessable_content)
  # end # 422
  
  private
  # Every success response looks like { data: ..., meta: {...} }
  def render_json(data, status: :ok, meta: {})
    meta = meta.merge(new_restock_tasks: Current.new_restock_tasks.map(&:as_json))
    render json: { data: data, meta: meta }, status: status
  end

  def render_error(code, message, status, details: {})
    render json: { code: code, error: message, details: details }, status: status
  end

  def paginate(scope)
    per = [params.fetch(:per, 10).to_i, 100].min
    scope.page(params[:page]).per(per)
  end

  def page_meta(page) = { total_count: page.total_count }

  # The monolith sends the acting user as user_id (may be nil).
  def current_user = (@current_user ||= User.find_by(id: params[:user_id]))
end
