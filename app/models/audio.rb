class Audio < ApplicationRecord
  validates :title, presence: true

  belongs_to :folder
end
