import type { WeatherBundle, ScoreResult } from '@/types/weather';
import { feelsLike, moonPhase } from './calculations';
import { clamp } from './utils';

const labelFor = (s: number): ScoreResult['label'] =>
  s >= 80 ? 'Excellent' : s >= 60 ? 'Good' : s >= 40 ? 'Fair' : s >= 20 ? 'Poor' : 'Bad';

const colorFor = (s: number): string =>
  s >= 80 ? '#10B981' : s >= 60 ? '#A3E635' : s >= 40 ? '#F59E0B' : s >= 20 ? '#F97316' : '#EF4444';

const wrap = (raw: number, reasons: string[]): ScoreResult => {
  const score = Math.round(clamp(raw, 0, 100));
  return { score, label: labelFor(score), color: colorFor(score), reasons };
};

function rangeScore(v: number, lo: number, hi: number, falloff = 1): number {
  if (v >= lo && v <= hi) return 1;
  const dist = v < lo ? lo - v : v - hi;
  return clamp(1 - dist / (falloff * (hi - lo || 1)), 0, 1);
}

export function cricketScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 18, 32, 1) * 30;
  if (cur.temperature >= 18 && cur.temperature <= 32) reasons.push('Ideal playing temperature');
  else reasons.push(cur.temperature > 32 ? 'Too hot for comfort' : 'Chilly for play');

  const dry = pop < 20 ? 30 : pop < 50 ? 15 : 0;
  if (pop < 20) reasons.push('Dry skies ahead');
  else if (pop >= 50) reasons.push('Rain likely');

  const wind = cur.windSpeed < 25 ? 20 : cur.windSpeed < 40 ? 10 : 0;
  if (cur.windSpeed < 25) reasons.push('Light winds');

  const hum = cur.humidity < 70 ? 10 : 5;
  const vis = cur.visibility > 5 ? 10 : 5;

  return wrap(temp + dry + wind + hum + vis, reasons.slice(0, 3));
}

export function solarScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const dailyUv = w.daily.uvIndexMax?.[0] ?? 0;
  const daylight = w.daily.daylightDuration?.[0] ?? 0;
  const reasons: string[] = [];

  const cloudPart = ((100 - cur.cloudCover) / 100) * 50;
  if (cur.cloudCover < 30) reasons.push('Clear skies');
  else if (cur.cloudCover > 70) reasons.push('Heavy cloud cover');

  const uvPart = clamp(dailyUv / 10, 0, 1) * 30;
  if (dailyUv >= 6) reasons.push('Strong sunlight');

  const dlPart = clamp(daylight / 50400, 0, 1) * 20;
  if (daylight > 43200) reasons.push('Long daylight hours');

  return wrap(cloudPart + uvPart + dlPart, reasons.slice(0, 3));
}

export function runningScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const feels = feelsLike(cur.temperature, cur.humidity, cur.windSpeed);
  const reasons: string[] = [];

  const temp = rangeScore(feels, 10, 25, 1.2) * 40;
  if (feels >= 10 && feels <= 25) reasons.push('Perfect running temperature');
  else reasons.push(feels < 10 ? 'A bit cold' : 'Quite warm');

  const dry = pop < 20 ? 25 : pop < 50 ? 12 : 0;
  if (pop < 20) reasons.push('Low rain chance');

  const hum = cur.humidity < 75 ? 15 : 5;
  const uv = cur.uvIndex < 6 ? 10 : 4;
  const wind = cur.windSpeed < 30 ? 10 : 3;
  if (cur.windSpeed > 30) reasons.push('Gusty conditions');

  return wrap(temp + dry + hum + uv + wind, reasons.slice(0, 3));
}

export function farmingScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const precip = w.daily.precipitationSum?.[0] ?? 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 15, 28, 1) * 30;
  if (cur.temperature >= 15 && cur.temperature <= 28) reasons.push('Good growing temperature');

  const precipPart = precip >= 1 && precip <= 10 ? 30 : precip < 1 ? 12 : precip > 25 ? 0 : 18;
  if (precip >= 1 && precip <= 10) reasons.push('Balanced rainfall');
  else if (precip > 25) reasons.push('Flood risk');
  else if (precip < 1) reasons.push('Dry conditions');

  const wind = cur.windSpeed < 25 ? 20 : 10;
  const hum = cur.humidity >= 50 && cur.humidity <= 80 ? 20 : 8;

  return wrap(temp + precipPart + wind + hum, reasons.slice(0, 3));
}

export function picnicScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const next6h = (w.hourly.precipitationProbability ?? []).slice(0, 6);
  const pop = next6h.length ? Math.max(...next6h) : 0;
  const reasons: string[] = [];

  const temp = rangeScore(cur.temperature, 18, 28, 1) * 30;
  if (cur.temperature >= 18 && cur.temperature <= 28) reasons.push('Pleasant temperature');

  const dry = pop < 15 ? 30 : pop < 40 ? 15 : 0;
  if (pop < 15) reasons.push('Very low rain chance');

  const wind = cur.windSpeed < 20 ? 20 : 8;
  const cloud = cur.cloudCover < 60 ? 10 : 4;
  const uv = cur.uvIndex < 8 ? 10 : 4;
  if (cur.cloudCover < 30) reasons.push('Sunny skies');

  return wrap(temp + dry + wind + cloud + uv, reasons.slice(0, 3));
}

export function stargazingScore(w: WeatherBundle): ScoreResult {
  const cur = w.current;
  const moon = moonPhase(new Date());
  const reasons: string[] = [];

  const cloudPart = ((100 - cur.cloudCover) / 100) * 50;
  if (cur.cloudCover < 20) reasons.push('Crystal clear skies');
  else if (cur.cloudCover > 60) reasons.push('Cloudy night');

  const moonPart = ((100 - moon.illumination) / 100) * 30;
  if (moon.illumination < 30) reasons.push('Dark moon — great visibility');
  else if (moon.illumination > 80) reasons.push('Bright moon washes out stars');

  const humPart = ((100 - cur.humidity) / 100) * 20;
  if (cur.humidity < 50) reasons.push('Low humidity');

  return wrap(cloudPart + moonPart + humPart, reasons.slice(0, 3));
}

export interface ScoredActivity {
  key: string;
  emoji: string;
  name: string;
  result: ScoreResult;
}

export function computeAllScores(w: WeatherBundle): ScoredActivity[] {
  return [
    { key: 'cricket',    emoji: '🏏', name: 'Cricket',    result: cricketScore(w) },
    { key: 'solar',      emoji: '☀️', name: 'Solar Power',result: solarScore(w) },
    { key: 'running',    emoji: '🏃', name: 'Running',    result: runningScore(w) },
    { key: 'farming',    emoji: '🌾', name: 'Farming',    result: farmingScore(w) },
    { key: 'picnic',     emoji: '🧺', name: 'Picnic',     result: picnicScore(w) },
    { key: 'stargazing', emoji: '🔭', name: 'Stargazing', result: stargazingScore(w) },
  ];
}
