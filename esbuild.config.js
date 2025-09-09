const esbuild = require("esbuild");
const sveltePlugin = require("esbuild-svelte");

const isWatch = process.argv.includes("--watch");

const options = {
  entryPoints: ["app/javascript/application.js"],
  bundle: true,
  outdir: "app/assets/builds",
  sourcemap: process.env.RAILS_ENV !== "production",
  plugins: [sveltePlugin()],
  loader: { ".svg": "file", ".png": "file" },
  logLevel: "info",
};

(async () => {
  if (isWatch) {
    const ctx = await esbuild.context(options);
    await ctx.watch();
    console.log("esbuild: watching for changes…");
  } else {
    await esbuild.build(options);
    console.log("esbuild: build complete");
  }
})();
