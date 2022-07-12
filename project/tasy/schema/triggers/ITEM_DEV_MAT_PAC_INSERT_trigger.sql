-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS item_dev_mat_pac_insert ON item_devolucao_material_pac CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_item_dev_mat_pac_insert() RETURNS trigger AS $BODY$
BEGIN

NEW.ie_tipo_baixa_estoque := '0';

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_item_dev_mat_pac_insert() FROM PUBLIC;

CREATE TRIGGER item_dev_mat_pac_insert
	BEFORE INSERT ON item_devolucao_material_pac FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_item_dev_mat_pac_insert();

