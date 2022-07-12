-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ LIMPEZA DE VARIAVEIS ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<-

	--LI>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Limpar variaveis <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	



CREATE OR REPLACE PROCEDURE projeto_recurso_pck.limpa_variaveis (ie_transacao_limpar text default 'ALL') AS $body$
BEGIN
	
	if (('ALL' = upper(ie_transacao_limpar)) or ('SC' = upper(ie_transacao_limpar))) then
		current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.qt_transacao := 0;
		current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.vl_transacao := 0;
	end if;
	
	if (('ALL' = upper(ie_transacao_limpar)) or ('OC' = upper(ie_transacao_limpar))) then
		current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.qt_transacao := 0;
		current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.vl_transacao := 0;
	end if;
	
	if (('ALL' = upper(ie_transacao_limpar)) or ('NF' = upper(ie_transacao_limpar))) then
		current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.qt_transacao := 0;
		current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.vl_transacao := 0;
	end if;
	
	if (('ALL' = upper(ie_transacao_limpar)) or ('TE' = upper(ie_transacao_limpar))) then
		current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.qt_transacao := 0;
		current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.vl_transacao := 0;
	end if;
	
	if (('ALL' = upper(ie_transacao_limpar)) or ('CB' = upper(ie_transacao_limpar))) then
		current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.qt_transacao := 0;
		current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.vl_transacao := 0;
	end if;
	
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE projeto_recurso_pck.limpa_variaveis (ie_transacao_limpar text default 'ALL') FROM PUBLIC;
