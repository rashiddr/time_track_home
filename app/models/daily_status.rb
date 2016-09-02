class DailyStatus < ApplicationRecord
	belongs_to:user
	belongs_to:project, -> { with_deleted }
	validates :user_id, uniqueness: { scope: [:status_date, :project_id] }
	validates :status_date, presence: true
  	validates :project_id, presence: true
  	validates :duration, presence:true
  	validates :work_done, presence:true
  	validates_date :status_date, :on_or_before => lambda { Date.current },
                                 :on_or_before_message => 'must be less than or equal to today',
							 	 :on_or_after => lambda { 7.days.ago },
							 	 :on_or_after_message => " must be after #{Date.today - 7.days} "

	def self.previous_statuses(current_user_id)
		includes(:project).where(user_id:current_user_id).order("created_at DESC")
	end
	def self.previous_day_statuses
		includes(:project,:user).where(status_date: Date.today - 1.days).order("created_at DESC")
	end
	def self.employe_wise_statuses(selected_user_id)
		includes(:project,:user).where(user_id: selected_user_id).order("created_at DESC")
	end
	def self.date_wise_statuses(selected_date)
		includes(:project,:user).where(status_date: selected_date).order("created_at DESC")
	end
	def self.status_of_user_at(selected_date,selected_user_id)
		includes(:project,:user).where(status_date: selected_date, user_id: selected_user_id ).order("created_at DESC")
	end
end
