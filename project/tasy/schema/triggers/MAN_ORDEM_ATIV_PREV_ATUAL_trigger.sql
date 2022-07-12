-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS man_ordem_ativ_prev_atual ON man_ordem_ativ_prev CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_man_ordem_ativ_prev_atual() RETURNS trigger AS $BODY$
declare
nm_user_w			varchar(50);

BEGIN

select	username
into STRICT	nm_user_w
from	user_users;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_man_ordem_ativ_prev_atual() FROM PUBLIC;

CREATE TRIGGER man_ordem_ativ_prev_atual
	AFTER INSERT OR UPDATE ON man_ordem_ativ_prev FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_man_ordem_ativ_prev_atual();

