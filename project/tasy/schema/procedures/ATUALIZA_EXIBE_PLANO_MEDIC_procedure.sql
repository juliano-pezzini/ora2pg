-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_exibe_plano_medic (ds_descricao_complementar_p text, ie_classificacao_p bigint, cd_material_p bigint, qt_dose_manha_p bigint, qt_dose_almoco_p bigint, qt_dose_tarde_p bigint, qt_dose_noite_p bigint, cd_unidade_medida_plano_p text, ds_observacao_p text, ds_motivo_p text, ds_horario_esp_p text, cd_pessoa_fisica_p text, ds_orientacao_p text, ds_medicamento_p text, ds_forma_medicamento_p text, ds_dose_diferenciada_P text, ds_potencia_p text, ds_forma_desc_p text, ds_unid_med_desc_p text, ds_princ_ativo_p text) AS $body$
DECLARE


	nr_sequencia_w 		paciente_medic_uso.nr_sequencia%TYPE;


BEGIN	

	select 	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from 	plano_versao_medic
	where	coalesce(cd_material,0) = coalesce(cd_material_p, 0)
	and 	coalesce(qt_dose_manha, 0) = coalesce(qt_dose_manha_p,  0)
	and 	coalesce(qt_dose_almoco,0) = coalesce(qt_dose_almoco_p,0)
	and 	coalesce(qt_dose_tarde, 0) = coalesce(qt_dose_tarde_p,  0)
	and 	coalesce(qt_dose_noite, 0) = coalesce(qt_dose_noite_p,  0)
	and 	coalesce(cd_unidade_medida,'XPTO') = coalesce(cd_unidade_medida_plano_p , 'XPTO')
	and 	coalesce(ds_observacao,'XPTO') = coalesce(ds_observacao_p, 'XPTO')
	and 	coalesce(ds_motivo,'XPTO') = coalesce(ds_motivo_p, 'XPTO')
	and 	coalesce(ds_horario_especial,'XPTO') = coalesce(ds_horario_esp_p, 'XPTO')
	and 	coalesce(cd_pessoa_fisica,'XPTO') = coalesce(cd_pessoa_fisica_p, 'XPTO')
	and 	coalesce(ds_orientacao,'XPTO') = coalesce(ds_orientacao_p, 'XPTO')
	and 	coalesce(ds_medicamento,'XPTO') = coalesce(ds_medicamento_p, 'XPTO')
	and 	coalesce(ds_forma_medicamento,'XPTO') = coalesce(ds_forma_medicamento_p, 'XPTO')
	and 	coalesce(ds_dose_diferenciada,'XPTO') = coalesce(ds_dose_diferenciada_P, 'XPTO')
	and 	coalesce(ds_potencia,'XPTO') = coalesce(ds_potencia_p, 'XPTO')
	and 	coalesce(ds_forma_desc,'XPTO') = coalesce(ds_forma_desc_p, 'XPTO')
	and 	coalesce(ds_unid_med_desc,'XPTO') = coalesce(ds_unid_med_desc_p, 'XPTO')
	and 	coalesce(ds_princ_ativo,'XPTO') = coalesce(ds_princ_ativo_p, 'XPTO');
	
	update	plano_versao_medic
	set		ie_exibir_plano_medic = 'S'
	where	nr_sequencia = nr_sequencia_w;
	
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_exibe_plano_medic (ds_descricao_complementar_p text, ie_classificacao_p bigint, cd_material_p bigint, qt_dose_manha_p bigint, qt_dose_almoco_p bigint, qt_dose_tarde_p bigint, qt_dose_noite_p bigint, cd_unidade_medida_plano_p text, ds_observacao_p text, ds_motivo_p text, ds_horario_esp_p text, cd_pessoa_fisica_p text, ds_orientacao_p text, ds_medicamento_p text, ds_forma_medicamento_p text, ds_dose_diferenciada_P text, ds_potencia_p text, ds_forma_desc_p text, ds_unid_med_desc_p text, ds_princ_ativo_p text) FROM PUBLIC;

