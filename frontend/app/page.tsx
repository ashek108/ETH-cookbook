import fs from "node:fs/promises";
import path from "node:path";
import CodeViewer from "./components/code-viewer";

type SolidityFile = {
  name: string;
  relativePath: string;
  code: string;
};

async function loadSolidityFiles(): Promise<SolidityFile[]> {
  const contractsRoot = path.join(process.cwd(), "..", "smart-contracts");

  async function walkDirectory(
    directory: string,
    baseDirectory: string,
  ): Promise<SolidityFile[]> {
    const entries = await fs.readdir(directory, { withFileTypes: true });
    const nestedFiles = await Promise.all(
      entries.map(async (entry) => {
        const absolutePath = path.join(directory, entry.name);

        if (entry.isDirectory()) {
          return walkDirectory(absolutePath, baseDirectory);
        }

        if (!entry.isFile() || !entry.name.endsWith(".sol")) {
          return [];
        }

        const code = await fs.readFile(absolutePath, "utf8");

        return [
          {
            name: entry.name,
            relativePath: path
              .relative(baseDirectory, absolutePath)
              .replaceAll(path.sep, "/"),
            code,
          },
        ];
      }),
    );

    return nestedFiles.flat();
  }

  try {
    return (await walkDirectory(contractsRoot, contractsRoot)).sort(
      (left, right) => left.relativePath.localeCompare(right.relativePath),
    );
  } catch {
    return [];
  }
}

export default async function Home() {
  const solidityFiles = await loadSolidityFiles();

  return (
    <div className="relative min-h-screen overflow-hidden bg-[#050816] text-zinc-100">
      <video
        className="absolute inset-0 h-full w-full object-cover opacity-80"
        autoPlay
        muted
        loop
        playsInline
        preload="auto"
        aria-hidden="true"
      >
        <source src="/space.mp4" type="video/mp4" />
      </video>

      <div
        className="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(11,16,40,0.12),rgba(5,8,22,0.45)_60%,rgba(5,8,22,0.72)_100%)]"
        aria-hidden="true"
      />
      <div
        className="absolute inset-0 bg-[#050816]/10 mix-blend-multiply"
        aria-hidden="true"
      />

      <main className="relative z-10 mx-auto flex min-h-screen w-full max-w-6xl flex-col px-6 py-10 sm:px-10 lg:px-12">
        <section className="mb-10 rounded-3xl border border-white/10 bg-white/5 p-8 shadow-2xl shadow-black/20 backdrop-blur-md sm:p-10">
          <p className="text-sm uppercase tracking-[0.35em] text-amber-300/80">
            Solidity explorer
          </p>
          <div className="mt-4 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div className="max-w-3xl">
              <h1 className="text-4xl font-semibold tracking-tight text-white sm:text-5xl">
                Browse every Solidity file in the repository.
              </h1>
              <p className="mt-4 max-w-2xl text-base leading-7 text-zinc-300 sm:text-lg">
                File names stay visible in the list. Click any contract to
                expand and inspect the full source.
              </p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-black/30 px-4 py-3 text-sm text-zinc-300">
              <div className="font-medium text-white">
                {solidityFiles.length} contract
                {solidityFiles.length === 1 ? "" : "s"} found
              </div>
              <div className="mt-1 text-zinc-400">Source: smart-contracts</div>
            </div>
          </div>
        </section>

        <section className="grid gap-4">
          {solidityFiles.length === 0 ? (
            <div className="rounded-3xl border border-dashed border-white/15 bg-white/5 px-6 py-16 text-center text-zinc-300">
              No Solidity files were found in smart-contracts.
            </div>
          ) : (
            solidityFiles.map((file) => (
              <details
                key={file.relativePath}
                className="group rounded-3xl border border-white/10 bg-white/5 shadow-lg shadow-black/10 backdrop-blur-sm transition hover:border-amber-300/30 hover:bg-white/10"
              >
                <summary className="flex cursor-pointer list-none items-center justify-between gap-4 px-6 py-5 text-left outline-none">
                  <div>
                    <div className="text-lg font-semibold text-white">
                      {file.name}
                    </div>
                    <div className="mt-1 text-sm italic text-zinc-400">
                      {file.name.replace(/\.sol$/, "")}
                    </div>
                  </div>
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full border border-white/10 bg-black/30 text-zinc-300 transition group-open:rotate-45 group-open:border-amber-300/40 group-open:text-amber-200">
                    +
                  </div>
                </summary>
                <div className="border-t border-white/10 px-6 py-5">
                  <CodeViewer code={file.code} />
                </div>
              </details>
            ))
          )}
        </section>
      </main>
    </div>
  );
}
