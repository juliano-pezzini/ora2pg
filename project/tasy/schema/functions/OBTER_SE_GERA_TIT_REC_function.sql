-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gera_tit_rec (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_gerar_w	varchar(10);

c01 CURSOR FOR
SELECT	'S'
from	regra_gerar_tit_rec a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	coalesce(a.cd_convenio, coalesce(cd_convenio_p,0))			= coalesce(cd_convenio_p,0)
and	coalesce(a.ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0))	= coalesce(ie_tipo_atendimento_p,0);


BEGIN

open c01;
loop
fetch c01 into
	ie_gerar_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_gerar_w	:= ie_gerar_w;
end loop;
close c01;

return coalesce(ie_gerar_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gera_tit_rec (cd_convenio_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint) FROM PUBLIC;

