-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_usuario_aprov ( cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_aprov_p text) RETURNS varchar AS $body$
DECLARE


/*Essa function é utilizada especifica para o processo de aprovação (no envio da comunicação interna pela regra de envio de e-mail do compras, para os tipo 9 e 15)
Ela identifica se o setor está liberado para o usuário, porém so quando o parâmetro [2] do processo de aprovação estiver = S
É para enviar o e-mail somente para o aprovador possuir o setor liberado
Feita atraves da OS 206636*/
ie_liberado_w			varchar(1) := 'S';
ie_setor_liberado_usuario_w		varchar(1) := 'S';
ie_restringe_setor_w		varchar(1);

BEGIN

select	max(Obter_Valor_Param_Usuario(267, 2, obter_perfil_ativo, nm_usuario_aprov_p, cd_estabelecimento_p))
into STRICT	ie_restringe_setor_w
;

if (ie_restringe_setor_w = 'S') then
	select	obter_se_setor_usuario(cd_setor_atendimento_p, nm_usuario_aprov_p)
	into STRICT	ie_setor_liberado_usuario_w
	;

	if (ie_setor_liberado_usuario_w = 'N') then
		ie_liberado_w := 'N';
	end if;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_usuario_aprov ( cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_aprov_p text) FROM PUBLIC;

