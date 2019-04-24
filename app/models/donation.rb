class Donation < ApplicationRecord
    belongs_to :user
    belongs_to :beacon
end
