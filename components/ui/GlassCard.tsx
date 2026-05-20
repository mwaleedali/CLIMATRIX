'use client';
import { cn } from '@/lib/utils';
import type { HTMLAttributes, ReactNode } from 'react';

interface Props extends HTMLAttributes<HTMLDivElement> {
  children: ReactNode;
  gradientBorder?: boolean;
}

export function GlassCard({ children, className, gradientBorder, ...rest }: Props) {
  return (
    <div
      className={cn(
        'relative rounded-xl border border-surface-border bg-surface-raised/70 backdrop-blur-xl',
        'shadow-glass-light dark:shadow-glass-dark',
        'transition-colors hover:border-brand-purple/40',
        gradientBorder && 'gradient-border',
        className
      )}
      {...rest}
    >
      {children}
    </div>
  );
}
