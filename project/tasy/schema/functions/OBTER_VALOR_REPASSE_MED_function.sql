-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_repasse_med (nr_repasse_terceiro_p bigint, ie_opcao_p text, cd_medico_p text) RETURNS bigint AS $body$
DECLARE


/*
P	- Proceidmento;
M	- Material;
PM	- Procedimento + Material;
PML	- Valores de Repasse Liberados Procedimento + Material;
RI	- Repasse Terceiro Item;
*/
vl_repasse_proc_w	double precision;
vl_liberado_proc_w	double precision;
vl_repasse_mat_w	double precision;
vl_liberado_mat_w	double precision;
vl_repasse_w		double precision;
vl_repasse_item_w	double precision;


BEGIN

if (ie_opcao_p	= 'P') then

	select	coalesce(sum(a.vl_repasse),0)
	into STRICT	vl_repasse_proc_w
	from	procedimento_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	vl_repasse_w	:= coalesce(vl_repasse_proc_w,0);

elsif (ie_opcao_p	= 'M') then

	select	coalesce(sum(a.vl_repasse),0)
	into STRICT	vl_repasse_mat_w
	from	material_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	vl_repasse_w	:= coalesce(vl_repasse_mat_w,0);

elsif (ie_opcao_p	= 'PM') then
	select	coalesce(sum(a.vl_repasse),0)
	into STRICT	vl_repasse_proc_w
	from	procedimento_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	select	coalesce(sum(a.vl_repasse),0)
	into STRICT	vl_repasse_mat_w
	from	material_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	vl_repasse_w	:= coalesce(vl_repasse_proc_w,0) + coalesce(vl_repasse_mat_w,0);

elsif (ie_opcao_p	= 'PML') then
	select	coalesce(sum(a.vl_liberado),0)
	into STRICT	vl_liberado_proc_w
	from	procedimento_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	select	coalesce(sum(a.vl_liberado),0)
	into STRICT	vl_liberado_mat_w
	from	material_repasse a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	vl_repasse_w	:= coalesce(vl_liberado_proc_w,0) + coalesce(vl_liberado_mat_w,0);
elsif (ie_opcao_p	= 'RI') then
	select	coalesce(sum(a.vl_repasse),0)
	into STRICT	vl_repasse_item_w
	from	repasse_terceiro_item a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_p
	and	a.cd_medico		= cd_medico_p;

	vl_repasse_w	:= coalesce(vl_repasse_item_w,0);
end if;

return	vl_repasse_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_repasse_med (nr_repasse_terceiro_p bigint, ie_opcao_p text, cd_medico_p text) FROM PUBLIC;

