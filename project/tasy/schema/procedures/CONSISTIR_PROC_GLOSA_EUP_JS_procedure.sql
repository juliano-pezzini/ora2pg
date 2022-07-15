-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_proc_glosa_eup_js ( nr_seq_agenda_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_medico_p bigint, ie_clinica_p text, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_convenio_p bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text, ds_valor_particular_p INOUT text) AS $body$
DECLARE

 
vl_parametro_w			varchar(1);
ie_setor_agenda_prescr_w	varchar(1);
ds_msg_erro_w			varchar(255);
ds_msg_aviso_w			varchar(255);
ie_continuar_exec_w		varchar(1)	:= 'S';

cd_convenio_w  		bigint;
cd_categoria_w  		varchar(10);
ie_tipo_convenio_w		smallint;
ie_classif_convenio_w		varchar(3);
cd_autorizacao_w		varchar(20);
nr_seq_autorizacao_w  	bigint;
qt_autorizada_w  		double precision;
cd_senha_w  			varchar(20);
nm_responsavel_w  		varchar(40);
ie_glosa_w			varchar(1);
cd_situacao_glosa_w		smallint;
nr_seq_regra_preco_w		bigint;
pr_glosa_w			double precision;
vl_glosa_w			double precision;
cd_motivo_exc_conta_w		bigint;
ie_preco_informado_w		varchar(1);
vl_negociado_w			double precision;
ie_autor_particular_w		varchar(1);
cd_convenio_glosa_w		integer;
cd_categoria_glosa_w		varchar(10);
nr_sequencia_w			bigint;

ds_valor_particular_w		varchar(255);
cd_setor_atend_prescr_w  		integer 	:= 0;
nr_seq_origem_w			bigint;				

BEGIN 
 
vl_parametro_w := obter_param_usuario(cd_funcao_p, 454, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
ie_setor_agenda_prescr_w	:= consistir_setor_agenda_prescr(nr_seq_agenda_p, nr_prescricao_p, nr_sequencia_p);
cd_convenio_w	:= cd_convenio_p;
 
if (vl_parametro_w <> 'S')and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')and (ie_setor_agenda_prescr_w = 'S')then 
	begin 
	 
	ds_msg_erro_w		:= wheb_mensagem_pck.get_texto(313651);
	ie_continuar_exec_w	:= 'N';
	 
	end;
end if;
 
if (ie_continuar_exec_w = 'S')then 
	begin 
	 
	vl_parametro_w := obter_param_usuario(cd_funcao_p, 487, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);
	 
	if (vl_parametro_w = 'S')then 
		begin 
		 
		begin 
		select	coalesce(max(cd_setor_atendimento),0) 
		into STRICT	cd_setor_atend_prescr_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
		exception 
		when others then 
			cd_setor_atend_prescr_w := 0;
		end;
		 
		nr_seq_origem_w := coalesce((obter_dados_categ_conv(nr_atendimento_p,'OC'))::numeric ,0);
 
		SELECT * FROM glosa_procedimento(cd_estabelecimento_p, nr_atendimento_p, clock_timestamp(), cd_procedimento_p, ie_origem_proced_p, qt_procedimento_p, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, 0, nr_seq_exame_lab_p, nr_seq_proc_interno_p, null, null, null, null, null, null, cd_convenio_w, cd_categoria_w, ie_tipo_convenio_w, ie_classif_convenio_w, cd_autorizacao_w, nr_seq_autorizacao_w, qt_autorizada_w, cd_senha_w, nm_responsavel_w, ie_glosa_w, cd_situacao_glosa_w, nr_seq_regra_preco_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_preco_informado_w, vl_negociado_w, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_sequencia_w, null, null, null, null, null, null, null, cd_setor_atend_prescr_w, null, null, null, nr_seq_origem_w, null) INTO STRICT cd_convenio_w, cd_categoria_w, ie_tipo_convenio_w, ie_classif_convenio_w, cd_autorizacao_w, nr_seq_autorizacao_w, qt_autorizada_w, cd_senha_w, nm_responsavel_w, ie_glosa_w, cd_situacao_glosa_w, nr_seq_regra_preco_w, pr_glosa_w, vl_glosa_w, cd_motivo_exc_conta_w, ie_preco_informado_w, vl_negociado_w, ie_autor_particular_w, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_sequencia_w;
				  
		if (ie_glosa_w = 'G')then 
			begin 
			 
			ds_msg_aviso_w		:= wheb_mensagem_pck.get_texto(313652);
			ds_valor_particular_w	:= 	substr(cd_procedimento_p,1,15) || ' - '|| 
							substr(obter_descricao_procedimento(cd_procedimento_p, ie_origem_proced_p),1,40) || 
							', ' || wheb_mensagem_pck.get_texto(313653) || 
							substr(obter_valor_particular_proced(cd_estabelecimento_p, cd_procedimento_p, ie_origem_proced_p, ie_tipo_atendimento_p, 
							cd_medico_p, ie_clinica_p, nr_seq_proc_interno_p, nr_seq_exame_lab_p),1,20);
			 
			end;
		end if;
		 
		end;
	end if;
	 
	end;
end if;
 
commit;
 
ds_msg_erro_p		:= ds_msg_erro_w;
ds_msg_aviso_p		:= ds_msg_aviso_w;
ds_valor_particular_p	:= ds_valor_particular_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_proc_glosa_eup_js ( nr_seq_agenda_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_atendimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_medico_p bigint, ie_clinica_p text, nm_usuario_p text, cd_funcao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, cd_convenio_p bigint, ds_msg_erro_p INOUT text, ds_msg_aviso_p INOUT text, ds_valor_particular_p INOUT text) FROM PUBLIC;

