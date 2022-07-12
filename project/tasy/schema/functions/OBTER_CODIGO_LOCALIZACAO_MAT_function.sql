-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_localizacao_mat ( cd_material_p bigint, cd_local_estoque_p bigint) RETURNS varchar AS $body$
DECLARE


nr_localizacao_w			varchar(25);


BEGIN

select	coalesce(max(to_char(nr_sequencia)),'X')
into STRICT	nr_localizacao_w
from	localizacao_estoque_local
where	cd_material		= cd_material_p
and	cd_local_estoque	= cd_local_estoque_p;

if (nr_localizacao_w = 'X') then
	begin
	select	CASE WHEN coalesce(nr_seq_estrut_mat::text, '') = '' THEN ds_localizacao  ELSE substr(obter_desc_estrut_loc_material(nr_seq_estrut_mat),1,80) END
	into STRICT	nr_localizacao_w
	from 	padrao_estoque_local b,
		material a
	where	a.cd_material_estoque 	= b.cd_material
	and	a.cd_material		= cd_material_p
	and	b.cd_local_estoque	= cd_local_estoque_p;
	exception
		when others then
			nr_localizacao_w	:= '';
	end;
	if (coalesce(nr_localizacao_w, 'X') = 'X') then
		nr_localizacao_w	:= Obter_Dados_Material(cd_material_p, 'L');
	end if;

end if;


return nr_localizacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_localizacao_mat ( cd_material_p bigint, cd_local_estoque_p bigint) FROM PUBLIC;

