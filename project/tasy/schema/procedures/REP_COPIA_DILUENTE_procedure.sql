-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_copia_diluente ( nr_prescricao_original_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text, nr_seq_mat_princ_p bigint default null) AS $body$
DECLARE

	
ie_loop_w		varchar(1);	
qt_itens_w		bigint;
nr_agrup_acum_w		bigint;
nr_sequencia_w		bigint;
nr_Seq_nova_atual_w	bigint := -1;
ie_copia_valid_igual_w	varchar(1);
dt_validade_origem_w	timestamp;
dt_validade_nova_w	timestamp;
dt_prescricao_www	timestamp;
dt_primeiro_horario_w	timestamp;
dt_inicio_prescr_w	timestamp;
nr_horas_validade_w	integer;
ie_prim_horario_setor_w	varchar(10);
hr_setor_w		varchar(10);
var_copia_diluicao_w	varchar(1);
ie_gerar_dil_setor_w	varchar(1);
cd_setor_atendimento_w	bigint;
cd_estabelecimento_w	smallint;
nr_atendimento_w	bigint;
cd_setor_prescr_w	bigint;
QT_JA_EXISTE_W	bigint;
var_param_813_w varchar(1);
nr_sequencia_precision_w    user_tab_columns.data_precision%type;

C01 CURSOR FOR
	SELECT 	a.*,
		b.nr_sequencia nr_Seq_nova,
		b.hr_prim_horario hr_prim_hor_nova,
		b.ds_horarios	ds_horarios_nova,
		b.ie_acm	ie_acm_nova,
		b.ie_se_necessario ie_se_neces_nova
	from	material c,
		prescr_material b,
		prescr_material a
	where	a.nr_prescricao = nr_prescricao_original_p 
	and 	b.nr_prescricao = nr_prescricao_p
	and	a.nr_sequencia_diluicao	= nr_seq_material_p
	and 	a.nr_sequencia_diluicao = b.nr_seq_anterior
	and 	a.nr_prescricao = b.nr_prescricao_original
	and 	c.cd_material	= a.cd_material
	and	coalesce(b.ie_suspenso,'N')		<> 'S'
	and	c.ie_situacao			= 'A'
	order by a.nr_sequencia;
	
c01row_w	c01%rowtype;


BEGIN

select	max(cd_estabelecimento),
		max(cd_setor_atendimento)
into STRICT	cd_estabelecimento_w,
		cd_setor_prescr_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	coalesce(max(ie_gerar_diluicao),'S')
into STRICT	ie_gerar_dil_setor_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_prescr_w;

var_copia_diluicao_w := Obter_Param_Usuario(924, 1077, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w, var_copia_diluicao_w);
var_param_813_w := Obter_Param_Usuario(924, 813, Obter_Perfil_ativo, nm_usuario_p, cd_estabelecimento_w, var_param_813_w);

select	coalesce(max(data_precision), 6)
into STRICT	nr_sequencia_precision_w
from	user_tab_columns
where	upper(table_name) = upper('prescr_material')
and		upper(column_name) = upper('nr_sequencia');

