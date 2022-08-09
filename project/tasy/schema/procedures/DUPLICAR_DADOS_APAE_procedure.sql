-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_dados_apae ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

								
nr_seq_aval_pre_w		bigint:= 0;
ie_registros_w		varchar(1);

nr_seq_apae_w		bigint;
qt_peso_w		real;
qt_pa_diastolica_w		smallint;
qt_pa_sistolica_w		smallint;
ds_pulsos_perif_w		varchar(255);
ds_mobilidade_cerv_w	varchar(255);
ds_rede_venosa_w		varchar(255);
ie_malampatti_w		varchar(15);
qt_freq_cardiaca_w		smallint;
qt_altura_cm_w		real;
qt_imc_w			real;
qt_superf_corporia_w	double precision;
ds_informacoes_adic_w	varchar(100);
ds_cardiovascular_w	varchar(255);
ds_respiratorio_w		varchar(255);
ds_abdominal_w		varchar(255);
qt_freq_respir_w		smallint;
qt_sat_oxig_w		smallint;
ie_abertura_boca_w	varchar(1);
ie_mobilidade_cerv_w	varchar(1);
ie_comprim_incisiv_w	varchar(1);	
ie_arcada_protusa_w	varchar(1);
ie_complasc_mandib_w	varchar(1);
ie_conform_palato_w	varchar(1);
ie_protusao_volunt_w	varchar(1);	
ie_dist_tireoment_w		varchar(1);
ie_comprim_pescoco_w	varchar(1);
ie_largura_pescoco_w	varchar(1);
nr_seq_superior_w		bigint;
ds_neurologico_w		varchar(255);
ds_ortopedico_w		varchar(255);
ds_ginecol_obst_w		varchar(255);
nr_seq_principal_w		bigint;
qt_temp_w            exame_fisico_apae.qt_temp%type;
ds_pescoco_w            exame_fisico_apae.ds_pescoco%type;
ds_dente_w            exame_fisico_apae.ds_dente%type;


C01 CURSOR FOR
SELECT	qt_peso,
		qt_pa_diastolica,
		qt_pa_sistolica,
		ds_pulsos_perif,
		ds_mobilidade_cerv,
		ds_rede_venosa,
		ie_malampatti,
		qt_freq_cardiaca,
		qt_altura_cm,
		qt_imc,
		qt_superf_corporia,
		ds_informacoes_adic,
		ds_cardiovascular,
		ds_respiratorio,
		ds_abdominal,
		qt_freq_respir,
		qt_sat_oxig,
		ie_abertura_boca,
		ie_mobilidade_cerv,
		ie_comprim_incisiv,
		ie_arcada_protusa,
		ie_complasc_mandib,
		ie_conform_palato,
		ie_protusao_volunt,
		ie_dist_tireoment,
		ie_comprim_pescoco,
		ie_largura_pescoco,
		nr_seq_superior,
		ds_neurologico,
		ds_ortopedico,
		ds_ginecol_obst,
      qt_temp,
      ds_pescoco,
      ds_dente
from	exame_fisico_apae
where	nr_seq_aval_pre = nr_sequencia_p;


BEGIN


select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_registros_w
from	aval_pre_anestesica 
where 	nr_sequencia = nr_sequencia_p;

