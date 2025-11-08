// Shared TypeScript types for DFWorX

// =============================================================================
// Export Database Types
// =============================================================================
export * from "./database";

// =============================================================================
// Export Blog Types
// =============================================================================
export * from "./blog";

// =============================================================================
// Export Chat Types
// =============================================================================
export * from "./chat";

// =============================================================================
// Generic API Response Types
// =============================================================================

export interface ApiResponse<T> {
  data: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

export interface ErrorResponse {
  error: string;
  message: string;
  statusCode: number;
  details?: Record<string, any>;
}

// =============================================================================
// Utility Types
// =============================================================================

export type Nullable<T> = T | null;
export type Optional<T> = T | undefined;
export type Maybe<T> = T | null | undefined;

// Make all properties optional
export type PartialDeep<T> = {
  [P in keyof T]?: T[P] extends object ? PartialDeep<T[P]> : T[P];
};

// Make specific properties required
export type RequireFields<T, K extends keyof T> = T & Required<Pick<T, K>>;

// Make specific properties optional
export type OptionalFields<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;

// Timestamp utilities
export type ISOTimestamp = string;
export type UnixTimestamp = number;
