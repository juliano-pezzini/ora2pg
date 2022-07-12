-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS padrao_estoque_local_delete ON padrao_estoque_local CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_padrao_estoque_local_delete() RETURNS trigger AS $BODY$
BEGIN
CALL gerar_int_dankia_pck.dankia_disp_material(OLD.cd_material,OLD.cd_local_estoque,'E',OLD.nm_usuario);
CALL gerar_int_dankia_pck.dankia_disp_padrao_local(OLD.cd_material,OLD.cd_local_estoque,OLD.qt_estoque_minimo,OLD.qt_estoque_maximo,'E',OLD.nr_seq_estrut_mat,OLD.nm_usuario);
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_padrao_estoque_local_delete() FROM PUBLIC;

CREATE TRIGGER padrao_estoque_local_delete
	BEFORE DELETE ON padrao_estoque_local FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_padrao_estoque_local_delete();

