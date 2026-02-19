#!/usr/bin/env node

/**
 * Script de Teste de Conexões do BigChat
 * Testa conexões PostgreSQL e Redis usando as dependências do projeto
 */

const path = require('path');
const { createRequire } = require('module');
const { execSync } = require('child_process');

const backendRequire = createRequire(path.join(__dirname, '../backend/package.json'));

// Carregar variáveis de ambiente
backendRequire('dotenv').config({ path: path.join(__dirname, '../.env.production') });

const resolveLocalHost = (host) => {
  if (!host) return host;
  return ["postgres", "redis"].includes(String(host).toLowerCase())
    ? "127.0.0.1"
    : host;
};

async function testDatabaseConnection() {
  console.log('🔍 Testando conexão PostgreSQL...');
  
  try {
    // Usar pg para testar conexão
    const { Client } = backendRequire('pg');
    
    const client = new Client({
      host: resolveLocalHost(process.env.DB_HOST),
      port: process.env.DB_PORT,
      user: process.env.DB_USER,
      password: process.env.DB_PASS,
      database: process.env.DB_NAME,
      connectTimeoutMillis: 10000,
    });

    await client.connect();
    const result = await client.query('SELECT version()');
    await client.end();
    
    console.log('✅ PostgreSQL: Conexão estabelecida com sucesso');
    console.log(`   Versão: ${result.rows[0].version.split(' ')[0]} ${result.rows[0].version.split(' ')[1]}`);
    console.log(`   Host: ${process.env.DB_HOST}:${process.env.DB_PORT}`);
    console.log(`   Database: ${process.env.DB_NAME}`);
    
    return true;
  } catch (error) {
    console.log('❌ PostgreSQL: Falha na conexão');
    console.log(`   Erro: ${error.message}`);
    return false;
  }
}

async function testRedisConnection() {
  console.log('\n🔍 Testando conexão Redis...');
  
  try {
    const redisPass = process.env.REDIS_PASSWORD || '';
    const ping = execSync(
      `docker exec -i bigchat-redis sh -lc 'redis-cli -a "${redisPass}" PING'`,
      { stdio: ['ignore', 'pipe', 'pipe'] }
    ).toString().trim();

    if (ping !== 'PONG') {
      throw new Error(`Resposta inesperada do Redis: ${ping}`);
    }

    const setResult = execSync(
      `docker exec -i bigchat-redis sh -lc 'redis-cli -a "${redisPass}" SET bigchat:test connection_test EX 10'`,
      { stdio: ['ignore', 'pipe', 'pipe'] }
    ).toString().trim();

    const getValue = execSync(
      `docker exec -i bigchat-redis sh -lc 'redis-cli -a "${redisPass}" GET bigchat:test'`,
      { stdio: ['ignore', 'pipe', 'pipe'] }
    ).toString().trim();

    execSync(
      `docker exec -i bigchat-redis sh -lc 'redis-cli -a "${redisPass}" DEL bigchat:test'`,
      { stdio: ['ignore', 'pipe', 'pipe'] }
    );

    if (setResult !== 'OK' || getValue !== 'connection_test') {
      throw new Error('Falha no teste de leitura/escrita Redis');
    }

    console.log('✅ Redis: Conexão estabelecida com sucesso');
    console.log('✅ Redis: Operações de leitura/escrita funcionando');
    return true;
    
  } catch (error) {
    console.log('❌ Redis: Falha na conexão');
    console.log(`   Erro: ${error.message}`);
    return false;
  }
}

async function testSequelizeConnection() {
  console.log('\n🔍 Testando conexão Sequelize...');
  
  try {
    const { Sequelize } = backendRequire('sequelize');
    const sequelize = new Sequelize(
      process.env.DB_NAME,
      process.env.DB_USER,
      process.env.DB_PASS,
      {
        dialect: process.env.DB_DIALECT || 'postgres',
        host: resolveLocalHost(process.env.DB_HOST),
        port: Number(process.env.DB_PORT || 5432),
        logging: false,
      }
    );
    
    await sequelize.authenticate();
    console.log('✅ Sequelize: Conexão autenticada com sucesso');
    
    // Testar query básica
    const [results, metadata] = await sequelize.query('SELECT NOW() as current_time');
    console.log(`   Timestamp do banco: ${results[0].current_time}`);
    
    await sequelize.close();
    return true;
    
  } catch (error) {
    console.log('❌ Sequelize: Falha na conexão');
    console.log(`   Erro: ${error.message}`);
    return false;
  }
}

