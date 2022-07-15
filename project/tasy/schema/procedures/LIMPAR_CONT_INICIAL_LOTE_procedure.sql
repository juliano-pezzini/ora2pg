-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_cont_inicial_lote ( cd_estabelecimento_p bigint, cd_material_p bigint) AS $body$
BEGIN
delete	FROM w_contagem_inicial_lote a
where	a.cd_material = cd_material_p
and	exists (	SELECT	1
		from	local_estoque x
		where	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_estabelecimento = cd_estabelecimento_p);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_cont_inicial_lote ( cd_estabelecimento_p bigint, cd_material_p bigint) FROM PUBLIC;

