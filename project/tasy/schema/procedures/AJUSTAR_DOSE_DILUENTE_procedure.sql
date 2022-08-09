-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_dose_diluente ( nr_prescricao_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE


nr_ocorrencia_w					double precision;
nr_sequencia_w					integer;
qt_conversao_dose_w				double precision;
cd_material_w					integer;
qt_unitaria_w					double precision;
qt_unitaria_pai_w				double precision;
qt_material_w					double precision;
qt_dose_especial_w				double precision;
qt_dose_especial_dil_w			double precision;
qt_dose_especial_ww				double precision;
ds_dose_diferenciada_w			varchar(50);
ie_origem_inf_w					varchar(1);
qt_dispensar_w					double precision;
qt_total_disp_w					double precision;
ds_erro_w						varchar(255);
cd_intervalo_w					varchar(7);
cd_intervalo_cad_w				varchar(7);
cd_intervalo_novo_w				varchar(7);
ie_acm_w						varchar(1);
ie_se_necessario_w				varchar(1);
ie_agrupador_w					smallint;
ie_urgencia_w					varchar(1);
ie_suspenso_w					varchar(1);
cd_unidade_medida_consumo_w		varchar(30);
cd_unidade_medida_dose_w		varchar(30);
qt_dose_w       				double precision;
qt_dose_medic_w					double precision;
ds_horarios						varchar(2000);
ds_horarios_ordenados_w			varchar(2000);
ds_horarios_validade_w			varchar(2000);
k								bigint;
i								bigint;
ds_dose_w						varchar(20);
ds_hora_w						varchar(10);
ds_horario_final_w				varchar(2000) :='';
teste_w							bigint := 0;
ds_prim_horario_w				varchar(5);
cd_estabelecimento_w			smallint;
ie_via_aplicacao_w				varchar(5);
ie_medicacao_paciente_w			varchar(1);
ie_recons_diluente_fixo_w		varchar(1);
qt_operacao_w					double precision;
dt_prim_horario_w				timestamp;
hr_prim_horario_w				timestamp;
hr_prim_horario_ww				varchar(5);
nr_horas_validade_w				integer;
ds_horario_w					varchar(255);
ds_horario_ww					varchar(255);
qt_diluente_hora_w				double precision;
qt_dose_espec_w					double precision;
qt_dif_w						double precision;
ie_diluicao_recons_w			varchar(15);
nm_usuario_original_w			varchar(15);
ie_regra_disp_w					varchar(1);/* rafael em 15/3/8 os86206 */
ie_atualiza_reconst_w			varchar(1);
cd_perfil_w						integer;
qt_hora_intervalo_w				smallint;
qt_min_intervalo_w				integer;
ie_operacao_w					varchar(1);
ie_tratar_fixo_validade_w		varchar(1)	:= 'N';
ie_dose_diferenciada_w			varchar(1)	:= 'N';
nr_ocorrencia_ww				double precision;
qt_dia_prim_hor_w				bigint;
qt_ref_diluente_w				double precision;
nr_seq_mat_diluicao_w			bigint;
ie_proporcao_w					varchar(3);
qt_minuto_aplicacao_w			smallint;
qt_hora_aplicacao_w				smallint;
nr_agrupador_w					bigint;
ie_calcula_volume_afterpost_w	varchar(1)	:= 'N';
ie_ConsisteDoseConsumoMedic_w	varchar(1) := 'S';
qt_volume_medic_w				double precision;
cd_material_prescr_w			integer;
qt_referencia_w					double precision;
IE_SUBTRAIR_VOLUME_MEDIC_w		material_diluicao.IE_SUBTRAIR_VOLUME_MEDIC%type;
nr_seq_sup_w					prescr_material.nr_sequencia%type;
cd_material_sup_w				material.cd_material%type;
cont_ml_w						bigint;
qt_subtr_ml_w					prescr_material.qt_dose%type;
cd_funcao_w						prescr_medica.cd_funcao_origem%type;

C01 CURSOR FOR
SELECT	coalesce(a.nr_sequencia,0),
		coalesce(a.cd_material,0),
		coalesce(a.qt_unitaria,0),
		coalesce(a.qt_material,0),
		coalesce(a.ds_dose_diferenciada,''),
		coalesce(a.ie_origem_inf,'1'),
		coalesce(a.ie_agrupador,3),
		substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
		a.qt_dose,
		a.ie_via_aplicacao,
		coalesce(a.ie_recons_diluente_fixo,'N'),
		a.cd_intervalo,
		coalesce(x.dt_primeiro_horario,x.dt_prescricao),
		TO_DATE(TO_CHAR(x.dt_prescricao,'dd/mm/yyyy') ||' '||coalesce(a.hr_prim_horario,TO_CHAR(coalesce(x.dt_primeiro_horario,x.dt_prescricao),'hh24:mi')),'dd/mm/yyyy hh24:mi:ss'),
		x.nr_horas_validade,
		a.qt_hora_intervalo,
		a.qt_min_intervalo,
		a.qt_ref_diluente,
		a.cd_unidade_medida_dose,
		a.nr_seq_mat_diluicao,
		coalesce(a.ie_se_necessario,'N'),
		coalesce(a.ie_acm,'N')
from	material b,
		prescr_material a,
		prescr_medica x
where	x.nr_prescricao 				= nr_prescricao_p
and		x.nr_prescricao					= a.nr_prescricao
and		a.nr_sequencia_diluicao			= nr_sequencia_p
and		a.cd_material					= b.cd_material
and		a.ie_agrupador 					= 3
and		(a.cd_material IS NOT NULL AND a.cd_material::text <> '')
and 	coalesce(a.ie_alterou_dose_dil,'N')	<> 'S'
and		(a.qt_ref_diluente IS NOT NULL AND a.qt_ref_diluente::text <> '');


BEGIN
select	coalesce(max(cd_estabelecimento),1),
		max(nm_usuario_original),
		max(cd_funcao_origem)
into STRICT	cd_estabelecimento_w,
		nm_usuario_original_w,
		cd_funcao_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

Select	coalesce(max(cd_intervalo),obter_interv_prescr_padrao(cd_estabelecimento_w)),
		coalesce(max(ie_acm),'N'),
		coalesce(max(ie_se_necessario),'N'),
		coalesce(max(qt_unitaria),1),
		coalesce(max(nr_ocorrencia),1),
		coalesce(max(ie_urgencia),'N'),
		coalesce(max(ie_suspenso),'N'),
		coalesce(max(qt_dose_especial),0),
		coalesce(max(ie_medicacao_paciente),'N'),
		coalesce(max(qt_total_dispensar),1),
		coalesce(max(qt_dose),0),
		max(hr_prim_horario),
		max(qt_dia_prim_hor),
		max(nr_agrupamento),
		max(cd_material)
into STRICT	cd_intervalo_w,
		ie_acm_w,
		ie_se_necessario_w,
		qt_unitaria_pai_w,
		nr_ocorrencia_w,
		ie_urgencia_w,
		ie_suspenso_w,
		qt_dose_especial_w,
		ie_medicacao_paciente_W,
		qt_total_disp_w,
		qt_dose_medic_w,
		hr_prim_horario_ww,
		qt_dia_prim_hor_w,
		nr_agrupador_w,
		cd_material_prescr_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia  = nr_sequencia_p
and		(cd_material IS NOT NULL AND cd_material::text <> '');

cd_perfil_w := obter_perfil_ativo;

ie_calcula_volume_afterpost_w := Obter_Param_Usuario(924, 600, cd_perfil_w, nm_usuario_original_w, cd_estabelecimento_w, ie_calcula_volume_afterpost_w);

open C01;
loop
fetch C01 into
		nr_sequencia_w,
		cd_material_w,
		qt_unitaria_w,
		qt_material_w,
		ds_dose_diferenciada_w,
		ie_origem_inf_w,
		ie_agrupador_w,
		cd_unidade_medida_consumo_w,
		qt_dose_w,
		ie_via_aplicacao_w,
		ie_recons_diluente_fixo_w,
		cd_intervalo_cad_w,
		dt_prim_horario_w,
		hr_prim_horario_w,
		nr_horas_validade_w,
		qt_hora_intervalo_w,
		qt_min_intervalo_w,
		qt_ref_diluente_w,
		cd_unidade_medida_dose_w,
		nr_seq_mat_diluicao_w,
		ie_se_necessario_w,
		ie_acm_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	coalesce(ie_diluir_inteiro,'N'),
			coalesce(qt_volume_medic,0),
			coalesce(IE_SUBTRAIR_VOLUME_MEDIC, 'N'),
			coalesce(qt_referencia,0)
	into STRICT	ie_ConsisteDoseConsumoMedic_w,
			qt_volume_medic_w,
			IE_SUBTRAIR_VOLUME_MEDIC_w,
			qt_referencia_w
	from	material_diluicao
	where 	nr_seq_interno	= nr_seq_mat_diluicao_w;
	exception
	when others then
		ie_ConsisteDoseConsumoMedic_w	:= 'N';
	end;

	if (qt_referencia_w > 0) then
		qt_referencia_w		:= obter_conversao_unid_med_cons(cd_material_w,cd_unidade_medida_dose_w,qt_referencia_w);
		qt_ref_diluente_w	:= qt_referencia_w;
	end if;

	select	coalesce(max(IE_SUBTRAIR_VOLUME_MEDIC), 'N')
	into STRICT 	IE_SUBTRAIR_VOLUME_MEDIC_w
	from 	material_diluicao a,
			prescr_material b
	where 	a.cd_material = b.cd_material
	and 	b.nr_prescricao = nr_prescricao_p
	and 	b.nr_sequencia = nr_sequencia_p
	and		a.ie_reconstituicao = 'N';

	if (ie_ConsisteDoseConsumoMedic_w = 'S') then
		qt_unitaria_w		:= qt_ref_diluente_w * ceil(qt_unitaria_pai_w);
	else
		if (qt_volume_medic_w	> 0) then
			qt_unitaria_w	:= obter_conversao_unid_med_cons(cd_material_prescr_w,obter_unid_med_usua('ml'),qt_volume_medic_w);
		else
			qt_unitaria_w	:= qt_ref_diluente_w * qt_unitaria_pai_w;
		end if;
	end if;

	qt_operacao_w		:= nr_ocorrencia_w;--ceil(qt_unitaria_w * nr_ocorrencia_w);
	qt_conversao_dose_w	:= obter_conversao_unid_med(cd_material_w,cd_unidade_medida_dose_w);
	qt_dose_w			:= qt_conversao_dose_w * qt_unitaria_w;

	if (coalesce(qt_dose_especial_w,0) > 0) then
		qt_dose_especial_dil_w	:= qt_dose_w;
	end if;

	SELECT * FROM Obter_Quant_Dispensar(1, cd_material_w, nr_prescricao_p, nr_sequencia_w, cd_intervalo_novo_w, ie_via_aplicacao_w, qt_unitaria_w, qt_dose_especial_dil_w, qt_operacao_w, ds_dose_diferenciada_w, ie_origem_inf_w, cd_unidade_medida_dose_w, 1, qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_w, ie_acm_w) INTO STRICT qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w;

	if (nr_seq_mat_diluicao_w IS NOT NULL AND nr_seq_mat_diluicao_w::text <> '') and (ie_agrupador_w = 3 ) then
		begin
		select	coalesce(ie_proporcao,'SC'),
				qt_minuto_aplicacao
		into STRICT	ie_proporcao_w,
				qt_minuto_aplicacao_w
		from 	material_diluicao
		where	nr_seq_interno	= nr_seq_mat_diluicao_w
		and 	coalesce(ie_reconstituicao,'S')	=  'N';
		exception
			when others then
				ie_proporcao_w := 'SC';
				qt_minuto_aplicacao_w := null;
		end;

		if (ie_proporcao_w = 'ST') and (qt_minuto_aplicacao_w IS NOT NULL AND qt_minuto_aplicacao_w::text <> '')then
			qt_minuto_aplicacao_w	:= trunc(qt_minuto_aplicacao_w * qt_unitaria_pai_w);

			if (qt_minuto_aplicacao_w > 0) then
					if (qt_minuto_aplicacao_w < 60) then
						qt_hora_aplicacao_w	:= null;
					elsif (qt_minuto_aplicacao_w = 60) then
						qt_hora_aplicacao_w	:= 1;
						qt_minuto_aplicacao_w	:= null;
					else
						qt_hora_aplicacao_w	:= trunc(dividir(qt_minuto_aplicacao_w,60));
						qt_minuto_aplicacao_w	:= (qt_minuto_aplicacao_w - (qt_hora_aplicacao_w * 60));
					end if;
				end if;

			if (qt_minuto_aplicacao_w = 0) then
				qt_minuto_aplicacao_w	:= null;
			end if;

			update	prescr_material
			set		qt_min_aplicacao	= qt_minuto_aplicacao_w,
					qt_hora_aplicacao	= qt_hora_aplicacao_w
			where	nr_prescricao		= nr_prescricao_p
			and		nr_sequencia		= nr_sequencia_p
			and		ie_aplic_bolus		= 'N'
			and		ie_aplic_lenta		= 'N';
		end if;

	end if;

	if (IE_SUBTRAIR_VOLUME_MEDIC_w = 'S') then

		qt_subtr_ml_w := 0;

		select	max(nr_sequencia)
		into STRICT	nr_seq_sup_w
		from	prescr_material
		where	nr_sequencia_diluicao = nr_sequencia_p
		and		nr_prescricao = nr_prescricao_p
		and		ie_agrupador = 9;

		if (nr_seq_sup_w > 0) then

				select	max(cd_material)
				into STRICT	cd_material_sup_w
				from 	prescr_material


				where 	nr_prescricao = nr_prescricao_p
				and 	nr_sequencia = nr_sequencia_p;

				select 	count(*)
				into STRICT	cont_ml_w
				from	material_conversao_unidade
				where 	cd_material = cd_material_sup_w
				and 	cd_unidade_medida = 'ml';

				if (cont_ml_w = 0) then

					select 	coalesce(max(qt_dose),0)
					into STRICT 	qt_subtr_ml_w
					from	prescr_material
					where	nr_sequencia_diluicao = nr_sequencia_p
					and		nr_prescricao = nr_prescricao_p
					and		ie_agrupador = 9;

					if (coalesce(qt_subtr_ml_w, 0) = 0) then

						select 	coalesce(max(qt_dose),0)
						into STRICT 	qt_subtr_ml_w
						from	prescr_material
						where	nr_sequencia_diluicao = nr_sequencia_p
						and		nr_prescricao = nr_prescricao_p
						and		ie_agrupador = 3;

					end if;
				end if;
		end if;

		qt_dose_w := qt_dose_w - (qt_unitaria_w * qt_subtr_ml_w);


	end if;

	update	prescr_material
	set		nr_ocorrencia		= qt_operacao_w,
			qt_total_dispensar	= qt_dispensar_w,
			qt_unitaria			= qt_unitaria_w,
			qt_material			= qt_material_w,
			qt_dose				= qt_dose_w,
			qt_ref_diluente		= qt_ref_diluente_w
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia			= nr_sequencia_w;

end loop;
close C01;

if (ie_calcula_volume_afterpost_w = 'S' and cd_funcao_w <> 2314) then
	CALL calcular_vol_dil_Prescr_mat(nr_prescricao_p,nr_agrupador_w,nm_usuario_original_w);
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_dose_diluente ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
