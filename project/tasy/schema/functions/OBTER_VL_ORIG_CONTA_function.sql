-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_orig_conta ( nr_interno_conta_p bigint, cd_item_p bigint, ie_proc_mat_p text, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;


BEGIN

if (ie_proc_mat_p = '1') then
	select	coalesce(sum(vl_original),0)
	into STRICT	vl_retorno_w
	from	conta_paciente_resumo
	where	nr_interno_conta	= nr_interno_conta_p
	and 	cd_procedimento		= cd_item_p;
elsif (ie_proc_mat_p = '2') then
	select	coalesce(sum(vl_original),0)
	into STRICT	vl_retorno_w
	from	conta_paciente_resumo
	where	nr_interno_conta	= nr_interno_conta_p
	and 	cd_material		= cd_item_p;
end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_orig_conta ( nr_interno_conta_p bigint, cd_item_p bigint, ie_proc_mat_p text, nm_usuario_p text) FROM PUBLIC;

