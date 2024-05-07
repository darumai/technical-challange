# app/models/document.rb
class Document < ApplicationRecord
  attr_accessor :template, :document_data
  before_validation :generate_pdf
  validates_presence_of :uuid, :pdf_url, :customer_name, :contract_value

  def generate_pdf
    self.pdf_url = PdfGenerator.create(template, document_data, self.uuid)
  end
end
