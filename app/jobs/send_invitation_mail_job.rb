class SendInvitationMailJob < ApplicationJob
  queue_as :default
  def perform(training)
    @training = training
    @users=User.select_trainees
    @users.each do |user|
    	TrainingMailer.invitation_email(user,@training).deliver_later
    end
  end
end
