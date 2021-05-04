class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  default_scope { includes(:user) }

  validates_presence_of :body

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  after_destroy_commit { MessageDeleteBroadcastJob.perform_now(self) }

  def as_json(options = {})
    super(options.merge({ include: [:user] }))
  end
end
