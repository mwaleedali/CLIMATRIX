export function heatIndex(tempC: number, humidity: number): number {
  const T = (tempC * 9) / 5 + 32;
  const R = humidity;
  if (T < 80) return tempC;
  const HI =
    -42.379 +
    2.04901523 * T +
    10.14333127 * R -
    0.22475541 * T * R -
    6.83783e-3 * T * T -
    5.481717e-2 * R * R +
    1.22874e-3 * T * T * R +
    8.5282e-4 * T * R * R -
    1.99e-6 * T * T * R * R;
  return ((HI - 32) * 5) / 9;
}

export function windChill(tempC: number, windKmh: number): number {
  if (tempC >= 10 || windKmh <= 4.8) return tempC;
  const v = Math.pow(windKmh, 0.16);
  return 13.12 + 0.6215 * tempC - 11.37 * v + 0.3965 * tempC * v;
}

export function dewPoint(tempC: number, humidity: number): number {
  const a = 17.27, b = 237.7;
  const alpha = (a * tempC) / (b + tempC) + Math.log(Math.max(humidity, 1) / 100);
  return (b * alpha) / (a - alpha);
}

export function beaufort(windKmh: number): { scale: number; label: string } {
  const tiers: [number, string][] = [
    [1,   'Calm'],         [5,   'Light air'],
    [11,  'Light breeze'], [19,  'Gentle breeze'],
    [28,  'Moderate'],     [38,  'Fresh breeze'],
    [49,  'Strong breeze'],[61,  'Near gale'],
    [74,  'Gale'],         [88,  'Strong gale'],
    [102, 'Storm'],        [117, 'Violent storm'],
  ];
  for (let i = 0; i < tiers.length; i++) if (windKmh < tiers[i][0]) return { scale: i, label: tiers[i][1] };
  return { scale: 12, label: 'Hurricane' };
}

export function moonPhase(date: Date): { phase: string; illumination: number; emoji: string } {
  const y = date.getUTCFullYear();
  const m = date.getUTCMonth() + 1;
  const d = date.getUTCDate();
  let r = y % 100;
  r %= 19;
  if (r > 9) r -= 19;
  r = ((r * 11) % 30) + (m < 3 ? m + 2 : m) + d;
  if (m < 3) r += 2;
  r -= y < 2000 ? 4 : 8.3;
  let phaseAge = (((r + 30) % 30) / 29.53);
  if (phaseAge < 0) phaseAge += 1;

  const labels = ['New Moon','Waxing Crescent','First Quarter','Waxing Gibbous','Full Moon','Waning Gibbous','Last Quarter','Waning Crescent'];
  const emojis = ['🌑','🌒','🌓','🌔','🌕','🌖','🌗','🌘'];
  const idx = Math.floor(phaseAge * 8) % 8;
  const illum = (1 - Math.cos(phaseAge * 2 * Math.PI)) / 2;
  return { phase: labels[idx], illumination: Math.round(illum * 100), emoji: emojis[idx] };
}

export function feelsLike(tempC: number, humidity: number, windKmh: number): number {
  if (tempC >= 27 && humidity >= 40) return heatIndex(tempC, humidity);
  if (tempC <= 10 && windKmh > 4.8) return windChill(tempC, windKmh);
  return tempC;
}
