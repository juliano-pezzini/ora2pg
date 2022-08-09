-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_gedi_medic_atend ( cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_horario_p bigint, nm_usuario_p text ) AS $body$
DECLARE


ie_usuario_def_disp_w			varchar(1);
qt_saldo_w						double precision;
qt_saldo2_w						double precision;
qt_saldo3_w						double precision;
nr_sequencia_w					bigint;
nr_sequencia_ww					bigint;
nr_atendimento_w				bigint;
cd_material_w					bigint;
cd_material_ww					bigint;
cd_material_prescrito_w			bigint;
cd_convenio_w					integer;
cd_setor_w						integer;
ie_via_aplicacao_w				varchar(10);
cd_intervalo_w					varchar(10);
cd_motivo_baixa_w				integer;
qt_material_w					double precision;
qt_unitaria_w					double precision;
qt_unitaria_2w					double precision;
qt_material_aux_w				double precision;
pr_margem_w						double precision;
cd_estab_prescr_w				integer;
qt_horas_estabilidade_w			double precision;
qt_mat_ocor_w					double precision;
qt_unitaria_especial_w			double precision;
qt_conversao_esp_w				double precision;
qt_w							bigint;
qt_dose_hor_w					double precision;
cd_unid_med_w					varchar(30);
cd_unidade_medida_estoque_w		varchar(30);
ie_dose_especial_w				varchar(30);
ie_horario_especial_w			varchar(30);
dt_horario_w					timestamp;
dt_horario_ww					timestamp;
dt_estabilidade_w				timestamp;
dt_estabilidade_ww				timestamp;
cd_unidade_medida_dose_w		varchar(30);
nr_seq_w						bigint;
ie_atualiza_dose_disp_hor_w		varchar(1);
ie_acm_w						varchar(1);
ie_se_necessario_w				varchar(1);
ie_material_estoque_w			varchar(1);
cd_perfil_w						bigint;
cont_w							bigint;
cd_material_estoque_w			bigint;
cd_unidade_medida_w				varchar(10);
ie_dose_menor_w					material_regra_disp.ie_dose_menor%type;
ie_regra_disp_2w				varchar(1);
cont_gedic_w					bigint;
nr_sequencia_mat_w				prescr_material.nr_sequencia%type;
qt_conversao_dose_w				prescr_material.qt_conversao_dose%type;
ie_origem_inf_w					prescr_material.ie_origem_inf%type;
qt_total_dispensar_w			prescr_material.qt_total_dispensar%type;
ie_regra_disp_w					prescr_material.ie_regra_disp%type;
qt_dose_especial_w				prescr_material.qt_dose_especial%type;
ds_dose_diferenciada_w			prescr_material.ds_dose_diferenciada%type;
qt_material_2w					double precision;
ds_erro_w						varchar(2000);
cd_estabelecimento_w			bigint;
sql_w						varchar(200);
qt_saldo_aux_w					double precision;

c01 CURSOR FOR
SELECT		coalesce(ie_usuario_def_disp, 'N'),
			coalesce(pr_margem, 0),
			coalesce(ie_material_estoque, 'N'),
			coalesce(ie_dose_menor, 'N'),
			coalesce(ie_regra_disp, 'C')
from		material_regra_disp
where		((coalesce(cd_unidade_medida::text, '') = '')
			or((ie_unidade_medida = 1)
				and (coalesce(cd_unid_med_w, cd_unidade_medida)= cd_unidade_medida))
			or((ie_unidade_medida = 2)
				and (coalesce(cd_unidade_medida_dose_w, cd_unidade_medida)= cd_unidade_medida))
			or((ie_unidade_medida = 3)
				and (coalesce(cd_unidade_medida_estoque_w, cd_unidade_medida)= cd_unidade_medida)))
and			((coalesce(cd_perfil_w, cd_perfil)= cd_perfil)
				or (coalesce(cd_perfil::text, '') = ''))
and			((coalesce(ie_via_aplicacao_w, ie_via_aplicacao)= ie_via_aplicacao)
				or (coalesce(ie_via_aplicacao::text, '') = ''))
and			((coalesce(cd_intervalo_w, cd_intervalo)= cd_intervalo)
				or (coalesce(cd_intervalo::text, '') = ''))
and			(((coalesce(ie_acm_sn, 'X')= 'N')
				and (ie_acm_w = 'N')
				and (ie_se_necessario_w = 'N'))
				or((coalesce(ie_acm_sn, 'X')= 'S')
					and((ie_acm_w = 'S')
						or (ie_se_necessario_w = 'S')))
				or (coalesce(ie_acm_sn, 'X')= 'X'))
