class Finding < ApplicationRecord
  belongs_to :document

  CATEGORIES = %w[diagnosis medication procedure key_date provider].freeze

  validates :category, inclusion: { in: CATEGORIES }
  validates :confidence, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end
