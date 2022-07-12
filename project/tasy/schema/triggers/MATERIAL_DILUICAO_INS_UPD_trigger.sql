-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_diluicao_ins_upd ON material_diluicao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_diluicao_ins_upd() RETURNS trigger AS $BODY$
declare
qt_reg_w	bigint;
ds_stack_w	varchar(2000);
BEGIN
null;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_material_diluicao_ins_upd() FROM PUBLIC;

CREATE TRIGGER material_diluicao_ins_upd
	BEFORE INSERT OR UPDATE ON material_diluicao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_diluicao_ins_upd();
