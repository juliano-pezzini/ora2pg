-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cc_setor_usuario_lib (nm_usuario_p text, cd_estabelecimento_p bigint, cd_centro_custo_p bigint) RETURNS varchar AS $body$
DECLARE


cd_centro_custo_setor_w	setor_atendimento.cd_centro_custo%type;
ds_retorno_w		varchar(1) := 'N';

C01 CURSOR FOR /*busca os setores liberados para o usuario*/
SELECT	distinct
	b.cd_centro_custo
from	usuario_setor a,
	setor_atendimento b
where	(b.cd_centro_custo IS NOT NULL AND b.cd_centro_custo::text <> '')
and	a.cd_setor_atendimento	= b.cd_setor_atendimento
and	a.nm_usuario_param 	= nm_usuario_p
and     b.cd_estabelecimento	= cd_estabelecimento_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_centro_custo_setor_w;
exit when(C01%notfound or ds_retorno_w = 'S');

	if (cd_centro_custo_setor_w = cd_centro_custo_p) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;

end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cc_setor_usuario_lib (nm_usuario_p text, cd_estabelecimento_p bigint, cd_centro_custo_p bigint) FROM PUBLIC;

