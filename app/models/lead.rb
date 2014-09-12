class Lead < ActiveRecord::Base
  has_many :bids, -> { order("created_at desc") }

  SERVICES = [:rentout, :rent, :buy, :sell]
  SERVICES_HUMAN = { "Rent" => :rent, "Rent out" => :rentout, "Sell" => :sell, "Buy" => :buy }
  enum service_kind: SERVICES
  default_scope -> { order("trading_until < now() or trading_until is null, trading_until desc nulls first, created_at desc") }
  scope :not_mine, lambda {|user_id| where("user_id is null or user_id != #{user_id.to_i}") }
  scope :mine, lambda {|user_id| where("user_id = #{user_id.to_i}") }

  validates :service_kind, presence: true

  def price
    if price_from && price_to && price_from != price_to
      return "$#{price_from || 0} to $#{price_to || '∞'}"
    elsif price_from 
      return "$#{price_from}+"
    elsif price_to
      return "up to $#{price_to}"
    else
      "—"
    end
  end

  def user_status(user)
    if sold? && !user_id
      return "Loading..."
    end

    if winner && winner.id == user.id
      if sold?
        return "You bought this lead."
      else
        return "Your bid is highest."
      end
    elsif bids.done.map(&:user_id).include?(user.id)
      if sold?
        return "Lead sold."
      else
        return "Someone placed higher bid."
      end
    else
      'You did not place any bids.'
    end
  end

  def finish!
    return false unless best_bid
    return false if user_id

    best_bid.update_attribute :status, "winner"
    update_attributes :user_id => winner.id, :trading_until => Time.now
  end

  def time_left
    return 0 if trading_until.nil?
    return 0 if trading_until <= Time.now
    return trading_until - Time.now
  end

  def user_bid(user)
    bids.done.order("bid desc").where(user_id: user.id).first
  end

  def best_bid
    bids.done.order("bid desc").first
  end

  def winner
    best_bid and best_bid.user
  end

  def trading?
    bid && trading_until && trading_until > Time.now
  end

  def sold?
    bid && trading_until && trading_until <= Time.now
  end

  def print_time_left
    total_seconds = time_left
    minutes = sprintf('%02d', (total_seconds / 60).to_i)
    seconds = sprintf('%02d', (total_seconds % 60).to_i)
    "#{minutes}:#{seconds}"
  end

  def next_bid
    return 25 unless bid
    return bid + 5
  end

  def buy_now_price
    ((self.next_bid.to_i) * 2.5).to_i
  end

  def hidden_phone_number
    phone_number.gsub(/^.+(.{4})$/, '...\1')
  end

  def hidden_email
    contact_email.gsub(/^(.{3}).+$/, '\1...')
  end

  def movein_date
    read_attribute(:movein_date).try(:to_date)
  end

  def moveout_date
    read_attribute(:moveout_date).try(:to_date)
  end

  def dates
    if movein_date && moveout_date && movein_date != moveout_date
      return "#{movein_date}<br/>#{moveout_date}"
    elsif movein_date || moveout_date
      return movein_date || moveout_date
    else
      "—"
    end
  end
end
