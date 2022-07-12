-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_material_fornec_atual_tot ON pls_material_fornec CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_material_fornec_atual_tot() RETURNS trigger AS $BODY$
BEGIN

null;

IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_material_fornec_atual_tot() FROM PUBLIC;

CREATE TRIGGER pls_material_fornec_atual_tot
	BEFORE INSERT OR UPDATE OR DELETE ON pls_material_fornec FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_material_fornec_atual_tot();

