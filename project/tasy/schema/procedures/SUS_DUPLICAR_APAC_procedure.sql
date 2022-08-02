-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_duplicar_apac ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_mot_apac_obt_p bigint default null, ds_justificativa_p text default null, ds_erro_p INOUT text DEFAULT NULL) AS $body$
DECLARE


dt_competencia_w			timestamp;
nr_sequencia_w			bigint;
cd_procedimento_apac_w		bigint;
nr_interno_conta_w			bigint;
nr_interno_conta_ww		bigint;
nr_interno_conta_ant_w		bigint;
cd_medico_executor_w		varchar(10);
cd_cbo_w			varchar(6);
cd_cgc_prestador_w		varchar(14);
nr_nf_prestador_w			bigint;
cd_motivo_cobranca_w		smallint;
ie_dupla_competencia_w		varchar(1);
cd_estabelecimento_w		smallint;
cd_estab_usuario_w		smallint;
dt_competencia_ant_w		timestamp;
ie_duplicar_conta_w		varchar(10);
ie_proc_secundario_w		varchar(10);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
qt_procedimento_w			double precision;
nr_seq_propaci_w			bigint;
ie_recalcular_conta_w		varchar(15);
ie_verificar_ultima_apac_w		varchar(1);
nr_sequencia_ww			bigint;
ds_erro_w			varchar(255);
ie_alterar_data_proc_w		varchar(1) := 'N';
ie_manter_estab_orig_w		varchar(15) := 'S';
ie_reabre_atendimento_w		varchar(15) := 'N';
qt_atendimento_fechado_w		bigint := 0;

c01 CURSOR FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.qt_procedimento
	from	sus_laudo_proced_adic a,
		sus_laudo_paciente b
	where	a.nr_seq_laudo 	= b.nr_seq_interno
	and	b.nr_interno_conta	= nr_interno_conta_ant_w;

BEGIN

begin
cd_estab_usuario_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
exception
when others then
	cd_estab_usuario_w := 0;
end;

/*Geliard OS146643 07/07/2009*/

