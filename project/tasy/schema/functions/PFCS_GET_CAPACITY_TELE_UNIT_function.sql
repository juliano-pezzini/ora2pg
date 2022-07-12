-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_capacity_tele_unit ( cd_establishment_p bigint, cd_department_p text) RETURNS bigint AS $body$
DECLARE

nr_unit_tl_capacity_w	setor_atendimento.nr_unit_tl_capacity%type;


BEGIN
	select	sum(coalesce(sa.nr_unit_tl_capacity,0))
	  into STRICT	nr_unit_tl_capacity_w
	   from	setor_atendimento sa
	  where	sa.cd_estabelecimento_base = cd_establishment_p
		and	sa.cd_classif_setor in ('1','3','4','9','11','12')
		and	sa.ie_situacao = 'A'
		and	((coalesce(cd_department_p::text, '') = '') or (sa.ds_setor_atendimento = cd_department_p));

	return nr_unit_tl_capacity_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_capacity_tele_unit ( cd_establishment_p bigint, cd_department_p text) FROM PUBLIC;

