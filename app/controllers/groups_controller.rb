class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def show
    @group = Group.includes(:memberships => [:person]).find(params[:id])
  end

end
