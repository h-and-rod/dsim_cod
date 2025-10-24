// Versão simplificada do cliente API sem dependências externas
// Este arquivo será usado até que o axios seja instalado

interface ApiResponse<T = any> {
  data: T;
  status: number;
  statusText: string;
}

interface ApiError {
  response?: {
    status: number;
    statusText: string;
    data: any;
  };
  message: string;
}

class SimpleApiClient {
  private baseURL: string;
  private timeout: number;
  private defaultHeaders: Record<string, string>;

  constructor(config: {
    baseURL: string;
    timeout?: number;
    headers?: Record<string, string>;
  }) {
    this.baseURL = config.baseURL;
    this.timeout = config.timeout || 10000;
    this.defaultHeaders = config.headers || {};
  }

  private async request<T>(
    method: string,
    url: string,
    data?: any,
    headers?: Record<string, string>
  ): Promise<ApiResponse<T>> {
    const fullUrl = url.startsWith('http') ? url : `${this.baseURL}${url}`;
    
    const requestHeaders = {
      ...this.defaultHeaders,
      ...headers,
    };

    // Adicionar token de autenticação se existir
    const token = localStorage.getItem('authToken');
    if (token) {
      requestHeaders.Authorization = `Bearer ${token}`;
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), this.timeout);

    try {
      const response = await fetch(fullUrl, {
        method,
        headers: requestHeaders,
        body: data ? JSON.stringify(data) : undefined,
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        if (response.status === 401) {
          // Token expirado, redirecionar para login
          localStorage.removeItem('authToken');
          window.location.href = '/login';
        }
        
        const error: ApiError = {
          response: {
            status: response.status,
            statusText: response.statusText,
            data: await response.text(),
          },
          message: `Request failed with status ${response.status}`,
        };
        throw error;
      }

      const responseData = await response.json();
      
      return {
        data: responseData,
        status: response.status,
        statusText: response.statusText,
      };
    } catch (error) {
      clearTimeout(timeoutId);
      throw error;
    }
  }

  async get<T>(url: string, headers?: Record<string, string>): Promise<ApiResponse<T>> {
    return this.request<T>('GET', url, undefined, headers);
  }

  async post<T>(url: string, data?: any, headers?: Record<string, string>): Promise<ApiResponse<T>> {
    return this.request<T>('POST', url, data, headers);
  }

  async put<T>(url: string, data?: any, headers?: Record<string, string>): Promise<ApiResponse<T>> {
    return this.request<T>('PUT', url, data, headers);
  }

  async delete<T>(url: string, headers?: Record<string, string>): Promise<ApiResponse<T>> {
    return this.request<T>('DELETE', url, undefined, headers);
  }
}

// Configuração base da API
const API_BASE_URL = (window as any).import?.meta?.env?.VITE_API_URL || 'http://localhost:8080';

const apiClient = new SimpleApiClient({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export default apiClient;