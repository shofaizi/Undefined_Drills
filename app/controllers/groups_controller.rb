class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_group_id, except: [:index, :new, :create]
  before_action :authorize, only: [:edit, :update, :destroy]
  before_action :find_user, only: [:index]


  # before_action :get_bookmarks, only: [:index]


  def index
    @groups = Group.order(created_at: :desc)
    drillz = UserDrill.where(completed: true).where(user_id: @user.id)
    @drills = Drill.where(:id => drillz).all
    # @user_groups = Group.where???
    # render json: @groups
  end

  def show
    @drills = Drill.where(group: @group)
    # render json: @group
  end

  def new
    render plain: "For Admin Use Only"
  end

  def new
    @group = Group.new
  end

  def create


    # render plain: "Creation of Groups is Admin Only"
    # ***Uncomment once admin is defined***
    group_params = params.require(:group).permit(:title)
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path(@group), notice: "Group Created Successfully"
    else
      render new_group_path, alert: "Group NOT Created Successfully"
    end
  end

  def edit

  end

  def update
    # render plain: "Editing of Groups is Admin Only"
    # ***Uncomment once admin is defined***
    group_params = params.require(:group).permit(:title)
    if @group.update(group_params)
      redirect_to group_drills_path(@group), notice: "Group Updated Successfully"
    else
      render group_edit_path(@group), notice: "Group NOT Updated Successfully"
    end
  end

  def destroy
    # render plain: "Destroying Groups is Admin Only"
    # ***Uncomment once admin is defined***
    if @group.destroy
      redirect_to root_path, notice: "Group Successfully Destroyed"
    else
      redirect_to group_path(@group), alert: "Group NOT Destroyed Successfully"
    end
  end


  private

  def find_user
    @user = User.find current_user.id
  end

  def get_group_id
    @group = Group.find params[:id]
  end

  def authorize
    if cannot?(:manage, @group)
      redirect_to group_drills_path(@group), alert: 'Not authorized!'
    end
  end



end
