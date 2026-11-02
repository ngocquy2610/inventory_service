class Current < ActiveSupport::CurrentAttributes
  attribute :new_restock_tasks

  def new_restock_tasks = super || (self.new_restock_tasks = [])
end