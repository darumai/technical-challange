class Api::V1::DocumentsController < ApplicationController
  def list
    render json: Document.all.map { |d| { uuid: d.uuid, 
                                          pdf_url: d.pdf_url, 
                                          description: d.description, 
                                          document_data: { 
                                            customer_name: d.customer_name, 
                                            contract_value: d.contract_value }, 
                                          created_at: d.created_at }}
  end

  def create
    # Parse request parameters
    description = document_params[:description]
    document_data = document_params[:document_data]
    template = document_params[:template]

    # Ensure required parameters are provided
    unless description && document_data && template
      return render json: { error: "Missing required parameters" }, status: :bad_request
    end

    # Render HTML template with provided data
    customer_name = document_data[:customer_name]
    contract_value = document_data[:contract_value]

    # Creates new instance of Document object
    document = Document.new(
      uuid: SecureRandom.uuid,
      description: description,
      customer_name: customer_name,
      contract_value: contract_value,
      template: template,
      document_data: document_data
    )

    if document.save
      # Respond with JSON representation of the created document
      render json: {
        uuid: document.uuid,
        pdf_url: document.pdf_url,
        description: document.description,
        document_data: document_data,
        created_at: document.created_at
      }, status: :created
    else
      render json: document.errors, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.permit(:description, { document_data: [:customer_name, :contract_value, :test_var] }, :template, :format, :document)
  end
end
