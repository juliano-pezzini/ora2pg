-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_prescr_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Campos da tabela LOOP */

cd_setor_atendimento_w     		integer;
cd_intervalo_w             		varchar(7);
cd_unidade_medida_w        		varchar(30);
qt_dose_w                  		double precision;
cd_unid_med_limite_w       		varchar(30);
qt_limite_pessoa_w         		double precision;
ie_dose_limite_w           		varchar(15);
qt_idade_min_w             		real;
qt_idade_max_w             		real;
ie_via_aplicacao_w         		varchar(5);
qt_peso_min_w              		real;
qt_peso_max_w              		real;
qt_intervalo_horas_w       		smallint;
qt_dias_maximo_w           		smallint;
ie_tipo_w                  		varchar(15);
qt_intervalo_max_horas_w   		smallint;
ie_via_aplic_padrao_w      		varchar(5);
ie_dispositivo_infusao_w   		varchar(1);
qt_minuto_aplicacao_w      		smallint;
hr_prim_horario_w          		varchar(5);
qt_concentracao_w          		double precision;
qt_concentracao_min_w			double precision;
cd_unid_med_cons_peso_w  		varchar(30);
cd_unid_med_cons_volume_w  	varchar(30);
qt_dias_solicitado_w       		smallint;
ie_dose_w                  		varchar(2);
qt_idade_min_mes_w         		double precision;
qt_idade_min_dia_w         		double precision;
qt_idade_max_mes_w         		double precision;
qt_idade_max_dia_w         		double precision;
qt_hora_aplicacao_w        		smallint;
qt_solucao_w               		double precision;
ie_justificativa_w         		varchar(1);
cd_especialidade_w         		integer;
ie_diluicao_w              		varchar(1);
qt_dias_prev_maximo_w      		smallint;
ie_objetivo_w              		varchar(1);
ie_se_necessario_w         		varchar(1);
ie_somente_sn_w            		varchar(1);
ds_referencia_w            		varchar(255);
qt_dose_min_w              		double precision;
cd_um_minima_w             		varchar(30);
ie_justificativa_padrao_w  		varchar(1);
ie_dose_nula_w             		varchar(1);
ie_tipo_item_w					material_prescr.ie_tipo_item%type;

/*  Sequencia da tabela */

nr_sequencia_w			   bigint;

