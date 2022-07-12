-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS saldo_estoque_log ON saldo_estoque CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_saldo_estoque_log() RETURNS trigger AS $BODY$
BEGIN

if (TG_OP = 'INSERT') then
	BEGIN
	insert into saldo_estoque_log(
		CD_ESTABELECIMENTO,
		CD_LOCAL_ESTOQUE,         
		CD_MATERIAL,              
		DT_MESANO_REFERENCIA,     
		QT_ESTOQUE,               
		VL_ESTOQUE,               
		QT_RESERVADA_REQUISICAO,  
		QT_RESERVADA,             
		DT_ATUALIZACAO,           
		NM_USUARIO,               
		VL_CUSTO_MEDIO,           
		VL_PRECO_ULT_COMPRA,      
		DT_ULT_COMPRA,            
		IE_STATUS_VALORIZACAO,    
		IE_BLOQUEIO_INVENTARIO,   
		QT_CONSUMO,               
		QT_ESTOQUE_MEDIO,         
		IE_ACAO,              
		DS_STACK,                 
		QT_OCOR_INVENT,           
		QT_OCOR_INVENT_OK,        
		QT_INVENTARIO) 
	values (
		NEW.CD_ESTABELECIMENTO,       
		NEW.CD_LOCAL_ESTOQUE,         
		NEW.CD_MATERIAL,              
		NEW.DT_MESANO_REFERENCIA,     
		NEW.QT_ESTOQUE,               
		NEW.VL_ESTOQUE,               
		NEW.QT_RESERVADA_REQUISICAO,  
		NEW.QT_RESERVADA,             
		NEW.DT_ATUALIZACAO,          
		NEW.NM_USUARIO,               
		NEW.VL_CUSTO_MEDIO,           
		NEW.VL_PRECO_ULT_COMPRA,      
		NEW.DT_ULT_COMPRA,            
		NEW.IE_STATUS_VALORIZACAO,    
		NEW.IE_BLOQUEIO_INVENTARIO,   
		NEW.QT_CONSUMO,               
		NEW.QT_ESTOQUE_MEDIO,         
		'I',              
		 substr(dbms_utility.format_call_stack,1,4000),                
		NEW.QT_OCOR_INVENT,           
		NEW.QT_OCOR_INVENT_OK,        
		NEW.QT_INVENTARIO);
	
	end;
elsif (TG_OP = 'UPDATE') then
	BEGIN
	
	insert into saldo_estoque_log(
		CD_ESTABELECIMENTO,
		CD_LOCAL_ESTOQUE,         
		CD_MATERIAL,              
		DT_MESANO_REFERENCIA,     
		QT_ESTOQUE,               
		VL_ESTOQUE,               
		QT_RESERVADA_REQUISICAO,  
		QT_RESERVADA,             
		DT_ATUALIZACAO,           
		NM_USUARIO,               
		VL_CUSTO_MEDIO,           
		VL_PRECO_ULT_COMPRA,      
		DT_ULT_COMPRA,            
		IE_STATUS_VALORIZACAO,    
		IE_BLOQUEIO_INVENTARIO,   
		QT_CONSUMO,               
		QT_ESTOQUE_MEDIO,         
		IE_ACAO,              
		DS_STACK,                 
		QT_OCOR_INVENT,           
		QT_OCOR_INVENT_OK,        
		QT_INVENTARIO)
	values (
		OLD.CD_ESTABELECIMENTO,       
		OLD.CD_LOCAL_ESTOQUE,         
		OLD.CD_MATERIAL,              
		OLD.DT_MESANO_REFERENCIA,     
		OLD.QT_ESTOQUE,               
		OLD.VL_ESTOQUE,               
		OLD.QT_RESERVADA_REQUISICAO,  
		OLD.QT_RESERVADA,             
		LOCALTIMESTAMP,     
		OLD.NM_USUARIO,               
		OLD.VL_CUSTO_MEDIO,           
		OLD.VL_PRECO_ULT_COMPRA,      
		OLD.DT_ULT_COMPRA,            
		OLD.IE_STATUS_VALORIZACAO,    
		OLD.IE_BLOQUEIO_INVENTARIO,   
		OLD.QT_CONSUMO,               
		OLD.QT_ESTOQUE_MEDIO,         
		'U',              
		 substr(dbms_utility.format_call_stack,1,4000),                
		OLD.QT_OCOR_INVENT,           
		OLD.QT_OCOR_INVENT_OK,        
		OLD.QT_INVENTARIO);
	
	end;
else
	BEGIN
	
	insert into saldo_estoque_log(
		CD_ESTABELECIMENTO,
		CD_LOCAL_ESTOQUE,         
		CD_MATERIAL,              
		DT_MESANO_REFERENCIA,     
		QT_ESTOQUE,               
		VL_ESTOQUE,               
		QT_RESERVADA_REQUISICAO,  
		QT_RESERVADA,             
		DT_ATUALIZACAO,           
		NM_USUARIO,               
		VL_CUSTO_MEDIO,           
		VL_PRECO_ULT_COMPRA,      
		DT_ULT_COMPRA,            
		IE_STATUS_VALORIZACAO,    
		IE_BLOQUEIO_INVENTARIO,   
		QT_CONSUMO,               
		QT_ESTOQUE_MEDIO,         
		IE_ACAO,              
		DS_STACK,                 
		QT_OCOR_INVENT,           
		QT_OCOR_INVENT_OK,        
		QT_INVENTARIO)
	values (
		OLD.CD_ESTABELECIMENTO,       
		OLD.CD_LOCAL_ESTOQUE,         
		OLD.CD_MATERIAL,              
		OLD.DT_MESANO_REFERENCIA,     
		OLD.QT_ESTOQUE,               
		OLD.VL_ESTOQUE,               
		OLD.QT_RESERVADA_REQUISICAO,  
		OLD.QT_RESERVADA,             
		OLD.DT_ATUALIZACAO,          
		OLD.NM_USUARIO,               
		OLD.VL_CUSTO_MEDIO,           
		OLD.VL_PRECO_ULT_COMPRA,      
		OLD.DT_ULT_COMPRA,            
		OLD.IE_STATUS_VALORIZACAO,    
		OLD.IE_BLOQUEIO_INVENTARIO,   
		OLD.QT_CONSUMO,               
		OLD.QT_ESTOQUE_MEDIO,         
		'D',              
		 substr(dbms_utility.format_call_stack,1,4000),                
		OLD.QT_OCOR_INVENT,           
		OLD.QT_OCOR_INVENT_OK,        
		OLD.QT_INVENTARIO);
	
	end;
end if;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_saldo_estoque_log() FROM PUBLIC;

CREATE TRIGGER saldo_estoque_log
	BEFORE INSERT OR UPDATE OR DELETE ON saldo_estoque FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_saldo_estoque_log();

