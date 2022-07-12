-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_classif_agecons (cd_classificacao_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_classificacao_w	varchar(1);


BEGIN
if (cd_classificacao_p IS NOT NULL AND cd_classificacao_p::text <> '') then
	select	max(ie_tipo_classif)
	into STRICT	ie_tipo_classificacao_w
	from	agenda_classif
	where	cd_classificacao = cd_classificacao_p
	and	ie_agenda in ('A','C');
end if;

return	ie_tipo_classificacao_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_classif_agecons (cd_classificacao_p text) FROM PUBLIC;

