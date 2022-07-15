-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_saida_temp_solic_data ( nr_atendimento_p atend_paciente_unidade.nr_atendimento%type, ie_opcao_p text default null, dt_entrada_unidade_p atend_paciente_unidade.dt_entrada_unidade%type default null, dt_movimentacao_p atend_paciente_unidade.dt_saida_temporaria%type default null, ds_motivo_temp_p atend_pac_un_log_mot_temp.ds_motivo_temp%type default null, ie_tipo_motivo_temp_p atend_pac_un_log_mot_temp.ie_tipo_motivo_temp%type default null, nr_seq_motivo_transf_pac atend_pac_un_log_mot_temp.nr_seq_motivo_transf_pac%type default null, dt_est_return_p atend_paciente_unidade.dt_est_return%type default null, dt_temp_leave_return_p atend_pac_un_log_mot_temp.dt_temp_leave_return%type default null, dt_final_jejum_p atend_pac_un_log_mot_temp.dt_final_jejum%type default null, nr_categoria_refeicao_fim_p atend_pac_un_log_mot_temp.nr_categoria_refeicao_fim%type default null) AS $body$
DECLARE

  /* ie_opcao_p = S - saida / R - retorno */


  -- Force recompile
dt_movimentacao_w	timestamp;
dt_saida_temporaria_w	timestamp;
ie_gerar_clinical_notes_w varchar(1) := 'N';
cd_evolucao_w                evolucao_paciente.cd_evolucao%type;
nr_seq_interno_w bigint;
 nr_sequencia_dieta_w   wocupacao_saida_temporaria.nr_sequencia_dieta%type;
 dt_inicio_jejum_w wocupacao_saida_temporaria.dt_inicio_jejum%type;



