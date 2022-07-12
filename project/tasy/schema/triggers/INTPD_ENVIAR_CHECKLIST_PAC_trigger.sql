-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_enviar_checklist_pac ON atend_pac_checklist CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_enviar_checklist_pac() RETURNS trigger AS $BODY$
declare

reg_integracao_w	gerar_int_padrao.reg_integracao;
ie_operacao			varchar(1);

BEGIN

if (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then

	reg_integracao_w.cd_estab_documento := wheb_usuario_pck.get_cd_estabelecimento;
	reg_integracao_w.ie_operacao		:=	'I';
	reg_integracao_w := gerar_int_padrao.gravar_integracao('178', NEW.nr_sequencia, NEW.nm_usuario, reg_integracao_w);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_enviar_checklist_pac() FROM PUBLIC;

CREATE TRIGGER intpd_enviar_checklist_pac
	BEFORE UPDATE ON atend_pac_checklist FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_enviar_checklist_pac();

