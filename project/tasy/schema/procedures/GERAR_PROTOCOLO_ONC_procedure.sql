-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_onc ( cd_protocolo_p bigint, nr_seq_subtipo_p bigint, nr_seq_paciente_p bigint, ie_copia_sol_p text, ie_copia_med_p text, ie_copia_proc_exa_p text, ie_copia_rec_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_solucao_w	bigint;
nr_seq_sol_comp_w	bigint;
nr_seq_med_w		bigint;
nr_seq_med_dil_w	bigint;
nr_seq_proc_w		bigint;
nr_seq_proc_comp_w	bigint;
nr_seq_rec_w		bigint;

--  Soluções
C01 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_soluc a
	where	nr_seq_paciente = nr_seq_paciente_p;

c01_w c01%rowtype;

-- Componentes da Solução
C02 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_medic a
	where	nr_seq_paciente = nr_seq_paciente_p
	and	coalesce(a.ie_zerado,'N') = 'N'
	and	nr_seq_solucao = c01_w.nr_seq_solucao;

c02_w c02%rowtype;

-- Medicamentos
C03 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_medic a
	where	nr_seq_paciente = nr_seq_paciente_p
	and	coalesce(nr_seq_diluicao::text, '') = ''
	and	coalesce(nr_seq_solucao::text, '') = ''
	and	coalesce(nr_seq_medic_material::text, '') = ''
	and	coalesce(nr_seq_procedimento::text, '') = '';

c03_w c03%rowtype;

-- Diluente
C04 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_medic a
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_seq_diluicao = c03_w.nr_seq_material;

c04_w c04%rowtype;

-- Procedimentos
C05 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_proc a
	where	nr_seq_paciente = nr_seq_paciente_p;

c05_w c05%rowtype;

-- Componentes dos Procedimentos
C06 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_medic a
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_seq_procedimento = c05_w.nr_seq_procedimento;

c06_w c06%rowtype;

-- Recomendações
C07 CURSOR FOR
	SELECT	a.*
	from	paciente_protocolo_rec a
	where	nr_seq_paciente = nr_seq_paciente_p;

c07_w c07%rowtype;


BEGIN
if (coalesce(cd_protocolo_p,0) > 0) and (coalesce(nr_seq_subtipo_p,0) > 0) and (coalesce(nr_seq_paciente_p,0) > 0) then

	if (coalesce(ie_copia_sol_p,'N') = 'S') then

		open C01;
		loop
		fetch C01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			select	coalesce(max(nr_seq_solucao),0)+1
			into STRICT	nr_seq_solucao_w
			from	protocolo_medic_solucao
			where	cd_protocolo = cd_protocolo_p
			and	nr_sequencia = nr_seq_subtipo_p;

			insert into protocolo_medic_solucao(	cd_protocolo,
								nr_sequencia,
								nr_seq_solucao,
								nr_agrupamento,
								dt_atualizacao,
								nm_usuario,
								ie_bomba_infusao,
								ie_esquema_alternado,
								ie_calc_aut,
								ie_acm,
								ie_solucao_pca,
								nr_etapas,
								qt_hora_fase,
								qt_tempo_aplicacao,
								ie_se_necessario,
								qt_solucao_total,
								qt_dosagem,
								ie_via_aplicacao,
								cd_intervalo,
								ie_tipo_dosagem,
								ds_dias_aplicacao,
								ds_ciclos_aplicacao,
								ds_solucao,
								ds_orientacao,
								ie_tipo_sol,
								ie_tipo_analgesia,
								ie_pca_modo_prog,
								qt_vol_infusao_pca,
								qt_bolus_pca,
								qt_intervalo_bloqueio,
								qt_limite_quatro_hora,
								qt_dose_inicial_pca,
								qt_dose_ataque,
								ie_pre_medicacao,
								ie_hemodialise)
							values (	cd_protocolo_p,
								nr_seq_subtipo_p,
								nr_seq_solucao_w,
								c01_w.nr_agrupamento,
								clock_timestamp(),
								nm_usuario_p,
								c01_w.ie_bomba_infusao,
								coalesce(c01_w.ie_esquema_alternado,'N'),
								coalesce(c01_w.ie_calc_aut,'N'),
								coalesce(c01_w.ie_acm,'N'),
								c01_w.ie_solucao_pca,
								c01_w.nr_etapas,
								c01_w.qt_hora_fase,
								c01_w.qt_tempo_aplicacao,
								c01_w.ie_se_necessario,
								c01_w.qt_solucao_total,
								c01_w.qt_dosagem,
								c01_w.ie_via_aplicacao,
								c01_w.cd_intervalo,
								c01_w.ie_tipo_dosagem,
								c01_w.ds_dias_aplicacao,
								c01_w.ds_ciclos_aplicacao,
								c01_w.ds_solucao,
								c01_w.ds_orientacao,
								c01_w.ie_tipo_sol,
								c01_w.ie_tipo_analgesia,
								c01_w.ie_pca_modo_prog,
								c01_w.qt_vol_infusao_pca,
								c01_w.qt_bolus_pca,
								c01_w.qt_intervalo_bloqueio,
								c01_w.qt_limite_quatro_hora,
								c01_w.qt_dose_inicial_pca,
								c01_w.qt_dose_ataque,
								c01_w.ie_pre_medicacao,
								'N');

			open C02;
			loop
			fetch C02 into
				c02_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				select	coalesce(max(nr_seq_material),0)+1
				into STRICT	nr_seq_sol_comp_w
				from	protocolo_medic_material
				where	cd_protocolo = cd_protocolo_p
				and	nr_sequencia = nr_seq_subtipo_p;

				insert into protocolo_medic_material(	cd_protocolo,
									nr_sequencia,
									nr_seq_material,
									cd_material,
									cd_unidade_medida,
									dt_atualizacao,
									nm_usuario,
									nr_agrupamento,
									ie_bomba_infusao,
									ie_aplic_bolus,
									ie_aplic_lenta,
									ie_urgencia,
									ie_pre_medicacao,
									ie_aplica_reducao,
									ie_agrupador,
									nr_seq_solucao,
									qt_dose,
									ie_via_aplicacao)
								values (	cd_protocolo_p,
									nr_seq_subtipo_p,
									nr_seq_sol_comp_w,
									c02_w.cd_material,
									c02_w.cd_unidade_medida,
									clock_timestamp(),
									nm_usuario_p,
									c02_w.nr_agrupamento,
									coalesce(c02_w.ie_bomba_infusao,'N'),
									coalesce(c02_w.ie_aplic_bolus,'N'),
									coalesce(c02_w.ie_aplic_lenta,'N'),
									coalesce(c02_w.ie_urgencia,'N'),
									c02_w.ie_pre_medicacao,
									c02_w.ie_aplica_reducao,
									4,
									c02_w.nr_seq_solucao,
									c02_w.qt_dose,
									c01_w.ie_via_aplicacao);
				end;
			end loop;
			close C02;
			end;

		end loop;
		close C01;
	end if;

	if (coalesce(ie_copia_med_p,'N') = 'S') then

		open C03;
		loop
		fetch C03 into
			c03_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			select	coalesce(max(nr_seq_material),0)+1
			into STRICT	nr_seq_med_w
			from	protocolo_medic_Material
			where	cd_protocolo = cd_protocolo_p
			and	nr_sequencia = nr_seq_subtipo_p;

			insert into protocolo_medic_material(	cd_protocolo,
								nr_sequencia,
								nr_seq_material,
								cd_material,
								cd_unidade_medida,
								dt_atualizacao,
								nm_usuario,
								nr_agrupamento,
								ie_bomba_infusao,
								ie_aplic_bolus,
								ie_aplic_lenta,
								ie_urgencia,
								ie_via_aplicacao,
								ie_uso_continuo,
								qt_dose,
								ie_se_necessario,
								cd_intervalo,
								qt_dias_util,
								ds_dias_aplicacao,
								ds_dose_diferenciada,
								qt_hora_aplicacao,
								qt_minuto_aplicacao,
								ie_pre_medicacao,
								ds_ciclos_aplicacao,
								ie_gerar_solucao,
								ds_recomendacao,
								ds_justificativa,
								ie_local_adm,
								ie_aplica_reducao,
								ie_acm,
								ie_agrupador,
								qt_dias_receita)
							values (	cd_protocolo_p,
								nr_seq_subtipo_p,
								nr_seq_med_w,
								c03_w.cd_material,
								c03_w.cd_unidade_medida,
								clock_timestamp(),
								nm_usuario_p,
								c03_w.nr_agrupamento,
								coalesce(c03_w.ie_bomba_infusao,'N'),
								coalesce(c03_w.ie_aplic_bolus,'N'),
								coalesce(c03_w.ie_aplic_lenta,'N'),
								coalesce(c03_w.ie_urgencia,'N'),
								c03_w.ie_via_aplicacao,
								coalesce(c03_w.ie_uso_continuo,'N'),
								c03_w.qt_dose,
								coalesce(c03_w.ie_se_necessario,'N'),
								c03_w.cd_intervalo,
								c03_w.qt_dias_util,
								c03_w.ds_dias_aplicacao,
								c03_w.ds_dose_diferenciada,
								c03_w.qt_hora_aplicacao,
								c03_w.qt_min_aplicacao,
								coalesce(c03_w.ie_pre_medicacao,'N'),
								c03_w.ds_ciclos_aplicacao,
								c03_w.ie_gerar_solucao,
								c03_w.ds_recomendacao,
								c03_w.ds_observacao,
								c03_w.ie_local_adm,
								c03_w.ie_aplica_reducao,
								c03_w.ie_acm,
								1,
								c03_w.qt_dias_receita);

			open C04;
			loop
			fetch C04 into
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin
				select	coalesce(max(nr_seq_material),0)+1
				into STRICT	nr_seq_med_dil_w
				from	protocolo_medic_Material
				where	cd_protocolo = cd_protocolo_p
				and	nr_sequencia = nr_seq_subtipo_p;

				insert into protocolo_medic_material(	cd_protocolo,
									nr_sequencia,
									nr_seq_material,
									nr_seq_diluicao,
									cd_material,
									cd_unidade_medida,
									dt_atualizacao,
									nm_usuario,
									nr_agrupamento,
									ie_bomba_infusao,
									ie_aplic_bolus,
									ie_aplic_lenta,
									ie_urgencia,
									qt_dose,
									ds_dias_aplicacao,
									qt_minuto_aplicacao,
									ie_aplica_reducao,
									ie_agrupador)
							values (		cd_protocolo_p,
									nr_seq_subtipo_p,
									nr_seq_med_dil_w,
									nr_seq_med_w,
									c04_w.cd_material,
									c04_w.cd_unidade_medida,
									clock_timestamp(),
									nm_usuario_p,
									c04_w.nr_agrupamento,
									coalesce(c04_w.ie_bomba_infusao,'N'),
									coalesce(c04_w.ie_aplic_bolus,'N'),
									coalesce(c04_w.ie_aplic_lenta,'N'),
									coalesce(c04_w.ie_urgencia,'N'),
									c04_w.qt_dose,
									c04_w.ds_dias_aplicacao,
									c04_w.qt_min_aplicacao,
									c04_w.ie_aplica_reducao,
									3);
				end;
			end loop;
			close C04;
			end;
		end loop;
		close C03;



	end if;

	if (coalesce(ie_copia_proc_exa_p,'N') = 'S') then

		open C05;
		loop
		fetch C05 into
			c05_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			select	coalesce(max(nr_seq_proc),0)+1
			into STRICT	nr_seq_proc_w
			from	protocolo_medic_Proc
			where	cd_protocolo = cd_protocolo_p
			and	nr_sequencia = nr_seq_subtipo_p;

			insert into protocolo_medic_proc(	cd_protocolo,
								nr_sequencia,
								nr_seq_proc,
								qt_procedimento,
								dt_atualizacao,
								nm_usuario,
								ie_se_necessario,
								ie_acm,
								ie_urgencia,
								nr_seq_proc_interno,
								cd_procedimento,
								ie_lado,
								cd_intervalo,
								ds_dias_aplicacao,
								ds_ciclos_aplicacao)
						values (		cd_protocolo_p,
								nr_seq_subtipo_p,
								nr_seq_proc_w,
								c05_w.qt_procedimento,
								clock_timestamp(),
								nm_usuario_p,
								coalesce(c05_w.ie_se_necessario,'N'),
								coalesce(c05_w.ie_acm,'N'),
								'N',
								c05_w.nr_seq_proc_interno,
								c05_w.cd_procedimento,
								c05_w.ie_lado,
								c05_w.cd_intervalo,
								c05_w.ds_dias_aplicacao,
								c05_w.ds_ciclos_aplicacao);

			open C06;
			loop
			fetch C06 into
				c06_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
				begin
				select	coalesce(max(nr_seq_material),0)+1
				into STRICT	nr_seq_proc_comp_w
				from	protocolo_medic_Material
				where	cd_protocolo = cd_protocolo_p
				and	nr_sequencia = nr_seq_subtipo_p;

				insert into protocolo_medic_material(	cd_protocolo,
									nr_sequencia,
									nr_seq_material,
									cd_material,
									cd_unidade_medida,
									dt_atualizacao,
									nm_usuario,
									nr_agrupamento,
									ie_bomba_infusao,
									ie_aplic_bolus,
									ie_aplic_lenta,
									ie_urgencia,
									ie_via_aplicacao,
									qt_dose,
									ie_agrupador,
									nr_seq_proc,
									cd_intervalo)
							values (		cd_protocolo_p,
									nr_seq_subtipo_p,
									nr_seq_proc_comp_w,
									c06_w.cd_material,
									c06_w.cd_unidade_medida,
									clock_timestamp(),
									nm_usuario_p,
									c06_w.nr_agrupamento,
									coalesce(c06_w.ie_bomba_infusao,'N'),
									coalesce(c06_w.ie_aplic_bolus,'N'),
									coalesce(c06_w.ie_aplic_lenta,'N'),
									coalesce(c06_w.ie_urgencia,'N'),
									c06_w.ie_via_aplicacao,
									c06_w.qt_dose,
									5,
									nr_seq_proc_w,
									c06_w.cd_intervalo);
				end;
			end loop;
			close C06;

			end;
		end loop;
		close C05;
	end if;

	if (coalesce(ie_copia_rec_p,'N') = 'S') then

		open C07;
		loop
		fetch C07 into
			c07_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin
			select	coalesce(max(nr_seq_rec),0)+1
			into STRICT	nr_seq_rec_w
			from	protocolo_medic_rec
			where	cd_protocolo = cd_protocolo_p
			and	nr_sequencia = nr_seq_subtipo_p;

			insert into protocolo_medic_rec(	cd_protocolo,
								nr_sequencia,
								nr_seq_rec,
								dt_atualizacao,
								nm_usuario,
								cd_recomendacao,
								ds_recomendacao,
								cd_intervalo,
								ie_se_necessario,
								ie_acm,
								ds_dias_aplicacao,
								ds_ciclos_aplicacao,
								nr_seq_classif)
						values (		cd_protocolo_p,
								nr_seq_subtipo_p,
								nr_seq_rec_w,
								clock_timestamp(),
								nm_usuario_p,
								c07_w.cd_recomendacao,
								c07_w.ds_recomendacao,
								c07_w.cd_intervalo,
								coalesce(c07_w.ie_se_necessario,'N'),
								coalesce(c07_w.ie_acm,'N'),
								c07_w.ds_dias_aplicacao,
								c07_w.ds_ciclos_aplicacao,
								c07_w.nr_seq_classif);
			end;
		end loop;
		close C07;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_onc ( cd_protocolo_p bigint, nr_seq_subtipo_p bigint, nr_seq_paciente_p bigint, ie_copia_sol_p text, ie_copia_med_p text, ie_copia_proc_exa_p text, ie_copia_rec_p text, nm_usuario_p text) FROM PUBLIC;
