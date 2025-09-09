# Record Review Copilot (Demo)

A tiny Rails app that uploads a **text-based medical PDF**, extracts text, calls an **LLM** to auto-summarize key facts (diagnoses, medications, procedures, dates, providers), lets an analyst **edit** the results inline, and **exports a CSV**.

**Stack**
- **Ruby on Rails, Postgres, Tailwind CSS, Hotwire, Svelte, Heroku** (Salesforce-ready later).

> ⚠️ **Demo-only / HIPAA disclaimer**
> This repository is **not** production-ready. It does **not** meet HIPAA compliance requirements. Do **not** upload real PHI. It sends text chunks to a third-party LLM API. Logs and error traces may include data. A production version would require a BAA with the LLM vendor, strict logging/retention controls, encryption at rest/transport, access controls, audit logging, and a security review.

---

## Feature Summary

- Upload PDF → extract text (text-based PDFs only; OCR not included).
- Chunk text → call LLM per chunk with a strict JSON schema.
- Merge/dedupe findings across chunks.
- Inline **editable** findings table (Svelte + Stimulus/Hotwire), **save** per row.
- **Export CSV** of findings.
- Optional **redact mode** to avoid echoing names/addresses in model output (demo-level).

**Models**
- `Document(id, title, status, text, redact:boolean)`
- `Finding(id, document_id, category, label, value, date, confidence:float)`

**Categories returned by the LLM**
- `diagnoses`, `medications (name,dose)`, `procedures (text,date)`, `key_dates (label,date)`, `providers (name,type)`

---

## Architecture (high-level)

- **Controllers**: `DocumentsController` (new/create/show/analyze/export), `FindingsController#update`
- **Services**:
  - `Pdf::ExtractText` — text extraction via `pdf-reader`
  - `Text::Chunker` — 3–5k char chunks
  - `Llm::MedicalFactsExtractor` — OpenAI Chat Completions → strict JSON
  - `Findings::Merge` — dedupe by normalized keys
  - `Csv::Exporter` — single CSV across categories
- **Frontend**:
  - Tailwind (cssbundling)
  - Svelte component mounted via Stimulus for editable table

---

## Live Heroku App
- Navigate to 'https://record-review-copilot-6b33aa679088.herokuapp.com/'
- Fill out form and upload a sample medical document pdf (note that this app is for demo purposes and is looking for specific keywords that may not be optimized for real docs yet)
- Click "Analyze" to fetch and save findings from the LLM results
- Click "Export CSV"

---

## Local Development

### Prereqs
- Ruby **3.2.x**
- Postgres
- Node **≥18 <23**, Yarn **≥1.22**
- OpenAI API key

### Setup
```bash
# install Ruby gems and JS deps
bundle install
yarn install

# DB
bin/rails db:create db:migrate

# .env
cat > .env <<'ENVVARS'
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini
ENVVARS

# build assets
yarn build && yarn build:css

# run dev (Rails + Tailwind + esbuild)
bin/dev
