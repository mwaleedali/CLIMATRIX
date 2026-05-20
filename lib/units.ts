export const cToF = (c: number) => (c * 9) / 5 + 32;
export const kmhToMph = (k: number) => k * 0.621371;
export const hpaToInHg = (h: number) => h * 0.02953;

export function formatTemp(c: number, unit: 'C' | 'F') {
  const v = unit === 'C' ? c : cToF(c);
  return `${Math.round(v)}°`;
}

export function formatWind(kmh: number, unit: 'kmh' | 'mph') {
  const v = unit === 'kmh' ? kmh : kmhToMph(kmh);
  return `${Math.round(v)} ${unit === 'kmh' ? 'km/h' : 'mph'}`;
}

export function formatPressure(hpa: number, unit: 'hPa' | 'inHg') {
  return unit === 'hPa' ? `${Math.round(hpa)} hPa` : `${hpaToInHg(hpa).toFixed(2)} inHg`;
}

export function uvRisk(uv: number) {
  if (uv < 3)  return 'Low';
  if (uv < 6)  return 'Moderate';
  if (uv < 8)  return 'High';
  if (uv < 11) return 'Very High';
  return 'Extreme';
}

export function windDirLabel(deg: number) {
  const dirs = ['N','NE','E','SE','S','SW','W','NW'];
  return dirs[Math.round(deg / 45) % 8];
}
