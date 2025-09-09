class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :analyze, :export, :salesforce_export]

  def new; @document = Document.new; end

  def create
  end

  def show
  end

  def analyze
  end

  def export
  end

  def salesforce_export
  end

  private

  def set_document; @document = Document.find(params[:id]); end
end
