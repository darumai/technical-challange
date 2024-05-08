module PdfGenerator
  def self.create(template,document_data,uuid,renderer="pandoc")
    # Defines path for soon to be PDF file
    pdf_path = Rails.root.join('public/pdf',"#{uuid}.pdf")

    # Save HTML content to a temporary file
    html_file = Tempfile.new(["#{uuid}",".html"])

    css_file = Tempfile.new(["#{uuid}",".css"])
    css_file << template[/<style>(.*?)<\/style>/m, 1]
    css_file.close
    
    # Perform variable substitution in HTML content
    template.gsub!(/{{(.*?)}}/) { document_data[$1.strip] }
    html_file << template
    html_file.close

    # Renders PDF based on the chosen rendering lib
    render_pdf(renderer,html_file.path,pdf_path,css_file.path)

    # Clean up temporary files
    html_file.unlink
    css_file.unlink

    # Returns PDF url based on environment
    uploader(pdf_path,uuid)
  end

  def self.render_pdf(renderer,html_path,pdf_path,css_path)
    case renderer
    when "pandoc"
      pandoc(html_path,pdf_path,css_path)
    else
      pandoc(html_path,pdf_path,css_path)
    end
  end

  def self.pandoc(html_path,pdf_path,css_path)
    # Convert HTML to PDF using pandoc
    system("pandoc --standalone #{html_path} -c #{css_path} -o #{pdf_path} --pdf-engine=weasyprint")
  end

  def self.uploader(pdf_path,uuid)
    if Rails.env.production?
      GOOGLE_STORAGE_BUCKET.create_file(pdf_path,"#{uuid}.pdf")
    else
      ENV['ROOT_URL']+"/pdf/#{uuid}.pdf"
    end
  end
end
