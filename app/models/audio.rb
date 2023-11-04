class Audio < ApplicationRecord
  validates :title, presence: true
  validates :folder, presence: true
end