C01 CURSOR FOR
	SELECT	cd_setor_atendimento,
			cd_intervalo,
			cd_unidade_medida,
			qt_dose,
			cd_unid_med_limite,
			qt_limite_pessoa,
			ie_dose_limite,
			qt_idade_min,
			qt_idade_max,
			ie_via_aplicacao,
			qt_peso_min,
			qt_peso_max,
			qt_intervalo_horas,
			qt_dias_maximo,
			ie_tipo,
			qt_intervalo_max_horas,
			ie_via_aplic_padrao,
			ie_dispositivo_infusao,
			qt_minuto_aplicacao,
			hr_prim_horario,
			qt_concentracao,
			qt_concentracao_min,
			cd_unid_med_cons_peso,
			cd_unid_med_cons_volume,
			qt_dias_solicitado,
			ie_dose,
			qt_idade_min_mes,
			qt_idade_min_dia,
			qt_idade_max_mes,
			qt_idade_max_dia,
			qt_hora_aplicacao,
			qt_solucao,
			ie_justificativa,
			cd_especialidade,
			ie_diluicao,
			qt_dias_prev_maximo,
			ie_objetivo,
			ie_se_necessario,
			ie_somente_sn,
			ds_referencia,
			qt_dose_min,
			cd_um_minima,
			obter_dados_medic_atb_var(cd_material,cd_estabelecimento_p,ie_justificativa_padrao,'JP',null,null,null),
			ie_dose_nula,
			ie_tipo_item
	from		material_prescr
	where	cd_material = cd_material_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_setor_atendimento_w,
	cd_intervalo_w,
	cd_unidade_medida_w,
	qt_dose_w,
	cd_unid_med_limite_w,
	qt_limite_pessoa_w,
	ie_dose_limite_w,
	qt_idade_min_w,
	qt_idade_max_w,
	ie_via_aplicacao_w,
	qt_peso_min_w,
	qt_peso_max_w,
	qt_intervalo_horas_w,
	qt_dias_maximo_w,
	ie_tipo_w,
	qt_intervalo_max_horas_w,
	ie_via_aplic_padrao_w,
	ie_dispositivo_infusao_w,
	qt_minuto_aplicacao_w,
	hr_prim_horario_w,
	qt_concentracao_w,
	qt_concentracao_min_w,
	cd_unid_med_cons_peso_w,
	cd_unid_med_cons_volume_w,
	qt_dias_solicitado_w,
	ie_dose_w,
	qt_idade_min_mes_w,
	qt_idade_min_dia_w,
	qt_idade_max_mes_w,
	qt_idade_max_dia_w,
	qt_hora_aplicacao_w,
	qt_solucao_w,
	ie_justificativa_w,
	cd_especialidade_w,
	ie_diluicao_w,
	qt_dias_prev_maximo_w,
	ie_objetivo_w,
	ie_se_necessario_w,
	ie_somente_sn_w,
	ds_referencia_w,
	qt_dose_min_w,
	cd_um_minima_w,
	ie_justificativa_padrao_w,
	ie_dose_nula_w,
	ie_tipo_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select 	nextval('material_prescr_seq')
	into STRICT	nr_sequencia_w
	;

	insert into  material_prescr( 	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_estabelecimento,
				cd_material,
				cd_setor_atendimento,
				cd_intervalo,
				cd_unidade_medida,
				qt_dose,
				cd_unid_med_limite,
				qt_limite_pessoa,
				ie_dose_limite,
				qt_idade_min,
				qt_idade_max,
				ie_via_aplicacao,
				qt_peso_min,
				qt_peso_max,
				qt_intervalo_horas,
				qt_dias_maximo,
				ie_tipo,
				qt_intervalo_max_horas,
				ie_via_aplic_padrao,
				ie_dispositivo_infusao,
				qt_minuto_aplicacao,
				hr_prim_horario,
				qt_concentracao,
				qt_concentracao_min,
				cd_unid_med_cons_peso,
				cd_unid_med_cons_volume,
				qt_dias_solicitado,
				ie_dose,
				qt_idade_min_mes,
				qt_idade_min_dia,
				qt_idade_max_mes,
				qt_idade_max_dia,
				qt_hora_aplicacao,
				qt_solucao,
				ie_justificativa,
				cd_especialidade,
				ie_diluicao,
				qt_dias_prev_maximo,
				ie_objetivo,
				ie_se_necessario,
				ie_somente_sn,
				ds_referencia,
				qt_dose_min,
				cd_um_minima,
				ie_justificativa_padrao,
				ie_dose_nula,
				ie_tipo_item
				)
		values (	nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento_p,
				cd_material_novo_p,
				cd_setor_atendimento_w,
				cd_intervalo_w,
				cd_unidade_medida_w,
				qt_dose_w,
				cd_unid_med_limite_w,
				qt_limite_pessoa_w,
				ie_dose_limite_w,
				qt_idade_min_w,
				qt_idade_max_w,
				ie_via_aplicacao_w,
				qt_peso_min_w,
				qt_peso_max_w,
				qt_intervalo_horas_w,
				qt_dias_maximo_w,
				ie_tipo_w,
				qt_intervalo_max_horas_w,
				ie_via_aplic_padrao_w,
				ie_dispositivo_infusao_w,
				qt_minuto_aplicacao_w,
				hr_prim_horario_w,
				qt_concentracao_w,
				qt_concentracao_min_w,
				cd_unid_med_cons_peso_w,
				cd_unid_med_cons_volume_w,
				qt_dias_solicitado_w,
				ie_dose_w,
				qt_idade_min_mes_w,
				qt_idade_min_dia_w,
				qt_idade_max_mes_w,
				qt_idade_max_dia_w,
				qt_hora_aplicacao_w,
				qt_solucao_w,
				ie_justificativa_w,
				cd_especialidade_w,
				ie_diluicao_w,
				qt_dias_prev_maximo_w,
				ie_objetivo_w,
				ie_se_necessario_w,
				ie_somente_sn_w,
				ds_referencia_w,
				qt_dose_min_w,
				cd_um_minima_w,
				ie_justificativa_padrao_w,
				ie_dose_nula_w,
				ie_tipo_item_w
				);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_prescr_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

