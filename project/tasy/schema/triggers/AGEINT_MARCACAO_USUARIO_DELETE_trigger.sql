-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ageint_marcacao_usuario_delete ON ageint_marcacao_usuario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ageint_marcacao_usuario_delete() RETURNS trigger AS $BODY$
declare

pragma autonomous_transaction;

BEGIN

if (OLD.nr_seq_combo is not null) then
	update	ageint_marcacao_usuario
	set	nr_seq_combo	 = NULL
	where	nm_usuario	= OLD.nm_usuario
	and	nr_seq_ageint	= OLD.nr_seq_ageint
	and	nr_seq_combo	= OLD.nr_seq_combo
	and	nr_sequencia	!= OLD.nr_sequencia;
	commit;
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ageint_marcacao_usuario_delete() FROM PUBLIC;

CREATE TRIGGER ageint_marcacao_usuario_delete
	AFTER DELETE ON ageint_marcacao_usuario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ageint_marcacao_usuario_delete();

