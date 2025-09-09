module Csv
  class Exporter
    require "csv"
    def self.call(document)
      CSV.generate(headers: true) do |csv|
        csv << %w[document_id category label value date confidence]
        document.findings.find_each do |f|
          csv << [document.id, f.category, f.label, f.value, f.date, f.confidence]
        end
      end
    end
  end
end
