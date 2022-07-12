-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_w_consulta_saldo_est_ins ON intpd_w_consulta_saldo_est CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_w_consulta_saldo_est_ins() RETURNS trigger AS $BODY$
declare
 
reg_integracao_p		gerar_int_padrao.reg_integracao;
 
BEGIN 
 
 
/*Integração padrão - Evento 98 - Enviar saldo estoque conforme consulta*/
 
reg_integracao_p.ie_operacao		:=	'I';
reg_integracao_p.ds_id_origin			:=	NEW.ds_id_origin;
reg_integracao_p := gerar_int_padrao.gravar_integracao('98', NEW.nr_sequencia, NEW.nm_usuario, reg_integracao_p);
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_w_consulta_saldo_est_ins() FROM PUBLIC;

CREATE TRIGGER intpd_w_consulta_saldo_est_ins
	AFTER INSERT ON intpd_w_consulta_saldo_est FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_w_consulta_saldo_est_ins();
