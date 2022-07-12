-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_mat_padrao_estoque (cd_material_p text, cd_local_estoque_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_local_w	varchar(60);


BEGIN

ds_local_w := '';

select	max(b.DS_LOCAL)
into STRICT	ds_local_w
from	LOCALIZACAO_ESTOQUE_LOCAL a,
	MATERIAL_LOCAL b
where	a.NR_SEQ_LOCAL = b.nr_sequencia
and	a.cd_local_estoque = cd_local_estoque_p
and	a.cd_material	= cd_material_p
and	a.cd_estabelecimento = cd_estabelecimento_p;

return	ds_local_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_mat_padrao_estoque (cd_material_p text, cd_local_estoque_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
