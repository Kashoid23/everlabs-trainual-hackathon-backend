class Folder < ApplicationRecord
  validates :name, presence: true

  has_many :audios
end
