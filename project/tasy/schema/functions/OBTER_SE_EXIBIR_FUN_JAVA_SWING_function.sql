-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibir_fun_java_swing ( ie_base_wheb_p text, cd_funcao_p bigint) RETURNS varchar AS $body$
DECLARE

				
ie_java_swing_w	varchar(1);
ie_exibir_funcao_w	varchar(1) := 'S';
ie_java_html5_w	varchar(1);
			

BEGIN
if (ie_base_wheb_p IS NOT NULL AND ie_base_wheb_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
	begin
	
	ie_java_html5_w := obter_param_usuario(2811, 2, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_java_html5_w);

	-- Devido a possibilidade de chamar a função SUEP do HTML5 da aplicação do java, foi necessário alterar como função ativa, mas essa função somente deve ser apresentada como chamada externa.
	if (cd_funcao_p = 2811 and ie_java_html5_w = 'N') then
	
		ie_exibir_funcao_w := 'N';

	else
		ie_java_swing_w	:= obter_se_funcao_java_swing(cd_funcao_p);
		if (ie_java_swing_w = 'N') then
			begin
			ie_exibir_funcao_w	:= 'S';
			end;
		else
			begin
			ie_exibir_funcao_w	:= ie_base_wheb_p;
			end;
		end if;	
		
	end if;
	end;
end if;
return ie_exibir_funcao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibir_fun_java_swing ( ie_base_wheb_p text, cd_funcao_p bigint) FROM PUBLIC;
