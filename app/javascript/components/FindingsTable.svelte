<script>
  export let findings = []; // [{id, category, label, value, date, confidence}]

  async function saveRow(row) {
    const body = { finding: {
      label: row.label,
      value: row.value,
      date: row.date,
      confidence: row.confidence
    }};
    const res = await fetch(`/findings/${row.id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(body)
    });
    if (!res.ok) {
      const j = await res.json().catch(()=>({errors:["Update failed"]}));
      alert((j.errors || []).join(", "));
    }
  }

  function tint(c) {
    const n = Number(c || 0);
    if (n >= 0.8) return "bg-green-50";
    if (n >= 0.5) return "bg-yellow-50";
    return "bg-red-50";
  }
</script>

<div class="overflow-x-auto">
  <table class="min-w-full text-sm">
    <thead>
      <tr class="text-left">
        <th class="p-2">Category</th>
        <th class="p-2">Label</th>
        <th class="p-2">Value</th>
        <th class="p-2">Date</th>
        <th class="p-2">Confidence</th>
        <th class="p-2"></th>
      </tr>
    </thead>
    <tbody>
      {#each findings as row}
        <tr class="border-t">
          <td class="p-2">{row.category}</td>
          <td class="p-2"><input class="input" bind:value={row.label}></td>
          <td class="p-2"><input class="input" bind:value={row.value}></td>
          <td class="p-2"><input class="input" type="date" bind:value={row.date}></td>
          <td class="p-2">
            <input class={"input w-24 " + tint(row.confidence)} type="number" min="0" max="1" step="0.01" bind:value={row.confidence}>
          </td>
          <td class="p-2">
            <button class="btn" on:click={() => saveRow(row)}>Save</button>
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
</div>

<style>
  .input { @apply border rounded px-2 py-1 w-full; }
  .btn { @apply px-2 py-1 rounded bg-indigo-600 text-white; }
</style>
