'use client';
import { describeWeather } from '@/lib/weatherCodes';
import { cn } from '@/lib/utils';

export function WeatherIcon({ code, className, size = 24 }: { code: number; className?: string; size?: number }) {
  const { Icon } = describeWeather(code);
  return <Icon className={cn('shrink-0', className)} size={size} />;
}
