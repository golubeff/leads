class LeadsController < ApplicationController
  def show
    @lead = Lead.find(params[:id])
    @bid = @lead.best_bid(current_user) if user_signed_in?
    LeadDistributor.perform_async(@lead.id) if @lead.sold? && !@lead.user_id
  end

  def index
    @leads = Lead.all
    if user_signed_in?
      if params[:my]
        @leads = @leads.mine(current_user.id) 
      else
        @leads = @leads.not_mine(current_user.id) 
      end
    end

    @leads = @leads.paginate(:per_page => 10, :page => params[:page])
    @leads.each do |lead|
      LeadDistributor.perform_async(lead.id) if lead.sold? && !lead.user_id
    end
  end
end
