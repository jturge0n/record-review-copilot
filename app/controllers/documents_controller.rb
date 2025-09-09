class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :analyze, :export, :salesforce_export]

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(
      title: params[:title].presence || "Untitled",
      redact: ActiveModel::Type::Boolean.new.cast(params[:redact]),
      status: "uploaded"
    )

    file = params[:pdf]
    unless file&.content_type == "application/pdf"
      redirect_to new_document_path, alert: "Please upload a valid PDF." and return
    end

    text = ::Pdf::ExtractText.call(file.tempfile)

    if text.blank?
      redirect_to new_document_path, alert: "Couldn’t read text from that PDF (scanned image?)." and return
    end

    @document.text = text
    @document.save!
    redirect_to @document
  rescue => e
    Rails.logger.error(e.full_message)
    redirect_to new_document_path, alert: "Upload failed."
  end

  def show
    @findings = @document.findings.order(:category, :label)
  end

  # Placeholder analye for now; LLM to be integrated later
  def analyze
    @document.update!(status: "processing")

    chunks = Text::Chunker.call(@document.text)
    Rails.logger.info("Chunked into #{chunks.size} part(s)")

    if @document.findings.blank?
      @document.findings.create!(
        category: "key_date",
        label: "Placeholder",
        value: "LLM extraction pending",
        date: nil,
        confidence: 0.1
      )
    end

    @document.update!(status: "ready")
    redirect_to @document, notice: "Analysis complete."
  rescue => e
    Rails.logger.error(e.full_message)
    @document.update!(status: "error")
    redirect_to @document, alert: "Analysis failed."
  end

  def export
    csv = Csv::Exporter.call(@document)
    send_data csv, filename: "document-#{@document.id}-findings.csv"
  end

  def salesforce_export
    redirect_to @document, notice: "Salesforce export stub."
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end
end
