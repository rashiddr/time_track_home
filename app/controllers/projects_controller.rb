class ProjectsController < ApplicationController
	before_action :authenticate_user!
	before_action :is_admin, except: [:latest_projects,:manage_projects,:remove_employe_from_project]
	
	def index
		@project=Project.project_list.paginate(page:params[:page], per_page:6)
	end
	def new 	
		@project=Project.new
	end
	def create
		@project = Project.new(project_params)
 		if(@project.save)
 			flash[:success]="Project created"
  			redirect_to @project
  		else
  			flash.now[:error] = "Unable to save project"
  			render 'new'
  		end
  	end
	def edit
		@project= Project.find(params[:id])		
	end
	def update
		@project= Project.find(params[:id])
		if(@project.update(project_params))
			flash[:success]="Project Updated"
  			redirect_to @project
  		else
  			flash.now[:error] = "Unable to update project"
  			render 'edit'
  		end
  	end
	def show
		@project=Project.find(params[:id])
	end
	def destroy
		@project=Project.find(params[:id])
		@project.destroy
		flash[:success]="Project deleted"
		redirect_to projects_path
	end
	def latest_projects #list latest projects
		@projects=Project.project_list.paginate(page:params[:page], per_page:6)
	end
	def manage_projects
		if(!params[:user].blank?)
			@user_project=UserProject.new
			@user_project.project_id=params[:project_id]
			@user_project.user_id=params[:user][:ids]
			@user_project.save
			redirect_to(:back) 
		end
		if(!params[:selected_project].blank?)	
			@users=UserProject.paginate(page:params[:page], per_page:5).select_users(params[:selected_project][:ids])
			@project=Project.find(params[:selected_project][:ids])
		end
	end	
	def auto_complete_projects
		@project=Project.where("project_name LIKE ?","#{params[:term]}%")
		respond_to do |format|  
    		format.html
    		format.json { render json: @project.map{|x| {label:x.project_name,value:x.id} } }
    	end
	end
	def remove_employe_from_project
		@user=UserProject.find(params[:user_project_id])
		@user.destroy
		flash[:success]="Employe removed"
		redirect_to(:back)
	end
	private
  	def project_params
    	params.require(:project).permit(:project_name, :client, :description, :project_manager,user_projects_attributes:[:user_id,:_destroy,:id])
  	end
end
