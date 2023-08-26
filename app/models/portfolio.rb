class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }

end
