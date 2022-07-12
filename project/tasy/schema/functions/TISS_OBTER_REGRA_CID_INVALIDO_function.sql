-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_regra_cid_invalido (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_doenca_cid_p text, ie_tipo_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_invalido_w	varchar(1);
ds_retorno_w	varchar(1);

c01 CURSOR FOR
SELECT	coalesce(ie_invalido,'N')
from	tiss_regra_cid_invalido
where	cd_estabelecimento					= cd_estabelecimento_p
and	cd_doenca						= cd_doenca_cid_p
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))			= coalesce(cd_convenio_p,0)
and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0)
order by coalesce(cd_convenio,0),
	coalesce(ie_tipo_atendimento,0);


BEGIN

ds_retorno_w	:= 'N';

open C01;
loop
fetch C01 into
	ie_invalido_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:= ie_invalido_w;
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_regra_cid_invalido (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_doenca_cid_p text, ie_tipo_atendimento_p bigint) FROM PUBLIC;

