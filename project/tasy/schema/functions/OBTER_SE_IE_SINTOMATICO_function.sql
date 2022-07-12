-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ie_sintomatico (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	diagnostico_doenca a
	where	a.ie_sintomatico > 0
	and		a.nr_atendimento = nr_atendimento_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ie_sintomatico (nr_atendimento_p bigint) FROM PUBLIC;
