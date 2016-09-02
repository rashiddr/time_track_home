class Training < ApplicationRecord
	before_save :set_training_datetime
	attr_accessor :training_time, :training_date
	validates :title, presence: true, length: { maximum:25 }
	validates :trainer, presence:true
	validates :training_date, presence:true
	validates :training_time, presence:true
	validates :duration, presence:true
	validates :location, presence:true
	validates_date :training_date,:after => lambda { Date.today },
							 	 :after_message => "must be after #{Date.today} "

	def self.latest_training
		where(training_datetime: Date.today..Date.today + 10.days).order("created_at DESC")
	end
	def self.all_training
		where("training_datetime > ?",Date.today).order("created_at DESC")
	end
	def set_training_datetime
	    if training_date.present? && training_time.present?
	      self.training_datetime="#{training_date} #{training_time}".to_datetime
	    end
  	end
end
