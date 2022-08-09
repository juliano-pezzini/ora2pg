-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_guia_focusgained_js ( ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mascara_guia_p INOUT text, ie_abrir_autorizacao_conv_p INOUT text, ie_abrir_local_guia_p INOUT text) AS $body$
DECLARE

 
ie_tipo_convenio_w		smallint;	
ie_abrir_autorizacao_conv_w	varchar(1);
ie_tipo_conv_abre_auto_w	varchar(60);	
ie_tipo_conv_contido_w		varchar(1);	
ie_classif_abre_auto_w		varchar(60);	
qt_classif_conv_w		bigint;	
ie_local_guias_w		varchar(2);
ie_senha_guia_igual_atend_w	varchar(1);
qt_regra_guia_ativa_w		bigint;
					

BEGIN 
 
ie_abrir_autorizacao_conv_p	:= 'N';
ie_abrir_local_guia_p		:= 'N';	
 
ie_abrir_autorizacao_conv_w := Obter_param_Usuario(916, 411, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_abrir_autorizacao_conv_w);
ie_tipo_conv_abre_auto_w := Obter_param_Usuario(916, 486, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_tipo_conv_abre_auto_w);
ie_classif_abre_auto_w := Obter_param_Usuario(916, 499, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_classif_abre_auto_w);
ie_senha_guia_igual_atend_w := Obter_param_Usuario(916, 1018, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_senha_guia_igual_atend_w);
ie_local_guias_w := Obter_param_Usuario(916, 1093, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_local_guias_w);
 
ds_mascara_guia_p := obter_mascara_guia_conv(cd_estabelecimento_p, cd_convenio_p, ie_tipo_atendimento_p);
 
ie_tipo_convenio_w := obter_tipo_convenio(cd_convenio_p);
 
if (coalesce(ie_tipo_convenio_w,0) > 0) and (ie_tipo_conv_abre_auto_w IS NOT NULL AND ie_tipo_conv_abre_auto_w::text <> '') then 
	 
	ie_tipo_conv_contido_w := obter_se_contido(ie_tipo_convenio_w,ie_tipo_conv_abre_auto_w);
 
end if;
 
if (ie_classif_abre_auto_w IS NOT NULL AND ie_classif_abre_auto_w::text <> '') then 
	 
	select	count(*) 
	into STRICT	qt_classif_conv_w 
    from  convenio_classif 
    where  cd_convenio = cd_convenio_p 
    and   obter_se_contido(nr_seq_classificacao, ie_classif_abre_auto_w) = 'S';
 
end if;
 
select 	count(*) 
into STRICT	qt_regra_guia_ativa_w 
from 	convenio_regra_guia 
where 	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_p;
 
 
if	((ie_abrir_autorizacao_conv_w = 'S' or 
	ie_abrir_autorizacao_conv_w = 'B') and 
	 (((coalesce(ie_tipo_conv_abre_auto_w::text, '') = '') or (ie_tipo_conv_contido_w = 'S')) and 
	 ((coalesce(ie_classif_abre_auto_w::text, '') = '') or (qt_classif_conv_w > 0)))) or 
	(ie_abrir_autorizacao_conv_w = 'C' AND ie_tipo_convenio_w = 2) then 
	ie_abrir_autorizacao_conv_p := 'S';
	 
elsif (ie_abrir_autorizacao_conv_w = 'N') and (ie_local_guias_w <> 'N') and (ie_senha_guia_igual_atend_w <> 'S') and (qt_regra_guia_ativa_w = 0) then 
	ie_abrir_local_guia_p := 'S';
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_guia_focusgained_js ( ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mascara_guia_p INOUT text, ie_abrir_autorizacao_conv_p INOUT text, ie_abrir_local_guia_p INOUT text) FROM PUBLIC;
