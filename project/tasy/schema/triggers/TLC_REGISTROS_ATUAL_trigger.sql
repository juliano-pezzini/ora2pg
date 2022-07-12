-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tlc_registros_atual ON pep_tlc_registros CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tlc_registros_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w bigint;

pragma autonomous_transaction;

BEGIN
if (upper(dbms_utility.format_call_stack) not like '%TLC_AGENDA_PEP%') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1005833);
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tlc_registros_atual() FROM PUBLIC;

CREATE TRIGGER tlc_registros_atual
	BEFORE DELETE ON pep_tlc_registros FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tlc_registros_atual();
