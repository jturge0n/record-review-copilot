# record-review-copilot
The app extracts text (pdf-reader), chunks it, and calls an LLM to produce structured findings (diagnoses, meds, procedures, key dates, providers). Findings are merged/deduped and stored in Postgres, shown in an editable UI (Tailwind + Hotwire + a Svelte table) and exported to CSV. 
