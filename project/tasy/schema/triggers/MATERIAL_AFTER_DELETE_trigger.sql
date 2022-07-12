-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_after_delete ON material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_after_delete() RETURNS trigger AS $BODY$
declare
ds_retorno_integracao_w 	text;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	if (wheb_usuario_pck.get_nm_usuario is not null) then

		ds_retorno_integracao_w := bifrost.send_integration(nm_event => 'material.deleted',
		                                                    nm_javaclass => 'com.philips.tasy.integration.material.outbound.MaterialCallback',
		                                                    ds_arguments => to_char(OLD.cd_material),
		                                                    nm_user => wheb_usuario_pck.get_nm_usuario);

	end if;

end if;
	
RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_material_after_delete() FROM PUBLIC;

CREATE TRIGGER material_after_delete
	AFTER DELETE ON material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_after_delete();

