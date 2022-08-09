-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_usuario_conv_js ( cd_convenio_p bigint, ie_tipo_atendimento_p bigint, cd_carater_internacao_p text, ie_clinica_p bigint, nr_seq_classificacao_p bigint, cd_categoria_p text, cd_plano_p text, cd_pessoa_fisica_p text, dt_atendimento_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_exige_senha_p INOUT text, ds_procedure_p INOUT text, cd_usuario_plano_p INOUT text, dt_validade_p INOUT timestamp) AS $body$
DECLARE

 
ie_exige_senha_w	varchar(1);
ds_procedure_w		varchar(255);
cd_usuario_plano_w	varchar(2000);
dt_validade_w		timestamp;
			

BEGIN 
if (coalesce(cd_convenio_p,0) > 0) then 
	ie_exige_senha_w	:= obter_se_exige_guia_senha(	cd_convenio_p, 
								ie_tipo_atendimento_p, 
								1, 
								'S', 
								cd_estabelecimento_p, 
								cd_carater_internacao_p, 
								ie_clinica_p, 
								null, 
								null, 
								nr_seq_classificacao_p, 
								null, 
								cd_categoria_P, 
								cd_plano_p, 
								null);
								 
	ie_exige_senha_p	:= ie_exige_senha_w;
 
	ds_procedure_w := obter_regra_valid_usuario_conv(cd_convenio_p, cd_categoria_p, ie_tipo_atendimento_p, ds_procedure_w);	
end if;
if (upper(ds_procedure_w) = 'PLS_OBTER_USUARIO_PLANO')then 
	begin 
	 
	 SELECT * FROM pls_obter_usuario_plano(	cd_pessoa_fisica_p, dt_atendimento_p, cd_estabelecimento_p, cd_usuario_plano_w, dt_validade_w) INTO STRICT cd_usuario_plano_w, dt_validade_w;
					 
	cd_usuario_plano_p	:= cd_usuario_plano_w;
	dt_validade_p		:= dt_validade_w;
	 
	end;
end if;
 
ds_procedure_p := ds_procedure_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_usuario_conv_js ( cd_convenio_p bigint, ie_tipo_atendimento_p bigint, cd_carater_internacao_p text, ie_clinica_p bigint, nr_seq_classificacao_p bigint, cd_categoria_p text, cd_plano_p text, cd_pessoa_fisica_p text, dt_atendimento_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_exige_senha_p INOUT text, ds_procedure_p INOUT text, cd_usuario_plano_p INOUT text, dt_validade_p INOUT timestamp) FROM PUBLIC;
