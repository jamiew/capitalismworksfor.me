class VotesController < ApplicationController

  before_filter :get_current_vote

  def index
    @vote_counts = vote_counts
  end

  def create
    # TODO change from true to false or vice versa if recent

    # TODO how to prevent this param from being injected? we just want to rely on the route
    @vote ||= build_vote_from_request(params[:value])

    respond_to do |format|
      response = lambda { { voted_at: @vote.created_at.to_i, vote_counts: vote_counts } }
      if !@vote.new_record?
        update_vote_value(@vote)
        format.json { render json: response.call.merge({status: 'changed'}), status: 202 } # Accepted
      elsif @vote.save
        format.json { render json: response.call.merge({status: 'voted'}), status: :ok }
      else
        logger.error "@vote save failed, errors: #{@vote.errors.to_hash.inspect}"
        output = response.call.merge({status: 'error', errors: @vote.errors.to_hash })
        format.json { render json: output, status: :unprocessable_entity }
      end
    end
  end

protected

  def get_current_vote
    @vote ||= Vote.where(ip_address: request_ip_address).where("created_at > ?", Vote.cooldown_period.ago).first
    logger.debug "get_current_vote: @vote=#{@vote.attributes.inspect}" if @vote.present?
  end

  def vote_counts
    Vote.group(:value).count
  end

  def build_vote_from_request(value)
    vote = Vote.new
    vote.value = value
    vote.ip_address = request_ip_address
    vote.referrer = session['referrer'] || request.referrer # TODO set session['referrer'] on landing
    vote.user_agent = request.user_agent
    logger.debug "build_vote_from_request: #{vote.attributes.inspect}"
    vote
  end

  def update_vote_value(vote)
    return if params[:value].to_s == vote.value.to_s
    vote.value = params[:value]
    vote.save!
  end

end
