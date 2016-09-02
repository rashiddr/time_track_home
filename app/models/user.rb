class User < ApplicationRecord
  after_initialize :default_values
  acts_as_birthday :dob #for birthday
  has_many:user_projects
  has_many:projects, through: :user_projects
  has_many:daily_statuses
  has_many:comments
  has_attached_file :user_pic, styles: { medium: "300x300#", thumb: "100x100#", smallthumb: "34x34#" }, default_url: "/images/default_:style.png"
  validates_attachment_content_type :user_pic, content_type: /\Aimage\/.*\Z/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:Manager, :Employe]
  validates_with AttachmentSizeValidator, attributes: :user_pic, less_than: 3.megabytes
  validates :first_name, presence: true, length: { maximum:15 }
  validates :last_name, length: { maximum:15 }
  validates :place, presence:true, length: { maximum:15 }
  validates :dob, presence:true
  validates :username, presence:true, uniqueness: true, length: { maximum:15 }
  validates_date :dob, :on_or_before => lambda { Date.current - 15.years},
                 :on_or_before_message => 'must be atleast 15 years ago'
  def self.new_joiners
    where(created_at:Date.today - 20.days..Date.today)
  end
  def self.users_list
    order("created_at DESC")
  end
  def self.birthday_ordered_asc
    find_dobs_for(Date.today, Date.today + 15.days).order("MONTH(dob) ASC","DAY(dob) ASC")
  end  
  def self.add_admins(user_id)
    where(id: user_id).update_all(role: 0)
  end
  def self.list_admins
    where(role: 0)
  end
  def self.select_available_users(projects_id)#select users who are not already in this projects
   User.where('id NOT IN (?)',UserProject.select("user_id").where(project_id: projects_id).distinct.pluck(:user_id).presence || [0]) 
  end
  def self.select_trainees
    order("created_at DESC").limit(5);
  end
  private
    def default_values
      self.role ||= "Employe"
    end
end
                 
