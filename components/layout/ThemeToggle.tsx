'use client';
import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';
import { Moon, Sun } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  const isDark = theme === 'dark';

  return (
    <button
      aria-label="Toggle theme"
      onClick={() => setTheme(isDark ? 'light' : 'dark')}
      className="relative inline-flex h-9 w-9 items-center justify-center rounded-lg border border-surface-border bg-surface-raised/60 backdrop-blur-xl text-ink-secondary transition-all hover:scale-[1.05] hover:text-ink-primary hover:border-brand-purple/40"
    >
      {mounted && (
        <AnimatePresence mode="wait">
          <motion.span
            key={isDark ? 'moon' : 'sun'}
            initial={{ rotate: -45, opacity: 0 }} animate={{ rotate: 0, opacity: 1 }} exit={{ rotate: 45, opacity: 0 }}
            transition={{ duration: 0.2 }}
          >
            {isDark ? <Moon size={16} /> : <Sun size={16} />}
          </motion.span>
        </AnimatePresence>
      )}
    </button>
  );
}
