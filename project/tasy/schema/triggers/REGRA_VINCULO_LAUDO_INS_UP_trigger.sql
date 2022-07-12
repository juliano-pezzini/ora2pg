-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_vinculo_laudo_ins_up ON regra_vinculo_laudo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_vinculo_laudo_ins_up() RETURNS trigger AS $BODY$
BEGIN

if (NEW.cd_procedimento is null ) and (NEW.cd_especialidade is null) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(232322);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_vinculo_laudo_ins_up() FROM PUBLIC;

CREATE TRIGGER regra_vinculo_laudo_ins_up
	BEFORE INSERT OR UPDATE ON regra_vinculo_laudo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_vinculo_laudo_ins_up();
