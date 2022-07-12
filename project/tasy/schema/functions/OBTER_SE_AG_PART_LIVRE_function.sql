-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ag_part_livre (nm_usuario_selecionado_p text, ie_permissao_agenda_p text) RETURNS varchar AS $body$
DECLARE


ie_param_16_w	varchar(1);


BEGIN

ie_param_16_w := Obter_Param_Usuario(791, 16, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_param_16_w);

if (ie_param_16_w = 'S') and (obter_usuario_ativo = nm_usuario_selecionado_p) and (ie_permissao_agenda_p = 'L') then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ag_part_livre (nm_usuario_selecionado_p text, ie_permissao_agenda_p text) FROM PUBLIC;
