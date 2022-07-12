-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cot_compra_beforeupdate ON cot_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cot_compra_beforeupdate() RETURNS trigger AS $BODY$
declare
 
reg_integracao_p			gerar_int_padrao.reg_integracao;
 
BEGIN 
 
if (TG_OP = 'UPDATE') then 
   	if (OLD.nr_documento_externo is not null) then 
		NEW.nr_documento_externo	:= OLD.nr_documento_externo;
	end if;
end if;
 
if (OLD.dt_envio_integr_padrao is null) and (NEW.dt_envio_integr_padrao is not null) then 
		 
	reg_integracao_p.ie_operacao		:=	'I';
	reg_integracao_p.cd_estab_documento	:=	NEW.cd_estabelecimento;
	reg_integracao_p.ie_finalidade_cotacao	:=	NEW.ie_finalidade_cotacao;
	reg_integracao_p := gerar_int_padrao.gravar_integracao('57', NEW.nr_cot_compra, NEW.nm_usuario, reg_integracao_p);
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cot_compra_beforeupdate() FROM PUBLIC;

CREATE TRIGGER cot_compra_beforeupdate
	BEFORE UPDATE ON cot_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cot_compra_beforeupdate();

