-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_nova_apac_eup_js ( nr_atendimento_p bigint, nm_usuario_p text, ds_msg_erro_p INOUT text, dt_competencia_p INOUT timestamp, cd_medico_autorizador_p INOUT text) AS $body$
DECLARE


ie_permite_nova_apac_w	varchar(1);
ds_msg_erro_w		varchar(100);
dt_competencia_w	timestamp;
cd_medico_autorizador_w	varchar(10);
cd_estabelecimento_w	smallint;
ie_nova_apac_w		varchar(1);
ie_medico_auto_w	varchar(1);
ie_continua_execucao_w	varchar(1) := 'S';


BEGIN
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;

ie_nova_apac_w := Obter_param_Usuario(1124, 26, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_nova_apac_w);
ie_medico_auto_w := Obter_param_Usuario(1124, 34, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_medico_auto_w);

if (coalesce(nr_atendimento_p,0) > 0) then
	begin

	ie_permite_nova_apac_w	:= sus_permite_nova_apac(nr_atendimento_p,'');
	if (ie_continua_execucao_w = 'S') and (ie_permite_nova_apac_w = 'N') and (ie_nova_apac_w = 'N') then

		ds_msg_erro_w		:= obter_texto_tasy(72542,null);
		ie_continua_execucao_w := 'N';
	end if;

	if (ie_continua_execucao_w = 'S') then
		select 	trunc(max(dt_competencia_apac))
		into STRICT	dt_competencia_w
		from 	sus_parametros_apac
		where 	cd_estabelecimento = cd_estabelecimento_w;

		if (ie_medico_auto_w = 'S') then

			select 	max(cd_medico_autorizador)
			into STRICT	cd_medico_autorizador_w
			from   	sus_parametros_apac
			where   cd_estabelecimento = cd_estabelecimento_w;
		end if;
	end if;
	end;
end if;

ds_msg_erro_p		:= ds_msg_erro_w;
dt_competencia_p	:= dt_competencia_w;
cd_medico_autorizador_p	:= cd_medico_autorizador_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_nova_apac_eup_js ( nr_atendimento_p bigint, nm_usuario_p text, ds_msg_erro_p INOUT text, dt_competencia_p INOUT timestamp, cd_medico_autorizador_p INOUT text) FROM PUBLIC;

