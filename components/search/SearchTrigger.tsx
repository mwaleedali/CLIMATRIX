'use client';
import { useEffect, useState } from 'react';
import { Search } from 'lucide-react';
import { SearchCommand } from './SearchCommand';

export function SearchTrigger() {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault(); setOpen((o) => !o);
      }
      if (e.key === 'Escape') setOpen(false);
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="group flex w-full items-center justify-between rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl px-3 py-2 text-left text-sm text-ink-muted transition-all hover:border-brand-purple/40 hover:text-ink-secondary"
      >
        <span className="inline-flex items-center gap-2">
          <Search size={14} />
          <span>Search any city…</span>
        </span>
        <kbd className="hidden sm:inline-flex items-center gap-1 rounded border border-surface-border bg-surface-elevated px-1.5 py-0.5 font-mono text-[10px] text-ink-muted">
          ⌘ K
        </kbd>
      </button>
      <SearchCommand open={open} onClose={() => setOpen(false)} />
    </>
  );
}
