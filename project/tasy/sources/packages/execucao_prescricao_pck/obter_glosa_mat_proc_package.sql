-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE execucao_prescricao_pck.obter_glosa_mat_proc ( ie_tipo_item_p text, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, dt_atendimento_p timestamp, dt_procedimento_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, nr_seq_grupo_rec_p bigint, nr_sequencia_p bigint, qt_material_p INOUT bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_material_p INOUT bigint, cd_motivo_exc_out_p INOUT bigint, ie_glosa_out_p INOUT text) AS $body$
BEGIN

	if (ie_tipo_item_p = 'P') then
		
		select	max(ie_clinica)
		into STRICT	current_setting('execucao_prescricao_pck.ie_clinica_w')::atendimento_paciente.ie_clinica%type
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p;
		
		select	max(obter_dado_atend_cat_conv(nr_atendimento_p, dt_procedimento_p, cd_convenio_p, cd_categoria_p, 'P'))
		into STRICT	current_setting('execucao_prescricao_pck.cd_plano_conv_glosa_w')::atend_categoria_convenio.cd_plano_convenio%type
		;
		
		glosa_procedimento(
					wheb_usuario_pck.get_cd_estabelecimento,
					nr_atendimento_p,
					dt_procedimento_p,
					cd_procedimento_p,
					ie_origem_proced_p,
					qt_procedimento_p,
					0,
					ie_tipo_atendimento_p,
					0,
					nr_seq_exame_p,
					nr_seq_proc_interno_p,
					null,
					current_setting('execucao_prescricao_pck.cd_plano_conv_glosa_w')::atend_categoria_convenio.cd_plano_convenio%type,
					current_setting('execucao_prescricao_pck.ie_clinica_w')::atendimento_paciente.ie_clinica%type,
					null,
					null,
					null,
					cd_convenio_p,
					cd_categoria_p,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					ie_glosa_out_p,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					cd_motivo_exc_out_p,
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),
					current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					nr_seq_grupo_rec_p,
					null,
					substr(obter_dados_categ_conv(nr_atendimento_p, 'OC'),1,10),
					null);

	else
		glosa_material(
			wheb_usuario_pck.get_cd_estabelecimento,	-- cd_estabelecimento_p
			nr_atendimento_p,       			-- nr_atendimento_p
			dt_atendimento_p,       			-- dt_atendimento_p
			cd_material_p,          			-- cd_material_p
			qt_material_p,          			-- qt_material_p
			0,                      			-- cd_tipo_acomodacao_p
			ie_tipo_atendimento_p,  			-- ie_tipo_atendimento_p
			0,                      			-- cd_setor_atendimento_p
			null,                   			-- qt_idade_p
			null,                   			-- cd_proc_referencia_p
			null,                   			-- ie_origem_proced_p
			nr_sequencia_p,         			-- nr_sequencia_p
			0,                      			-- nr_seq_proc_interno_p
			cd_convenio_p,  		  			-- cd_convenio_p     	 in
			cd_categoria_p,   					-- cd_categoria_p    	 in
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,      			-- ie_tipo_convenio_p	 out
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),      			-- ie_classif_convenio_p out
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),      			-- cd_autorizacao_p    	 out
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,      			-- nr_seq_autorizacao_p  out
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,      			-- qt_autorizada_p    	 out
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),      			-- cd_senha_p    	 out
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),      			-- nm_responsavel_p    	 out
			ie_glosa_out_p,         			-- ie_glosa_p		 out
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,      			-- cd_situacao_glosa_p	 out
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,      			-- pr_glosa_p		 out
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,				-- vl_glosa_p		 out
			cd_motivo_exc_out_p,                    	-- cd_motivo_exc_conta_p out 
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),                      	-- ie_autor_particular_p out 
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,                      	-- cd_convenio_glosa_p	 out 
			current_setting('execucao_prescricao_pck.ds_sem_ret_proc_w')::varchar(255),                      	-- cd_categoria_glosa_p	 out 
			current_setting('execucao_prescricao_pck.nr_sem_ret_proc_w')::bigint,                      	-- nr_seq_regra_ajuste_p out 
			null);                                  	-- nr_seq_orcamento_p	 in
	end if;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE execucao_prescricao_pck.obter_glosa_mat_proc ( ie_tipo_item_p text, nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, dt_atendimento_p timestamp, dt_procedimento_p timestamp, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, nr_seq_grupo_rec_p bigint, nr_sequencia_p bigint, qt_material_p INOUT bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_material_p INOUT bigint, cd_motivo_exc_out_p INOUT bigint, ie_glosa_out_p INOUT text) FROM PUBLIC;