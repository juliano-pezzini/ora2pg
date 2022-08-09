-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_dados_medic_estab ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_estab_destino_p bigint, ie_opcao_copia_p bigint, nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_w			bigint;
nr_seq_interno_w		bigint;
qt_existe_w			bigint;
cd_material_w			integer;

c01 CURSOR FOR
SELECT	distinct cd_material
from	material
where	ie_opcao_copia_p	= 0
and	ie_situacao	= 'A'

union all

SELECT	cd_material
from	material
where	ie_opcao_copia_p	= 1
and	cd_material	= cd_material_p;

c02 CURSOR FOR
SELECT	nr_sequencia
from	material_diluicao
where	cd_material		= cd_material_w
and	cd_estabelecimento	= cd_estabelecimento_p;

c03 CURSOR FOR
SELECT	nr_sequencia
from	material_prescr
where	cd_material		= cd_material_w
and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento	= cd_estabelecimento_p));


BEGIN
open C01;
loop
fetch C01 into	
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (nm_tabela_p = 'MATERIAL_ESTAB') then

		select	count(*)
		into STRICT	qt_existe_w
		from	material_estab
		where	cd_material	= cd_material_w
		and	cd_estabelecimento	= cd_estab_destino_p;
		
		if (qt_existe_w = 0) then

			--select	material_estab_seq.nextval

			--into	nr_sequencia_w

			--from	dual;
			
			insert into material_estab(
				nr_sequencia,			cd_estabelecimento,			cd_material,
				dt_atualizacao,			nm_usuario,				ie_baixa_estoq_pac,
				ie_material_estoque,		qt_estoque_minimo,				qt_ponto_pedido,
				qt_estoque_maximo,		qt_dia_interv_ressup,			qt_dia_ressup_forn,
				qt_dia_estoque_minimo,		nr_minimo_cotacao,				qt_consumo_mensal,
				cd_material_conta,			cd_kit_material,				qt_peso_kg,
				dt_atual_consumo,			qt_mes_consumo,				ie_ressuprimento,
				dt_atualizacao_nrec,		nm_usuario_nrec,				ie_classif_custo,
				nr_registro_anvisa,			ie_prescricao,				ie_padronizado,
				ie_estoque_lote,			ie_requisicao,				ie_curva_xyz,
				ie_controla_serie,			dt_validade_reg_anvisa,			ie_unid_consumo_prescr,
				qt_desvio_padrao_cons, 		ie_vigente_anvisa)
			SELECT	nextval('material_estab_seq'),	cd_estab_destino_p,			cd_material,
				clock_timestamp(),			nm_usuario_p,				ie_baixa_estoq_pac,
				ie_material_estoque,		qt_estoque_minimo,				qt_ponto_pedido,
				qt_estoque_maximo,		qt_dia_interv_ressup,			qt_dia_ressup_forn,
				qt_dia_estoque_minimo,		nr_minimo_cotacao,				qt_consumo_mensal,
				cd_material_conta,			cd_kit_material,				qt_peso_kg,
				dt_atual_consumo,			qt_mes_consumo,				ie_ressuprimento,
				clock_timestamp(),				nm_usuario_p,				ie_classif_custo,
				nr_registro_anvisa,			ie_prescricao,				ie_padronizado,
				ie_estoque_lote,			ie_requisicao,				ie_curva_xyz,
				ie_controla_serie,			dt_validade_reg_anvisa,			ie_unid_consumo_prescr,
				qt_desvio_padrao_cons,			ie_vigente_anvisa
			from	material_estab
			where	cd_material	= cd_material_w
			and	cd_estabelecimento	= cd_estabelecimento_p;
		end if;

	elsif (nm_tabela_p = 'MATERIAL_DILUICAO') then

		qt_existe_w	:= 0;
		/* Comentei esta linha porque esta mesma tabela e utilizada para as pastas de diluicao,recontituicao e rediluicao, sendo assim nao copia os tres itens.
		select	count(*)
		into	qt_existe_w
		from	material_diluicao
		where	cd_material	= cd_material_w
		and	cd_estabelecimento	= cd_estab_destino_p;*/
		
		if (qt_existe_w = 0) then
		
			open C02;
			loop
			fetch C02 into	
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */

				select	nextval('material_diluicao_seq')
				into STRICT	nr_seq_w
				;
				
				select	nextval('material_diluicao_seq')
				into STRICT	nr_seq_interno_w
				;
					
				insert into material_diluicao(
					cd_material,			nr_sequencia,			cd_unidade_medida,
					cd_diluente,			cd_unid_med_diluente,		dt_atualizacao,
					nm_usuario,			qt_diluicao,			qt_minima_diluicao,
					qt_fixa_diluicao,			qt_minuto_aplicacao,		ie_reconstituicao,
					ie_via_aplicacao,			qt_concentracao,			cd_unid_med_concentracao,
					cd_unid_med_base_concent,		nr_seq_prioridade,			cd_intervalo,
					dt_atualizacao_nrec,		nm_usuario_nrec,			cd_setor_atendimento,
					cd_estabelecimento,		qt_idade_min,			qt_idade_max,
					ie_cobra_paciente,			cd_motivo_baixa,			cd_setor_excluir,
					qt_peso_min,			qt_peso_max,			ie_proporcao,
					qt_referencia,			nr_seq_interno,			qt_volume_adic,
					qt_idade_min_mes,			qt_idade_min_dia,			qt_idade_max_mes,
					qt_idade_max_dia,			qt_dose_min,			qt_dose_max,
					nr_seq_via_acesso,			nr_seq_restricao,			qt_volume,
					ie_gerar_rediluente,			ie_subtrair_volume_medic,		cd_unid_med_reconst)
				SELECT	cd_material,			nr_seq_w,			cd_unidade_medida,
					cd_diluente,			cd_unid_med_diluente,		clock_timestamp(),
					nm_usuario_p,			qt_diluicao,			qt_minima_diluicao,
					qt_fixa_diluicao,			qt_minuto_aplicacao,		ie_reconstituicao,
					ie_via_aplicacao,			qt_concentracao,			cd_unid_med_concentracao,
					cd_unid_med_base_concent,		nr_seq_prioridade,			cd_intervalo,
					clock_timestamp(),				nm_usuario_p,			cd_setor_atendimento,
					cd_estab_destino_p,		qt_idade_min,			qt_idade_max,
					ie_cobra_paciente,			cd_motivo_baixa,			cd_setor_excluir,
					qt_peso_min,			qt_peso_max,			ie_proporcao,
					qt_referencia,			nr_seq_interno_w,			qt_volume_adic,
					qt_idade_min_mes,			qt_idade_min_dia,			qt_idade_max_mes,
					qt_idade_max_dia,			qt_dose_min,			qt_dose_max,
					nr_seq_via_acesso,			nr_seq_restricao,			qt_volume,
					ie_gerar_rediluente,			ie_subtrair_volume_medic,		cd_unid_med_reconst
				from	material_diluicao
				where	cd_material		= cd_material_w
				and	nr_sequencia		= nr_sequencia_w
				and	cd_estabelecimento	= cd_estabelecimento_p;
			
			end loop;
			close C02;
		end if;
		
	elsif (nm_tabela_p = 'MATERIAL_PRESCR') then

		select	count(*)
		into STRICT	qt_existe_w
		from	material_prescr
		where	cd_material		= cd_material_w
		and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estab_destino_p));
		
		if (qt_existe_w = 0) then

		
			open C03;
			loop
			fetch C03 into	
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
			
			select	nextval('material_prescr_seq')
			into STRICT	nr_seq_w
			;
			
			insert into material_prescr(
					nr_sequencia,			cd_estabelecimento,			dt_atualizacao,
					nm_usuario,				dt_atualizacao_nrec,		nm_usuario_nrec,
					cd_material,			cd_setor_atendimento,		cd_intervalo,
					cd_unidade_medida,		qt_dose,					cd_unid_med_limite,
					qt_limite_pessoa,		ie_dose_limite,				qt_idade_min,
					qt_idade_max,			ie_via_aplicacao,			qt_peso_min,
					qt_peso_max,			qt_intervalo_horas,			qt_dias_maximo,
					ie_tipo,				qt_intervalo_max_horas,		ie_via_aplic_padrao,
					ie_dispositivo_infusao,	qt_minuto_aplicacao,		hr_prim_horario,
					qt_concentracao,		qt_concentracao_min,
					cd_unid_med_cons_peso,	cd_unid_med_cons_volume,
					qt_dias_solicitado,		ie_exige_justificativa,		ie_dose,
					qt_idade_min_mes,		qt_idade_min_dia,			qt_idade_max_mes,
					qt_idade_max_dia,		ds_justificativa,			qt_hora_aplicacao,
					qt_solucao,				ie_justificativa,			cd_especialidade,
					ie_diluicao,			qt_dias_prev_maximo,		ie_objetivo,
					cd_intervalo_filtro,	ie_tipo_item)
			SELECT	nr_seq_w,			cd_estab_destino_p,			clock_timestamp(),
					nm_usuario_p,			clock_timestamp(),					nm_usuario_p,
					cd_material,			cd_setor_atendimento,		cd_intervalo,
					cd_unidade_medida,		qt_dose,					cd_unid_med_limite,
					qt_limite_pessoa,		ie_dose_limite,				qt_idade_min,
					qt_idade_max,			ie_via_aplicacao,			qt_peso_min,
					qt_peso_max,			qt_intervalo_horas,			qt_dias_maximo,
					ie_tipo,				qt_intervalo_max_horas,		ie_via_aplic_padrao,
					ie_dispositivo_infusao,	qt_minuto_aplicacao,		hr_prim_horario,
					qt_concentracao,		qt_concentracao_min,
					cd_unid_med_cons_peso,	cd_unid_med_cons_volume,
					qt_dias_solicitado,		ie_exige_justificativa,		ie_dose,
					qt_idade_min_mes,		qt_idade_min_dia,			qt_idade_max_mes,
					qt_idade_max_dia,		ds_justificativa,			qt_hora_aplicacao,
					qt_solucao,				ie_justificativa,			cd_especialidade,
					ie_diluicao,			qt_dias_prev_maximo,		ie_objetivo,
					cd_intervalo_filtro,	ie_tipo_item
			from	material_prescr
			where	cd_material	= cd_material_w
			and		nr_sequencia	= nr_sequencia_w
			and		((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p));
			
			CALL sup_gravar_historico_material(	cd_estab_destino_p,
						cd_material_w,
						'Copia da MATERIAL_PRESCR',
						obter_desc_expressao(348002, 'NM_TABELA_W='|| 'MATERIAL_PRESCR' || ';CD_ESTABELECIMENTO_P=' || cd_estabelecimento_p || ';CD_ESTAB_DESTINO_P='||cd_estab_destino_p)/*'Foi copiado as informacoes da tabela MATERIAL_PRESCR (Seq= ' || nr_sequencia_w || ' ) do estabelecimento ' || cd_estabelecimento_p || ' para ' || cd_estab_destino_p || '.'*/,
						'S',
						nm_usuario_p);
			end loop;
			close c03;
		end if;
		
	elsif (nm_tabela_p = 'KIT_MAT_PRESCRICAO') then

		select	count(*)
		into STRICT	qt_existe_w
		from	kit_mat_prescricao
		where	cd_material	= cd_material_w
		and	cd_estabelecimento	= cd_estab_destino_p;
		
		if (qt_existe_w = 0) then

			--select	kit_mat_prescricao_seq.nextval

			--into	nr_sequencia_w

			--from	dual;
			
			insert into kit_mat_prescricao(
				nr_sequencia,			cd_estabelecimento,		dt_atualizacao,
				nm_usuario,				cd_kit,					cd_material,
				qt_volume,				ie_via_aplicacao,		dt_atualizacao_nrec,
				nm_usuario_nrec,		cd_unidade_medida,		cd_setor_atendimento,
				cd_setor_excluir,		ie_tipo_atendimento,	
				qt_idade_min,			qt_idade_min_mes,		qt_idade_min_dia,
				qt_idade_max,			qt_idade_max_mes,		qt_idade_max_dia,
				nr_seq_via_acesso,		qt_dose_max,
				qt_dose_min,			cd_unidade_medida_dose,	qt_tempo_min,
				qt_tempo_max,			ie_gerar_lib_farm,		ie_gerar_recons_dilui,
				ie_bomba_infusao,		nr_horas_validade_kit)
			SELECT	nextval('kit_mat_prescricao_seq'),	cd_estab_destino_p,		clock_timestamp(),
				nm_usuario_p,			cd_kit,					cd_material,
				qt_volume,				ie_via_aplicacao,		clock_timestamp(),
				nm_usuario_p,			cd_unidade_medida,		cd_setor_atendimento,
				cd_setor_excluir,		ie_tipo_atendimento,	
				qt_idade_min,			qt_idade_min_mes,		qt_idade_min_dia,
				qt_idade_max,			qt_idade_max_mes,		qt_idade_max_dia,
				nr_seq_via_acesso,		qt_dose_max,
				qt_dose_min,			cd_unidade_medida_dose,	qt_tempo_min,
				qt_tempo_max,			ie_gerar_lib_farm,		ie_gerar_recons_dilui,
				ie_bomba_infusao,		nr_horas_validade_kit
			from	kit_mat_prescricao
			where	cd_material	= cd_material_w
			and	cd_estabelecimento	= cd_estabelecimento_p;
		end if;

	elsif (nm_tabela_p = 'MATERIAL_DOSE_TERAP') then
		
		select	count(*)
		into STRICT	qt_existe_w
		from	material_dose_terap
		where	cd_material	= cd_material_w
		and	cd_estabelecimento	= cd_estab_destino_p;
		
		if (qt_existe_w = 0) then	
		
			--select	material_dose_terap_seq.nextval

			--into	nr_sequencia_w

			--from	dual;
			insert into material_dose_terap(
				nr_sequencia,			dt_atualizacao,			nm_usuario,
				dt_atualizacao_nrec,		nm_usuario_nrec,			cd_estabelecimento,
				cd_material,			nr_seq_dose_terap,			qt_dose_min_aviso,
				qt_dose_max_aviso,		qt_dose_min_bloqueia,		qt_dose_max_bloqueia,
				qt_idade_minima,			qt_idade_maxima,			qt_peso_minimo,
				qt_peso_maximo,			cd_setor_atendimento)
			SELECT	nextval('material_dose_terap_seq'),	dt_atualizacao,			nm_usuario_p,
				clock_timestamp(),				nm_usuario_p,			cd_estab_destino_p,
				cd_material,			nr_seq_dose_terap,			qt_dose_min_aviso,
				qt_dose_max_aviso,		qt_dose_min_bloqueia,		qt_dose_max_bloqueia,
				qt_idade_minima,			qt_idade_maxima,			qt_peso_minimo,
				qt_peso_maximo,			cd_setor_atendimento
			from	material_dose_terap
			where	cd_material	= cd_material_w
			and	cd_estabelecimento	= cd_estabelecimento_p;
		end if;
	end if;
	end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_dados_medic_estab ( cd_material_p bigint, cd_estabelecimento_p bigint, cd_estab_destino_p bigint, ie_opcao_copia_p bigint, nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;
