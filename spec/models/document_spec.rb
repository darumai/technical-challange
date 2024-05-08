# spec/models/document_spec.rb
require 'rails_helper'

RSpec.describe Document, type: :model do
  describe "#generate_pdf" do
    let(:document) { build(:document) }

    it "generates a PDF URL" do
      allow(PdfGenerator).to receive(:create).and_return("http://example.com/pdf/#{document.uuid}.pdf")
      document.generate_pdf
      expect(document.pdf_url).to eq("http://example.com/pdf/#{document.uuid}.pdf")
    end
  end

  describe "validations" do
    subject { build(:document) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a uuid" do
      subject.uuid = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a customer_name" do
      subject.customer_name = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a contract_value" do
      subject.contract_value = nil
      expect(subject).not_to be_valid
    end
  end
end