ie_dupla_competencia_w 		:= obter_valor_param_usuario(1124,41,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w);
ie_duplicar_conta_w		:= obter_valor_param_usuario(1124,46,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w);
ie_proc_secundario_w		:= obter_valor_param_usuario(1124,47,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w);
ie_recalcular_conta_w		:= coalesce(obter_valor_param_usuario(1124,49,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_verificar_ultima_apac_w	:= coalesce(obter_valor_param_usuario(1124,55,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_alterar_data_proc_w		:= coalesce(obter_valor_param_usuario(1124,78,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');
ie_manter_estab_orig_w		:= coalesce(obter_valor_param_usuario(1124,105,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'S');
ie_reabre_atendimento_w		:= coalesce(obter_valor_param_usuario(1124,110,obter_perfil_ativo,nm_usuario_p,cd_estab_usuario_w),'N');


select	coalesce(max(c.dt_competencia_apac),trunc(clock_timestamp(), 'mm')),
	max(a.cd_motivo_cobranca),
	max(a.cd_estabelecimento)
into STRICT	dt_competencia_w,
	cd_motivo_cobranca_w,
	cd_estabelecimento_w
from	sus_parametros_apac	c,
	atendimento_paciente	b,
	sus_apac_unif		a
where	a.nr_atendimento		= b.nr_atendimento
and	b.cd_estabelecimento	= c.cd_estabelecimento
and	a.nr_sequencia		= nr_sequencia_p;

if (coalesce(ie_manter_estab_orig_w,'S') = 'N') and (cd_estab_usuario_w > 0) then
	begin
	cd_estabelecimento_w := cd_estab_usuario_w;
	end;
end if;

if (ie_dupla_competencia_w = 'S') then
	begin
	select	max(dt_competencia)
	into STRICT	dt_competencia_ant_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;

	if (dt_competencia_w = dt_competencia_ant_w) then
		begin
		CALL wheb_mensagem_pck.exibir_mensagem_abort(205011);
		end;
	end if;

	end;
end if;

if (cd_motivo_cobranca_w in (21, 22, 23, 24, 25, 31, 26, 27, 28)) then
	if (ie_verificar_ultima_apac_w = 'S') then
		begin
		select	max(a.nr_sequencia)
		into STRICT	nr_sequencia_ww
		from	sus_apac_unif a
		where	a.nr_atendimento = nr_atendimento_p
		and	a.nr_apac = (	SELECT 	max(b.nr_apac)
					from	sus_apac_unif b
					where	b.nr_atendimento = nr_atendimento_p
					and	b.nr_sequencia	 = nr_sequencia_p);

		if (nr_sequencia_ww <> nr_sequencia_p) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(205012);
		end if;
		end;
	end if;
	
	if (coalesce(ie_reabre_atendimento_w,'N') = 'S') then
		begin
		select	count(*)
		into STRICT	qt_atendimento_fechado_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p
		and	(dt_fim_conta IS NOT NULL AND dt_fim_conta::text <> '');
	
		if (qt_atendimento_fechado_w > 0) then
			CALL Abrir_Atendimento(nr_atendimento_p,nm_usuario_p);
		end if;		
		end;
	end if;	

	select  nextval('sus_apac_unif_seq')
	into STRICT    nr_sequencia_w
	;

	insert into sus_apac_unif(
		nr_sequencia,
		nr_apac,
		cd_estabelecimento,
		nr_atendimento,
		cd_procedimento,
		ie_origem_proced,
		dt_competencia,
		dt_inicio_validade,
		dt_fim_validade,
		dt_emissao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_apac,
		cd_motivo_cobranca,
		cd_medico_responsavel,
		dt_solicitacao,
		cd_medico_autorizador,
		dt_autorizacao,
		nr_apac_anterior,
		dt_ocorrencia,
		cd_cid_principal,
		cd_cid_secundario,
		cd_cid_causa_assoc,
		nr_interno_conta,
		dt_inicio_tratamento,
		dt_diagnostico,
		cd_carater_internacao,
		cd_cid_topografia,
		cd_cid_primeiro_trat,
		cd_cid_segundo_trat,
		cd_cid_terceiro_trat,
		dt_pri_tratamento,
		dt_seg_tratamento,
		dt_ter_tratamento,
		ie_linfonodos_reg_inv,
		cd_estadio,
		cd_grau_histopat,
		dt_diag_cito_hist,
		ie_tratamento_ant,
		ie_finalidade,
		cd_cid_pri_radiacao,
		cd_cid_seg_radiacao,
		cd_cid_ter_radiacao,
		nr_campos_pri_radi,
		nr_campos_seg_radi,
		nr_campos_ter_radi,
		dt_inicio_pri_radi,
		dt_inicio_seg_radi,
		dt_inicio_ter_radi,
		dt_fim_pri_radi,
		dt_fim_seg_radi,
		dt_fim_ter_radi,
		ds_sigla_esquema,
		qt_meses_planejados,
		qt_meses_autorizados,
		dt_pri_dialise,
		qt_altura_cm,
		qt_peso,
		qt_diurese,
		qt_glicose,
		pr_albumina,
		pr_hb,
		ie_acesso_vascular,
		ie_hiv,
		ie_hcv,
		ie_hb_sangue,
		ie_ultra_abdomen,
		ie_continuidade_trat,
		qt_interv_fistola,
		ie_inscrito_cncdo,
		nr_tru,
		nr_seq_mot_apac_obt,
		ds_justificativa,
		nr_seq_pri_trat,
		nr_seq_seg_trat,
		nr_seq_ter_trat,
		qt_ureia_pos_hemo,
		qt_ureia_pre_hemo,
		dt_inicio_dialise_cli,
		ie_caract_tratamento,
		ie_acesso_vasc_dial,
		ie_acomp_nefrol,
		ie_situacao_usu_ini,
		ie_situacao_trasp,
		ie_dados_apto,
		qt_fosforo,
		qt_ktv_semanal,
		qt_pth,
		ie_inter_clinica,
		ie_peritonite_diag,
		ie_encaminhado_fav,
		ie_encam_imp_cateter,
		ie_situacao_vacina,
		ie_anti_hbs,
		ie_influenza,
		ie_difteria_tetano,
		ie_pneumococica,
		ie_ieca,
		ie_bra,
		ie_duplex_previo,
		ie_cateter_outros,
		ie_fav_previas,
		ie_flebites,
		ie_hematomas,
		ie_veia_visivel,
		ie_presenca_pulso,
		qt_diametro_veia,
		qt_diametro_arteria,
		ie_fremito_traj_fav,
		ie_pulso_fremito,
		qt_icm_atual_pac,
		pr_exces_peso_perd,
		qt_kilogr_perdido,
		ie_gastrec_desv_duode,
		ie_gastrec_vert_manga,
		ie_gastrec_deri_intes,
		ie_gastrec_vert_banda,
		dt_cirur_bariatrica,
		nr_aih_bariatrica,
		ie_comorbidades,
		ie_cid_i10,
		ie_cid_o243,
		ie_cid_e780,
		ie_cid_m190,
		ie_cid_g473,
		cd_cid_outro_comor,
		ie_reconst_microcir,
		qt_reconst_microcir,
		ie_dermo_abdominal,
		qt_dermo_abdominal,
		ie_mamoplastia,
		qt_mamoplastia,
		ie_dermo_braquial,
		qt_dermo_braquial,
		ie_dermo_crural,
		qt_dermo_crural,
		qt_meses_acompanha,
		qt_anos_acompanha,
		ie_uso_medicamento,
		ie_uso_polivitaminico,
		ie_pratica_ativ_fisica,
		ie_reganho_peso,
		ie_ades_alim_saud,
                cd_medic_antineo_1,
                cd_medic_antineo_2,
                cd_medic_antineo_3,
                cd_medic_antineo_4,
                cd_medic_antineo_5,
                cd_medic_antineo_6,
                cd_medic_antineo_7,
                cd_medic_antineo_8,
                cd_medic_antineo_9,
                cd_medic_antineo_10)
	SELECT	nr_sequencia_w,
		nr_apac,
		cd_estabelecimento_w,
		nr_atendimento_p,
		cd_procedimento,
		ie_origem_proced,
		dt_competencia_w,
		dt_inicio_validade,
		dt_fim_validade,
		dt_emissao,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		2,
		cd_motivo_cobranca,
		cd_medico_responsavel,
		dt_solicitacao,
		cd_medico_autorizador,
		dt_autorizacao,
		nr_apac_anterior,
		dt_ocorrencia,
		cd_cid_principal,
		cd_cid_secundario,
		cd_cid_causa_assoc,
		null,
		dt_inicio_tratamento,
		dt_diagnostico,
		cd_carater_internacao,
		cd_cid_topografia,
		cd_cid_primeiro_trat,
		cd_cid_segundo_trat,
		cd_cid_terceiro_trat,
		dt_pri_tratamento,
		dt_seg_tratamento,
		dt_ter_tratamento,
		ie_linfonodos_reg_inv,
		cd_estadio,
		cd_grau_histopat,
		dt_diag_cito_hist,
		ie_tratamento_ant,
		ie_finalidade,
		cd_cid_pri_radiacao,
		cd_cid_seg_radiacao,
		cd_cid_ter_radiacao,
		nr_campos_pri_radi,
		nr_campos_seg_radi,
		nr_campos_ter_radi,
		dt_inicio_pri_radi,
		dt_inicio_seg_radi,
		dt_inicio_ter_radi,
		dt_fim_pri_radi,
		dt_fim_seg_radi,
		dt_fim_ter_radi,
		ds_sigla_esquema,
		qt_meses_planejados,
		qt_meses_autorizados,
		dt_pri_dialise,
		qt_altura_cm,
		qt_peso,
		qt_diurese,
		qt_glicose,
		pr_albumina,
		pr_hb,
		ie_acesso_vascular,
		ie_hiv,
		ie_hcv,
		ie_hb_sangue,
		ie_ultra_abdomen,
		ie_continuidade_trat,
		qt_interv_fistola,
		ie_inscrito_cncdo,
		nr_tru,
		nr_seq_mot_apac_obt_p,
		ds_justificativa_p,
		nr_seq_pri_trat,
		nr_seq_seg_trat,
		nr_seq_ter_trat,
		qt_ureia_pos_hemo,
		qt_ureia_pre_hemo,
		dt_inicio_dialise_cli,
		ie_caract_tratamento,
		ie_acesso_vasc_dial,
		ie_acomp_nefrol,
		ie_situacao_usu_ini,
		ie_situacao_trasp,
		ie_dados_apto,
		qt_fosforo,
		qt_ktv_semanal,
		qt_pth,
		ie_inter_clinica,
		ie_peritonite_diag,
		ie_encaminhado_fav,
		ie_encam_imp_cateter,
		ie_situacao_vacina,
		ie_anti_hbs,
		ie_influenza,
		ie_difteria_tetano,
		ie_pneumococica,
		ie_ieca,
		ie_bra,
		ie_duplex_previo,
		ie_cateter_outros,
		ie_fav_previas,
		ie_flebites,
		ie_hematomas,
		ie_veia_visivel,
		ie_presenca_pulso,
		qt_diametro_veia,
		qt_diametro_arteria,
		ie_fremito_traj_fav,
		ie_pulso_fremito,
		qt_icm_atual_pac,
		pr_exces_peso_perd,
		qt_kilogr_perdido,
		ie_gastrec_desv_duode,
		ie_gastrec_vert_manga,
		ie_gastrec_deri_intes,
		ie_gastrec_vert_banda,
		dt_cirur_bariatrica,
		nr_aih_bariatrica,
		ie_comorbidades,
		ie_cid_i10,
		ie_cid_o243,
		ie_cid_e780,
		ie_cid_m190,
		ie_cid_g473,
		cd_cid_outro_comor,
		ie_reconst_microcir,
		qt_reconst_microcir,
		ie_dermo_abdominal,
		qt_dermo_abdominal,
		ie_mamoplastia,
		qt_mamoplastia,
		ie_dermo_braquial,
		qt_dermo_braquial,
		ie_dermo_crural,
		qt_dermo_crural,
		qt_meses_acompanha,
		qt_anos_acompanha,
		ie_uso_medicamento,
		ie_uso_polivitaminico,
		ie_pratica_ativ_fisica,
		ie_reganho_peso,
		ie_ades_alim_saud,
                cd_medic_antineo_1,
                cd_medic_antineo_2,
                cd_medic_antineo_3,
                cd_medic_antineo_4,
                cd_medic_antineo_5,
                cd_medic_antineo_6,
                cd_medic_antineo_7,
                cd_medic_antineo_8,
                cd_medic_antineo_9,
                cd_medic_antineo_10
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;

	if (ie_duplicar_conta_w = 'S') then
		begin
		begin
		select	nr_interno_conta
		into STRICT	nr_interno_conta_ww
		from	sus_apac_unif
		where	nr_sequencia	= nr_sequencia_p;
		exception
			when others then
			nr_interno_conta_ww := null;
			end;
		if 	not(coalesce(nr_interno_conta_ww::text, '') = '') then
			CALL duplicar_conta_paciente(nr_interno_conta_ww,nm_usuario_p);
		end if;
		end;
	end if;

	CALL sus_define_conta_apac(nr_atendimento_p, nr_sequencia_w, nm_usuario_p);
	ds_erro_w := sus_atualiza_proced_apac(nr_sequencia_w, nm_usuario_p, ds_erro_w);

	ds_erro_p := ds_erro_w;

	select	cd_procedimento,
		nr_interno_conta
	into STRICT	cd_procedimento_apac_w,
		nr_interno_conta_ant_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;

	begin
	select	nr_interno_conta
	into STRICT	nr_interno_conta_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_w;
	exception
		when others then
		nr_interno_conta_w	:= null;
	end;

	if	not(coalesce(nr_interno_conta_w::text, '') = '') then
		begin
		begin
		select	a.cd_medico_executor,
			a.cd_cbo,
			a.cd_cgc_prestador,
			a.nr_nf_prestador
		into STRICT	cd_medico_executor_w,
			cd_cbo_w,
			cd_cgc_prestador_w,
			nr_nf_prestador_w
		from	procedimento_paciente a
		where	a.cd_procedimento		= cd_procedimento_apac_w
		and	a.nr_interno_conta	= nr_interno_conta_ant_w
		and	a.nr_sequencia		= (	SELECT 	max(x.nr_sequencia)
							from	procedimento_paciente x
							where	x.cd_procedimento = a.cd_procedimento
							and	x.nr_interno_conta = a.nr_interno_conta)
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
		exception
			when others then
			cd_medico_executor_w	:= null;
			cd_cbo_w		:= null;
			cd_cgc_prestador_w	:= null;
			nr_nf_prestador_w	:= null;
		end;

		update	procedimento_paciente
		set	cd_medico_executor	= cd_medico_executor_w,
			cd_cbo			= cd_cbo_w,
			cd_cgc_prestador	= cd_cgc_prestador_w,
			nr_nf_prestador		= nr_nf_prestador_w
		where	nr_interno_conta	= nr_interno_conta_w
		and	cd_procedimento		= cd_procedimento_apac_w;
		
		if (ie_alterar_data_proc_w = 'S') then
			begin
			begin
			update	procedimento_paciente
			set	dt_procedimento		= dt_competencia_w
			where	nr_interno_conta	= nr_interno_conta_w;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(205013,'NR_INTERNO_CONTA_P='||nr_interno_conta_w||';DT_COMPETENCIA_P='||dt_competencia_w);
				/*Ocorreu um problema ao atualizar a data dos procedimentos da conta nr_interno_conta_w para dt_competencia_w. */

			end;
			end;
		end if;

		if (ie_proc_secundario_w = 'S') then
			begin
			open c01;
			loop
			fetch c01 into
				cd_procedimento_w,
				ie_origem_proced_w,
				qt_procedimento_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin

				select	nextval('procedimento_paciente_seq')
				into STRICT	nr_seq_propaci_w
				;

				begin
				insert into procedimento_paciente(
					nr_sequencia,
					nr_atendimento,
					dt_entrada_unidade,
					cd_procedimento,
					ie_origem_proced,
					dt_procedimento,
					qt_procedimento,
					dt_atualizacao,
					nm_usuario,
					cd_setor_atendimento,
					nr_seq_atepacu,
					nr_interno_conta,
					nr_seq_servico_classif,
					nr_seq_servico)
				SELECT	nr_seq_propaci_w,
					a.nr_atendimento,
					a.dt_entrada_unidade,
					cd_procedimento_w,
					ie_origem_proced_w,
					a.dt_procedimento,
					qt_procedimento_w,
					clock_timestamp(),
					nm_usuario_p,
					a.cd_setor_atendimento,
					a.nr_seq_atepacu,
					nr_interno_conta_w,
					nr_seq_servico_classif,
					nr_seq_servico
				from	procedimento_paciente a,
					sus_laudo_paciente b
				where	a.cd_procedimento 	= b.cd_procedimento_solic
				and	a.ie_origem_proced 	= b.ie_origem_proced
				and	a.nr_interno_conta 	= b.nr_interno_conta
				and	b.nr_interno_conta 	= nr_interno_conta_ant_w;
				exception
					when others then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(205014);
						/*Ocorreu um problema ao inserir registro na procedimento paciente.*/

					end;
				end;
			end loop;
			close c01;
			end;
		end if;

		if (ie_recalcular_conta_w = 'S') then
			CALL recalcular_conta_paciente(nr_interno_conta_w, nm_usuario_p);
		end if;

		end;
	end if;
else	
	ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(281129) || chr(13) ||
	'21, 22, 23, 24, 25, 31, 26, 27, 28.';
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_duplicar_apac ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_mot_apac_obt_p bigint default null, ds_justificativa_p text default null, ds_erro_p INOUT text DEFAULT NULL) FROM PUBLIC;

