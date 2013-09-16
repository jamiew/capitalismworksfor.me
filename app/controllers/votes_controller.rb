class VotesController < ApplicationController

  before_filter :get_current_vote

  respond_to :html, :json

  def index
  end

  def create
    @vote ||= create_vote_from_request
    respond_with(@vote, new_record: @vote.new_record?)
  end

  def destroy
    respond_with(@vote)
  end

protected

  def get_current_vote
    @vote = Vote.where(ip_address: request_ip_address).where("created_at > ?", Vote.cooldown_period.ago).first
    logger.debug "get_current_vote: #{@vote.inspect}"
  end

  def create_vote_from_request
    vote = Vote.new
    vote.ip_address = request_ip_address
    vote.referrer = session['referrer'] || request.referrer # TODO set session['referrer'] on landing
    vote.user_agent = request.user_agent
    # TODO store some kind of guid/uuid. session id?
    # maybe store a session ID separately
    vote.save
    vote
  end


end
