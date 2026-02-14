import Redis from "ioredis";
import { REDIS_URI_CONNECTION } from "../config/redis";
import util from "util";
import * as crypto from "crypto";

let redis: Redis | null = null;
const inMemoryCache: Map<string, { value: string; expires?: number }> = new Map();

// Tentar conectar a Redis, mas usar cache em memória se falhar
if (REDIS_URI_CONNECTION) {
  redis = new Redis(REDIS_URI_CONNECTION);
  redis.on("error", (err) => {
    console.warn("[CACHE] Redis connection failed, using in-memory cache:", err.message);
    redis = null;
  });
}

function encryptParams(params: any) {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("base64");
}

export function setFromParams(
  key: string,
  params: any,
  value: string,
  option?: string,
  optionValue?: string | number
) {
  const finalKey = `${key}:${encryptParams(params)}`;
  if (option !== undefined && optionValue !== undefined) {
    return set(finalKey, value, option, optionValue);
  }
  return set(finalKey, value);
}

export function getFromParams(key: string, params: any) {
  const finalKey = `${key}:${encryptParams(params)}`;
  return get(finalKey);
}

export function delFromParams(key: string, params: any) {
  const finalKey = `${key}:${encryptParams(params)}`;
  return del(finalKey);
}

export function set(
  key: string,
  value: string,
  option?: string,
  optionValue?: string | number
) {
  if (redis) {
    const setPromisefy = util.promisify(redis.set).bind(redis);
    if (option !== undefined && optionValue !== undefined) {
      return setPromisefy(key, value, option, optionValue);
    }
    return setPromisefy(key, value);
  }

  // In-memory cache fallback
  let expires: number | undefined;
  if (option === "EX" && typeof optionValue === "number") {
    expires = Date.now() + optionValue * 1000;
  }
  inMemoryCache.set(key, { value, expires });
  return Promise.resolve("OK");
}

export function get(key: string) {
  if (redis) {
    const getPromisefy = util.promisify(redis.get).bind(redis);
    return getPromisefy(key);
  }

  // In-memory cache fallback
  const item = inMemoryCache.get(key);
  if (!item) return Promise.resolve(null);

  if (item.expires && Date.now() > item.expires) {
    inMemoryCache.delete(key);
    return Promise.resolve(null);
  }

  return Promise.resolve(item.value);
}

export function getKeys(pattern: string) {
  if (redis) {
    const getKeysPromisefy = util.promisify(redis.keys).bind(redis);
    return getKeysPromisefy(pattern);
  }

  // In-memory cache fallback - simple pattern matching
  const keys: string[] = [];
  const regex = new RegExp("^" + pattern.replace("*", ".*") + "$");

  for (const [key, item] of inMemoryCache.entries()) {
    if (regex.test(key)) {
      if (!item.expires || Date.now() <= item.expires) {
        keys.push(key);
      } else {
        inMemoryCache.delete(key);
      }
    }
  }

  return Promise.resolve(keys);
}

export function del(key: string) {
  if (redis) {
    const delPromisefy = util.promisify(redis.del).bind(redis);
    return delPromisefy(key);
  }

  // In-memory cache fallback
  inMemoryCache.delete(key);
  return Promise.resolve(1);
}

export async function delFromPattern(pattern: string) {
  const all = await getKeys(pattern);
  for (let item of all) {
    await del(item);
  }
}

export const cacheLayer = {
  set,
  setFromParams,
  get,
  getFromParams,
  getKeys,
  del,
  delFromParams,
  delFromPattern
};
