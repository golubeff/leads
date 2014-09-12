class Bidder
  include Sidekiq::Worker

  def perform(job_id)
    job = Bid.find(job_id)
    if job.lead.sold?
      job.update_attributes :status => "error", :error => "Unable to place bid. This lead is already sold."
      return true
    end

    if job.bid < job.lead.next_bid
      job.update_attributes :status => "error", :error => "Unable to place bid. Minimum bid is $#{job.lead.next_bid}."
    elsif job.buynow? && job.bid != job.lead.buy_now_price
      job.update_attributes :status => "error", :error => "Unable to buy. Price has changed. Try again."
    else
      job.lead.update_attributes :bid => job.bid, :trading_until => Time.now + 5.minutes
      job.update_attribute :status, 'done'
      if job.buynow?
        LeadDistributor.perform_async(job.lead.id)
      end
    end
  end
end