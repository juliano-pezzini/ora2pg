-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_diluicao ( cd_material_p bigint, nr_seq_diluicao_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_unidade_medida_conv_w	varchar(30);
cd_unidade_medida_dil_w		varchar(30);

cd_estabelecimento_w		smallint;
qt_dose_min_w			double precision;
qt_dose_max_w			double precision;
ie_via_aplicacao_w		varchar(5);
cd_perfil_w			integer;
cd_setor_atendimento_w		integer;
cd_setor_excluir_w		integer;
nr_seq_restricao_w		bigint;
qt_idade_min_w			double precision;
qt_idade_min_mes_w		double precision;
qt_idade_min_dia_w		double precision;
qt_idade_max_w			double precision;
qt_idade_max_mes_w		double precision;
qt_idade_max_dia_w		double precision;
qt_peso_min_w			real;
qt_peso_max_w			real;
cd_diluente_w			integer;
cd_unid_med_diluente_w		varchar(30);
qt_diluicao_w			double precision;
qt_volume_adic_w		double precision;
qt_minuto_aplicacao_w		smallint;
qt_concentracao_w		double precision;
cd_unid_med_concentracao_w	varchar(30);
cd_unid_med_base_concent_w	varchar(30);
nr_seq_prioridade_w		smallint;
ie_cobra_paciente_w		varchar(1);
cd_motivo_baixa_w		smallint;
cd_unid_med_reconst_w		varchar(30);
ds_referencia_w			varchar(255);
ie_atualizar_tempo_w		varchar(1);
ie_priorizar_min_w		varchar(1);
ie_reconstituicao_w		varchar(1);
ie_subtrair_volume_medic_w	varchar(1);
qt_referencia_w			double precision;
nr_seq_via_acesso_w		bigint;
ie_proporcao_w			varchar(15);
qt_dose_min_orig_w		double precision;
qt_dose_max_orig_w		double precision;


count_w				bigint;

c01 CURSOR FOR
SELECT	cd_unidade_medida
from	material_conversao_unidade
where	cd_material = cd_material_p;


BEGIN

select	max(cd_estabelecimento),
	max(cd_unidade_medida),
	max(qt_dose_min),
	max(qt_dose_max),
	max(ie_via_aplicacao),
	max(cd_perfil),
	max(cd_setor_atendimento),
	max(cd_setor_excluir),
	max(nr_seq_restricao),
	max(qt_idade_min),
	max(qt_idade_min_mes),
	max(qt_idade_min_dia),
	max(qt_idade_max),
	max(qt_idade_max_mes),
	max(qt_idade_max_dia),
	max(qt_peso_min),
	max(qt_peso_max),
	max(cd_diluente),
	max(cd_unid_med_diluente),
	max(qt_diluicao),
	max(qt_volume_adic),
	max(qt_minuto_aplicacao),
	max(qt_concentracao),
	max(cd_unid_med_concentracao),
	max(cd_unid_med_base_concent),
	max(nr_seq_prioridade),
	max(ie_cobra_paciente),
	max(cd_motivo_baixa),
	max(cd_unid_med_reconst),
	max(ds_referencia),
	max(ie_atualizar_tempo),
	max(ie_priorizar_min),
	max(ie_reconstituicao),
	max(ie_subtrair_volume_medic),
	max(qt_referencia),
	max(ie_proporcao),
	count(*)
into STRICT	cd_estabelecimento_w,
	cd_unidade_medida_dil_w,
	qt_dose_min_w,
	qt_dose_max_w,
	ie_via_aplicacao_w,
	cd_perfil_w,
	cd_setor_atendimento_w,
	cd_setor_excluir_w,
	nr_seq_restricao_w,
	qt_idade_min_w,
	qt_idade_min_mes_w,
	qt_idade_min_dia_w,
	qt_idade_max_w,
	qt_idade_max_mes_w,
	qt_idade_max_dia_w,
	qt_peso_min_w,
	qt_peso_max_w,
	cd_diluente_w,
	cd_unid_med_diluente_w,
	qt_diluicao_w,
	qt_volume_adic_w,
	qt_minuto_aplicacao_w,
	qt_concentracao_w,
	cd_unid_med_concentracao_w,
	cd_unid_med_base_concent_w,
	nr_seq_prioridade_w,
	ie_cobra_paciente_w,
	cd_motivo_baixa_w,
	cd_unid_med_reconst_w,
	ds_referencia_w,
	ie_atualizar_tempo_w,
	ie_priorizar_min_w,
	ie_reconstituicao_w,
	ie_subtrair_volume_medic_w,
	qt_referencia_w,
	ie_proporcao_w,
	count_w
from	material_diluicao
where	cd_material 	= cd_material_p
and	nr_sequencia 	= nr_seq_diluicao_p
and	(cd_unidade_medida IS NOT NULL AND cd_unidade_medida::text <> '');
--and	((qt_dose_min is not null) or (qt_dose_max is not null));
if (count_w > 0) then

	open C01;
	loop
	fetch C01 into
		cd_unidade_medida_conv_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		qt_dose_min_orig_w := qt_dose_min_w;
		qt_dose_max_orig_w := qt_dose_max_w;

		if (cd_unidade_medida_conv_w <> cd_unidade_medida_dil_w) then

			qt_dose_min_w	:= Obter_dose_convertida(cd_material_p, qt_dose_min_orig_w, cd_unidade_medida_dil_w, cd_unidade_medida_conv_w);
			qt_dose_max_w	:= Obter_dose_convertida(cd_material_p, qt_dose_max_orig_w, cd_unidade_medida_dil_w, cd_unidade_medida_conv_w);

			if (ie_reconstituicao_w = 'S') then
				insert into material_diluicao(
					nr_sequencia,
					cd_estabelecimento,
					cd_unidade_medida,
					qt_dose_min,
					qt_dose_max,
					ie_via_aplicacao,
					cd_perfil,
					cd_setor_atendimento,
					cd_setor_excluir,
					nr_seq_restricao,
					qt_idade_min,
					qt_idade_min_mes,
					qt_idade_min_dia,
					qt_idade_max,
					qt_idade_max_mes,
					qt_idade_max_dia,
					qt_peso_min,
					qt_peso_max,
					cd_diluente,
					cd_unid_med_diluente,
					qt_diluicao,
					qt_volume_adic,
					qt_minuto_aplicacao,
					qt_concentracao,
					cd_unid_med_concentracao,
					cd_unid_med_base_concent,
					nr_seq_prioridade,
					ie_cobra_paciente,
					cd_motivo_baixa,
					cd_unid_med_reconst,
					ds_referencia,
					ie_atualizar_tempo,
					ie_priorizar_min,
					cd_material,
					dt_atualizacao,
					ie_reconstituicao,
					nm_usuario)
				values (
					nextval('material_diluicao_seq'),
					cd_estabelecimento_w,
					cd_unidade_medida_conv_w,
					qt_dose_min_w,
					qt_dose_max_w,
					ie_via_aplicacao_w,
					cd_perfil_w,
					cd_setor_atendimento_w,
					cd_setor_excluir_w,
					nr_seq_restricao_w,
					qt_idade_min_w,
					qt_idade_min_mes_w,
					qt_idade_min_dia_w,
					qt_idade_max_w,
					qt_idade_max_mes_w,
					qt_idade_max_dia_w,
					qt_peso_min_w,
					qt_peso_max_w,
					cd_diluente_w,
					cd_unid_med_diluente_w,
					qt_diluicao_w,
					qt_volume_adic_w,
					qt_minuto_aplicacao_w,
					qt_concentracao_w,
					cd_unid_med_concentracao_w,
					cd_unid_med_base_concent_w,
					nr_seq_prioridade_w,
					ie_cobra_paciente_w,
					cd_motivo_baixa_w,
					cd_unid_med_reconst_w,
					ds_referencia_w,
					ie_atualizar_tempo_w,
					ie_priorizar_min_w,
					cd_material_p,
					clock_timestamp(),
					ie_reconstituicao_w,
					nm_usuario_p
					);
			elsif (ie_reconstituicao_w = 'N') then

				qt_dose_min_w	:= Obter_dose_convertida(cd_material_p, qt_dose_min_orig_w, cd_unidade_medida_dil_w, cd_unidade_medida_conv_w);
				qt_dose_max_w	:= Obter_dose_convertida(cd_material_p, qt_dose_max_orig_w, cd_unidade_medida_dil_w, cd_unidade_medida_conv_w);

				insert into material_diluicao(
					nr_sequencia,
					cd_estabelecimento,
					cd_unidade_medida,
					qt_dose_min,
					qt_dose_max,
					ie_via_aplicacao,
					cd_perfil,
					cd_setor_atendimento,
					cd_setor_excluir,
					nr_seq_restricao,
					qt_idade_min,
					qt_idade_min_mes,
					qt_idade_min_dia,
					qt_idade_max,
					qt_idade_max_mes,
					qt_idade_max_dia,
					qt_peso_min,
					qt_peso_max,
					cd_diluente,
					cd_unid_med_diluente,
					qt_diluicao,
					qt_minuto_aplicacao,
					qt_referencia,
					ie_subtrair_volume_medic,
					nr_seq_prioridade,
					cd_motivo_baixa,
					ds_referencia,
					ie_atualizar_tempo,
					nr_seq_via_acesso,
					ie_proporcao,
					cd_material,
					dt_atualizacao,
					ie_reconstituicao,
					nm_usuario)
				values (
					nextval('material_diluicao_seq'),
					cd_estabelecimento_w,
					cd_unidade_medida_conv_w,
					qt_dose_min_w,
					qt_dose_max_w,
					ie_via_aplicacao_w,
					cd_perfil_w,
					cd_setor_atendimento_w,
					cd_setor_excluir_w,
					nr_seq_restricao_w,
					qt_idade_min_w,
					qt_idade_min_mes_w,
					qt_idade_min_dia_w,
					qt_idade_max_w,
					qt_idade_max_mes_w,
					qt_idade_max_dia_w,
					qt_peso_min_w,
					qt_peso_max_w,
					cd_diluente_w,
					cd_unid_med_diluente_w,
					qt_diluicao_w,
					qt_minuto_aplicacao_w,
					qt_referencia_w,
					ie_subtrair_volume_medic_w,
					nr_seq_prioridade_w,
					cd_motivo_baixa_w,
					ds_referencia_w,
					ie_atualizar_tempo_w,
					nr_seq_via_acesso_w,
					ie_proporcao_w,
					cd_material_p,
					clock_timestamp(),
					ie_reconstituicao_w,
					nm_usuario_p);
			end if;
			qt_dose_min_w	:= qt_dose_min_orig_w;
			qt_dose_max_w	:= qt_dose_max_orig_w;

		end if;

		end;
	end loop;
	close C01;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_diluicao ( cd_material_p bigint, nr_seq_diluicao_p bigint, nm_usuario_p text) FROM PUBLIC;
