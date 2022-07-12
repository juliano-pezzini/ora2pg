-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_se_gng_taxa ( cd_estabelecimento_p bigint, nr_seq_gng_p bigint, cd_centro_controle_p bigint) RETURNS varchar AS $body$
DECLARE


ie_compoe_taxa_custo_w		varchar(1)	:= 'S';
qt_regra_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	cus_regra_grupo_taxa
where	nr_seq_gng	= nr_seq_gng_p;

if (qt_regra_w = 0) then

	select	coalesce(max(ie_compoe_taxa_custo),'S')
	into STRICT	ie_compoe_taxa_custo_w
	from	grupo_natureza_gasto
	where	nr_sequencia	= nr_seq_gng_p;
else
	ie_compoe_taxa_custo_w			:= 'N';

	select	count(*)
	into STRICT	qt_regra_w
	from	cus_regra_grupo_taxa a
	where	cd_estabelecimento		= cd_estabelecimento_p
	and	cd_centro_controle		= cd_centro_controle_p
	and	nr_seq_gng		= nr_seq_gng_p
	and	ie_compoe_taxa_custo	= 'S';

	if (qt_regra_w > 0) then
		ie_compoe_taxa_custo_w	:= 'S';
	end if;
end if;

return	ie_compoe_taxa_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_se_gng_taxa ( cd_estabelecimento_p bigint, nr_seq_gng_p bigint, cd_centro_controle_p bigint) FROM PUBLIC;

