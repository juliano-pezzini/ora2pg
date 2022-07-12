-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_legenda_classif_insert ON regra_legenda_classif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_legenda_classif_insert() RETURNS trigger AS $BODY$
BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
		if (NEW.ds_cor is null and NEW.ds_cor_html is not null) then
			NEW.ds_cor := NEW.ds_cor_html;
		end if;
	end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_legenda_classif_insert() FROM PUBLIC;

CREATE TRIGGER regra_legenda_classif_insert
	BEFORE INSERT ON regra_legenda_classif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_legenda_classif_insert();

