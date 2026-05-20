'use client';
import { useState, type ReactNode } from 'react';
import { AnimatePresence, motion } from 'framer-motion';

export function Tooltip({ children, content }: { children: ReactNode; content: string }) {
  const [open, setOpen] = useState(false);
  return (
    <span className="relative inline-flex" onMouseEnter={() => setOpen(true)} onMouseLeave={() => setOpen(false)}>
      {children}
      <AnimatePresence>
        {open && (
          <motion.span
            initial={{ opacity: 0, y: -4 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -4 }}
            className="pointer-events-none absolute left-1/2 -translate-x-1/2 -top-9 whitespace-nowrap rounded-md border border-surface-border bg-surface-elevated px-2 py-1 text-xs text-ink-primary shadow-glass-dark"
          >
            {content}
          </motion.span>
        )}
      </AnimatePresence>
    </span>
  );
}
