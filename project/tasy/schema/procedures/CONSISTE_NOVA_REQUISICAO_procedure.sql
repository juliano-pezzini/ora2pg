-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_nova_requisicao ( cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ie_permite_nova_req_w	varchar(1);
cd_perfil_w		bigint;
ds_erro_w		varchar(255) := '';
nr_requisicao_w		bigint;


BEGIN
cd_perfil_w	:= obter_perfil_ativo;

select	coalesce(max(obter_valor_param_usuario(919, 111, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p)),'S')
into STRICT	ie_permite_nova_req_w
;

if (ie_permite_nova_req_w = 'N') then
	select	max(nr_requisicao)
	into STRICT	nr_requisicao_w
	from	requisicao_material
	where 	coalesce(dt_liberacao::text, '') = ''
	and	coalesce(dt_baixa::text, '') = ''
	and	nm_usuario_nrec = nm_usuario_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (nr_requisicao_w > 0) then
	   ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(281456) || nr_requisicao_w || WHEB_MENSAGEM_PCK.get_texto(281459);
	end if;
end if;

ds_erro_p := ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_nova_requisicao ( cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
