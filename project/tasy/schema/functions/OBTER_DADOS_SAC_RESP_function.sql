-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_sac_resp (nr_seq_responsavel_p bigint, nm_usuario_p text, ie_dado_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'N';
cont_w			bigint;
nm_usuario_resp_w	varchar(15);
cd_perfil_resp_w	integer;
qt_minuto_aviso_w	smallint;
dt_ultimo_aviso_w	timestamp;
ie_solucao_w		varchar(1);
ie_restricao_w		smallint;
ie_tipo_perfil_w	varchar(15) := 'N';
cd_perfil_ativo_w	bigint := Obter_perfil_Ativo;

/*Ie_dado_p:

	'R' ->	Obter se o usuário é responsável
	'E' ->	Obter se avisa evento SAC do usuário
	'S' ->	Obter se usuário pode solucionar
*/
--Responsáveis
c01 CURSOR FOR
SELECT	1 ie_restricao,
	'' nm_usuario_resp,
	cd_perfil_resp,
	qt_minuto_aviso,
	dt_ultimo_aviso,
	coalesce(ie_solucao,'N')
from	sac_resp_perfil b
where	b.nr_seq_resp	= nr_seq_responsavel_p
and	((ie_tipo_perfil_w = 'N' and exists (select	1
						from	usuario_perfil x
						where	x.cd_perfil	= b.cd_perfil_resp
						and	x.nm_usuario	= nm_usuario_p))or (ie_tipo_perfil_w = 'S') and (cd_perfil_ativo_w = cd_perfil_resp))


union all

select	2 ie_restricao,
	nm_usuario_resp,
	0 cd_perfil_resp,
	qt_minuto_aviso,
	dt_ultimo_aviso,
	coalesce(ie_solucao,'N')
from	sac_resp_usuario a
where	a.nr_seq_resp		= nr_seq_responsavel_p
and	a.nm_usuario_resp	= nm_usuario_p
order by
	ie_restricao;


BEGIN
ie_tipo_perfil_w := obter_param_usuario(2000, 102, obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_tipo_perfil_w);
open	c01;
loop
fetch 	c01 into
	ie_restricao_w,
	nm_usuario_resp_w,
	cd_perfil_resp_w,
	qt_minuto_aviso_w,
	dt_ultimo_aviso_w,
	ie_solucao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (ie_dado_p = 'R')then
		ie_retorno_w	:= 'S';
	elsif (ie_dado_p = 'E') then
		if	((coalesce(dt_ultimo_aviso_w,clock_timestamp() - interval '1 days') + qt_minuto_aviso_w/1440) < clock_timestamp()) then
			ie_retorno_w	:= 'S';
		end if;
	elsif (ie_dado_p = 'S') then
		if (ie_solucao_w = 'S') then
			ie_retorno_w	:= 'S';
		end if;
	end if;
end loop;
close	c01;


return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_sac_resp (nr_seq_responsavel_p bigint, nm_usuario_p text, ie_dado_p text) FROM PUBLIC;
