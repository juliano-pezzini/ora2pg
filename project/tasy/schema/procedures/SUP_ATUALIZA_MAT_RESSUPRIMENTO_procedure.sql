-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_atualiza_mat_ressuprimento ( qt_compra_p bigint, ds_observacao_p text, cd_material_p bigint, ie_dado_atualiza_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

if (ie_dado_atualiza_p = 'Q') then
	begin

	update	material_ressuprimento
	set	qt_compra_alterada = qt_compra_p
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_material = cd_material_p;

	end;
end if;

if (ie_dado_atualiza_p = 'O') then
	begin

	update	material_ressuprimento
	set	ds_observacao = ds_observacao_p
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_material = cd_material_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_atualiza_mat_ressuprimento ( qt_compra_p bigint, ds_observacao_p text, cd_material_p bigint, ie_dado_atualiza_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