async function testEmailConfiguration() {
  console.log('\n🔍 Testando configuração de email...');
  
  try {
    const hasDefaultCreds =
      !process.env.MAIL_USER ||
      !process.env.MAIL_PASS ||
      process.env.MAIL_USER.includes('seu@gmail.com') ||
      process.env.MAIL_PASS.includes('SuaSenha');

    if (hasDefaultCreds) {
      console.log('⚠️  Email: credenciais padrão detectadas, teste SMTP ignorado');
      return true;
    }

    const nodemailer = backendRequire('nodemailer');
    
    const transporter = nodemailer.createTransporter({
      host: process.env.MAIL_HOST,
      port: process.env.MAIL_PORT,
      secure: process.env.MAIL_PORT == 465, // true para 465, false para outras portas
      auth: {
        user: process.env.MAIL_USER,
        pass: process.env.MAIL_PASS,
      },
    });
    
    // Verificar conexão
    await transporter.verify();
    console.log('✅ Email: Configuração SMTP válida');
    console.log(`   Host: ${process.env.MAIL_HOST}:${process.env.MAIL_PORT}`);
    console.log(`   User: ${process.env.MAIL_USER}`);
    
    return true;
    
  } catch (error) {
    console.log('❌ Email: Falha na configuração SMTP');
    console.log(`   Erro: ${error.message}`);
    return false;
  }
}

async function checkDependencies() {
  console.log('🔍 Verificando dependências...');
  
  const requiredDeps = [
    'pg', 'sequelize', 'nodemailer', 'dotenv'
  ];
  
  const missing = [];
  
  for (const dep of requiredDeps) {
    try {
      backendRequire.resolve(dep);
      console.log(`✅ Dependência encontrada: ${dep}`);
    } catch (error) {
      console.log(`❌ Dependência faltando: ${dep}`);
      missing.push(dep);
    }
  }
  
  if (missing.length > 0) {
    console.log(`\n⚠️  Instale as dependências faltando: npm install ${missing.join(' ')}`);
    return false;
  }
  
  return true;
}

async function main() {
  console.log('='.repeat(60));
  console.log('BigChat - Teste de Conexões');
  console.log('='.repeat(60));
  
  // Mudar para o diretório do backend para carregar dependências
  process.chdir(path.join(__dirname, '../backend'));
  
  const results = {
    dependencies: false,
    postgres: false,
    redis: false,
    sequelize: false,
    email: false
  };
  
  try {
    results.dependencies = await checkDependencies();
    
    if (results.dependencies) {
      results.postgres = await testDatabaseConnection();
      results.redis = await testRedisConnection();
      results.sequelize = await testSequelizeConnection();
      results.email = await testEmailConfiguration();
    }
    
  } catch (error) {
    console.log(`\n❌ Erro geral: ${error.message}`);
  }
  
  // Relatório final
  console.log('\n' + '='.repeat(60));
  console.log('RELATÓRIO DE CONEXÕES');
  console.log('='.repeat(60));
  
  const passed = Object.values(results).filter(r => r === true).length;
  const total = Object.keys(results).length;
  
  console.log(`\n📊 Resultado: ${passed}/${total} testes aprovados\n`);
  
  Object.entries(results).forEach(([test, result]) => {
    const status = result ? '✅' : '❌';
    const testName = test.charAt(0).toUpperCase() + test.slice(1);
    console.log(`${status} ${testName}`);
  });
  
  if (passed === total) {
    console.log('\n🎉 Todas as conexões estão funcionando!');
    process.exit(0);
  } else {
    console.log('\n🚨 Algumas conexões falharam. Verifique as configurações.');
    process.exit(1);
  }
}

// Executar teste
if (require.main === module) {
  main().catch(error => {
    console.error('\n💥 Erro fatal:', error.message);
    process.exit(1);
  });
}

module.exports = {
  testDatabaseConnection,
  testRedisConnection,
  testSequelizeConnection,
  testEmailConfiguration
};