if (ie_registros_w = 'S') then
	select	nextval('aval_pre_anestesica_seq')
	into STRICT	nr_seq_aval_pre_w
	;

	insert into aval_pre_anestesica(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda,
				nr_cirurgia,
				dt_avaliacao,
				cd_avaliador,
				cd_pessoa_fisica,
				cd_medico,
				cd_procedimento,
				ie_origem_proced,
				cd_doenca_cid,
				dt_cirurgia,
				nr_atendimento,
				ie_situacao,
				nr_aval_clinica_externa,
				nr_seq_proc_interno)
	SELECT	   	nr_seq_aval_pre_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_agenda,
				nr_cirurgia,
				clock_timestamp(),
				cd_avaliador,
				cd_pessoa_fisica,
				cd_medico,
				cd_procedimento,
				ie_origem_proced,
				cd_doenca_cid,
				dt_cirurgia,
				nr_atendimento,
				'A',
				nr_aval_clinica_externa,
				nr_seq_proc_interno
	from		aval_pre_anestesica
	where		nr_sequencia = nr_sequencia_p;

	insert into anamnese_apae(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_aval_pre,
				qt_anestesia,
				ds_anestesia,
				ds_intercorrencia_anest,
				qt_cirurgia,
				ds_cirurgia,
				ds_intercorrencia_cir,
				ds_doenca,
				ds_tolerancia_exerc,
				ds_alergia,
				ds_medicamento_uso,
				dt_visita_medica,
				dt_ultima_menstruacao,
				ds_habito,
				ie_lentes_contato,
				ie_protese_dentaria,
				ds_protese,
				ie_hipertermia_maligna)
	SELECT	   	nextval('anamnese_apae_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_aval_pre_w,
				qt_anestesia,
				ds_anestesia,
				ds_intercorrencia_anest,
				qt_cirurgia,
				ds_cirurgia,
				ds_intercorrencia_cir,
				ds_doenca,
				ds_tolerancia_exerc,
				ds_alergia,
				ds_medicamento_uso,
				dt_visita_medica,
				dt_ultima_menstruacao,
				ds_habito,
				ie_lentes_contato,
				ie_protese_dentaria,
				ds_protese,
				ie_hipertermia_maligna
	from		anamnese_apae
	where		nr_seq_aval_pre = nr_sequencia_p;
	
	insert into aval_pre_anest_diag(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_diag,
				ds_observacao,
				nr_seq_aval_pre,
				ie_paciente,
				ds_familiar)
	SELECT	   	nextval('aval_pre_anest_diag_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_diag,
				ds_observacao,
				nr_seq_aval_pre_w,
				ie_paciente,
				ds_familiar
	from		aval_pre_anest_diag
	where		nr_seq_aval_pre = nr_sequencia_p;
	
	open C01;
	loop
	fetch C01 into	
		qt_peso_w,
		qt_pa_diastolica_w,
		qt_pa_sistolica_w,
		ds_pulsos_perif_w,
		ds_mobilidade_cerv_w,
		ds_rede_venosa_w,
		ie_malampatti_w,
		qt_freq_cardiaca_w,
		qt_altura_cm_w,
		qt_imc_w,
		qt_superf_corporia_w,
		ds_informacoes_adic_w,
		ds_cardiovascular_w,
		ds_respiratorio_w,
		ds_abdominal_w,
		qt_freq_respir_w,
		qt_sat_oxig_w,
		ie_abertura_boca_w,
		ie_mobilidade_cerv_w,
		ie_comprim_incisiv_w,
		ie_arcada_protusa_w,
		ie_complasc_mandib_w,
		ie_conform_palato_w,
		ie_protusao_volunt_w,
		ie_dist_tireoment_w,
		ie_comprim_pescoco_w,
		ie_largura_pescoco_w,
		nr_seq_superior_w,
		ds_neurologico_w,
		ds_ortopedico_w,
		ds_ginecol_obst_w,
		qt_temp_w,
		ds_pescoco_w,
		ds_dente_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		select	nextval('exame_fisico_apae_seq')
		into STRICT	nr_seq_apae_w
		;
		
		if (coalesce(nr_seq_superior_w::text, '') = '') then
			nr_seq_principal_w	:= nr_seq_apae_w;
		else
			nr_seq_superior_w 	:= nr_seq_principal_w;
		end if;	
		
		insert into exame_fisico_apae(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_aval_pre,
					qt_peso,
					qt_pa_diastolica,
					qt_pa_sistolica,
					ds_pulsos_perif,
					ds_mobilidade_cerv,
					ds_rede_venosa,
					ie_malampatti,
					qt_freq_cardiaca,
					qt_altura_cm,
					qt_imc,
					qt_superf_corporia,
					ds_informacoes_adic,
					ds_cardiovascular,
					ds_respiratorio,
					ds_abdominal,
					qt_freq_respir,
					qt_sat_oxig,
					ie_abertura_boca,
					ie_mobilidade_cerv,
					ie_comprim_incisiv,
					ie_arcada_protusa,
					ie_complasc_mandib,
					ie_conform_palato,
					ie_protusao_volunt,
					ie_dist_tireoment,
					ie_comprim_pescoco,
					ie_largura_pescoco,
					nr_seq_superior,
					ds_neurologico,
					ds_ortopedico,
					ds_ginecol_obst,
					qt_temp,
					ds_pescoco,
					ds_dente
					)
			values (nr_seq_apae_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_aval_pre_w,
					qt_peso_w,
					qt_pa_diastolica_w,
					qt_pa_sistolica_w,
					ds_pulsos_perif_w,
					ds_mobilidade_cerv_w,
					ds_rede_venosa_w,
					ie_malampatti_w,
					qt_freq_cardiaca_w,
					qt_altura_cm_w,
					qt_imc_w,
					qt_superf_corporia_w,
					ds_informacoes_adic_w,
					ds_cardiovascular_w,
					ds_respiratorio_w,
					ds_abdominal_w,
					qt_freq_respir_w,
					qt_sat_oxig_w,
					ie_abertura_boca_w,
					ie_mobilidade_cerv_w,
					ie_comprim_incisiv_w,
					ie_arcada_protusa_w,
					ie_complasc_mandib_w,
					ie_conform_palato_w,
					ie_protusao_volunt_w,
					ie_dist_tireoment_w,
					ie_comprim_pescoco_w,
					ie_largura_pescoco_w,
					nr_seq_superior_w,
					ds_neurologico_w,
					ds_ortopedico_w,
					ds_ginecol_obst_w,
					qt_temp_w,
					ds_pescoco_w,
					ds_dente_w);
	end loop;
	close C01;	
		
	insert into aval_pre_anest_dado_estat(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_tipo_dado,
				qt_dado,
				nr_seq_apresentacao,
				nr_seq_aval_pre,
				dt_exame)
	SELECT	   	nextval('aval_pre_anest_dado_estat_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_tipo_dado,
				qt_dado,
				nr_seq_apresentacao,
				nr_seq_aval_pre_w,
				dt_exame
	from		aval_pre_anest_dado_estat
	where		nr_seq_aval_pre = nr_sequencia_p;
	
	insert into asa_apae(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_asa,
				ie_emergencia,
				nr_seq_aval_pre)
	SELECT	   	nextval('asa_apae_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ie_asa,
				ie_emergencia,
				nr_seq_aval_pre_w
	from		asa_apae
	where		nr_seq_aval_pre = nr_sequencia_p;
	
	insert into resultado_risco_apae(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_apae,
				nr_seq_risco,
				nr_seq_risco_item)
	SELECT	   	nextval('resultado_risco_apae_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_aval_pre_w,
				nr_seq_risco,
				nr_seq_risco_item
	from		resultado_risco_apae
	where		nr_seq_apae = nr_sequencia_p;
	
	insert into conclusao_recom_apae(
		   		nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_aval_pre,
				nr_seq_tec_anest,
				nr_prescricao,
				ds_dados_clinicos_compl)
	SELECT	   	nextval('conclusao_recom_apae_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_aval_pre_w,
				nr_seq_tec_anest,
				nr_prescricao,
				ds_dados_clinicos_compl
	from		conclusao_recom_apae
	where		nr_seq_aval_pre = nr_sequencia_p;
end if;	

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_dados_apae ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
