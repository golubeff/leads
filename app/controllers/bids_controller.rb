class BidsController < ApplicationController
  before_filter :check_input
  before_filter :authorize


  def show
    @bid = Bid.find(params[:id])
    LeadDistributor.perform_async(@bid.lead_id) if @bid.lead.sold? && !@bid.lead.user_id
  end

  def create
    bid = Bid.create! :user_id => current_user.id, :lead_id => params[:lead_id], :bid => params[:bid], :bid_type => (params[:buynow] ? "buynow" : "regular")
    Bidder.perform_async(bid.id)
    redirect_to bid
  end

  protected
  def check_input
    params[:lead_id] = params[:lead_id].to_i
    params[:bid] = params[:bid].to_s.gsub(/[^\d+]/, '').to_i
    params[:bid] = 0 if params[:bid] < 0
  end

  def authorize
    unless user_signed_in?
      render :text => "Please <a href=\"/users/sign_in\">sign in</a> to place bids.", :status => "403"
      return false
    end
  end
end