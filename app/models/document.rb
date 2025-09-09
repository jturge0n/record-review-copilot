class Document < ApplicationRecord
  has_many :findings, dependent: :destroy

  STATUSES = %w[uploaded processing ready error].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :title, presence: true
end
