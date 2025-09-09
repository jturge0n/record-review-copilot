require "pdf-reader"

module Pdf
  class ExtractText
    def self.call(io)
      reader = PDF::Reader.new(io)
      reader.pages.map(&:text).join("\n\n")
    rescue PDF::Reader::MalformedPDFError, PDF::Reader::EncryptedPDFError => e
      Rails.logger.warn("PDF extract error: #{e.class}: #{e.message}")
      ""
    end
  end
end
