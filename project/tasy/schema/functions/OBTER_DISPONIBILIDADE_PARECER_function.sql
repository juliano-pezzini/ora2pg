-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_disponibilidade_parecer (cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


ie_disponibilidade_w	varchar(255);


BEGIN

select	max(coalesce(a.IE_DISPONIBILIDADE,'S'))
into STRICT	IE_DISPONIBILIDADE_W
from	USUARIO_DISP_PARECER a,
		PARECER_MEDICO_REQ b
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
AND		b.CD_PESSOA_PARECER = a.cd_pessoa_fisica;

return	ie_disponibilidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_disponibilidade_parecer (cd_pessoa_fisica_p bigint) FROM PUBLIC;

