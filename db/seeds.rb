# Clear old data
Finding.delete_all
Document.delete_all

doc = Document.create!(
  title: "Sample ER Visit",
  text: "Patient presented with chest pain on 2023-08-15. Diagnosed with GERD. Prescribed omeprazole 20mg daily.",
  status: "ready",
  redact: true
)

doc.findings.create!(
  category: "diagnosis",
  label: "GERD",
  value: nil,
  confidence: 0.9
)

doc.findings.create!(
  category: "medication",
  label: "omeprazole",
  value: "20mg daily",
  confidence: 0.95
)

doc.findings.create!(
  category: "key_date",
  label: "ER visit",
  value: nil,
  date: "2023-08-15",
  confidence: 0.85
)
puts "Seeded 1 document with 3 findings."
