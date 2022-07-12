-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_tipo_gasto_centro ( cd_estabelecimento_p bigint, cd_centro_controle_p bigint, nr_seq_gng_p bigint, cd_natureza_gasto_p bigint, nr_seq_ng_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_gasto_w			varchar(2);
nr_seq_gng_w			bigint;
nr_seq_ng_w			bigint;


BEGIN
nr_seq_ng_w	:= coalesce(nr_seq_ng_p,0);

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_centro_controle_p IS NOT NULL AND cd_centro_controle_p::text <> '') then
	begin

	if (nr_seq_ng_w <> 0) then
		select	nr_seq_gng
		into STRICT	nr_seq_gng_w
		from	natureza_gasto
		where	nr_sequencia	= nr_seq_ng_w;

	elsif (cd_natureza_gasto_p IS NOT NULL AND cd_natureza_gasto_p::text <> '') then
		begin

		select	max(nr_seq_gng)
		into STRICT	nr_seq_gng_w
		from	natureza_gasto
		where	coalesce(cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
		and	cd_natureza_gasto				= cd_natureza_gasto_p;
		end;
	end if;
	nr_seq_gng_w := coalesce(nr_seq_gng_w,0);

	select	ie_tipo_gasto
	into STRICT	ie_tipo_gasto_w
	from (SELECT	coalesce(ie_tipo_gasto,'X') ie_tipo_gasto,
			coalesce(cd_natureza_gasto, 0) cd_natureza_gasto,
			coalesce(cd_grupo_natureza_gasto, 0) cd_grupo_natureza_gasto,
			1 ie_ordem
		from	centro_controle_tipo_gasto
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_centro_controle		= cd_centro_controle_p
		and	coalesce(nr_seq_ng,nr_seq_ng_w)	= nr_seq_ng_w
		and	coalesce(nr_seq_gng, nr_seq_gng_w)	= nr_seq_gng_w
		
union all

		SELECT	'X' ie_tipo_gasto,
			0 cd_natureza_gasto,
			0 cd_grupo_natureza_gasto,
			0 ie_ordem
		
		order by
			cd_natureza_gasto desc,
			cd_grupo_natureza_gasto desc,
			ie_ordem desc) x LIMIT 1;
	
	if (coalesce(ie_tipo_gasto_w,'X') = 'X') and (nr_seq_gng_w <> 0)then
		begin
		select	a.ie_tipo_gasto
		into STRICT	ie_tipo_gasto_w
		from	grupo_natureza_gasto a
		where	a.nr_sequencia = nr_seq_gng_w;
		end;
	end if;
	end;
end if;

return substr(ie_tipo_gasto_w,1,2);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_tipo_gasto_centro ( cd_estabelecimento_p bigint, cd_centro_controle_p bigint, nr_seq_gng_p bigint, cd_natureza_gasto_p bigint, nr_seq_ng_p bigint) FROM PUBLIC;
