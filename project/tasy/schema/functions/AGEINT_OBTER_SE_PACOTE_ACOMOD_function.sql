-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_pacote_acomod ( ie_tipo_acomod_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1)	:= 'S';
qt_regra_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	ageint_tipo_acomod_padrao;

if (qt_regra_w	> 0) then
	select  CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT    ds_retorno_w
	from    tipo_acomodacao a,
		ageint_tipo_acomod_padrao b
	where 	a.cd_tipo_acomodacao 	= b.cd_tipo_acomodacao
	and	a.ie_classificacao	= ie_tipo_acomod_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_pacote_acomod ( ie_tipo_acomod_p text) FROM PUBLIC;
