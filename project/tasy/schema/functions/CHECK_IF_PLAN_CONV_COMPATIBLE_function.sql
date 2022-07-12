-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_if_plan_conv_compatible (cd_plano_p regra_convenio_plano_mat.cd_plano%type, cd_convenio_p regra_convenio_plano_mat.cd_convenio%type) RETURNS REGRA_CONVENIO_PLANO_MAT.CD_PLANO%TYPE AS $body$
DECLARE


ie_exists_plan_w convenio_plano.ie_situacao%type := 'N';
value_cd_plan_or_null regra_convenio_plano_mat.cd_plano%type;
														

BEGIN

begin
select	'S'
into STRICT	ie_exists_plan_w
from 	convenio_plano a
where 	a.cd_convenio = cd_convenio_p
and		a.cd_plano = cd_plano_p
and		coalesce(a.ie_situacao,'A') = 'A';
exception
	when no_data_found then
		ie_exists_plan_w := 'N';
	when too_many_rows then
		ie_exists_plan_w := 'N';
end;

if (ie_exists_plan_w = 'S')then
	value_cd_plan_or_null := cd_plano_p;
end if;

return value_cd_plan_or_null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_if_plan_conv_compatible (cd_plano_p regra_convenio_plano_mat.cd_plano%type, cd_convenio_p regra_convenio_plano_mat.cd_convenio%type) FROM PUBLIC;

