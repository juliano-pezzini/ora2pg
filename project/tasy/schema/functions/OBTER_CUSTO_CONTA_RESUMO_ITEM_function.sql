-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_custo_conta_resumo_item (nr_interno_conta_p bigint, cd_item_p bigint, ie_proc_mat_p text, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


vl_custo_w	double precision;
qt_resumo_w	double precision;
ds_retorno_w	double precision;


BEGIN

if (ie_proc_mat_p = '1') then
	select	coalesce(sum(vl_custo),0),
		coalesce(sum(qt_resumo),1)
	into STRICT	vl_custo_w,
		qt_resumo_w
	from	conta_paciente_resumo
	where	nr_interno_conta	= nr_interno_conta_p
	and 	cd_procedimento		= cd_item_p;
elsif (ie_proc_mat_p = '2') then
	select	coalesce(sum(vl_custo),0),
		coalesce(sum(qt_resumo),1)
	into STRICT	vl_custo_w,
		qt_resumo_w
	from	conta_paciente_resumo
	where	nr_interno_conta	= nr_interno_conta_p
	and 	cd_material		= cd_item_p;
end if;

ds_retorno_w := vl_custo_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_custo_conta_resumo_item (nr_interno_conta_p bigint, cd_item_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;
