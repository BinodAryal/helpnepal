require 'rails_helper'

describe SupportsController do
  context '#skip' do
    let(:support) { double(:support, id: 4) }
    let(:skip_service) { double(:skip_service).as_null_object }

    before do
      expect(controller).to receive(:current_user).and_return(double(:user))
      expect(controller).to receive(:support).and_return(support).at_least(:once)
      expect(SkipSupport).to receive(:new).with(support).and_return(skip_service)
    end

    it 'executes SkipSupport service' do
      expect(skip_service).to receive(:commence!)

      post :skip, id: support.id
    end

    context "when skip isn't successful" do
      it 'redirects to support path with error message' do
        expect(skip_service).to receive(:success?).and_return false
        post :skip, id: support.id

        expect(response).to redirect_to support_path(support)
        expect(flash[:error]).to_not be_empty
      end
    end

    context "when skip is successful" do
      it 'redirects to support path with notice message' do
        expect(skip_service).to receive(:success?).and_return true
        post :skip, id: support.id

        expect(response).to redirect_to support_path(support)
        expect(flash[:notice]).to_not be_empty
      end
    end
  end
end

