-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_em_obito (CD_PESSOA_FISICA_P text) RETURNS varchar AS $body$
DECLARE


qt_obito_motivo_w		smallint;
ds_retorno_w		varchar(1);
qt_obito_cadastro_w	smallint;


BEGIN

select	count(*)
into STRICT	qt_obito_cadastro_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	(dt_obito IS NOT NULL AND dt_obito::text <> '');

if (qt_obito_cadastro_w	> 0) then
	return 'S';
end if;

select	count(*)
into STRICT	qt_obito_motivo_w
from	motivo_alta b,
	atendimento_paciente a
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
and	a.cd_motivo_alta_medica = b.cd_motivo_alta
and	b.ie_obito = 'S';

if (qt_obito_motivo_w	> 0) then
	return 'S';
end if;

return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_em_obito (CD_PESSOA_FISICA_P text) FROM PUBLIC;
