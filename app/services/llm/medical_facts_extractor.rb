# frozen_string_literal: true
require "json"
require "faraday"

module Llm
  class MedicalFactsExtractor
    DEFAULT_MODEL = ENV.fetch("OPENAI_MODEL", "gpt-4o-mini")

    def self.call(text, redact: true)
      payload = {
        model: DEFAULT_MODEL,
        messages: [
          { role: "system", content: "You are a medical records analyst assistant. Return ONLY strict JSON with the specified schema." },
          { role: "user", content: build_prompt(text, redact:) }
        ],
        response_format: { type: "json_object" }
      }

      resp = Faraday.post("https://api.openai.com/v1/chat/completions") do |req|
        req.headers["Authorization"] = "Bearer #{ENV["OPENAI_API_KEY"]}"
        req.headers["Content-Type"]  = "application/json"
        req.options.timeout = 60
        req.options.open_timeout = 10
        req.body = JSON.dump(payload)
      end

      body = JSON.parse(resp.body) rescue {}
      content = body.dig("choices", 0, "message", "content").to_s
      parsed = JSON.parse(content) rescue {}
      normalize(parsed)
    rescue => e
      Rails.logger.error("LLM error: #{e.class} #{e.message}")
      empty_payload
    end

    def self.build_prompt(text, redact:)
      <<~PROMPT
      Task: From the following medical-record text, extract structured facts:
      - diagnoses/conditions
      - medications (name, dose if present)
      - procedures/surgeries
      - key dates (accident, ER visits, imaging)
      - providers/facilities
      Rules:
      - Return JSON with:
        {
          "diagnoses":[{"text":"","confidence":0.0}],
          "medications":[{"name":"","dose":null,"confidence":0.0}],
          "procedures":[{"text":"","date":null,"confidence":0.0}],
          "key_dates":[{"label":"","date":"YYYY-MM-DD","confidence":0.0}],
          "providers":[{"name":"","type":null,"confidence":0.0}]
        }
      - If uncertain, include with lower confidence.
      - #{redact ? "Do not output full names/addresses; replace with 'REDACTED'." : ""}
      Text:
      #{text}
      PROMPT
    end

    def self.normalize(h)
      h ||= {}
      {
        "diagnoses"  => Array(h["diagnoses"]).map   { |x| {"text"=>x["text"].to_s, "confidence"=>x["confidence"].to_f} },
        "medications"=> Array(h["medications"]).map { |x| {"name"=>x["name"].to_s, "dose"=>x["dose"], "confidence"=>x["confidence"].to_f} },
        "procedures" => Array(h["procedures"]).map  { |x| {"text"=>x["text"].to_s, "date"=>x["date"], "confidence"=>x["confidence"].to_f} },
        "key_dates"  => Array(h["key_dates"]).map   { |x| {"label"=>x["label"].to_s, "date"=>x["date"], "confidence"=>x["confidence"].to_f} },
        "providers"  => Array(h["providers"]).map   { |x| {"name"=>x["name"].to_s, "type"=>x["type"], "confidence"=>x["confidence"].to_f} }
      }
    end

    def self.empty_payload
      { "diagnoses"=>[], "medications"=>[], "procedures"=>[], "key_dates"=>[], "providers"=>[] }
    end
  end
end
