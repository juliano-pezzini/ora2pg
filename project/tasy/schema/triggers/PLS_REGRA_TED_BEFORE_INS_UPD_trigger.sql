-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_ted_before_ins_upd ON pls_regra_ted CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_ted_before_ins_upd() RETURNS trigger AS $BODY$
declare

BEGIN
if (NEW.ie_forma_geracao = 'I' and NEW.cd_interface is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1068830);
elsif (NEW.ie_forma_geracao = 'P' and NEW.nm_objeto is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1068831);
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_ted_before_ins_upd() FROM PUBLIC;

CREATE TRIGGER pls_regra_ted_before_ins_upd
	BEFORE INSERT OR UPDATE ON pls_regra_ted FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_ted_before_ins_upd();

