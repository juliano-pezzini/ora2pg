-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_focuslost_plano_js ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_acompanhante_p bigint, qt_dieta_acomp_p bigint, ie_lib_dieta_p text, nr_seq_regra_acomp_p bigint, cd_empresa_p bigint, dt_entrada_p timestamp, ie_tipo_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, cd_plano_convenio_p text, cd_convenio_p bigint, nm_usuario_p text, ds_msg_plano_inativo_p INOUT text, ds_mascara_cod_p INOUT text, nr_acompanhante_ret_p INOUT bigint, qt_dieta_acomp_ret_p INOUT bigint, ie_lib_dieta_ret_p INOUT text, nr_seq_regra_acomp_ret_p INOUT bigint, ds_msg_dieta_p INOUT text, ie_regra_conv_plano_p INOUT text, ie_forma_doc_conv_p INOUT text, qt_doc_conv_p INOUT bigint) AS $body$
DECLARE

 
ie_situacao_w			varchar(1);
ie_mascara_conv_local_w		varchar(1);	
ie_util_masc_conv_w		varchar(50);	
ie_mascara_convenio_w		varchar(1);
ds_mascara_cod_w		varchar(30);
ie_consiste_guia_prescr_w 	varchar(60);
ie_exibe_dieta_categ_conv_w	varchar(1);
ie_atualiza_dieta_nenhuma_w	varchar(1);	
ie_gera_qt_acomp_w		varchar(1);		
ie_atualiza_dieta_w		varchar(1);			
			 

BEGIN 
 
ie_regra_conv_plano_p := 'N';
ie_forma_doc_conv_p := 'T';
 
ie_mascara_conv_local_w := Obter_param_Usuario(3008, 4, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_mascara_conv_local_w);
 
ie_consiste_guia_prescr_w := Obter_param_Usuario(916, 77, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_guia_prescr_w);
ie_mascara_convenio_w := Obter_param_Usuario(916, 333, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_mascara_convenio_w);
ie_atualiza_dieta_nenhuma_w := Obter_param_Usuario(916, 466, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_dieta_nenhuma_w);
ie_exibe_dieta_categ_conv_w := Obter_param_Usuario(916, 520, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exibe_dieta_categ_conv_w);
ie_gera_qt_acomp_w := Obter_param_Usuario(916, 706, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_qt_acomp_w);
ie_atualiza_dieta_w := Obter_param_Usuario(916, 1115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_dieta_w);
 
if (cd_plano_convenio_p IS NOT NULL AND cd_plano_convenio_p::text <> '') then 
 
	Select	max(ie_situacao) 
	into STRICT	ie_situacao_w 
	from 	convenio_plano 
	where	cd_convenio = cd_convenio_p 
	and 	cd_plano = cd_plano_convenio_p;
	 
	if (ie_situacao_w = 'I') then 
		ds_msg_plano_inativo_p := substr(obter_texto_tasy(88545, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
		 
	if	((ie_mascara_conv_local_w <> 'S') and 
		((coalesce(ie_consiste_guia_prescr_w::text, '') = '') or (ie_consiste_guia_prescr_w = '999.9999.999999.99-9;0;_')) or (ie_mascara_convenio_w = 'S')) then 
		 
		ds_mascara_cod_p := obter_mascara_usuario_conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, ie_tipo_atendimento_p, cd_plano_convenio_p, dt_entrada_p, cd_empresa_p);
	end if;
	SELECT * FROM obter_dados_dieta_eup_js(ie_exibe_dieta_categ_conv_w, nr_seq_regra_acomp_p, ie_lib_dieta_p, qt_dieta_acomp_p, nr_acompanhante_p, ie_atualiza_dieta_nenhuma_w, ie_gera_qt_acomp_w, ie_atualiza_dieta_w, nr_atendimento_p, cd_pessoa_fisica_p, cd_plano_convenio_p, cd_categoria_p, cd_convenio_p, nm_usuario_p, nr_acompanhante_ret_p, qt_dieta_acomp_ret_p, ie_lib_dieta_ret_p, nr_seq_regra_acomp_ret_p, ds_msg_dieta_p) INTO STRICT nr_acompanhante_ret_p, qt_dieta_acomp_ret_p, ie_lib_dieta_ret_p, nr_seq_regra_acomp_ret_p, ds_msg_dieta_p;
					 
	ie_regra_conv_plano_p := obter_se_reg_conv_pl_cat(cd_convenio_p, 'PC', null, cd_plano_convenio_p);
	 
	begin 
		select coalesce(ie_forma_doc_conv,'T') 
		into STRICT	ie_forma_doc_conv_p 
		from	parametro_atendimento 
		where 	cd_estabelecimento = cd_estabelecimento_p;	
	exception 
	when others then 
		ie_forma_doc_conv_p := 'T';
	end;
	 
	select	max(1) 
	into STRICT	qt_doc_conv_p 
	from	convenio_doc_atend 
	where	cd_convenio = cd_convenio_p 
	and 	coalesce(cd_plano::text, '') = '';
	 
end if;
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_focuslost_plano_js ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_acompanhante_p bigint, qt_dieta_acomp_p bigint, ie_lib_dieta_p text, nr_seq_regra_acomp_p bigint, cd_empresa_p bigint, dt_entrada_p timestamp, ie_tipo_atendimento_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, cd_plano_convenio_p text, cd_convenio_p bigint, nm_usuario_p text, ds_msg_plano_inativo_p INOUT text, ds_mascara_cod_p INOUT text, nr_acompanhante_ret_p INOUT bigint, qt_dieta_acomp_ret_p INOUT bigint, ie_lib_dieta_ret_p INOUT text, nr_seq_regra_acomp_ret_p INOUT bigint, ds_msg_dieta_p INOUT text, ie_regra_conv_plano_p INOUT text, ie_forma_doc_conv_p INOUT text, qt_doc_conv_p INOUT bigint) FROM PUBLIC;

