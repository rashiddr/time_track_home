class Comment < ApplicationRecord
	belongs_to:daily_status
	belongs_to:user
end
