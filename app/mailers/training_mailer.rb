class TrainingMailer < ApplicationMailer
	def invitation_email(users,training)
	    @user = users
	    @training=training
	    mail( from: 'Space <rashiddr2011@gmail.com>', to: @user.email, subject: 'Training Invitation')
    end
end
