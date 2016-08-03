class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def show
    @group = Group.includes(:group_contacts, :memberships => [:person]).find(params[:id])
  end

end
