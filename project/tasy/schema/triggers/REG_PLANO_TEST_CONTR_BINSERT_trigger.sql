-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_plano_test_contr_binsert ON reg_plano_teste_controle CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_plano_test_contr_binsert() RETURNS trigger AS $BODY$
declare

BEGIN
	
	if (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') then
	
		NEW.ie_considera_rtm := coalesce(NEW.ie_considera_rtm,'S');
	end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_plano_test_contr_binsert() FROM PUBLIC;

CREATE TRIGGER reg_plano_test_contr_binsert
	BEFORE INSERT ON reg_plano_teste_controle FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_plano_test_contr_binsert();

