-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_w_esus_ate_odont ( nr_seq_lote_p esus_lote_envio.nr_sequencia%type, ie_tipo_lote_esus_p esus_lote_envio.ie_tipo_lote_esus%type, cd_cnes_estab_p estabelecimento.cd_cns%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


cd_cns_paciente_w			w_esus_atend_odontolog.cd_cns_paciente%type;				
dt_nascimento_paciente_w		w_esus_atend_odontolog.dt_nascimento_paciente%type;					
ie_sexo_paciente_w			w_esus_atend_odontolog.ie_sexo_paciente%type;
cd_cns_profissional_w			w_esus_atend_odontolog.cd_cns_profissional%type;
nr_seq_exp_w				w_esus_atend_odontolog.nr_sequencia%type;
cd_uuid_original_w			w_esus_atend_odontolog.cd_uuid_original%type;
nr_data_atendimento_w    		w_esus_atend_odontolog.nr_data_atendimento%type;
nr_data_fim_atendimento_w    		w_esus_atend_odontolog.nr_data_fim_atendimento%type;
nr_atendimento_w  			w_esus_atend_odontolog.nr_atendimento%type;
ie_alta_episodio_w			w_esus_atend_odontolog.ie_alta_episodio%type;
nr_data_nasc_paciente_w			w_esus_atend_odontolog.nr_data_nasc_paciente%type;
cd_cns_sec_prof_w			w_esus_atend_odontolog.cd_cns_sec_prof%type;
cd_cns_ter_prof_w			w_esus_atend_odontolog.cd_cns_ter_prof%type;

nr_sequencia_w				esus_atend_odontolog.nr_sequencia%type;
cd_estabelecimento_w			esus_atend_odontolog.cd_estabelecimento%type;
dt_atualizacao_w			esus_atend_odontolog.dt_atualizacao%type;
nm_usuario_w				esus_atend_odontolog.nm_usuario%type;
dt_atualizacao_nrec_w			esus_atend_odontolog.dt_atualizacao_nrec%type;
nm_usuario_nrec_w			esus_atend_odontolog.nm_usuario_nrec%type;
dt_liberacao_w				esus_atend_odontolog.dt_liberacao%type;
cd_pri_profissional_w			esus_atend_odontolog.cd_pri_profissional%type;
cd_sec_profissional_w			esus_atend_odontolog.cd_sec_profissional%type;
cd_ter_profissional_w			esus_atend_odontolog.cd_ter_profissional%type;
cd_pri_cbo_w				esus_atend_odontolog.cd_pri_cbo%type;
cd_sec_cbo_w				esus_atend_odontolog.cd_sec_cbo%type;
cd_ter_cbo_w				esus_atend_odontolog.cd_ter_cbo%type;
cd_cnes_unidade_w			esus_atend_odontolog.cd_cnes_unidade%type;
cd_cnes_unidade_ww			esus_atend_odontolog.cd_cnes_unidade%type;
nr_seq_sus_equipe_w			esus_atend_odontolog.nr_seq_sus_equipe%type;
dt_atendimento_w			esus_atend_odontolog.dt_atendimento%type;
dt_final_atendimento_w			esus_atend_odontolog.dt_final_atendimento%type;
cd_pessoa_fisica_w			esus_atend_odontolog.cd_pessoa_fisica%type;
ie_turno_w				esus_atend_odontolog.ie_turno%type;
nr_prontuario_w				esus_atend_odontolog.nr_prontuario%type;
ie_local_atendimento_w			esus_atend_odontolog.ie_local_atendimento%type;
ie_paciente_nec_espe_w			esus_atend_odontolog.ie_paciente_nec_espe%type;
ie_tipo_atendimento_w			esus_atend_odontolog.ie_tipo_atendimento%type;
ie_gestante_w				esus_atend_odontolog.ie_gestante%type;
ie_tipo_consulta_w			esus_atend_odontolog.ie_tipo_consulta%type;
ie_abscesso_den_alve_w			esus_atend_odontolog.ie_abscesso_den_alve%type;
ie_alteracao_tec_mol_w			esus_atend_odontolog.ie_alteracao_tec_mol%type;
ie_dor_dente_w				esus_atend_odontolog.ie_dor_dente%type;
ie_fenda_labio_palat_w			esus_atend_odontolog.ie_fenda_labio_palat%type;
ie_fluorose_dentaria_w			esus_atend_odontolog.ie_fluorose_dentaria%type;
ie_trauma_dento_alve_w			esus_atend_odontolog.ie_trauma_dento_alve%type;
ie_nao_identificado_w			esus_atend_odontolog.ie_nao_identificado%type;
qt_acesso_polpa_dent_w			esus_atend_odontolog.qt_acesso_polpa_dent%type;
qt_adapt_prot_dentar_w			esus_atend_odontolog.qt_adapt_prot_dentar%type;
qt_aplica_cariostati_w			esus_atend_odontolog.qt_aplica_cariostati%type;
qt_aplicacao_selante_w			esus_atend_odontolog.qt_aplicacao_selante%type;
qt_aplica_topi_fluor_w			esus_atend_odontolog.qt_aplica_topi_fluor%type;
qt_capeamento_pulpar_w			esus_atend_odontolog.qt_capeamento_pulpar%type;
qt_cimentacao_protes_w			esus_atend_odontolog.qt_cimentacao_protes%type;
qt_cur_dem_sem_prepa_w			esus_atend_odontolog.qt_cur_dem_sem_prepa%type;
qt_drenagem_abscesso_w			esus_atend_odontolog.qt_drenagem_abscesso%type;
qt_eviden_placa_bact_w			esus_atend_odontolog.qt_eviden_placa_bact%type;
qt_exodontia_deciduo_w			esus_atend_odontolog.qt_exodontia_deciduo%type;
qt_exodontia_permant_w			esus_atend_odontolog.qt_exodontia_permant%type;
qt_inst_protese_dent_w			esus_atend_odontolog.qt_inst_protese_dent%type;
qt_moldagem_den_geng_w			esus_atend_odontolog.qt_moldagem_den_geng%type;
qt_orientacao_higien_w			esus_atend_odontolog.qt_orientacao_higien%type;
qt_profil_placa_bact_w			esus_atend_odontolog.qt_profil_placa_bact%type;
qt_pulpotomia_dentar_w			esus_atend_odontolog.qt_pulpotomia_dentar%type;
qt_radiog_periap_int_w			esus_atend_odontolog.qt_radiog_periap_int%type;
qt_rasp_alis_pol_sup_w			esus_atend_odontolog.qt_rasp_alis_pol_sup%type;
qt_raspa_alisa_subge_w			esus_atend_odontolog.qt_raspa_alisa_subge%type;
qt_resta_dente_decid_w			esus_atend_odontolog.qt_resta_dente_decid%type;
qt_rest_den_anterior_w			esus_atend_odontolog.qt_rest_den_anterior%type;
qt_res_den_posterior_w			esus_atend_odontolog.qt_res_den_posterior%type;
qt_ret_ponto_cir_bas_w			esus_atend_odontolog.qt_ret_ponto_cir_bas%type;
qt_sela_pro_cav_dent_w			esus_atend_odontolog.qt_sela_pro_cav_dent%type;
qt_tratamento_alveol_w			esus_atend_odontolog.qt_tratamento_alveol%type;
qt_ulotomia_ulectomi_w			esus_atend_odontolog.qt_ulotomia_ulectomi%type;
ie_fornec_escova_den_w			esus_atend_odontolog.ie_fornec_escova_den%type;
ie_fornec_creme_dent_w			esus_atend_odontolog.ie_fornec_creme_dent%type;
ie_fornec_fio_dental_w			esus_atend_odontolog.ie_fornec_fio_dental%type;
ie_ret_consulta_agen_w			esus_atend_odontolog.ie_ret_consulta_agen%type;
ie_agenda_outro_prof_w			esus_atend_odontolog.ie_agenda_outro_prof%type;
ie_agendamento_nasf_w			esus_atend_odontolog.ie_agendamento_nasf%type;
ie_agendamento_grupo_w			esus_atend_odontolog.ie_agendamento_grupo%type;
ie_tratame_concluido_w			esus_atend_odontolog.ie_tratame_concluido%type;
ie_enc_atend_nec_esp_w			esus_atend_odontolog.ie_enc_atend_nec_esp%type;
ie_enca_cirurgia_bmf_w			esus_atend_odontolog.ie_enca_cirurgia_bmf%type;
ie_encami_endodontia_w			esus_atend_odontolog.ie_encami_endodontia%type;
ie_enc_estinatologia_w			esus_atend_odontolog.ie_enc_estinatologia%type;
ie_enc_implantodonti_w			esus_atend_odontolog.ie_enc_implantodonti%type;
ie_enc_odontoperiatr_w			esus_atend_odontolog.ie_enc_odontoperiatr%type;
ie_enc_ortod_ortoped_w			esus_atend_odontolog.ie_enc_ortod_ortoped%type;
ie_encam_periodontia_w			esus_atend_odontolog.ie_encam_periodontia%type;
ie_enc_prot_dentaria_w			esus_atend_odontolog.ie_enc_prot_dentaria%type;
ie_encami_radiologia_w			esus_atend_odontolog.ie_encami_radiologia%type;
ie_encaminham_outros_w			esus_atend_odontolog.ie_encaminham_outros%type;
nr_seq_lote_envio_w			esus_atend_odontolog.nr_seq_lote_envio%type;

cd_contra_chave_rem_w		w_esus_header_footer.cd_contra_chave_rem%type;
cd_uuid_instal_rem_w		w_esus_header_footer.cd_uuid_instal_rem%type;
cd_contra_chave_ori_w		w_esus_header_footer.cd_contra_chave_ori%type;
cd_uuid_instal_orig_w		w_esus_header_footer.cd_uuid_instal_orig%type;
cd_municipio_ibge_ww		w_esus_header_footer.cd_municipio_ibge%type;

AteOdon CURSOR FOR
	SELECT 	nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_liberacao,
		cd_pri_profissional,
		cd_sec_profissional,
		cd_ter_profissional,
		cd_pri_cbo,
		cd_sec_cbo,
		cd_ter_cbo,
		cd_cnes_unidade,
		nr_seq_sus_equipe,
		dt_atendimento,
		dt_final_atendimento,
		cd_pessoa_fisica,
		ie_turno,
		nr_prontuario,
		ie_local_atendimento,
		ie_paciente_nec_espe,
		ie_tipo_atendimento,
		ie_gestante,
		ie_tipo_consulta,
		ie_abscesso_den_alve,
		ie_alteracao_tec_mol,
		ie_dor_dente,
		ie_fenda_labio_palat,
		ie_fluorose_dentaria,
		ie_trauma_dento_alve,
		ie_nao_identificado,
		qt_acesso_polpa_dent,
		qt_adapt_prot_dentar,
		qt_aplica_cariostati,
		qt_aplicacao_selante,
		qt_aplica_topi_fluor,
		qt_capeamento_pulpar,
		qt_cimentacao_protes,
		qt_cur_dem_sem_prepa,
		qt_drenagem_abscesso,
		qt_eviden_placa_bact,
		qt_exodontia_deciduo,
		qt_exodontia_permant,
		qt_inst_protese_dent,
		qt_moldagem_den_geng,
		qt_orientacao_higien,
		qt_profil_placa_bact,
		qt_pulpotomia_dentar,
		qt_radiog_periap_int,
		qt_rasp_alis_pol_sup,
		qt_raspa_alisa_subge,
		qt_resta_dente_decid,
		qt_rest_den_anterior,
		qt_res_den_posterior,
		qt_ret_ponto_cir_bas,
		qt_sela_pro_cav_dent,
		qt_tratamento_alveol,
		qt_ulotomia_ulectomi,
		ie_fornec_escova_den,
		ie_fornec_creme_dent,
		ie_fornec_fio_dental,
		ie_ret_consulta_agen,
		ie_agenda_outro_prof,
		ie_agendamento_nasf,
		ie_agendamento_grupo,
		ie_tratame_concluido,
		ie_enc_atend_nec_esp,
		ie_enca_cirurgia_bmf,
		ie_encami_endodontia,
		ie_enc_estinatologia,
		ie_enc_implantodonti,
		ie_enc_odontoperiatr,
		ie_enc_ortod_ortoped,
		ie_encam_periodontia,
		ie_enc_prot_dentaria,
		ie_encami_radiologia,
		ie_encaminham_outros,
		nr_seq_lote_envio,
		cd_uuid_original,
		nr_atendimento,
		ie_alta_episodio
	from	esus_atend_odontolog
	where	nr_seq_lote_envio =	nr_seq_lote_p
	order by nr_sequencia;

	
AteOdonProc CURSOR FOR
	SELECT 	nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		qt_procedimento,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_atend_onco
	from 	esus_atend_odon_proced
	where	nr_seq_atend_onco = nr_sequencia_w;

AteOdonProc_w			AteOdonProc%rowtype;
	
type 		fetch_array is table of AteOdon%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_AteOdon_w			vetor;

	
BEGIN

delete 	from w_esus_atend_odontolog
where	nr_seq_lote_envio = nr_seq_lote_p;

delete 	from w_esus_atend_odon_proced
where	nr_seq_lote_envio = nr_seq_lote_p;

open AteOdon;
loop
fetch AteOdon bulk collect into s_array limit 1000;
	vetor_AteOdon_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on AteOdon */
end loop;
close AteOdon;


for i in 1..vetor_AteOdon_w.count loop
	begin
	s_array := vetor_AteOdon_w(i);
	for z in 1..s_array.count loop
		begin
		
		nr_sequencia_w				:= s_array[z].nr_sequencia;
		cd_estabelecimento_w			:= s_array[z].cd_estabelecimento;
		dt_atualizacao_w			:= s_array[z].dt_atualizacao;
		nm_usuario_w				:= s_array[z].nm_usuario;
		dt_atualizacao_nrec_w			:= s_array[z].dt_atualizacao_nrec;
		nm_usuario_nrec_w			:= s_array[z].nm_usuario_nrec;
		dt_liberacao_w				:= s_array[z].dt_liberacao;
		cd_pri_profissional_w			:= s_array[z].cd_pri_profissional;
		cd_sec_profissional_w			:= s_array[z].cd_sec_profissional;
		cd_ter_profissional_w			:= s_array[z].cd_ter_profissional;
		cd_pri_cbo_w				:= s_array[z].cd_pri_cbo;
		cd_sec_cbo_w				:= s_array[z].cd_sec_cbo;
		cd_ter_cbo_w				:= s_array[z].cd_ter_cbo;
		cd_cnes_unidade_w			:= s_array[z].cd_cnes_unidade;
		nr_seq_sus_equipe_w			:= s_array[z].nr_seq_sus_equipe;
		dt_atendimento_w			:= s_array[z].dt_atendimento;
		dt_final_atendimento_w			:= s_array[z].dt_final_atendimento;
		cd_pessoa_fisica_w			:= s_array[z].cd_pessoa_fisica;
		ie_turno_w				:= s_array[z].ie_turno;
		nr_prontuario_w				:= s_array[z].nr_prontuario;
		ie_local_atendimento_w			:= s_array[z].ie_local_atendimento;
		ie_paciente_nec_espe_w			:= s_array[z].ie_paciente_nec_espe;
		ie_tipo_atendimento_w			:= s_array[z].ie_tipo_atendimento;
		ie_gestante_w				:= s_array[z].ie_gestante;
		ie_tipo_consulta_w			:= s_array[z].ie_tipo_consulta;
		ie_abscesso_den_alve_w			:= s_array[z].ie_abscesso_den_alve;
		ie_alteracao_tec_mol_w			:= s_array[z].ie_alteracao_tec_mol;
		ie_dor_dente_w				:= s_array[z].ie_dor_dente;
		ie_fenda_labio_palat_w			:= s_array[z].ie_fenda_labio_palat;
		ie_fluorose_dentaria_w			:= s_array[z].ie_fluorose_dentaria;
		ie_trauma_dento_alve_w			:= s_array[z].ie_trauma_dento_alve;
		ie_nao_identificado_w			:= s_array[z].ie_nao_identificado;
		qt_acesso_polpa_dent_w			:= s_array[z].qt_acesso_polpa_dent;
		qt_adapt_prot_dentar_w			:= s_array[z].qt_adapt_prot_dentar;
		qt_aplica_cariostati_w			:= s_array[z].qt_aplica_cariostati;
		qt_aplicacao_selante_w			:= s_array[z].qt_aplicacao_selante;
		qt_aplica_topi_fluor_w			:= s_array[z].qt_aplica_topi_fluor;
		qt_capeamento_pulpar_w			:= s_array[z].qt_capeamento_pulpar;
		qt_cimentacao_protes_w			:= s_array[z].qt_cimentacao_protes;
		qt_cur_dem_sem_prepa_w			:= s_array[z].qt_cur_dem_sem_prepa;
		qt_drenagem_abscesso_w			:= s_array[z].qt_drenagem_abscesso;
		qt_eviden_placa_bact_w			:= s_array[z].qt_eviden_placa_bact;
		qt_exodontia_deciduo_w			:= s_array[z].qt_exodontia_deciduo;
		qt_exodontia_permant_w			:= s_array[z].qt_exodontia_permant;
		qt_inst_protese_dent_w			:= s_array[z].qt_inst_protese_dent;
		qt_moldagem_den_geng_w			:= s_array[z].qt_moldagem_den_geng;
		qt_orientacao_higien_w			:= s_array[z].qt_orientacao_higien;
		qt_profil_placa_bact_w			:= s_array[z].qt_profil_placa_bact;
		qt_pulpotomia_dentar_w			:= s_array[z].qt_pulpotomia_dentar;
		qt_radiog_periap_int_w			:= s_array[z].qt_radiog_periap_int;
		qt_rasp_alis_pol_sup_w			:= s_array[z].qt_rasp_alis_pol_sup;
		qt_raspa_alisa_subge_w			:= s_array[z].qt_raspa_alisa_subge;
		qt_resta_dente_decid_w			:= s_array[z].qt_resta_dente_decid;
		qt_rest_den_anterior_w			:= s_array[z].qt_rest_den_anterior;
		qt_res_den_posterior_w			:= s_array[z].qt_res_den_posterior;
		qt_ret_ponto_cir_bas_w			:= s_array[z].qt_ret_ponto_cir_bas;
		qt_sela_pro_cav_dent_w			:= s_array[z].qt_sela_pro_cav_dent;
		qt_tratamento_alveol_w			:= s_array[z].qt_tratamento_alveol;
		qt_ulotomia_ulectomi_w			:= s_array[z].qt_ulotomia_ulectomi;
		ie_fornec_escova_den_w			:= s_array[z].ie_fornec_escova_den;
		ie_fornec_creme_dent_w			:= s_array[z].ie_fornec_creme_dent;
		ie_fornec_fio_dental_w			:= s_array[z].ie_fornec_fio_dental;
		ie_ret_consulta_agen_w			:= s_array[z].ie_ret_consulta_agen;
		ie_agenda_outro_prof_w			:= s_array[z].ie_agenda_outro_prof;
		ie_agendamento_nasf_w			:= s_array[z].ie_agendamento_nasf;
		ie_agendamento_grupo_w			:= s_array[z].ie_agendamento_grupo;
		ie_tratame_concluido_w			:= s_array[z].ie_tratame_concluido;
		ie_enc_atend_nec_esp_w			:= s_array[z].ie_enc_atend_nec_esp;
		ie_enca_cirurgia_bmf_w			:= s_array[z].ie_enca_cirurgia_bmf;
		ie_encami_endodontia_w			:= s_array[z].ie_encami_endodontia;
		ie_enc_estinatologia_w			:= s_array[z].ie_enc_estinatologia;
		ie_enc_implantodonti_w			:= s_array[z].ie_enc_implantodonti;
		ie_enc_odontoperiatr_w			:= s_array[z].ie_enc_odontoperiatr;
		ie_enc_ortod_ortoped_w			:= s_array[z].ie_enc_ortod_ortoped;
		ie_encam_periodontia_w			:= s_array[z].ie_encam_periodontia;
		ie_enc_prot_dentaria_w			:= s_array[z].ie_enc_prot_dentaria;
		ie_encami_radiologia_w			:= s_array[z].ie_encami_radiologia;
		ie_encaminham_outros_w			:= s_array[z].ie_encaminham_outros;
		nr_seq_lote_envio_w			:= s_array[z].nr_seq_lote_envio;
		cd_uuid_original_w			:= s_array[z].cd_uuid_original;
		nr_atendimento_w			:= s_array[z].nr_atendimento;
		ie_alta_episodio_w			:= s_array[z].ie_alta_episodio;
		
		if (coalesce(cd_pessoa_fisica_w,'X') <> 'X') then
			begin
			cd_cns_paciente_w		:= substr(obter_dados_pf(cd_pessoa_fisica_w,'CNS'),1,20);
			dt_nascimento_paciente_w	:= to_date(substr(obter_dados_pf(cd_pessoa_fisica_w,'DN'),1,10),'dd/mm/yyyy');
			ie_sexo_paciente_w		:= substr(sus_gerar_depara_esus(obter_dados_pf(cd_pessoa_fisica_w,'SE'),'SEXO'),1,20);
			end;
		end if;	
		
		cd_cns_profissional_w	:= substr(coalesce(obter_dados_pf(cd_pri_profissional_w,'CNS'),''),1,15);
		cd_cns_sec_prof_w	:= substr(coalesce(obter_dados_pf(cd_sec_profissional_w,'CNS'),''),1,15);
		cd_cns_ter_prof_w	:= substr(coalesce(obter_dados_pf(cd_ter_profissional_w,'CNS'),''),1,15);

		if (ie_sexo_paciente_w <> '1') then
			ie_gestante_w := '';
		end if;
			
		select	nextval('w_esus_atend_odontolog_seq')
		into STRICT	nr_seq_exp_w
		;		
		
		if (dt_nascimento_paciente_w IS NOT NULL AND dt_nascimento_paciente_w::text <> '') then
			nr_data_nasc_paciente_w := ((dt_nascimento_paciente_w - to_date('01/01/1970 00:00:00','dd/mm/yyyy hh24:mi:ss')) * 86400);
		else
			nr_data_nasc_paciente_w := null;
		end if;
		
		if (dt_atendimento_w IS NOT NULL AND dt_atendimento_w::text <> '') then
			nr_data_atendimento_w	:= rpad(((dt_atendimento_w - to_date('01/01/1970 00:00:00','dd/mm/yyyy hh24:mi:ss')) * 86400),13,0);
		else
			nr_data_atendimento_w	:= null;
		end if;
		
		if (dt_final_atendimento_w IS NOT NULL AND dt_final_atendimento_w::text <> '') then
			nr_data_fim_atendimento_w	:= rpad(((dt_final_atendimento_w - to_date('01/01/1970 00:00:00','dd/mm/yyyy hh24:mi:ss')) * 86400),13,0);
		else
			nr_data_fim_atendimento_w	:= null;
		end if;
		
		if (coalesce(ie_local_atendimento_w,'99') in ('11','12','13','14')) then
			ie_local_atendimento_w	:= '';
		end if;

		if (ie_tipo_atendimento_w	= '4') then
			ie_tipo_consulta_w	:= '';
		elsif (ie_tipo_atendimento_w	= '6') and (ie_tipo_consulta_w	= 'R') then
			ie_tipo_consulta_w	:= '';
		end if;

		if (coalesce(ie_tipo_consulta_w,'X') in ('P','M')) then
			ie_alta_episodio_w	:= '';
		else
			ie_tratame_concluido_w	:= '';
		end if;
		
		select	coalesce(max(cd_cnes_unidade),'0')
		into STRICT	cd_cnes_unidade_ww
		from	w_esus_header_footer
		where	nr_seq_lote_envio = nr_seq_lote_p;
		
		if (cd_cnes_unidade_w <> cd_cnes_unidade_ww) then
			begin
			cd_contra_chave_rem_w	:= substr(sus_gerar_uuid_esus(cd_cnes_unidade_w,'C'),1,50);
			cd_uuid_instal_rem_w	:= substr(sus_gerar_uuid_esus(cd_cnes_unidade_w,'U'),1,50);
			cd_contra_chave_ori_w	:= cd_contra_chave_rem_w;
			cd_uuid_instal_orig_w	:= cd_uuid_instal_rem_w;			
			cd_municipio_ibge_ww	:= sus_obter_dados_equipe(nr_seq_sus_equipe_w,'CM');
			cd_municipio_ibge_ww	:= substr(cd_municipio_ibge_ww||Calcula_Digito('MODULO10',cd_municipio_ibge_ww),1,7);
			
			update 	w_esus_header_footer
			set 	cd_cnes_unidade = cd_cnes_unidade_w,
				cd_cnes_serealizado = cd_cnes_unidade_w,
				cd_contra_chave_rem = cd_contra_chave_rem_w,
				cd_uuid_instal_rem = cd_uuid_instal_rem_w,
				cd_contra_chave_ori = cd_contra_chave_ori_w,
				cd_uuid_instal_orig = cd_uuid_instal_orig_w,
				cd_municipio_ibge = cd_municipio_ibge_ww
			where	nr_seq_lote_envio = nr_seq_lote_p;
			
			end;
		end if;	

		if (coalesce(cd_uuid_original_w,'X') = 'X')  then
			cd_uuid_original_w := coalesce(sus_gerar_uuid_esus(cd_cnes_unidade_w,'U'),'0');
			update esus_atend_odontolog set cd_uuid_original = cd_uuid_original_w where  nr_sequencia = nr_sequencia_w;
		end if;	

		insert into w_esus_atend_odontolog(nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_pri_profissional,
						cd_sec_profissional,
						cd_ter_profissional,
						cd_pri_cbo,
						cd_sec_cbo,
						cd_ter_cbo,
						nr_seq_sus_equipe,
						dt_atendimento,
						dt_final_atendimento,
						cd_pessoa_fisica,
						ie_turno,
						nr_prontuario,
						ie_local_atendimento,
						ie_paciente_nec_espe,
						ie_tipo_atendimento,
						ie_gestante,
						ie_tipo_consulta,
						ie_abscesso_den_alve,
						ie_alteracao_tec_mol,
						ie_dor_dente,
						ie_fenda_labio_palat,
						ie_fluorose_dentaria,
						ie_trauma_dento_alve,
						ie_nao_identificado,
						qt_acesso_polpa_dent,
						qt_adapt_prot_dentar,
						qt_aplica_cariostati,
						qt_aplicacao_selante,
						qt_aplica_topi_fluor,
						qt_capeamento_pulpar,
						qt_cimentacao_protes,
						qt_cur_dem_sem_prepa,
						qt_drenagem_abscesso,
						qt_eviden_placa_bact,
						qt_exodontia_deciduo,
						qt_exodontia_permant,
						qt_inst_protese_dent,
						qt_moldagem_den_geng,
						qt_orientacao_higien,
						qt_profil_placa_bact,
						qt_pulpotomia_dentar,
						qt_radiog_periap_int,
						qt_rasp_alis_pol_sup,
						qt_raspa_alisa_subge,
						qt_resta_dente_decid,
						qt_rest_den_anterior,
						qt_res_den_posterior,
						qt_ret_ponto_cir_bas,
						qt_sela_pro_cav_dent,
						qt_tratamento_alveol,
						qt_ulotomia_ulectomi,
						cd_acesso_polpa_dent,
						cd_adapt_prot_dentar,
						cd_aplica_cariostati,
						cd_aplicacao_selante,
						cd_aplica_topi_fluor,
						cd_capeamento_pulpar,
						cd_cimentacao_protes,
						cd_cur_dem_sem_prepa,
						cd_drenagem_abscesso,
						cd_eviden_placa_bact,
						cd_exodontia_deciduo,
						cd_exodontia_permant,
						cd_inst_protese_dent,
						cd_moldagem_den_geng,
						cd_orientacao_higien,
						cd_profil_placa_bact,
						cd_pulpotomia_dentar,
						cd_radiog_periap_int,
						cd_rasp_alis_pol_sup,
						cd_raspa_alisa_subge,
						cd_resta_dente_decid,
						cd_rest_den_anterior,
						cd_res_den_posterior,
						cd_ret_ponto_cir_bas,
						cd_sela_pro_cav_dent,
						cd_tratamento_alveol,
						cd_ulotomia_ulectomi,
						ie_fornec_escova_den,
						ie_fornec_creme_dent,
						ie_fornec_fio_dental,
						ie_ret_consulta_agen,
						ie_agenda_outro_prof,
						ie_agendamento_nasf,
						ie_agendamento_grupo,
						ie_tratame_concluido,
						ie_enc_atend_nec_esp,
						ie_enca_cirurgia_bmf,
						ie_encami_endodontia,
						ie_enc_estinatologia,
						ie_enc_implantodonti,
						ie_enc_odontoperiatr,
						ie_enc_ortod_ortoped,
						ie_encam_periodontia,
						ie_enc_prot_dentaria,
						ie_encami_radiologia,
						ie_encaminham_outros,
						nr_seq_lote_envio,
						cd_cns_paciente,
						dt_nascimento_paciente,
						ie_sexo_paciente,
						cd_cns_profissional,
						cd_uuid_original,
						nr_data_atendimento,
						nr_data_fim_atendimento,
						nr_atendimento,
						ie_alta_episodio,
						nr_data_nasc_paciente,
						nr_seq_ficha,
						cd_cnes_unidade,
						cd_cns_sec_prof,
						cd_cns_ter_prof)
				values (	nr_seq_exp_w,
						cd_estabelecimento_w,
						dt_atualizacao_w,
						nm_usuario_w,
						dt_atualizacao_nrec_w,
						nm_usuario_nrec_w,
						cd_pri_profissional_w,
						cd_sec_profissional_w,
						cd_ter_profissional_w,
						cd_pri_cbo_w,
						cd_sec_cbo_w,
						cd_ter_cbo_w,
						nr_seq_sus_equipe_w,
						dt_atendimento_w,
						dt_final_atendimento_w,
						cd_pessoa_fisica_w,
						ie_turno_w,
						nr_prontuario_w,
						ie_local_atendimento_w,
						CASE WHEN ie_paciente_nec_espe_w='S' THEN 'true' WHEN ie_paciente_nec_espe_w='N' THEN 'false'  ELSE '' END ,
						CASE WHEN ie_tipo_atendimento_w='C' THEN '2' WHEN ie_tipo_atendimento_w='E' THEN '4' WHEN ie_tipo_atendimento_w='D' THEN '5' WHEN ie_tipo_atendimento_w='U' THEN '6'  ELSE '' END ,
						CASE WHEN ie_gestante_w='S' THEN 'true' WHEN ie_gestante_w='N' THEN 'false'  ELSE '' END ,
						CASE WHEN ie_tipo_consulta_w='P' THEN '1' WHEN ie_tipo_consulta_w='R' THEN '2' WHEN ie_tipo_consulta_w='M' THEN '4'  ELSE '' END ,
						CASE WHEN ie_abscesso_den_alve_w='S' THEN '1'  ELSE '' END ,
						CASE WHEN ie_alteracao_tec_mol_w='S' THEN '2'  ELSE '' END ,
						CASE WHEN ie_dor_dente_w='S' THEN '3'  ELSE '' END ,
						CASE WHEN ie_fenda_labio_palat_w='S' THEN '4'  ELSE '' END ,
						CASE WHEN ie_fluorose_dentaria_w='S' THEN '5'  ELSE '' END ,
						CASE WHEN ie_trauma_dento_alve_w='S' THEN '6'  ELSE '' END ,
						CASE WHEN ie_nao_identificado_w='S' THEN '99'  ELSE '' END ,
						replace(qt_acesso_polpa_dent_w,',','.'),
						replace(qt_adapt_prot_dentar_w,',','.'),
						replace(qt_aplica_cariostati_w,',','.'),
						replace(qt_aplicacao_selante_w,',','.'),
						replace(qt_aplica_topi_fluor_w,',','.'),
						replace(qt_capeamento_pulpar_w,',','.'),
						replace(qt_cimentacao_protes_w,',','.'),
						replace(qt_cur_dem_sem_prepa_w,',','.'),
						replace(qt_drenagem_abscesso_w,',','.'),
						replace(qt_eviden_placa_bact_w,',','.'),
						replace(qt_exodontia_deciduo_w,',','.'),
						replace(qt_exodontia_permant_w,',','.'),
						replace(qt_inst_protese_dent_w,',','.'),
						replace(qt_moldagem_den_geng_w,',','.'),
						replace(qt_orientacao_higien_w,',','.'),
						replace(qt_profil_placa_bact_w,',','.'),
						replace(qt_pulpotomia_dentar_w,',','.'),
						replace(qt_radiog_periap_int_w,',','.'),
						replace(qt_rasp_alis_pol_sup_w,',','.'),
						replace(qt_raspa_alisa_subge_w,',','.'),
						replace(qt_resta_dente_decid_w,',','.'),
						replace(qt_rest_den_anterior_w,',','.'),
						replace(qt_res_den_posterior_w,',','.'),
						replace(qt_ret_ponto_cir_bas_w,',','.'),
						replace(qt_sela_pro_cav_dent_w,',','.'),
						replace(qt_tratamento_alveol_w,',','.'),
						replace(qt_ulotomia_ulectomi_w,',','.'),
						'ABPO001',
						'ABPO002',
						'ABPO003',
						'ABPO004',
						'ABPO005',
						'ABPO006',
						'ABPO007',
						'ABPO008',
						'ABPG008',
						'ABPO010',
						'ABPO011',
						'ABPO012',
						'ABPO013',
						'ABPO014',
						'ABPO015',
						'ABPO016',
						'ABPO017',
						'ABPO018',
						'ABPO019',
						'ABPO020',
						'ABPO021',
						'ABPO022',
						'ABPO023',
						'ABPG018',
						'ABPO025',
						'ABPO026',
						'ABPO027',
						CASE WHEN ie_fornec_escova_den_w='S' THEN '1'  ELSE '' END ,
						CASE WHEN ie_fornec_creme_dent_w='S' THEN '2'  ELSE '' END ,
						CASE WHEN ie_fornec_fio_dental_w='S' THEN '3'  ELSE '' END ,						
						CASE WHEN ie_ret_consulta_agen_w='S' THEN '16'  ELSE '' END ,
						CASE WHEN ie_agenda_outro_prof_w='S' THEN '12'  ELSE '' END ,
						CASE WHEN ie_agendamento_nasf_w='S' THEN '13'  ELSE '' END ,
						CASE WHEN ie_agendamento_grupo_w='S' THEN '14'  ELSE '' END ,
						CASE WHEN ie_tratame_concluido_w='S' THEN '15'  ELSE '' END ,
						CASE WHEN ie_enc_atend_nec_esp_w='S' THEN '1'  ELSE '' END ,
						CASE WHEN ie_enca_cirurgia_bmf_w='S' THEN '2'  ELSE '' END ,
						CASE WHEN ie_encami_endodontia_w='S' THEN '3'  ELSE '' END ,
						CASE WHEN ie_enc_estinatologia_w='S' THEN '4'  ELSE '' END ,
						CASE WHEN ie_enc_implantodonti_w='S' THEN '5'  ELSE '' END ,
						CASE WHEN ie_enc_odontoperiatr_w='S' THEN '6'  ELSE '' END ,
						CASE WHEN ie_enc_ortod_ortoped_w='S' THEN '7'  ELSE '' END ,
						CASE WHEN ie_encam_periodontia_w='S' THEN '8'  ELSE '' END ,
						CASE WHEN ie_enc_prot_dentaria_w='S' THEN '9'  ELSE '' END ,
						CASE WHEN ie_encami_radiologia_w='S' THEN '10'  ELSE '' END ,
						CASE WHEN ie_encaminham_outros_w='S' THEN '11'  ELSE '' END ,
						nr_seq_lote_envio_w,
						substr(cd_cns_paciente_w,1,15),
						dt_nascimento_paciente_w,
						ie_sexo_paciente_w,
						cd_cns_profissional_w,
						cd_uuid_original_w,
						nr_data_atendimento_w,
						nr_data_fim_atendimento_w,
						nr_atendimento_w,
						CASE WHEN ie_alta_episodio_w='S' THEN '17'  ELSE '' END ,
						nr_data_nasc_paciente_w,
						nr_sequencia_w,
						cd_cnes_unidade_w,
						cd_cns_sec_prof_w,
						cd_cns_ter_prof_w);
				
			open AteOdonProc;
			loop
			fetch AteOdonProc into AteOdonProc_w;
			EXIT WHEN NOT FOUND; /* apply on AteOdonProc */
				insert	into w_esus_atend_odon_proced( nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								qt_procedimento,
								cd_procedimento,
								ie_origem_proced,
								nr_seq_atend_onco,
								nr_seq_w_atend_onco,
								nr_seq_ficha,
								nr_seq_lote_envio)
						values (		nextval('w_esus_atend_odon_proced_seq'),
								AteOdonProc_w.dt_atualizacao,
								AteOdonProc_w.nm_usuario,
								AteOdonProc_w.dt_atualizacao_nrec,
								AteOdonProc_w.nm_usuario_nrec,
								AteOdonProc_w.qt_procedimento,
								AteOdonProc_w.cd_procedimento,
								AteOdonProc_w.ie_origem_proced,
								AteOdonProc_w.nr_seq_atend_onco,
								nr_seq_exp_w,
								nr_sequencia_w,
								nr_seq_lote_envio_w);
			end loop;
			close AteOdonProc;
				
		end;
	end loop;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_w_esus_ate_odont ( nr_seq_lote_p esus_lote_envio.nr_sequencia%type, ie_tipo_lote_esus_p esus_lote_envio.ie_tipo_lote_esus%type, cd_cnes_estab_p estabelecimento.cd_cns%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

