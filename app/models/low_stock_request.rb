class LowStockRequest < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient
  belongs_to :reviewed_by, class_name: "User", optional: true

  enum :status,  { pending: 0, approved: 1, rejected: 2, completed: 3 }, default: :pending
  enum :urgency, { low: 0, normal: 1, high: 2 }, default: :normal

  scope :recent, -> { order(created_at: :desc) }
  scope :open, -> { where(status: %i[pending approved]) }

  scope :by_status, ->(status) { where(status: status) if status.present? && statuses.key?(status) }
  scope :by_urgency, ->(urgency) { where(urgency: urgency) if urgency.present? && urgencies.key?(urgency) }

  validates :note, length: { maximum: 500 }, allow_blank: true
  validate  :requester_must_be_kitchen_staff

  REVIEW_TRANSITIONS = {
    "pending" => %w[approved rejected],
    "rejected" => %w[approved],
    "approved" => %w[completed]
  }.freeze

  #TODO - Return json
  def review!(reviewer, decision, note: nil)
    decision = decision.to_s
    unless %w[approved rejected completed].include?(decision)
      raise ArgumentError, "invalid decision: #{status}"
    end

    unless REVIEW_TRANSITIONS.fetch(status,[]).include?(decision)
      raise ArgumentError, "request is already #{status}"
    end

    if decision == "rejected" && note.blank?
      raise ArgumentError, "rejection reason is required"
    end

    transaction do
      update!(status: decision, reviewed_by: reviewer, reviewed_at: Time.current, review_note: note.presence)
      create_restock_task! if approved?
    end
  end

end