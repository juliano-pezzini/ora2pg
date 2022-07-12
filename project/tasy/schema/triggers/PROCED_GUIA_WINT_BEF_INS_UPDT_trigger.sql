-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proced_guia_wint_bef_ins_updt ON procedimento_guia_wint CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proced_guia_wint_bef_ins_updt() RETURNS trigger AS $BODY$
declare

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
	if (NEW.CD_PROCEDIMENTO_TUSS is null) then
		NEW.ds_erro := obter_desc_expressao(1067558);
		NEW.ds_status := 'ERRO';
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proced_guia_wint_bef_ins_updt() FROM PUBLIC;

CREATE TRIGGER proced_guia_wint_bef_ins_updt
	BEFORE INSERT OR UPDATE ON procedimento_guia_wint FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proced_guia_wint_bef_ins_updt();

