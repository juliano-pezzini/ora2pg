-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_leitos_normais (cd_setor_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w			varchar(1)	:=	'S';
qt_existe_normal_w		integer;

BEGIN

select	count(*)
into STRICT	qt_existe_normal_w
from	UNIDADE_ATEND_LIVRE_V
where	ie_temporario = 'N'
and	cd_setor_atendimento = cd_setor_p;

if (qt_existe_normal_w = 0) then
	retorno_w := 'N';
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_leitos_normais (cd_setor_p bigint) FROM PUBLIC;

