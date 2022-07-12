-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_acomodacao (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_acomodacao_w	varchar(1);
qt_acomodacao_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_acomodacao_w
from	setor_tipo_acomodacao
where 	cd_setor_atendimento = cd_setor_atendimento_p;

if (qt_acomodacao_w > 0) then
	ie_acomodacao_w := 'S';
else
	ie_acomodacao_w := 'N';
end if;

return	ie_acomodacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_acomodacao (cd_setor_atendimento_p bigint) FROM PUBLIC;

