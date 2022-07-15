-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_plano_usuario_js ( cd_plano_padrao_p bigint, cd_convenio_p bigint, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, cd_categoria_p text, dt_atendimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_plano_cod_usuario_p INOUT text, ds_erro_p INOUT text, cd_plano_conv_p INOUT text) AS $body$
DECLARE


cd_plano_cod_usuario_w	varchar(10);
ds_erro_w		varchar(255);
cd_plano_conv_w		varchar(60);
				

BEGIN

if (cd_plano_padrao_p = 0)then
	begin
	
	cd_plano_cod_usuario_w	:= obter_plano_cod_usuario_conv(cd_convenio_p, cd_usuario_convenio_p);
	
	end;
end if;

ds_erro_w := consiste_debito_paciente(cd_pessoa_fisica_p, cd_convenio_p, cd_usuario_convenio_p, ie_tipo_atendimento_p, ie_clinica_p, null, cd_categoria_p, dt_atendimento_p, ds_erro_w);

cd_plano_conv_w	:= obter_plano_conv_usu(cd_usuario_convenio_p, cd_convenio_p, cd_categoria_p, cd_estabelecimento_p, dt_atendimento_p);

cd_plano_cod_usuario_p	:= cd_plano_cod_usuario_w;
ds_erro_p		:= ds_erro_w;
cd_plano_conv_p		:= cd_plano_conv_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_plano_usuario_js ( cd_plano_padrao_p bigint, cd_convenio_p bigint, cd_usuario_convenio_p text, cd_pessoa_fisica_p text, ie_tipo_atendimento_p bigint, ie_clinica_p bigint, cd_categoria_p text, dt_atendimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_plano_cod_usuario_p INOUT text, ds_erro_p INOUT text, cd_plano_conv_p INOUT text) FROM PUBLIC;

