"use client";

import { useState } from "react";

type CopyState = "idle" | "copied" | "error";

type CodeViewerProps = {
  code: string;
};

export default function CodeViewer({ code }: CodeViewerProps) {
  const [copyState, setCopyState] = useState<CopyState>("idle");

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(code);
      setCopyState("copied");
      window.setTimeout(() => setCopyState("idle"), 1600);
    } catch {
      setCopyState("error");
      window.setTimeout(() => setCopyState("idle"), 2000);
    }
  };

  const copyLabel =
    copyState === "copied"
      ? "Copied"
      : copyState === "error"
        ? "Copy failed"
        : "Copy";

  return (
    <div className="relative">
      <button
        type="button"
        onClick={handleCopy}
        className="absolute right-4 top-4 z-10 rounded-lg border border-white/15 bg-black/70 px-3 py-1.5 text-xs font-medium text-zinc-100 transition hover:border-amber-300/40 hover:text-amber-200"
        aria-label="Copy code"
      >
        {copyLabel}
      </button>
      <pre className="overflow-x-auto rounded-2xl border border-white/10 bg-[#09090b] p-5 pr-24 text-sm leading-6 text-zinc-200">
        <code>{code}</code>
      </pre>
    </div>
  );
}
