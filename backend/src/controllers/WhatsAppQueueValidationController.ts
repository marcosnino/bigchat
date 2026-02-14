import { Request, Response } from "express";
import WhatsAppQueueValidationService from "../services/ValidationServices/WhatsAppQueueValidationService";

/**
 * Valida as vinculações entre WhatsApps e filas
 */
export const validateConnections = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    
    const validation = await WhatsAppQueueValidationService.validateConnections(companyId);
    
    return res.status(200).json({
      success: true,
      data: validation
    });
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro interno na validação",
      error: error.message
    });
  }
};

/**
 * Gera relatório de WhatsApps e suas filas
 */
export const getWhatsAppQueuesReport = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    
    const report = await WhatsAppQueueValidationService.getWhatsAppQueuesReport(companyId);
    
    return res.status(200).json({
      success: true,
      data: report
    });
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro interno ao gerar relatório",
      error: error.message
    });
  }
};

/**
 * Gera relatório de filas e seus WhatsApps
 */
export const getQueuesWhatsAppReport = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    
    const report = await WhatsAppQueueValidationService.getQueuesWhatsAppReport(companyId);
    
    return res.status(200).json({
      success: true,
      data: report
    });
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro interno ao gerar relatório",
      error: error.message
    });
  }
};

/**
 * Corrige automaticamente vinculações básicas
 */
export const autoFixConnections = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    
    const result = await WhatsAppQueueValidationService.autoFixBasicConnections(companyId);
    
    return res.status(200).json({
      success: true,
      data: result,
      message: `${result.fixed} vinculações corrigidas automaticamente`
    });
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro interno na correção automática",
      error: error.message
    });
  }
};

/**
 * Remove vinculações órfãs
 */
export const cleanupOrphanConnections = async (req: Request, res: Response): Promise<Response> => {
  try {
    const { companyId } = req.user;
    
    const result = await WhatsAppQueueValidationService.cleanupOrphanConnections(companyId);
    
    return res.status(200).json({
      success: true,
      data: result,
      message: `${result.removed} vinculações órfãs removidas`
    });
    
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro interno na limpeza",
      error: error.message
    });
  }
};