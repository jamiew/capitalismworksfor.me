require 'spec_helper'

describe VotesController do

  describe 'POST #create' do
    let(:valid_params){{ value: 'true', format: 'json' }}

    it "routes POST /vote/true" do
      { post: '/vote/true' }.should route_to('votes#create', value: 'true')
    end

    it "routes POST /vote/false" do
      { post: '/vote/false' }.should route_to('votes#create', value: 'false')
    end

    context 'value param is present' do
      it 'works' do
        lambda {
          post :create, valid_params
          response.status.should == 200
        }.should change(Vote, :count).by(1)
      end

      it 'outputs valid JSON' do
        post :create, valid_params
        json = JSON.parse(response.body)
        json['vote']['value'].should == 'true'
        json['vote']['user_agent'].should == 'Rails Testing'
      end

      it 'does not create a new Vote if you recently voted' do
        existing_vote = nil
        lambda {
          post :create, valid_params
          existing_vote = assigns(:vote)
        }.should change(Vote, :count).by(1)


        lambda {
          post :create, valid_params
          assigns(:vote).should == existing_vote
          response.status.should == 304
        }.should_not change(Vote, :count)
      end
    end

    context "fails to save Vote for any reason" do
      before do
        Vote.any_instance.stub(:save).and_return(false)
      end

      it "returns status code 422" do
        post :create, valid_params
        response.status.should == 422
      end

      it "outputs errors in the JSON" do
        post :create, valid_params
        json = JSON.parse(response.body)
        json['errors'].should_not be_nil # can't check .present since it's actually blank
      end
    end

    context "value param is blank" do
      it "fails to route" do
        lambda {
          post :create, value: nil
        }.should raise_error(ActionController::UrlGenerationError)
      end
    end
  end

end
