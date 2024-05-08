# spec/controllers/api/v1/documents_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::DocumentsController, type: :controller do
  describe "GET #list" do
    it "returns a list of documents" do
      documents = create_list(:document, 3)
      get :list
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_params) do
        {
          description: "Example description",
          document_data: {
            customer_name: "John Doe",
            contract_value: "R$ 10,000.00"
          },
          template: "Example template"
        }
      end

      it "creates a new document" do
        expect {
          post :create, params: valid_params
        }.to change(Document, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with missing parameters" do
      let(:invalid_params) { { document_data: { customer_name: "John Doe" } } }

      it "returns a bad request error" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Missing required parameters")
      end
    end
  end
end
