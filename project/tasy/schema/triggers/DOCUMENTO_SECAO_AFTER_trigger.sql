-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS documento_secao_after ON documento_secao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_documento_secao_after() RETURNS trigger AS $BODY$
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (obtain_user_locale(wheb_usuario_pck.get_nm_usuario) = 'ja_JP') then
		if (coalesce(NEW.nr_seq_linked_data, 0) <> coalesce(OLD.nr_seq_linked_data, 0)) then
			delete from documento_subsecao where nr_seq_documento_secao = NEW.nr_sequencia;
		end if;
	end if;	
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_documento_secao_after() FROM PUBLIC;

CREATE TRIGGER documento_secao_after
	AFTER UPDATE ON documento_secao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_documento_secao_after();

