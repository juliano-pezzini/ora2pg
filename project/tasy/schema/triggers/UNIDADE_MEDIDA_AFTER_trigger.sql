-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS unidade_medida_after ON unidade_medida CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_unidade_medida_after() RETURNS trigger AS $BODY$
declare
 
reg_integracao_p		gerar_int_padrao.reg_integracao;
BEGIN 
reg_integracao_p.cd_estab_documento	:= wheb_usuario_pck.get_cd_estabelecimento;
 
if (TG_OP = 'INSERT') then 
	reg_integracao_p.ie_operacao	:=	'I';
elsif (TG_OP = 'UPDATE') then 
	reg_integracao_p.ie_operacao	:=	'A';
end if;
 
reg_integracao_p := gerar_int_padrao.gravar_integracao('5', NEW.cd_unidade_medida, NEW.nm_usuario, reg_integracao_p);
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_unidade_medida_after() FROM PUBLIC;

CREATE TRIGGER unidade_medida_after
	AFTER INSERT OR UPDATE ON unidade_medida FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_unidade_medida_after();
