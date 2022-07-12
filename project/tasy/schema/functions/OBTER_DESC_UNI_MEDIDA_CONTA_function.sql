-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_uni_medida_conta ( nr_interno_conta_p bigint, cd_material_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := '';


BEGIN

if (nr_interno_conta_p > 0 and
	(cd_material_p IS NOT NULL AND cd_material_p::text <> '')) then

	select 	max(Obter_Unidade_Medida(a.cd_unidade_medida))
	into STRICT	ds_retorno_w
	from	material_atend_paciente a
	where	a.nr_interno_conta 	= nr_interno_conta_p
	and	a.cd_material		= cd_material_p;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_uni_medida_conta ( nr_interno_conta_p bigint, cd_material_p text) FROM PUBLIC;

