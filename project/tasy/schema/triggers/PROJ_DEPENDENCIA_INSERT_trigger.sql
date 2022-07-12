-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_dependencia_insert ON proj_dependencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_dependencia_insert() RETURNS trigger AS $BODY$
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then 
	BEGIN 
	if (NEW.nr_seq_ordem_serv is not null) then 
		BEGIN 
		CALL gerar_nec_vinc_dep_proj(NEW.nr_seq_projeto, NEW.nr_sequencia, NEW.nr_seq_ordem_serv, wheb_usuario_pck.get_nm_usuario);
		end;
	end if;
	end;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_dependencia_insert() FROM PUBLIC;

CREATE TRIGGER proj_dependencia_insert
	AFTER INSERT ON proj_dependencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_dependencia_insert();
