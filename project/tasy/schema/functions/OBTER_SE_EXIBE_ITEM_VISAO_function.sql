-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_item_visao ( nr_seq_item_p bigint, nr_seq_item_visao_p bigint) RETURNS varchar AS $body$
DECLARE




cd_perfil_w	integer;
ds_retorno_w	varchar(1) := 'S';
ie_possui_w	varchar(1) := 'S';


BEGIN

cd_perfil_w	:= wheb_usuario_pck.get_cd_perfil;

select	coalesce(max('S'),'N')
into STRICT	ie_possui_w
from	perfil_item_oftalmologia a,
	perfil_item_oft_visual b
where	a.nr_sequencia	= b.nr_seq_item_perfil
and	a.nr_seq_item	= nr_seq_item_p
and	a.cd_perfil	= cd_perfil_w;

if (ie_possui_w = 'S') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_possui_w
	from	perfil_item_oftalmologia a,
		perfil_item_oft_visual b
	where	a.nr_sequencia	= b.nr_seq_item_perfil
	and	a.nr_seq_item	= nr_seq_item_p
	and	b.nr_seq_item	= nr_seq_item_visao_p
	and	a.cd_perfil	= cd_perfil_w;
	if (ie_possui_w = 'S') then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
else
	ds_retorno_w := 'S';
end if;

return 	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_item_visao ( nr_seq_item_p bigint, nr_seq_item_visao_p bigint) FROM PUBLIC;

