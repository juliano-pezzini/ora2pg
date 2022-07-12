-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_tipo_conta_ans ( cd_conta_ans_p bigint, cd_empresa_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_conta_w		varchar(5);


BEGIN

begin
select	c.ie_tipo
into STRICT	ie_tipo_conta_w
from	ctb_grupo_conta c,
	conta_contabil b
where	b.cd_empresa	= cd_empresa_p
and	b.cd_plano_ans	= cd_conta_ans_p
and	b.cd_grupo	= c.cd_grupo;

exception
	when others then
		ie_tipo_conta_w	:= null;
end;

return	ie_tipo_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_tipo_conta_ans ( cd_conta_ans_p bigint, cd_empresa_p bigint) FROM PUBLIC;

