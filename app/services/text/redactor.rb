module Text
  class Redactor
    EMAIL = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i
    PHONE = /(?<!\d)(?:\+?1[-.\s]?)?(?:\(?\d{3}\)?[-.\s]?)\d{3}[-.\s]?\d{4}(?!\d)/
    SSN   = /\b\d{3}-\d{2}-\d{4}\b/
    ADDR  = /\b\d{1,5}\s+[A-Za-z0-9.\- ]+\s+(Street|St|Ave|Avenue|Rd|Road|Blvd|Lane|Ln|Dr|Drive)\b/i

    def self.call(text)
      text.to_s
          .gsub(EMAIL, "REDACTED_EMAIL")
          .gsub(PHONE, "REDACTED_PHONE")
          .gsub(SSN,   "REDACTED_SSN")
          .gsub(ADDR,  "REDACTED_ADDRESS")
    end
  end
end
