-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_escala_dor ( cd_pessoa_fisica_p text, cd_escala_dor_p text) RETURNS varchar AS $body$
DECLARE


qt_idade_ano_w		double precision;
qt_idade_mes_w		double precision;
qt_idade_dia_w		double precision;
ie_sexo_w		varchar(5);
ie_retorno_w		varchar(5);


BEGIN

select	max(obter_idade(dt_nascimento,clock_timestamp(),'A')),
	max(obter_idade(dt_nascimento,clock_timestamp(),'M')),
	max(obter_idade(dt_nascimento,clock_timestamp(),'DIA')),
	coalesce(max(ie_sexo),'A')
into STRICT	qt_idade_ano_w,
	qt_idade_mes_w,
	qt_idade_dia_w,
	ie_sexo_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

select	coalesce(max('S'),'N')
into STRICT	ie_retorno_w
from	escala_dor
where	cd_escala_dor	= cd_escala_dor_p
and	coalesce(ie_sexo,ie_sexo_w)	= ie_sexo_w
and (coalesce(qt_idade_min::text, '') = '' or qt_idade_min <= qt_idade_ano_w)
and (coalesce(qt_idade_max::text, '') = '' or qt_idade_max >= qt_idade_ano_w)
and (coalesce(qt_idade_min_mes::text, '') = '' or qt_idade_min_mes <= qt_idade_mes_w)
and (coalesce(qt_idade_max_mes::text, '') = '' or qt_idade_max_mes >= qt_idade_mes_w)
and (coalesce(qt_idade_min_dia::text, '') = '' or qt_idade_min_dia <= qt_idade_dia_w)
and (coalesce(qt_idade_max_dia::text, '') = '' or qt_idade_max_dia >= qt_idade_dia_w)
and	coalesce(ie_situacao,'A') = 'A';

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_escala_dor ( cd_pessoa_fisica_p text, cd_escala_dor_p text) FROM PUBLIC;
