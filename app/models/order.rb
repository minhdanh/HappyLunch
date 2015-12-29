class Order < ActiveRecord::Base
  has_many :order_items

  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  def self.today_order_completed?
    @today_order = self.today.first
    return false unless @today_order
    GetListMembersService.call.uniq.count == @today_order.order_items.pluck(:username).uniq.count
  end

  def self.notify_users
    if !today_order_completed?
      @today_order = self.today.first
      if @today_order
        unorder_members = GetListMembersService.call.uniq - @today_order.order_items.pluck(:username).uniq
        unorder_members.each do |member|
          SendMessageToSlackService.call("#lunch", "Hey @#{member}! You haven't ordered lunch yet. Please order now!", link_names: 1)
        end
      end
    end
  end
end