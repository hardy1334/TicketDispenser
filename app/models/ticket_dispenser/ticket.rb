# frozen_string_literal: true

module TicketDispenser
  class Ticket < ApplicationRecord
    belongs_to :course, optional: true
    belongs_to :owner, class_name: :User, optional: true

    has_many :messages, dependent: :destroy

    module Statuses
      OPEN             = 0
      WAITING_RESPONSE = 1
      RESOLVED         = 2
    end

    validates :status, numericality: true, inclusion: {
      in: Statuses.constants.map { |c| Statuses.const_get c }
    }

    def reply_to
      self.messages.first.sender
    end

    def recipients
      senders = self.messages.map { |message| message.sender }
      senders.uniq
    end

    def other_recipient(user)
      recipients.reject { |recipient| recipient == user }.first
    end
  end
end
