-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_desc_criterio_ref ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_sequencia_criterio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulo_w					varchar(80)	:= '';


BEGIN

if (cd_sequencia_criterio_p IS NOT NULL AND cd_sequencia_criterio_p::text <> '') then

	select	coalesce(max(ds_titulo),'X')
	into STRICT	ds_titulo_w
	from	criterio_distr_orc
	where	cd_sequencia_criterio	= cd_sequencia_criterio_p;

	if (ds_titulo_w = 'X') then
		select	substr(obter_desc_centro_controle(cd_centro_controle, cd_estabelecimento_p),1,50)
		into STRICT	ds_titulo_w
		from	criterio_distr_orc
		where	cd_sequencia_criterio	= cd_sequencia_criterio_p;
	end if;

end if;

return ds_titulo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_desc_criterio_ref ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_sequencia_criterio_p bigint) FROM PUBLIC;

