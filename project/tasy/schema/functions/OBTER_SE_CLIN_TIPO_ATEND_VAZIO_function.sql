-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_clin_tipo_atend_vazio (cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_regra_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	clinica_tipo_atendimento
where	ie_tipo_atendimento		= ie_tipo_atendimento_p
and 	cd_estabelecimento		= cd_estabelecimento_p
and	coalesce(ie_situacao,'A') = 'A'
and	(ie_clinica IS NOT NULL AND ie_clinica::text <> '');

if (qt_regra_w > 0) then
	return 'N';
else
	return 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_clin_tipo_atend_vazio (cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) FROM PUBLIC;

