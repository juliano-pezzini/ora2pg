-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_prioridade_setor ( cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_local_estoque_w		smallint := 0;

C01 CURSOR FOR
	SELECT	a.cd_local_estoque cd_local_estoque
	from    	local_estoque a,
		setor_local b
	where   	a.cd_local_estoque        = b.cd_local_estoque
	and     	b.cd_setor_atendimento = cd_setor_atendimento_p
	and	a.cd_estabelecimento     = cd_estabelecimento_p
	and     	obter_se_local_padrao_setor(b.cd_setor_atendimento, a.cd_local_estoque) = 'S'
	and     	a.ie_situacao = 'A'
	and     	(b.ie_prioridade =     (SELECT	max(x.ie_prioridade)
				from    	setor_local x
				where   	x.cd_setor_atendimento = b.cd_setor_atendimento
				and	exists (	select	1
						from 	setor_local z
						where   	x.cd_setor_atendimento = z.cd_setor_atendimento
						and	(z.ie_prioridade IS NOT NULL AND z.ie_prioridade::text <> ''))))
	
union

	select	a.cd_local_estoque cd_local_estoque
	from    	local_estoque a,
		setor_local b
	where   	a.cd_local_estoque        = b.cd_local_estoque
	and     	b.cd_setor_atendimento = cd_setor_atendimento_p
	and	a.cd_estabelecimento    = cd_estabelecimento_p
	and     	obter_se_local_padrao_setor(b.cd_setor_atendimento, a.cd_local_estoque) = 'S'
	and     	a.ie_situacao = 'A'
	and	(b.cd_local_estoque = (	select	max(x.cd_local_estoque)
					from    	setor_local x
					where   	x.cd_setor_atendimento = b.cd_setor_atendimento
					and	not exists (	select	1
								from 	setor_local z
								where   	x.cd_setor_atendimento = z.cd_setor_atendimento
								and	(z.ie_prioridade IS NOT NULL AND z.ie_prioridade::text <> ''))));


BEGIN

begin
open C01;
loop
fetch C01 into
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;
exception when others then
	cd_local_estoque_w := 0;
end;

return	cd_local_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_prioridade_setor ( cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

