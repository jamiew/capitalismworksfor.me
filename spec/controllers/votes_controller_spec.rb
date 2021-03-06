require 'spec_helper'

describe VotesController do

  describe 'GET #index' do
    it "works" do
      get :index
      response.should be_success
    end

    it "correctly assigns @vote_counts" do
      Vote.delete_all
      FactoryGirl.create(:true_vote)
      FactoryGirl.create(:false_vote)
      get :index
      assigns(:vote_counts).should == { 'false' => 1, 'true' => 1 }
    end
  end

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
        json['status'].should == 'voted'
        json['voted_at'].should be_present
        json['vote_counts'].class.should == Hash
      end

      it "does not respond to .html" do
        lambda {
          post :create, valid_params.merge({ format: nil })
        }.should raise_error(ActionController::UnknownFormat)
      end

      context "if you recently voted" do
        before do
          @existing_vote = nil
          lambda {
            post :create, valid_params
            @existing_vote = assigns(:vote)
          }.should change(Vote, :count).by(1)
        end

        it 'does not create a new Vote' do
          lambda {
            post :create, valid_params
            assigns(:vote).should == @existing_vote
            response.status.should == 202 # FIXME what's status code for partially modified
          }.should_not change(Vote, :count)
        end

        it "changes your vote if applicable" do
          @existing_vote.value.should == 'true'
          post :create, valid_params.merge({value: 'false'})
          @existing_vote.reload.value.should == 'false'
        end
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
