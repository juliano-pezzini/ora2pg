-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS service_pack_hotfix_after_ins ON service_pack_hotfix CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_service_pack_hotfix_after_ins() RETURNS trigger AS $BODY$
declare

BEGIN

  CALL insert_service_order_sp_hotfix(NEW.nr_service_order, NEW.nr_sequencia, NEW.nm_usuario, 'N');

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_service_pack_hotfix_after_ins() FROM PUBLIC;

CREATE TRIGGER service_pack_hotfix_after_ins
	AFTER INSERT ON service_pack_hotfix FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_service_pack_hotfix_after_ins();

