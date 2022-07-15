-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_unid_newrecord_eup_js ( cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_clinica_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, cd_pessoa_resp_p text, nm_usuario_p text, ds_msg_abort_cpf_p INOUT text, ds_msg_abort_p INOUT text, ds_msg_regra_setor_p INOUT text, cd_setor_atendimento_p INOUT bigint, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, cd_tipo_acomodacao_p INOUT bigint, qt_reserva_convenio_p INOUT bigint, ds_msg_reserva_p INOUT text, cd_setor_agenda_p INOUT bigint, cd_setor_ag_quimio_p INOUT bigint, ie_leito_s_p INOUT text, ie_leito_ub_p INOUT text, ie_leito_uc_p INOUT text, ie_leito_a_p INOUT text, ie_leito_v_p INOUT text, ie_leito_sit_p INOUT text) AS $body$
DECLARE

 
cd_estabelecimento_w	smallint;					
ie_conv_exig_cpf_w	varchar(1);
ie_exige_cpg_rg_estr_w	varchar(1);	
ie_regra_conv_atend_w	varchar(1);
ie_agenda_atual_setor_w	varchar(1);
ie_setor_ag_quimio_w	varchar(1);
			

BEGIN 
 
 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
 
ie_regra_conv_atend_w := Obter_param_Usuario(916, 141, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_regra_conv_atend_w);
ie_agenda_atual_setor_w := Obter_param_Usuario(916, 398, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_agenda_atual_setor_w);
ie_conv_exig_cpf_w := Obter_param_Usuario(916, 501, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_conv_exig_cpf_w);
ie_exige_cpg_rg_estr_w := Obter_param_Usuario(916, 665, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_exige_cpg_rg_estr_w);
ie_setor_ag_quimio_w := Obter_param_Usuario(916, 949, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_setor_ag_quimio_w);
 
SELECT * FROM atend_unid_newre_abort_js(ie_regra_conv_atend_w, cd_estabelecimento_w, ie_conv_exig_cpf_w, ie_exige_cpg_rg_estr_w, nr_atendimento_p, ie_tipo_atendimento_p, cd_convenio_p, cd_pessoa_fisica_p, cd_pessoa_resp_p, nm_usuario_p, ds_msg_abort_cpf_p, ds_msg_abort_p) INTO STRICT ds_msg_abort_cpf_p, ds_msg_abort_p;
 
if (ds_msg_abort_cpf_p IS NOT NULL AND ds_msg_abort_cpf_p::text <> '') or (ds_msg_abort_p IS NOT NULL AND ds_msg_abort_p::text <> '') then 
	goto final;
end if;
 
ds_msg_regra_setor_p := obter_itens_regra_setor(ie_tipo_atendimento_p, cd_pessoa_fisica_p, nm_usuario_p, cd_estabelecimento_w, ds_msg_regra_setor_p);
 
SELECT * FROM consistir_reserva_paciente(cd_pessoa_fisica_p, cd_convenio_p, ie_tipo_atendimento_p, ie_clinica_p, cd_estabelecimento_w, nm_usuario_p, cd_setor_atendimento_p, cd_unidade_basica_p, cd_unidade_compl_p, cd_tipo_acomodacao_p, qt_reserva_convenio_p, ds_msg_reserva_p) INTO STRICT cd_setor_atendimento_p, cd_unidade_basica_p, cd_unidade_compl_p, cd_tipo_acomodacao_p, qt_reserva_convenio_p, ds_msg_reserva_p;
					 
if (ie_agenda_atual_setor_w = 'S') and (coalesce(nr_seq_agenda_p,0) > 0) and 
	((coalesce(cd_tipo_agenda_p,0) = 3) or (coalesce(cd_tipo_agenda_p,0) = 4)) then 
	 
	select	coalesce(max(cd_setor_atendimento),0) 
	into STRICT	cd_setor_agenda_p 
	from 	agenda_consulta  
	where 	nr_sequencia = nr_seq_agenda_p;
end if;
 
if (ie_setor_ag_quimio_w = 'S') and (coalesce(nr_seq_agenda_p,0) > 0) and (coalesce(cd_tipo_agenda_p,0) = 11) then 
	 
	select 	coalesce(max(b.cd_setor_atendimento),0) 
	into STRICT	cd_setor_ag_quimio_p 
    from  agenda_quimio a, 
        qt_local b 
    where  a.nr_seq_local = b.nr_sequencia 
    and   a.nr_sequencia = nr_seq_agenda_p;
end if;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
 
	ie_leito_s_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'S','L','N',0);
	ie_leito_ub_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'UB','L','N',0);
	ie_leito_uc_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'UC','L','N',0);
	ie_leito_a_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'A','L','N',0);
	ie_leito_v_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'V','L','N',0);
	ie_leito_sit_p := obter_se_leito_livre_reservado(cd_pessoa_fisica_p,'ST','AB','N',0);
 
end if;
 
<<final>> 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_unid_newrecord_eup_js ( cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_clinica_p bigint, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, cd_pessoa_fisica_p text, cd_pessoa_resp_p text, nm_usuario_p text, ds_msg_abort_cpf_p INOUT text, ds_msg_abort_p INOUT text, ds_msg_regra_setor_p INOUT text, cd_setor_atendimento_p INOUT bigint, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, cd_tipo_acomodacao_p INOUT bigint, qt_reserva_convenio_p INOUT bigint, ds_msg_reserva_p INOUT text, cd_setor_agenda_p INOUT bigint, cd_setor_ag_quimio_p INOUT bigint, ie_leito_s_p INOUT text, ie_leito_ub_p INOUT text, ie_leito_uc_p INOUT text, ie_leito_a_p INOUT text, ie_leito_v_p INOUT text, ie_leito_sit_p INOUT text) FROM PUBLIC;

