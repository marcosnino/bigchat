#!/usr/bin/env node

/**
 * Script de Teste de Conexões do BigChat
 * Testa conexões PostgreSQL e Redis usando as dependências do projeto
 */

const path = require('path');
const { execSync } = require('child_process');

// Carregar variáveis de ambiente
require('dotenv').config({ path: path.join(__dirname, '../.env.production') });

async function testDatabaseConnection() {
  console.log('🔍 Testando conexão PostgreSQL...');
  
  try {
    // Usar pg para testar conexão
    const { Client } = require('pg');
    
    const client = new Client({
      host: process.env.DB_HOST,
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
    const redis = require('redis');
    
    // Parsear a URI do Redis
    const redisURL = process.env.REDIS_URI;
    const client = redis.createClient({
      url: redisURL,
      connectTimeout: 10000
    });
    
    client.on('error', (err) => {
      console.log('❌ Redis Client Error:', err);
    });

    await client.connect();
    const result = await client.ping();
    
    if (result === 'PONG') {
      console.log('✅ Redis: Conexão estabelecida com sucesso');
      console.log(`   URI: ${redisURL.replace(/\/\/:[^@]*@/, '//***:***@')}`); // Ocultar senha
      
      // Testar operações básicas
      await client.set('bigchat:test', 'connection_test', { EX: 10 });
      const testValue = await client.get('bigchat:test');
      
      if (testValue === 'connection_test') {
        console.log('✅ Redis: Operações de leitura/escrita funcionando');
      }
      
      await client.del('bigchat:test');
    }
    
    await client.disconnect();
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
    // Carregar configuração do banco usando o arquivo do projeto
    const dbConfig = require('../backend/src/config/database');
    const { Sequelize } = require('sequelize');
    
    const sequelize = new Sequelize(dbConfig);
    
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
    const nodemailer = require('nodemailer');
    
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
    'pg', 'redis', 'sequelize', 'nodemailer', 'dotenv'
  ];
  
  const missing = [];
  
  for (const dep of requiredDeps) {
    try {
      require.resolve(dep);
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