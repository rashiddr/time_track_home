class UserProject < ApplicationRecord
	belongs_to:user
	belongs_to:project,-> { with_deleted }, inverse_of: :user_projects
	#validates :project_id, uniqueness: { scope: [:user_id] }
	#validates :project_id, presence: true
	validates :user_id, presence:true 
	def self.select_users(proj_id)
		includes(:user).where(project_id:proj_id).order("created_at DESC")
	end
end
