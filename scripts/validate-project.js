#!/usr/bin/env node

const { execSync, spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

/**
 * Script de Validação do Projeto BigChat
 * Verifica todas as configurações e conexões necessárias
 */

class ProjectValidator {
  constructor() {
    this.errors = [];
    this.warnings = [];
    this.passed = [];
  }

  log(message, type = 'info') {
    const timestamp = new Date().toISOString();
    const prefix = {
      error: '❌ ERROR',
      warning: '⚠️  WARNING', 
      success: '✅ PASSED',
      info: '🔍 INFO'
    };
    
    console.log(`[${timestamp}] ${prefix[type]}: ${message}`);
  }

  addError(message) {
    this.errors.push(message);
    this.log(message, 'error');
  }

  addWarning(message) {
    this.warnings.push(message);
    this.log(message, 'warning');
  }

  addPassed(message) {
    this.passed.push(message);
    this.log(message, 'success');
  }

  // Verifica se um arquivo existe
  checkFileExists(filePath, required = true) {
    const exists = fs.existsSync(filePath);
    if (!exists && required) {
      this.addError(`Arquivo obrigatório não encontrado: ${filePath}`);
      return false;
    } else if (!exists) {
      this.addWarning(`Arquivo opcional não encontrado: ${filePath}`);
      return false;
    } else {
      this.addPassed(`Arquivo encontrado: ${filePath}`);
      return true;
    }
  }

  // Carrega variáveis de ambiente
  loadEnvFile(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const env = {};
      content.split('\n').forEach(line => {
        const match = line.match(/^([A-Z_]+)=(.*)$/);
        if (match) {
          env[match[1]] = match[2].replace(/^["']|["']$/g, '');
        }
      });
      this.addPassed(`Arquivo .env carregado: ${filePath}`);
      return env;
    } catch (error) {
      this.addError(`Erro ao carregar arquivo .env: ${filePath} - ${error.message}`);
      return {};
    }
  }

  // Valida configurações obrigatórias
  validateRequiredEnvVars(env, required) {
    required.forEach(varName => {
      if (!env[varName]) {
        this.addError(`Variável de ambiente obrigatória não definida: ${varName}`);
      } else if (env[varName].includes('seu@gmail.com') || env[varName].includes('SuaSenha') || env[varName].includes('Client_Id_')) {
        this.addError(`Variável de ambiente com valor padrão (precisa ser configurada): ${varName}`);
      } else {
        this.addPassed(`Variável de ambiente configurada: ${varName}`);
      }
    });
  }

  // Verifica se uma porta está em uso
  async checkPortAvailability(port, service) {
    try {
      const result = execSync(`netstat -tuln | grep :${port}`, { encoding: 'utf8', stdio: 'pipe' });
      if (result.trim()) {
        this.addWarning(`Porta ${port} (${service}) já está em uso`);
        return false;
      } else {
        this.addPassed(`Porta ${port} (${service}) está disponível`);
        return true;
      }
    } catch (error) {
      this.addPassed(`Porta ${port} (${service}) está disponível`);
      return true;
    }
  }

  // Verifica dependências do Node.js
  validateNodeDependencies() {
    this.log('Verificando dependências do Node.js...', 'info');
    
    const packageJsonPaths = [
      './package.json',
      './backend/package.json',
      './frontend/package.json'
    ];

    packageJsonPaths.forEach(packagePath => {
      if (this.checkFileExists(packagePath)) {
        try {
          const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
          
          // Verifica se node_modules existe
          const nodeModulesPath = path.dirname(packagePath) + '/node_modules';
          if (fs.existsSync(nodeModulesPath)) {
            this.addPassed(`Node modules instalados: ${packagePath}`);
          } else {
            this.addError(`Node modules não instalados: ${packagePath} (execute npm install)`);
          }

        } catch (error) {
          this.addError(`Erro ao ler package.json: ${packagePath} - ${error.message}`);
        }
      }
    });
  }

  // Verifica status do Docker
  validateDockerServices() {
    this.log('Verificando serviços Docker...', 'info');
    
    try {
      // Verifica se Docker está rodando
      execSync('docker info', { stdio: 'pipe' });
      this.addPassed('Docker daemon está rodando');

      // Verifica se docker-compose existe
      this.checkFileExists('./docker-compose.yml');

      // Lista containers ativos
      try {
        const containers = execSync('docker ps --format "table {{.Names}}\\t{{.Status}}"', { encoding: 'utf8' });
        this.log('Containers Docker ativos:\n' + containers, 'info');
      } catch (error) {
        this.addWarning('Não foi possível listar containers Docker');
      }

    } catch (error) {
      this.addError('Docker daemon não está rodando ou não está instalado');
    }
  }

  // Testa conexão com banco PostgreSQL
  async testDatabaseConnection(env) {
    this.log('Testando conexão com banco de dados...', 'info');
    
    if (!env.DB_HOST || !env.DB_PORT || !env.DB_USER || !env.DB_PASS || !env.DB_NAME) {
      this.addError('Configurações de banco de dados incompletas');
      return;
    }

    try {
      const testCommand = `PGPASSWORD="${env.DB_PASS}" psql -h ${env.DB_HOST} -p ${env.DB_PORT} -U ${env.DB_USER} -d ${env.DB_NAME} -c "SELECT version();" -t`;
      
      const result = execSync(testCommand, { 
        encoding: 'utf8', 
        stdio: 'pipe',
        timeout: 10000 
      });
      
      this.addPassed('Conexão com banco PostgreSQL estabelecida com sucesso');
      this.log(`Versão do PostgreSQL: ${result.trim()}`, 'info');
      
    } catch (error) {
      this.addError(`Falha na conexão com banco PostgreSQL: ${error.message}`);
    }
  }

  // Testa conexão com Redis
  async testRedisConnection(env) {
    this.log('Testando conexão com Redis...', 'info');
    
    if (!env.REDIS_URI && !env.REDIS_PASSWORD) {
      this.addError('Configurações de Redis não definidas');
      return;
    }

    try {
      const redisHost = env.REDIS_URI ? env.REDIS_URI.split('@')[1]?.split(':')[0] : 'redis';
      const redisPort = env.REDIS_URI ? env.REDIS_URI.split(':')[3] || '6379' : '6379';
      
      let testCommand;
      if (env.REDIS_PASSWORD) {
        testCommand = `redis-cli -h ${redisHost} -p ${redisPort} -a "${env.REDIS_PASSWORD}" ping`;
      } else {
        testCommand = `redis-cli -h ${redisHost} -p ${redisPort} ping`;
      }
      
      const result = execSync(testCommand, { 
        encoding: 'utf8', 
        stdio: 'pipe',
        timeout: 10000 
      });
      
      if (result.trim() === 'PONG') {
        this.addPassed('Conexão com Redis estabelecida com sucesso');
      } else {
        this.addError('Redis não respondeu ao comando PING');
      }
      
    } catch (error) {
      this.addError(`Falha na conexão com Redis: ${error.message}`);
    }
  }

  // Verifica configurações de SSL/certificados
  validateSSLConfiguration() {
    this.log('Verificando configurações SSL...', 'info');
    
    const certPaths = [
      './nginx/certs',
      './backend/certs',
      '/etc/letsencrypt'
    ];

    let sslConfigured = false;
    
    certPaths.forEach(certPath => {
      if (fs.existsSync(certPath)) {
        this.addPassed(`Diretório de certificados encontrado: ${certPath}`);
        sslConfigured = true;
      }
    });

    if (!sslConfigured) {
      this.addWarning('Nenhum diretório de certificados SSL encontrado');
    }
  }

  // Verifica configurações de email
  validateEmailConfiguration(env) {
    this.log('Verificando configurações de email...', 'info');
    
    const emailVars = ['MAIL_HOST', 'MAIL_USER', 'MAIL_PASS', 'MAIL_FROM', 'MAIL_PORT'];
    const missingVars = emailVars.filter(varName => !env[varName]);
    
    if (missingVars.length > 0) {
      this.addWarning(`Configurações de email incompletas: ${missingVars.join(', ')}`);
    } else if (env.MAIL_USER.includes('seu@gmail.com') || env.MAIL_PASS === 'SuaSenha') {
      this.addWarning('Configurações de email usando valores padrão');
    } else {
      this.addPassed('Configurações de email parecem válidas');
    }
  }

  // Executa todas as validações
  async runValidation() {
    this.log('='.repeat(60), 'info');
    this.log('INICIANDO VALIDAÇÃO DO PROJETO BIGCHAT', 'info');
    this.log('='.repeat(60), 'info');

    // 1. Verificar arquivos essenciais
    this.log('\n1. Verificando arquivos essenciais...', 'info');
    const requiredFiles = [
      '.env',
      '.env.production',
      'docker-compose.yml',
      'backend/package.json',
      'frontend/package.json',
      'backend/src/server.ts',
      'backend/src/app.ts'
    ];
    
    requiredFiles.forEach(file => this.checkFileExists(file));

    // 2. Carregar e validar variáveis de ambiente
    this.log('\n2. Validando variáveis de ambiente...', 'info');
    const envProd = this.loadEnvFile('.env.production');
    const envDev = this.loadEnvFile('.env');

    const requiredEnvVars = [
      'NODE_ENV', 'BACKEND_URL', 'FRONTEND_URL', 'PORT',
      'DB_DIALECT', 'DB_HOST', 'DB_PORT', 'DB_USER', 'DB_PASS', 'DB_NAME',
      'REDIS_URI', 'REDIS_PASSWORD',
      'JWT_SECRET', 'JWT_REFRESH_SECRET'
    ];

    this.validateRequiredEnvVars(envProd, requiredEnvVars);

    // 3. Verificar dependências
    this.log('\n3. Verificando dependências...', 'info');
    this.validateNodeDependencies();

    // 4. Verificar Docker
    this.log('\n4. Verificando Docker...', 'info');
    this.validateDockerServices();

    // 5. Verificar portas
    this.log('\n5. Verificando disponibilidade de portas...', 'info');
    await this.checkPortAvailability(envProd.PORT || 4000, 'Backend');
    await this.checkPortAvailability(80, 'HTTP');
    await this.checkPortAvailability(443, 'HTTPS');
    await this.checkPortAvailability(5432, 'PostgreSQL');
    await this.checkPortAvailability(6379, 'Redis');

    // 6. Testar conexões de banco de dados
    this.log('\n6. Testando conexões...', 'info');
    await this.testDatabaseConnection(envProd);
    await this.testRedisConnection(envProd);

    // 7. Verificar configurações adicionais
    this.log('\n7. Verificando configurações adicionais...', 'info');
    this.validateSSLConfiguration();
    this.validateEmailConfiguration(envProd);

    // 8. Gerar relatório final
    this.generateFinalReport();
  }

  generateFinalReport() {
    this.log('\n' + '='.repeat(60), 'info');
    this.log('RELATÓRIO FINAL DE VALIDAÇÃO', 'info');
    this.log('='.repeat(60), 'info');

    this.log(`\n📊 RESUMO:`, 'info');
    this.log(`  ✅ Testes aprovados: ${this.passed.length}`, 'info');
    this.log(`  ⚠️  Avisos: ${this.warnings.length}`, 'info');
    this.log(`  ❌ Erros: ${this.errors.length}`, 'info');

    if (this.errors.length > 0) {
      this.log(`\n❌ ERROS CRÍTICOS (${this.errors.length}):`, 'info');
      this.errors.forEach((error, index) => {
        this.log(`  ${index + 1}. ${error}`, 'info');
      });
    }

    if (this.warnings.length > 0) {
      this.log(`\n⚠️  AVISOS (${this.warnings.length}):`, 'info');
      this.warnings.forEach((warning, index) => {
        this.log(`  ${index + 1}. ${warning}`, 'info');
      });
    }

    // Status geral
    if (this.errors.length === 0) {
      this.log(`\n🎉 PROJETO VALIDADO COM SUCESSO!`, 'success');
      this.log(`O projeto está configurado corretamente e pronto para deploy.`, 'info');
      process.exit(0);
    } else {
      this.log(`\n🚨 PROJETO COM PROBLEMAS!`, 'error');
      this.log(`Corrija os erros críticos antes de fazer o deploy.`, 'info');
      process.exit(1);
    }
  }
}

// Executar validação
if (require.main === module) {
  const validator = new ProjectValidator();
  validator.runValidation().catch(error => {
    console.error('Erro durante validação:', error);
    process.exit(1);
  });
}

module.exports = ProjectValidator;