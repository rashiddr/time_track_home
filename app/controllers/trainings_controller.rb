class TrainingsController < ApplicationController
	before_action :authenticate_user!
	before_action :is_admin, except: [:list_training,:show]
	def index
		@training=Training.order("created_at DESC").paginate(page:params[:page], per_page:10)
	end
	def new
		@training=Training.new()
	end
	def create
		@training = Training.new(training_params)
 		if(@training.save)
 			SendInvitationMailJob.set(wait: 20.seconds).perform_later(@training)
 			session[:request_from] = 'create'
 			flash[:success]="Training created"
  			redirect_to @training
  		else
  			flash.now[:error] = "Unable to save training"
  			render 'new'
  		end
  	end
	def edit
		@training= Training.find(params[:id])
		@training.training_date=@training.training_datetime.to_date
		@training.training_time=@training.training_datetime.strftime("%I:%M %p")	
	end
	def update
		@training= Training.find(params[:id])
		if(@training.update(training_params))
			session[:request_from] = 'create'
			flash[:success]="Training updated"
  			redirect_to @training
  		else
  			flash.now[:error] = "Unable to update training"
  			render 'edit'
  		end
	end
	def show
		@training=Training.find(params[:id])
	end
	def destroy
		@training=Training.find(params[:id])
		@training.destroy
		respond_to do |format|
      		format.html { redirect_to trainings_path }
      		format.js   { render :layout => false }
   		end		
	end
	def list_training #list latest trainings
		session[:request_from] = 'list_training'
		@training=Training.all_training.paginate(page:params[:page], per_page:10)
	end
	private
  	def training_params
    	params.require(:training).permit(:title, :trainer, :training_date, :training_time, :location, :duration)
  	end
end
