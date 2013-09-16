class VotesController < ApplicationController

  before_filter :get_current_vote

  def index
  end

  def create
    # TODO how to prevent this param from being injected? we just want to rely on the route
    @vote ||= build_vote_from_request(params[:value])

    respond_to do |format|
      response = { vote: @vote.as_json }
      if !@vote.new_record?
        format.json { render json: response, status: :not_modified }
      elsif @vote.save
        format.json { render json: response, status: :ok }
      else
        logger.error "@vote save failed, errors: #{@vote.errors.to_hash.inspect}"
        output = response.merge({ errors: @vote.errors.to_hash })
        format.json { render json: output, status: :unprocessable_entity }
      end
    end
  end

protected

  def get_current_vote
    @vote ||= Vote.where(ip_address: request_ip_address).where("created_at > ?", Vote.cooldown_period.ago).first
    logger.debug "get_current_vote: @vote=#{@vote.attributes.inspect}" if @vote.present?
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

end
