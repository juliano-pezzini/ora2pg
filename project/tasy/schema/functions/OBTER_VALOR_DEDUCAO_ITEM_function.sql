-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_deducao_item ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint) RETURNS bigint AS $body$
DECLARE


vl_deducao_w	double precision;


BEGIN

if (coalesce(nr_seq_procedimento_p,0) > 0) then

	select	coalesce(sum(a.vl_rateio),0)
	into STRICT	vl_deducao_w
	from	conta_pac_ded_conv_item a
	where	((a.nr_seq_propaci_origem = nr_seq_procedimento_p) or (a.nr_seq_propaci_dest = nr_seq_procedimento_p));

elsif (coalesce(nr_seq_material_p,0) > 0) then

	select	coalesce(sum(a.vl_rateio),0)
	into STRICT	vl_deducao_w
	from	conta_pac_ded_conv_item a
	where	((a.nr_seq_matpaci_origem = nr_seq_material_p) or (a.nr_seq_matpaci_dest = nr_seq_material_p));

end if;

return vl_deducao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_deducao_item ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint) FROM PUBLIC;
