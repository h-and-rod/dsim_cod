import apiClient from './api';

export interface PacienteBackend {
  id: string;
  nomeCompleto: string;
  email: string;
  telefone: string;
  dataNascimento: string;
  genero: string;
  tipoSanguineo: string;
  contatoEmergencia: string;
  observacoes?: string;
  ativo: boolean;
}

export interface DadosPulseira {
  deviceId: string;
  temperatura: number;
  frequenciaCardiaca: number;
  pressaoSistolica: number;
  pressaoDiastolica: number;
  saturacaoOxigenio: number;
  timestamp: string;
}

export interface HealthStatus {
  status: string;
  timestamp: string;
  service: string;
  version: string;
}

class PacienteService {
  
  // Buscar paciente por device ID
  async buscarPorDeviceId(deviceId: string): Promise<PacienteBackend> {
    const response = await apiClient.get(`/api/v1/pacientes/device/${deviceId}`);
    return response.data;
  }

  // Health check
  async healthCheck(): Promise<HealthStatus> {
    const response = await apiClient.get('/api/health');
    return response.data;
  }

  // Status simplificado (público)
  async statusCheck(): Promise<HealthStatus> {
    const response = await apiClient.get('/status');
    return response.data;
  }

  // Enviar dados da pulseira (para simulação)
  async enviarDadosPulseira(dados: DadosPulseira): Promise<string> {
    const response = await apiClient.post('/api/v1/pulseira/dados', dados);
    return response.data;
  }

  // Avaliar MEWS
  async avaliarMews(dados: DadosPulseira): Promise<string> {
    const response = await apiClient.post('/api/v1/mews/avaliar', dados);
    return response.data;
  }

  // Obter perfil do usuário
  async obterPerfilUsuario(): Promise<any> {
    const response = await apiClient.get('/api/v1/usuarios/me');
    return response.data;
  }
}

export default new PacienteService();