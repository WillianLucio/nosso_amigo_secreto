class CampaignRaffleJob < ApplicationJob
  queue_as :emails

  def perform(campaign)
    results = RaffleService.new(campaign).call
    results = false

    if results == false
      CampaignMailer.error_raffle(campaign).deliver_now
    elsif
      campaign.members.each {|m| m.set_pixel}
      results.each do |r|
        CampaignMailer.raffle(campaign, r.first, r.last).deliver_now
      end

      campaign.update(status: :finished)
    end
  end
end