and			coalesce(cd_unid_med_estoque, cd_unidade_medida_estoque_w)= cd_unidade_medida_estoque_w
and			coalesce(cd_convenio, cd_convenio_w)= cd_convenio_w
and			coalesce(cd_setor_atendimento, cd_setor_w)= cd_setor_w
and			(((coalesce(cd_material, cd_material_w)= cd_material_w)
				and (coalesce(ie_material_estoque, 'N')= 'N'))
				or((coalesce(cd_material, cd_material_estoque_w)= cd_material_estoque_w)
					and (coalesce(ie_material_estoque, 'N')= 'S')))
and			((coalesce(nr_seq_estrut_int::text, '') = '')
				or (consistir_se_mat_estrutura(nr_seq_estrut_int, cd_material_w)= 'S'))
and			cd_estabelecimento = cd_estabelecimento_p
order by	coalesce(cd_material, 0),
			coalesce(cd_convenio, 0),
			coalesce(cd_setor_atendimento, 0),
			coalesce(cd_unidade_medida, 'zzzz')desc,
			coalesce(ie_via_aplicacao, 'zzzz')desc,
			coalesce(nr_seq_estrut_int, 0),
			coalesce(cd_intervalo, 0),
			coalesce(cd_perfil, 0);

c02 CURSOR FOR
SELECT	qt_saldo,
		nr_sequencia
from	gedi_medic_atend
where	ie_status not in ('S', 'E')
and		((coalesce(qt_horas_estabilidade_w, 0)> 0
			and (dt_fim_estabilidade IS NOT NULL AND dt_fim_estabilidade::text <> '')
			and dt_horario_ww between dt_fim_estabilidade - qt_horas_estabilidade_w / 24 and dt_fim_estabilidade
			and dt_fim_estabilidade > dt_horario_ww)
			or (coalesce(qt_horas_estabilidade_w, 0)= 0
			and coalesce(dt_fim_estabilidade, dt_horario_ww + 1)> dt_horario_ww))
and			cd_material = cd_material_w
and			nr_atendimento = nr_atendimento_w
order by	nr_sequencia;


