-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_html5_fechar_funcao (cd_convenio_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_consiste_presc_p text, ds_msg_abort_p INOUT text, ds_msg_urgencia_pa_p INOUT text, ds_msg_decl_obito_p INOUT text, ds_mensagem_pf_p INOUT text, ie_atrib_obrig_pf_p INOUT text, ie_regra_proc_p INOUT text ) AS $body$
DECLARE
	
 
ds_msg_abort_w 		varchar(255);
ds_msg_urgencia_pa_w 	varchar(255);
ds_msg_decl_obito_w 	varchar(255);
ds_mensagem_pf_w 	varchar(255);
ie_atrib_obrig_pf_w 		varchar(255);
ie_regra_proc_w 		varchar(255);
ie_consiste_medico_exec_w 	varchar(1);
cd_estabelecimento_w 	smallint;


BEGIN 
 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
ie_consiste_medico_exec_w := Obter_param_Usuario(916, 461, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_medico_exec_w);
 
SELECT * FROM eup_permite_fechar_funcao_js(cd_convenio_p, cd_pessoa_fisica_p, nr_atendimento_p, nm_usuario_p, ds_msg_abort_w, ds_msg_urgencia_pa_w, ds_msg_decl_obito_w, ds_mensagem_pf_w, ie_atrib_obrig_pf_w, ie_regra_proc_w) INTO STRICT ds_msg_abort_w, ds_msg_urgencia_pa_w, ds_msg_decl_obito_w, ds_mensagem_pf_w, ie_atrib_obrig_pf_w, ie_regra_proc_w;
 
ds_msg_abort_p 		:= ds_msg_abort_w;
ds_msg_urgencia_pa_p 	:= ds_msg_urgencia_pa_w;
ds_msg_decl_obito_p 	:= ds_msg_decl_obito_w;
ds_mensagem_pf_p 	:= ds_mensagem_pf_w;
ie_atrib_obrig_pf_p 		:= ie_atrib_obrig_pf_w;
ie_regra_proc_p 		:= ie_regra_proc_w;
 
 
if ((ie_consiste_medico_exec_w = 'S') 
 and (ds_msg_abort_w IS NOT NULL AND ds_msg_abort_w::text <> '') 
 and (position('[461]' in ds_msg_abort_w) > 0) 
 and (ie_consiste_presc_p = 'N')) then	 
	ds_msg_abort_p := ''; -- abort only when one prescription have already been viewed. front-end: IE_CONSISTE_PRESC	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_html5_fechar_funcao (cd_convenio_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_consiste_presc_p text, ds_msg_abort_p INOUT text, ds_msg_urgencia_pa_p INOUT text, ds_msg_decl_obito_p INOUT text, ds_mensagem_pf_p INOUT text, ie_atrib_obrig_pf_p INOUT text, ie_regra_proc_p INOUT text ) FROM PUBLIC;
