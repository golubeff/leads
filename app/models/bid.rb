class Bid < ActiveRecord::Base

  belongs_to :user
  belongs_to :lead

  scope :done, -> { where(status: ["done", "winner"]) }

  def status_human 
    { pending: "Placing bid..." }[status.to_sym]
  end

  def buynow?
    bid_type == 'buynow'
  end

end