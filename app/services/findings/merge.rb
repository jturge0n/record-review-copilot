# frozen_string_literal: true
module Findings
  class Merge
    def self.key_for(category, h)
      case category
      when "medication" then "#{h["name"]&.downcase}|#{h["dose"]&.to_s&.downcase}"
      when "diagnosis", "procedure" then h["text"]&.downcase
      when "provider" then h["name"]&.downcase
      when "key_date" then "#{h["label"]&.downcase}|#{h["date"]}"
      end.presence || SecureRandom.uuid
    end

    def self.call(document, per_chunk_results)
      buckets = Hash.new { |h, k| h[k] = {} }

      per_chunk_results.each do |res|
        {
          "diagnosis" => res["diagnoses"],
          "medication" => res["medications"],
          "procedure" => res["procedures"],
          "key_date"   => res["key_dates"],
          "provider"   => res["providers"]
        }.each do |cat, arr|
          Array(arr).each do |item|
            k = key_for(cat, item)
            exist = buckets[cat][k]
            if exist.nil? || item["confidence"].to_f > exist["confidence"].to_f
              buckets[cat][k] = item
            end
          end
        end
      end

      document.findings.delete_all

      buckets.each do |cat, items|
        items.values.each do |h|
          label, value, date =
            case cat
            when "medication" then [h["name"], h["dose"], nil]
            when "diagnosis"  then [h["text"], nil, nil]
            when "procedure"  then [h["text"], nil, (h["date"].presence)]
            when "key_date"   then [h["label"], nil, (h["date"].presence)]
            when "provider"   then [h["name"], h["type"], nil]
            end

          next if label.blank?

          document.findings.create!(
            category: cat,
            label: label,
            value: value,
            date: (Date.parse(date) rescue nil),
            confidence: h["confidence"].to_f.clamp(0.0, 1.0)
          )
        end
      end
    end
  end
end
