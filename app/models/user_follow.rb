class UserFollow < ApplicationRecord
    belongs_to :topic, optional: true
    belongs_to :user
end
