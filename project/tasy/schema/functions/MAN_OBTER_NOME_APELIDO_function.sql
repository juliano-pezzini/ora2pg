-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_nome_apelido (cd_pessoa_solicitante_p text) RETURNS varchar AS $body$
DECLARE


/*
Esta function ira retornar o nome ou o apelido do solicitante da OS conforme o valor (S ou N) do parametro [68] da funcao Gestao de Ordens de Servico 
OS 1347673
*/
				
				
ie_nome_apelido_w	varchar(255);
ie_param_w			varchar(1);
				

BEGIN

ie_param_w := coalesce(Obter_Valor_Param_Usuario(296,68,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'S');

if (ie_param_w = 'S' )then
	ie_nome_apelido_w := substr(coalesce(obter_apelido_pessoa(cd_pessoa_solicitante_p), obter_nome_pf(cd_pessoa_solicitante_p)),1,60);
else
	ie_nome_apelido_w := substr(obter_nome_pf(cd_pessoa_solicitante_p),1,60);
end if;

return	ie_nome_apelido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_nome_apelido (cd_pessoa_solicitante_p text) FROM PUBLIC;