BEGIN
	select	count(*)
	into STRICT	cont_gedic_w
	from	gedi_medic_atend
	where	nr_seq_horario = nr_seq_horario_p;

	if ((nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and cont_gedic_w = 0) then

		cd_perfil_w := coalesce(obter_perfil_ativo, 0);

		select	max(nr_atendimento),
				max(cd_estabelecimento)
		into STRICT	nr_atendimento_w,
				cd_estab_prescr_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;

		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

			select	coalesce(max(ie_arredondar_disp_hor), 'N')
			into STRICT	ie_atualiza_dose_disp_hor_w
			from	parametro_medico
			where	cd_estabelecimento = cd_estab_prescr_w;

			select	coalesce(max(cd_convenio), 0),
					coalesce(max(cd_setor_atendimento), 0),
					max(cd_estabelecimento)
			into STRICT	cd_convenio_w,
					cd_setor_w,
					cd_estabelecimento_w
			from	atendimento_paciente_v
			where	nr_atendimento = nr_atendimento_w;

/* Comentado por Anderson Almeida - META
			SELECT
				nvl(MAX(cd_convenio), 0),
				nvl(MAX(cd_setor_atendimento), 0)
			INTO
				cd_convenio_w,
				cd_setor_w
			FROM
				atendimento_paciente_v
			WHERE
				nr_atendimento = nr_atendimento_w;
*/
			select	max(cd_material),
					max(ie_via_aplicacao),
					max(cd_intervalo),
					max(qt_unitaria) * max(nr_ocorrencia),
					max(qt_unitaria),
					max(cd_unidade_medida_dose),
					max(qt_horas_estabilidade),
					coalesce(max(ie_acm), 'N'),
					coalesce(max(ie_se_necessario), 'N'),
					max(qt_conversao_dose),
					max(nr_sequencia),
					max(ie_origem_inf),
					max(ie_regra_disp),
					max(qt_dose_especial),
					max(ds_dose_diferenciada)
			into STRICT	cd_material_w,
					ie_via_aplicacao_w,
					cd_intervalo_w,
					qt_mat_ocor_w,
					qt_unitaria_w,
					cd_unidade_medida_dose_w,
					qt_horas_estabilidade_w,
					ie_acm_w,
					ie_se_necessario_w,
					qt_conversao_dose_w,
					nr_sequencia_mat_w,
					ie_origem_inf_w,
					ie_regra_disp_w,
					qt_dose_especial_w,
					ds_dose_diferenciada_w
			from	prescr_material
			where	nr_sequencia = nr_seq_material_p
			and		nr_prescricao = nr_prescricao_p;

			select	min(dt_horario)
			into STRICT	dt_horario_w
			from	prescr_mat_hor
			where	nr_seq_material = nr_seq_material_p
			and		nr_prescricao = nr_prescricao_p;

			select	min(dt_horario),
					max(qt_dispensar_hor),
					coalesce(max(qt_dose), 0),
					coalesce(max(ie_dose_especial), 'N'),
					coalesce(max(ie_horario_especial), 'N')
			into STRICT	dt_horario_ww,
					qt_material_w,
					qt_dose_hor_w,
					ie_dose_especial_w,
					ie_horario_especial_w
			from	prescr_mat_hor
			where	nr_sequencia = nr_seq_horario_p;

			/*Comentado por Anderson Almeida - META
			IF ( ie_horario_especial_w = 'N' ) THEN
			*/
			if (ie_horario_especial_w = 'N') or (gedi_obter_se_saldo_espec(cd_estabelecimento_w) = 'S') then

				cd_unid_med_w := substr(obter_dados_material_estab(cd_material_w, cd_estabelecimento_p, 'UMS'), 1, 30);

				cd_unidade_medida_estoque_w := substr(obter_dados_material_estab(cd_material_w, cd_estabelecimento_p, 'UME'), 1, 30);

				cd_material_estoque_w := substr(obter_dados_material(cd_material_w, 'EST'), 1, 30);

				open c01;
				loop
					fetch c01 into
						ie_usuario_def_disp_w,
						pr_margem_w,
						ie_material_estoque_w,
						ie_dose_menor_w,
						ie_regra_disp_2w;
					EXIT WHEN NOT FOUND; /* apply on c01 */
					ie_usuario_def_disp_w := ie_usuario_def_disp_w;
					ie_regra_disp_2w := ie_regra_disp_2w;
				end loop;

				close c01;

				cd_material_prescrito_w := cd_material_w;

				if (ie_material_estoque_w = 'S') then
					cd_material_w := cd_material_estoque_w;
				end if;

				if (qt_dose_hor_w > 0) and (ie_dose_especial_w = 'S') then

					select	coalesce(max(qt_conversao), 0)
					into STRICT	qt_conversao_esp_w
					from	material_conversao_unidade
					where	cd_unidade_medida = cd_unidade_medida_dose_w
					and		cd_material = cd_material_w;

					if (qt_conversao_esp_w = 0) then
						qt_conversao_esp_w := 1;
					end if;

				--- Inicio MD1
					begin
						sql_w := 'CALL calc_qt_unit_esp_med_atend_md(:1, :2) INTO :qt_unitaria_especial_w';
						EXECUTE sql_w
							using	in qt_dose_hor_w,
									in qt_conversao_esp_w,
									out qt_unitaria_especial_w;
					exception
						when others then
							qt_unitaria_especial_w := null;
					end;
				--- Fim MD1
				end if;

				if (coalesce(qt_material_w, 0) = 0) then
					qt_material_w := qt_mat_ocor_w;
				end if;

				if (ie_usuario_def_disp_w = 'T') or (ie_usuario_def_disp_w = 'E') then

					select	count(nr_sequencia)
					into STRICT	cont_w
					from	gedi_medic_atend where		ie_status not in ('S','E')
					and		((coalesce(qt_horas_estabilidade_w, 0) > 0
								and (dt_fim_estabilidade IS NOT NULL AND dt_fim_estabilidade::text <> '')
								and dt_horario_ww between dt_fim_estabilidade - qt_horas_estabilidade_w / 24 and dt_fim_estabilidade)
								or (coalesce(qt_horas_estabilidade_w, 0) = 0
									and coalesce(dt_fim_estabilidade, dt_horario_ww + 1) > dt_horario_ww))
					and		cd_material = cd_material_w
					and		nr_atendimento = nr_atendimento_w LIMIT 1;

					open c02;
					loop
						fetch c02 into
							qt_saldo_w,
							nr_sequencia_w;
						EXIT WHEN NOT FOUND; /* apply on c02 */
						qt_saldo_w := qt_saldo_w;
						nr_sequencia_w := nr_sequencia_w;
					end loop;

					close c02;

				--- Inicio MD2
					begin
						sql_w := 'begin obter_mat_gedi_med_atend_md (:1, :2, :3, :4, :5, :6, :7, :8); end;';
						EXECUTE sql_w
							using	in ie_horario_especial_w,
									in qt_material_w,
									in qt_unitaria_especial_w,
									in qt_unitaria_w,
									in qt_saldo_w,
									in pr_margem_w,
									out qt_material_aux_w,
									out qt_saldo2_w;

					exception
						when others then
							qt_material_aux_w := null;
							qt_saldo2_w := null;
					end;
 				--- Fim MD2


				--- Inicio MD3
					if (coalesce(qt_saldo2_w, 0) >= coalesce(qt_unitaria_especial_w, qt_unitaria_w)) and --Conversado com Caldas. De > para >=
					 (coalesce(qt_saldo2_w, 0) > 0) then
						begin
							sql_w := 'CALL calc_saldo_ged_medic_atend_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :qt_saldo_aux_w';
							EXECUTE sql_w
								using	in qt_saldo_w,
										in qt_unitaria_especial_w,
										in qt_unitaria_w,
										in qt_total_dispensar_w,
										in qt_unitaria_2w,
										in ie_dose_menor_w,
										in qt_material_aux_w,
										in 1,
										in ie_horario_especial_w,
										out qt_saldo_aux_w;

						exception
							when others then
								qt_saldo_aux_w := null;
						end;

						qt_saldo_w := qt_saldo_aux_w;
						dt_estabilidade_ww := null;

						if (coalesce(qt_horas_estabilidade_w, 0) > 0) then

							select	nextval('gedi_medic_atend_seq'),
									nr_atendimento,
									cd_material,
									cd_unidade_medida,
									dt_fim_estabilidade
							into STRICT	nr_sequencia_ww,
									nr_atendimento_w,
									cd_material_ww,
									cd_unidade_medida_w,
									dt_estabilidade_ww
							from	gedi_medic_atend
							where	nr_sequencia = nr_sequencia_w;
						else
							select	nextval('gedi_medic_atend_seq'),
									nr_atendimento,
									cd_material,
									cd_unidade_medida
							into STRICT	nr_sequencia_ww,
									nr_atendimento_w,
									cd_material_ww,
									cd_unidade_medida_w
							from	gedi_medic_atend
							where	nr_sequencia = nr_sequencia_w;

						end if;

						insert into gedi_medic_atend(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_atendimento,
							cd_material,
							dt_inicio,
							cd_unidade_medida,
							qt_saldo,
							ie_status,
							nr_seq_horario,
							dt_fim_estabilidade,
							cd_material_prescrito
						) values (
							nr_sequencia_ww,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_atendimento_w,
							cd_material_ww,
							clock_timestamp(),
							cd_unidade_medida_w,
							qt_saldo_w,
							'A',
							nr_seq_horario_p,
							dt_estabilidade_ww,
							cd_material_prescrito_w
						);

						cd_motivo_baixa_w := obter_param_usuario(924, 587, cd_perfil_w, nm_usuario_p, cd_estab_prescr_w, cd_motivo_baixa_w);

						if (coalesce(cd_motivo_baixa_w, 0) > 0) then

							update	prescr_mat_hor
							set		cd_motivo_baixa = cd_motivo_baixa_w
							where	nr_sequencia = nr_seq_horario_p;

						end if;

						update	prescr_mat_hor
						set		ie_gerar_lote = 'N',
								qt_dispensar_hor = 0
						where	nr_sequencia = nr_seq_horario_p;

						if (ie_usuario_def_disp_w <> 'E') then

							update	prescr_material
							set		ie_regra_disp = 'N'
							where	nr_sequencia = nr_seq_material_p
							and		nr_prescricao = nr_prescricao_p
							and		not exists (
													SELECT 1
													from gedi_medic_atend   b,
														 prescr_mat_hor     a
													where b.nr_seq_horario = a.nr_sequencia
														  and a.nr_prescricao = nr_prescricao_p
														  and b.cd_material_prescrito = cd_material_prescrito_w
														  and b.ie_status = 'G'
												);

						end if;

					elsif (ie_usuario_def_disp_w <> 'E') or (cont_w = 0) then

						select	nextval('gedi_medic_atend_seq')
						into STRICT	nr_sequencia_w
						;

						if (qt_saldo_w > 0) and (ie_regra_disp_2w = 'H') then

							begin
								sql_w := 'CALL calc_qt_unit_ged_med_atend_md(:1, :2) INTO :qt_unitaria_2w';
								EXECUTE sql_w
									using in qt_saldo_w, in qt_unitaria_w, out qt_unitaria_2w;
							exception
								when others then
									qt_unitaria_2w := null;
							end;

							SELECT * FROM obter_quant_dispensar(cd_estabelecimento_p, cd_material_w, nr_prescricao_p, nr_sequencia_mat_w, cd_intervalo_w, ie_via_aplicacao_w, qt_unitaria_2w, qt_dose_especial_w, 1, ds_dose_diferenciada_w, ie_origem_inf_w, cd_unidade_medida_dose_w, 1, qt_material_2w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_w, ie_acm_w) INTO STRICT qt_material_2w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;

							begin
								sql_w := 'CALL calc_saldo_ged_medic_atend_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :qt_saldo_aux_w';
								EXECUTE sql_w
									using	in qt_saldo_w,
											in qt_unitaria_especial_w,
											in qt_unitaria_w,
											in qt_total_dispensar_w,
											in qt_unitaria_2w,
											in ie_dose_menor_w,
											in qt_material_aux_w,
											in 2,
											in ie_horario_especial_w,
											out qt_saldo_aux_w;

							exception
								when others then
									qt_saldo_aux_w := null;
							end;

							qt_saldo3_w := qt_saldo_aux_w;

							update	prescr_mat_hor
							set		qt_dispensar_hor = qt_total_dispensar_w
							where	nr_sequencia = nr_seq_horario_p;

							qt_saldo_w := qt_saldo3_w;
						else
							begin
								sql_w := 'CALL calc_saldo_ged_medic_atend_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :qt_saldo_aux_w';
								EXECUTE sql_w
									using	in qt_saldo_w,
											in qt_unitaria_especial_w,
											in qt_unitaria_w,
											in qt_total_dispensar_w,
											in qt_unitaria_2w,
											in ie_dose_menor_w,
											in qt_material_aux_w,
											in 3,
											in ie_horario_especial_w,
											out qt_saldo_aux_w;

							exception
								when others then
									qt_saldo_aux_w := null;
							end;

							qt_saldo_w := qt_saldo_aux_w;
						end if;

						select	min(dt_horario)
						into STRICT	dt_horario_w
						from	prescr_mat_hor
						where	nr_sequencia = nr_seq_horario_p;

						dt_estabilidade_w := null;

						begin
							sql_w := 'CALL obter_dt_estab_med_atend_md(:1, :2) INTO :dt_estabilidade_w';
							EXECUTE sql_w
								using	in dt_horario_w,
										in qt_horas_estabilidade_w,
										out dt_estabilidade_w;
						exception
							when others then
								dt_estabilidade_w := null;
						end;

						insert into gedi_medic_atend(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_atendimento,
							cd_material,
							dt_inicio,
							cd_unidade_medida,
							qt_saldo,
							ie_status,
							nr_seq_horario,
							dt_fim_estabilidade,
							cd_material_prescrito
						) values (
							nr_sequencia_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_atendimento_w,
							cd_material_w,
							clock_timestamp(),
							cd_unid_med_w,
							qt_saldo_w,
							'G',
							nr_seq_horario_p,
							dt_estabilidade_w,
							cd_material_prescrito_w
						);

						update	prescr_material
						set		ie_regra_disp = CASE WHEN coalesce(ie_regra_disp, 'X')='D' THEN  ie_regra_disp WHEN coalesce(ie_regra_disp, 'X')='E' THEN  ie_regra_disp  ELSE 'S' END
						where	nr_sequencia = nr_seq_material_p
						and		nr_prescricao = nr_prescricao_p;

						if (ie_atualiza_dose_disp_hor_w = 'S') then

							update	prescr_mat_hor
							set		qt_dispensar_hor = ceil(qt_dispensar_hor)
							where	nr_sequencia = nr_seq_horario_p;

						end if;

					end if;
				--- Fim MD3
					if (ie_usuario_def_disp_w = 'E') and (cont_w > 0) then

						update	prescr_mat_hor
						set		ie_gerar_lote = 'N',
								qt_dispensar_hor = 0
						where	nr_sequencia = nr_seq_horario_p;

					end if;

					if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
						commit;
					end if;

				end if;

			end if;

		end if;

	end if;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_gedi_medic_atend ( cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_horario_p bigint, nm_usuario_p text ) FROM PUBLIC;
