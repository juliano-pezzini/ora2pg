-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pharmindex_processo_after ON pharmindex_processo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pharmindex_processo_after() RETURNS trigger AS $BODY$
declare

reg_integracao_p		gerar_int_padrao.reg_integracao;
ie_integrar_w		varchar(1);
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	BEGIN
	if (TG_OP = 'UPDATE') and (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_integrar_w	:=	'S';
	elsif (TG_OP = 'INSERT') and (NEW.dt_liberacao is not null) then
		ie_integrar_w	:=	'S';
	end if;
	
	if (ie_integrar_w = 'S') then
		BEGIN
		reg_integracao_p.ie_operacao		:=	'I';
	
		if (NEW.ie_atc = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('411', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_empresa = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('412', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_pag_doenca = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('413', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_doenca = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('414', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_medic = 'S') then
			if (NEW.cd_material_externo is null) then
				reg_integracao_p := gerar_int_padrao.gravar_integracao('415', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);				
			else
				reg_integracao_p := gerar_int_padrao.gravar_integracao('416', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
			end if;
		end if;
		
		if (NEW.ie_form_medic = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('417', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;		
		
		if (NEW.ie_prescr = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('418', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_status = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('419', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;
		
		if (NEW.ie_substancia = 'S') then
			reg_integracao_p := gerar_int_padrao.gravar_integracao('420', NEW.nr_sequencia, coalesce(obter_usuario_ativo, coalesce(NEW.nm_usuario, OLD.nm_usuario)), reg_integracao_p);
		end if;		
		end;
	end if;	
	end;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pharmindex_processo_after() FROM PUBLIC;

CREATE TRIGGER pharmindex_processo_after
	AFTER INSERT OR UPDATE ON pharmindex_processo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pharmindex_processo_after();

