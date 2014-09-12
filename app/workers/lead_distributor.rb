class LeadDistributor
  include Sidekiq::Worker

  def perform(lead_id)
    lead = Lead.find(lead_id)
    lead.finish!
  end
end