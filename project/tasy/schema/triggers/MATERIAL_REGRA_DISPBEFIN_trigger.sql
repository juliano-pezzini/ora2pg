-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_regra_dispbefin ON material_regra_disp CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_regra_dispbefin() RETURNS trigger AS $BODY$
declare

ie_situacao_w	varchar(5);

BEGIN

if (NEW.cd_material is not null) then
	select	max(ie_situacao)
	into STRICT	ie_situacao_w
	from	material
	where	cd_material	= NEW.cd_material;

	if (ie_situacao_w = 'I') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(191617);
	end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_material_regra_dispbefin() FROM PUBLIC;

CREATE TRIGGER material_regra_dispbefin
	BEFORE INSERT ON material_regra_disp FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_regra_dispbefin();