if	((var_copia_diluicao_w <> 'N') or (var_param_813_w = 'P')) and
	((ie_gerar_dil_setor_w = 'S') or (var_copia_diluicao_w = 'T')) then
	Select	Max(nr_agrupamento)
	into STRICT	nr_agrup_acum_w
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p;

	open C01;
	loop
	fetch C01 into	
		c01row_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if	nr_Seq_nova_atual_w = -1 then
			nr_Seq_nova_atual_w := c01row_w.nr_Seq_nova;
		end if;
		
		ie_loop_w := 'S';
		nr_sequencia_w := c01row_w.nr_sequencia;
		nr_sequencia_w := nr_sequencia_w + nr_seq_material_p;
		
		if (length(nr_sequencia_w) > nr_sequencia_precision_w) then
			nr_sequencia_w := 1;
		end if;
		
		c01row_w.nr_agrupamento		:= c01row_w.nr_agrupamento + nr_agrup_acum_w;
		while(ie_loop_w = 'S') loop
			select	count(*)
			into STRICT	qt_itens_w
			from	prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_sequencia_w;
			if (qt_itens_w	= 0) then
				ie_loop_w	:= 'N';
			else	
				nr_sequencia_w	:= nr_sequencia_w + 1;
			end if;
		end loop;
		begin
		
		if (c01row_w.ie_agrupador = 3) then
		
			select	count(nr_sequencia)
			into STRICT	qt_ja_existe_w
			from	prescr_material
			where	ie_agrupador = 3
			and	nr_sequencia_diluicao 	= coalesce(nr_seq_mat_princ_p, c01row_w.nr_seq_nova)
			and	nr_prescricao = nr_prescricao_p;
			
		elsif (c01row_w.ie_agrupador = 7) then	
		
			select	count(nr_sequencia)
			into STRICT	qt_ja_existe_w
			from	prescr_material
			where	ie_agrupador = 7
			and	nr_sequencia_diluicao 	= coalesce(nr_seq_mat_princ_p, c01row_w.nr_seq_nova)
			and	nr_prescricao = nr_prescricao_p;
			
		elsif (c01row_w.ie_agrupador = 9) then

			select	count(nr_sequencia)
			into STRICT	qt_ja_existe_w
			from	prescr_material
			where	ie_agrupador = 9
			and	nr_sequencia_diluicao 	= coalesce(nr_seq_mat_princ_p, c01row_w.nr_seq_nova)
			and	nr_prescricao = nr_prescricao_p;

		end if;
		
		if (qt_ja_existe_w = 0) then
		
			Insert  into Prescr_Material(
					nr_prescricao,
					nr_sequencia,
					ie_origem_inf,
					cd_material,
					cd_unidade_medida,
					qt_dose,
					qt_unitaria,
					qt_material,
					dt_atualizacao,
					nm_usuario,
					cd_intervalo,
					ds_horarios,
					ds_observacao,
					ds_observacao_enf,
					ie_via_aplicacao,
					nr_agrupamento,
					ie_cobra_paciente,
					cd_motivo_baixa,
					dt_baixa,
					ie_utiliza_kit,
					cd_unidade_medida_dose,
					qt_conversao_dose,
					nr_ocorrencia,
					qt_total_dispensar,
					cd_fornec_consignado,
					--nr_sequencia_solucao,

					--nr_sequencia_proc,
					qt_solucao,
					ds_dose_diferenciada,
					ie_medicacao_paciente,
					nr_sequencia_diluicao,
					hr_prim_horario,
					nr_sequencia_dieta,
					ie_agrupador,
					nr_dia_util,
					ie_suspenso,
					ie_se_necessario,
					qt_min_aplicacao,
					ie_bomba_infusao,
					ie_aplic_bolus,
					ie_aplic_lenta,
					ie_acm,
					ie_objetivo,
					cd_topografia_cih,
					ie_origem_infeccao,
					cd_amostra_cih,
					cd_microorganismo_cih,
					ie_uso_antimicrobiano,
					cd_protocolo,
					nr_seq_protocolo,
					nr_seq_mat_protocolo,
					qt_hora_aplicacao,
					ie_recons_diluente_fixo,
					qt_vel_infusao,
					ds_justificativa,
					ie_sem_aprazamento,
					ie_indicacao,
					dt_proxima_dose,
					qt_total_dias_lib,
					nr_seq_substituto,
					ie_lado,
					dt_inicio_medic,
					qt_dia_prim_hor,
					ie_regra_disp,
					qt_vol_adic_reconst,
					qt_hora_intervalo,
					qt_min_intervalo,
					ie_urgencia,
					IE_PERMITE_SUBSTITUIR,
					qt_dose_especial,
					ie_dose_espec_agora,
					hr_dose_especial,
					ds_observacao_far,
					nr_seq_anterior,
					nr_prescricao_original,
					nr_seq_mat_diluicao,
					qt_qsp_diluente,
					ie_gerar_lote)
				values (nr_prescricao_p,
					nr_sequencia_w,
					c01row_w.ie_origem_inf,
					c01row_w.cd_material,
					c01row_w.cd_unidade_medida,
					c01row_w.qt_dose,
					c01row_w.qt_unitaria,
					c01row_w.qt_material,
					clock_timestamp(),
					nm_usuario_p,
					c01row_w.cd_intervalo,
					c01row_w.ds_horarios_nova,
					c01row_w.ds_observacao,
					c01row_w.ds_observacao_enf,
					c01row_w.ie_via_aplicacao,
					c01row_w.nr_agrupamento,
					coalesce(c01row_w.ie_cobra_paciente,'S'),
					CASE WHEN coalesce(c01row_w.ie_regra_disp,'X')='D' THEN  c01row_w.cd_motivo_baixa  ELSE CASE WHEN coalesce(c01row_w.ie_cobra_paciente,'S')='S' THEN  0  ELSE c01row_w.cd_motivo_baixa END  END ,CASE WHEN coalesce(c01row_w.ie_regra_disp,'X')='D' THEN  clock_timestamp()  ELSE CASE WHEN coalesce(c01row_w.ie_cobra_paciente,'S')='S' THEN  null  ELSE clock_timestamp() END  END ,
					c01row_w.ie_utiliza_kit,
					c01row_w.cd_unidade_medida_dose,
					c01row_w.qt_conversao_dose,
					c01row_w.nr_ocorrencia,
					c01row_w.qt_total_dispensar,
					c01row_w.cd_fornec_consignado,
					c01row_w.qt_solucao,
					c01row_w.ds_dose_diferenciada,
					c01row_w.ie_medicacao_paciente,
					coalesce(nr_seq_mat_princ_p, c01row_w.nr_seq_nova),
					c01row_w.hr_prim_hor_nova,
					c01row_w.nr_sequencia_dieta,
					c01row_w.ie_agrupador,
					c01row_w.nr_dia_util,
					'N',
					c01row_w.ie_se_neces_nova,
					c01row_w.qt_min_aplicacao,
					c01row_w.ie_bomba_infusao,
					coalesce(c01row_w.ie_aplic_bolus,'N'),
					coalesce(c01row_w.ie_aplic_lenta,'N'),
					coalesce(c01row_w.ie_acm_nova,'N'),
					c01row_w.ie_objetivo,
					c01row_w.cd_topografia_cih,
					c01row_w.ie_origem_infeccao,
					c01row_w.cd_amostra_cih,
					c01row_w.cd_microorganismo_cih,
					coalesce(c01row_w.ie_uso_antimicrobiano,'N'),
					c01row_w.cd_protocolo,
					c01row_w.nr_seq_protocolo,
					c01row_w.nr_seq_mat_protocolo,
					c01row_w.qt_hora_aplicacao,
					'N',
					c01row_w.qt_vel_infusao,
					c01row_w.ds_justificativa,
					c01row_w.ie_sem_aprazamento,
					c01row_w.ie_indicacao,
					c01row_w.dt_proxima_dose,
					c01row_w.qt_total_dias_lib,
					c01row_w.nr_seq_substituto,
					c01row_w.ie_lado,
					c01row_w.dt_inicio_medic,
					c01row_w.qt_dia_prim_hor,
					CASE WHEN coalesce(c01row_w.ie_regra_disp,'X')='D' THEN  c01row_w.ie_regra_disp  ELSE null END  ,
					c01row_w.qt_vol_adic_reconst,
					c01row_w.qt_hora_intervalo,
					c01row_w.qt_min_intervalo,
					'N',
					c01row_w.IE_PERMITE_SUBSTITUIR,
					null,
					'N',
					null,
					c01row_w.ds_observacao_far,
					c01row_w.nr_sequencia,
					c01row_w.nr_prescricao,
					c01row_w.nr_seq_mat_diluicao,
					c01row_w.qt_qsp_diluente,
					c01row_w.ie_gerar_lote);
			
			
			if	nr_Seq_nova_atual_w <> c01row_w.nr_Seq_nova then
				CALL Ajustar_prescr_material(nr_prescricao_p, nr_Seq_nova_atual_w);
				nr_Seq_nova_atual_w := c01row_w.nr_Seq_nova;
			end if;
		end if;
		
		exception when others then
			CALL Gerar_log_prescr_mat(nr_prescricao_p, nr_sequencia_w, null, null, null, substr('Exception: '||substr(sqlerrm||chr(13)||DBMS_UTILITY.format_error_backtrace,1,1500),1,4000), nm_usuario_p, 'N');		
			end;		
		end;
	
	end loop;
	close C01;
		
	CALL Ajustar_prescr_material(nr_prescricao_p, nr_Seq_nova_atual_w);
end if;
	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_copia_diluente ( nr_prescricao_original_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text, nr_seq_mat_princ_p bigint default null) FROM PUBLIC;

