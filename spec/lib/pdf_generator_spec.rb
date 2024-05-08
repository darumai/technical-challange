# spec/lib/pdf_generator_spec.rb
require 'rails_helper'

describe PdfGenerator do
  describe '.create' do
    let(:template) { "<style>body { color: red; }</style><div>{{content}}</div>" }
    let(:document_data) { { 'content' => 'Hello, World!' } }
    let(:uuid) { SecureRandom.uuid }

    it 'generates a PDF file' do
      pdf_url = PdfGenerator.create(template, document_data, uuid)

      expect(pdf_url).to be_present
      expect(pdf_url).to include(uuid)
      expect(pdf_url).to include('.pdf')
    end
  end

  describe '.render_pdf' do
    let(:html_path) { 'path/to/html/file.html' }
    let(:pdf_path) { 'path/to/pdf/file.pdf' }
    let(:css_path) { 'path/to/css/file.css' }

    it 'renders PDF using pandoc' do
      allow(PdfGenerator).to receive(:system)
      PdfGenerator.render_pdf('pandoc', html_path, pdf_path, css_path)

      expect(PdfGenerator).to have_received(:system).with("pandoc --standalone #{html_path} -c #{css_path} -o #{pdf_path} --pdf-engine=weasyprint")
    end
  end

  describe '.uploader' do
    let(:pdf_path) { 'path/to/pdf/file.pdf' }
    let(:uuid) { SecureRandom.uuid }

    context 'in non-production environment' do
      before { allow(Rails).to receive(:env).and_return('development'.inquiry) }

      it 'returns PDF URL' do
        allow(ENV).to receive(:[]).with('ROOT_URL').and_return('http://example.com')
        pdf_url = PdfGenerator.uploader(pdf_path, uuid)

        expect(pdf_url).to eq("http://example.com/pdf/#{uuid}.pdf")
      end
    end
  end
end
