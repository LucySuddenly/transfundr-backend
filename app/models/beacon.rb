class Beacon < ApplicationRecord
    belongs_to :user
    has_many :donations
    has_one :profile, through: :user
end
