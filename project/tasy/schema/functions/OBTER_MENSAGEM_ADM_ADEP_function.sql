-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mensagem_adm_adep ( cd_setor_p bigint, cd_unidade_medida_p text) RETURNS varchar AS $body$
DECLARE


ds_mensagem_w	varchar(255);

c01 CURSOR FOR
SELECT	ds_mensagem
from	REGRA_MENSAGEM_ADM_ITEM
where	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_p = cd_setor_atendimento))
and	cd_unidade_medida	= cd_unidade_medida_p
order by coalesce(cd_setor_atendimento,0),
	cd_unidade_medida;


BEGIN

open C01;
loop
fetch C01 into
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ds_mensagem_w	:= ds_mensagem_w;
end loop;
close C01;

return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mensagem_adm_adep ( cd_setor_p bigint, cd_unidade_medida_p text) FROM PUBLIC;

