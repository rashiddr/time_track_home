class UsersController < ApplicationController
	before_action :authenticate_user!
	def list_users
		if(params[:project_id].blank?)
			@user=User.users_list.paginate(page:params[:page], per_page:10)
		else
			@project=Project.find(params[:project_id])
			@user=@project.users.paginate(page:params[:page], per_page:10)
		end
	end
	def show
		@user=User.find(params[:id])
		respond_to do |format|
      		format.html
      		format.js
      	end
	end
	def new_joiners
		@new_join=User.new_joiners
	end
	def birthdays
		@user_birthday_recent=User.birthday_ordered_asc
	end
	def edit_profile
		@user=current_user
	end
	def update_profile
		@user=User.find(current_user.id)
		if(@user.update(user_params))
			flash[:success] = "Profile edited successfully"
  			redirect_to root_path
  		else
  			flash.now[:error] = "Unable to update profile"
  			render 'edit_profile'
  		end
	end
	private
	def user_params
    	params.require(:user).permit(:user_pic,:first_name, :last_name, :place, :dob, :username, :email, :project_id)
  	end 
end
