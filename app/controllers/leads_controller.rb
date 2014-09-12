class LeadsController < ApplicationController
  def index
    @leads = Lead.all
    if params[:my]
      @leads = @leads.mine(current_user.id) 
    else
      @leads = @leads.not_mine(current_user.id) 
    end

    @leads = @leads.paginate(:per_page => 10, :page => params[:page])
    @leads.each do |lead|
      LeadDistributor.perform_async(lead.id) if lead.sold? && !lead.user_id
    end
  end
end
