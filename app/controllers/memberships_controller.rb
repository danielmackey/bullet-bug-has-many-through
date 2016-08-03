class MembershipsController < ApplicationController

  def show
    @group = Group.find(params[:group_id])
    @membership = @group.memberships.find(params[:id])
  end

end