BEGIN
ie_gerar_clinical_notes_w := obter_param_usuario(281, 1598, Obter_perfil_ativo, obter_usuario_ativo, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_clinical_notes_w);

	if ( ie_gerar_clinical_notes_w = 'S') then
		select coalesce(max(nr_seq_interno),0)
		into STRICT nr_seq_interno_w
		from  atend_paciente_unidade
		where	nr_atendimento	= nr_atendimento_p
		and	trunc(dt_entrada_unidade) = trunc(dt_entrada_unidade_p);
	end if;

	if ((dt_movimentacao_p IS NOT NULL AND dt_movimentacao_p::text <> '') and (dt_est_return_p IS NOT NULL AND dt_est_return_p::text <> '') and dt_movimentacao_p > dt_est_return_p) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1127560, 'STARTDATE='|| obter_desc_expressao(286530, '') || ';ENDDATE=' || obter_desc_expressao(288771, ''));
	end if;
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	    if (ie_opcao_p = 'S') then
		update atend_paciente_unidade
		set dt_saida_temporaria		= dt_movimentacao_p,
		dt_retorno_saida_temporaria	 = NULL,
		nm_usuario			= coalesce(obter_usuario_ativo,nm_usuario),
		dt_atualizacao			= clock_timestamp(),
		dt_est_return			= dt_est_return_p
		where	nr_atendimento	= nr_atendimento_p
		and	dt_entrada_unidade = dt_entrada_unidade_p;
		insert	into atend_pac_un_log_mot_temp(nr_sequencia,
			nr_atendimento,
			dt_entrada_unidade, 
			dt_movimentacao, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			ds_motivo_temp, 
			ie_tipo_motivo_temp, 
			nr_seq_motivo_transf_pac,
			dt_est_return,
            dt_temp_leave_return,
            dt_final_jejum,
            nr_categoria_refeicao_fim
           )
		values (nextval('atend_pac_un_log_mot_temp_seq'),
			nr_atendimento_p,
			dt_entrada_unidade_p,
			dt_movimentacao_p,
			obter_usuario_ativo,
			clock_timestamp(),
			obter_usuario_ativo,
			clock_timestamp(),
			ds_motivo_temp_p,
			ie_tipo_motivo_temp_p,
			nr_seq_motivo_transf_pac,
			dt_est_return_p,
            dt_temp_leave_return_p,
            dt_final_jejum_p,
            nr_categoria_refeicao_fim_p);
		if (ie_gerar_clinical_notes_w = 'S') then
			cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_p, nr_seq_interno_w, 'TEMP_LEAVE', null, 'P', 1, cd_evolucao_w, ie_opcao_p);

			update atend_paciente_unidade
			set cd_evolucao = cd_evolucao_w
			where nr_seq_interno = nr_seq_interno_w
			and nr_atendimento = nr_atendimento_p;
        end if;

	    elsif (ie_opcao_p	= 'R') then
		select	max(dt_saida_temporaria)
		into STRICT	dt_saida_temporaria_w
		from	atend_paciente_unidade
		where	nr_atendimento	= nr_atendimento_p
		and dt_entrada_unidade = dt_entrada_unidade_p;
		if (dt_movimentacao_p = dt_saida_temporaria_w) then
			dt_movimentacao_w := dt_movimentacao_p + interval '1' second;
		else
			dt_movimentacao_w := dt_movimentacao_p;
		end if;
		update	atend_paciente_unidade
		set	dt_retorno_saida_temporaria = dt_movimentacao_w,
		nm_usuario	= coalesce(obter_usuario_ativo,nm_usuario),
		dt_atualizacao	= clock_timestamp()
		where nr_atendimento	= nr_atendimento_p
		and dt_entrada_unidade	= dt_entrada_unidade_p;

        
		insert	into atend_pac_un_log_mot_temp(nr_sequencia,
			nr_atendimento, 
			dt_entrada_unidade, 
			dt_movimentacao, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			ds_motivo_temp, 
			ie_tipo_motivo_temp, 
			nr_seq_motivo_transf_pac,
            dt_temp_leave_return,
            dt_final_jejum,
            nr_categoria_refeicao_fim)
		values (nextval('atend_pac_un_log_mot_temp_seq'),
		nr_atendimento_p,
		dt_entrada_unidade_p,
		dt_movimentacao_w,
		obter_usuario_ativo,
		clock_timestamp(),
		obter_usuario_ativo,
		clock_timestamp(),
		ds_motivo_temp_p,
		ie_tipo_motivo_temp_p,
		nr_seq_motivo_transf_pac,
        dt_temp_leave_return_p,
        dt_final_jejum_p,
        nr_categoria_refeicao_fim_p);

     select max(nr_sequencia_dieta),
     max(dt_inicio_jejum)
     into STRICT nr_sequencia_dieta_w,
     dt_inicio_jejum_w         
     from wocupacao_saida_temporaria 
    where nr_atendimento=nr_atendimento_p
    and coalesce(ie_sem_jejum,'N') <> 'S';

	if (dt_inicio_jejum_w  >  dt_final_jejum_p  and (nr_sequencia_dieta_w IS NOT NULL AND nr_sequencia_dieta_w::text <> '') )then  
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1127560, 'STARTDATE='|| obter_desc_expressao(286980) || ';ENDDATE=' || obter_desc_expressao(1067080));
	else

		update  wocupacao_saida_temporaria  
		set  dt_final_jejum = dt_final_jejum_p,
		nr_categoria_refeicao_fim =nr_categoria_refeicao_fim_p,
		nm_usuario =obter_usuario_ativo,
		dt_atualizacao=clock_timestamp()
		where nr_atendimento =nr_atendimento_p;

    end if;
   -- added
   
		if (ie_gerar_clinical_notes_w = 'S') then
        cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_p, nr_seq_interno_w, 'TEMP_LEAVE', null, 'P', 1, cd_evolucao_w, ie_opcao_p);

        update atend_paciente_unidade
        set cd_evolucao = cd_evolucao_w
        where nr_seq_interno = nr_seq_interno_w
        and nr_atendimento = nr_atendimento_p;
        end if;


    end if;
  end if;
  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_saida_temp_solic_data ( nr_atendimento_p atend_paciente_unidade.nr_atendimento%type, ie_opcao_p text default null, dt_entrada_unidade_p atend_paciente_unidade.dt_entrada_unidade%type default null, dt_movimentacao_p atend_paciente_unidade.dt_saida_temporaria%type default null, ds_motivo_temp_p atend_pac_un_log_mot_temp.ds_motivo_temp%type default null, ie_tipo_motivo_temp_p atend_pac_un_log_mot_temp.ie_tipo_motivo_temp%type default null, nr_seq_motivo_transf_pac atend_pac_un_log_mot_temp.nr_seq_motivo_transf_pac%type default null, dt_est_return_p atend_paciente_unidade.dt_est_return%type default null, dt_temp_leave_return_p atend_pac_un_log_mot_temp.dt_temp_leave_return%type default null, dt_final_jejum_p atend_pac_un_log_mot_temp.dt_final_jejum%type default null, nr_categoria_refeicao_fim_p atend_pac_un_log_mot_temp.nr_categoria_refeicao_fim%type default null) FROM PUBLIC;

