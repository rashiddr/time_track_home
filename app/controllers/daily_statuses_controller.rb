class DailyStatusesController < ApplicationController
	before_action :authenticate_user!
	before_action :is_admin, :only => [:verify_statuses]
	def index
		@daily_status=DailyStatus.new()
		@status_history=DailyStatus.previous_statuses(current_user.id).paginate(page:params[:page], per_page:5)	
	end
	def new
		@daily_status=  DailyStatus.new()
	end
	def create
	 	@daily_status= DailyStatus.new(status_params)
		@daily_status.user_id=current_user.id
		if(@daily_status.save)
			flash[:success]="Status submitted sucessfully"
			redirect_to @daily_status
		else
			flash.now[:error] = "Unable to save project"
			render 'new'
		end
	end
	def edit
		@daily_status= DailyStatus.find(params[:id])
	end
	def update
		@daily_status= DailyStatus.find(params[:id]) 
		if(@daily_status.update(status_params))
			flash[:success]="Status updated sucessfully"
  			redirect_to @daily_status
  		else
  			flash.now[:error] = "Unable to update project"
  			render 'edit'
  		end
	end
	def show
		@daily_status=DailyStatus.find(params[:id])
		@project=Project.find(@daily_status.project_id)
	end
	def add_status
		if request.xhr? # respond to Ajax request
		    @daily_status= DailyStatus.new(status_params)
		    @daily_status.user_id=current_user.id
		    if(@daily_status.save)
	    		render partial: 'new_status'
	    	else
	    		result = 'failed'
	    		render json:result
	    	end
		else            # respond to normal request
		 	
		end
	end
  	def verify_statuses #manager to view daily status of all employe
  		if(params[:search_date].blank? && params[:user].blank?)
			@daily_status=DailyStatus.previous_day_statuses
		elsif(params[:search_date].blank?)
			@daily_status=DailyStatus.employe_wise_statuses(params[:user][:user_id])	
		elsif(params[:user][:user_id].blank?)
			@daily_status=DailyStatus.date_wise_statuses(params[:search_date])
		else
			@daily_status=DailyStatus.status_of_user_at(params[:search_date],params[:user][:user_id])
		end 
  	end
  	private
  	def status_params
    	params.require(:daily_status).permit(:status_date, :project_name, :duration, :work_done, :project_id, :checked)
  	end
end
