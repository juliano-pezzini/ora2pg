-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_liberacao_atual ON pls_regra_liberacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_liberacao_atual() RETURNS trigger AS $BODY$
declare

cd_material_w	integer;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then
	if (NEW.nr_seq_material is not null) then
		select	cd_material
		into STRICT	cd_material_w
		from	pls_material a
		where	a.nr_sequencia	= NEW.nr_seq_material;

		NEW.cd_material	:= cd_material_w;
	end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_liberacao_atual() FROM PUBLIC;

CREATE TRIGGER pls_regra_liberacao_atual
	BEFORE INSERT OR UPDATE ON pls_regra_liberacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_liberacao_atual();

