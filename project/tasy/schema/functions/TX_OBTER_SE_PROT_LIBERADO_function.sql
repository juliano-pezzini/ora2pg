-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tx_obter_se_prot_liberado (cd_protocolo_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_itens_w	varchar(2000);
ds_retorno_w	varchar(1);

BEGIN
if (ie_opcao_p = 'EL') then
	ds_itens_w := obter_param_usuario(7006, 22, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ds_itens_w);

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	
	where	((obter_se_contido(cd_protocolo_p,ds_itens_w) = 'S') or (ds_itens_w = '0'));

elsif (ie_opcao_p = 'ENL') then
	ds_itens_w := obter_param_usuario(7006, 23, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ds_itens_w);

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	
	where	((obter_se_contido(cd_protocolo_p,ds_itens_w) = 'S') or (ds_itens_w = '0'));
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tx_obter_se_prot_liberado (cd_protocolo_p text, ie_opcao_p text) FROM PUBLIC;

