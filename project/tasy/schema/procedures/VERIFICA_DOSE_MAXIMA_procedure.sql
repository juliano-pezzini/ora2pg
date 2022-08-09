-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_dose_maxima ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, ds_erro_p INOUT text, ds_erro2_p INOUT text, dt_aprazamento_p timestamp default null, ie_tipo_erro_p INOUT text DEFAULT NULL, qt_dose_limite_p INOUT bigint DEFAULT NULL, cd_unid_med_lim_p INOUT text DEFAULT NULL) AS $body$
DECLARE


qt_max_prescricao_w			double precision;
cd_unidade_medida_consumo_w	varchar(30);
cd_unid_med_limite_w		varchar(30);
cd_unid_med_limite_mensagem_w		varchar(30);
qt_limite_pessoa_w			double precision;
qt_limite_pessoa_ww	double precision;
qt_conversao_dose_w			double precision;
qt_conversao_dose_limite_w	double precision;
qt_dose_w					double precision;
qt_dose_ww					double precision;
qt_dose_limite_w			double precision;
qt_dose_limite_mensagem_w			double precision;
qt_dose_npt_ped_w			double precision;
nr_ocorrencia_npt_ped_w		double precision;
qt_volume_npt_ped_w			double precision;
qt_dose_npt_ad_w			double precision;
nr_ocorrencia_npt_ad_w		double precision;
qt_volume_npt_ad_w			double precision;
qt_dose_npt_prot_w			double precision;
nr_ocorrencia_npt_prot_w	double precision;
qt_volume_npt_prot_w		double precision;
cd_unidade_medida_dose_w	varchar(30);
ds_observacao_w				varchar(255);
ds_mensagem_regra_w			varchar(255);
cd_pessoa_fisica_w			varchar(30);
cd_material_w				integer;
ie_dose_limite_w			varchar(15);
nr_ocorrencia_w				double precision;
nr_ocorrencia_ww			double precision;
ie_via_aplicacao_w			varchar(5);
nr_seq_agrupamento_w		bigint;
ie_justificativa_w			varchar(5);
ds_justificativa_w			varchar(2000);
cd_prescritor_w				varchar(50);
cd_setor_atendimento_w		integer;
qt_regra_w					bigint;
qt_idade_w					bigint;
qt_idade_dia_w				double precision;
qt_solucao_w				double precision;
qt_ml_componente_w			double precision;
qt_total_w					double precision;
qt_dose_www					double precision;
qt_idade_mes_w				double precision;
qt_peso_w					double precision;
qt_limite_peso_w			double precision;
nr_horas_validade_w			integer;
cd_estabelecimento_w		bigint;
ie_somar_dose_medic_w		varchar(5);
nr_atendimento_w			bigint;
ie_agrupador_w				prescr_material.ie_agrupador%type;
nr_ocorrencia_sol_w			double precision;
qt_dose_sol_w				double precision;
qt_solucao_sol_w			double precision;
qt_solucao_mat_w			double precision;
ie_consistiu_dose_w			varchar(50) := 'S';
ie_acm_w					varchar(1);
ie_se_necessario_w			varchar(1);
qt_dose_retorno_w			double precision;
nr_seq_solucao_w			prescr_solucao.nr_seq_solucao%type;
qt_hora_aplic_w			bigint;
qt_min_aplic_w				prescr_material.qt_min_aplicacao%type;
qt_tempo_aplicacao_w		prescr_solucao.qt_tempo_aplicacao%type;
qt_hora_infusao_w			prescr_solucao.qt_hora_infusao%type;
qt_tempo_infusao_w		prescr_solucao.qt_tempo_infusao%type;	
qt_hora_fase_w				prescr_solucao.qt_hora_fase%type;
nr_etapas_w					prescr_solucao.nr_etapas%type;	
qt_dif_tempo_etapa_w		bigint;
qt_tempo_item_w			bigint;
cd_doenca_cid_w				material_prescr.cd_doenca_cid%type;
nr_seq_mat_cpoe_w			prescr_Material.nr_seq_mat_cpoe%type;
ie_param_170_f_w			varchar(2);
hr_dose_especial_w			prescr_material.hr_dose_especial%type;
qt_dose_especial_w			prescr_material.qt_dose_especial%type;
ie_objetivo_w				prescr_material.ie_objetivo%type;
qt_dose_limite_dia_cpoe_w		double precision;
ds_erro2_w					varchar(2000) := null;
qt_dose_range_min_w			cpoe_material.qt_dose_range_min%type;

c01 CURSOR FOR
	SELECT	coalesce(qt_limite_pessoa,0),
			coalesce(ie_dose_limite,'DOSE'),
			cd_unid_med_limite,
			coalesce(ie_justificativa,'S'),
			ds_observacao,
			ds_mensagem_regra,
			cd_doenca_cid
	from	material_prescr
	where	cd_material = cd_material_w
	and		coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0)) = coalesce(cd_setor_atendimento_w,0)
	and		coalesce(ie_via_aplicacao, coalesce(ie_via_aplicacao_w,0)) = coalesce(ie_via_aplicacao_w,0)
	and		(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
	and		qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
	and		qt_idade_dia_w between coalesce(qt_idade_min_dia,0) and coalesce(qt_idade_max_dia,55000)
	and		qt_idade_mes_w between coalesce(qt_idade_min_mes,0) and coalesce(qt_idade_max_mes,55000)
	and		((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento = nr_seq_agrupamento_w))
	and		qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999)
	and		coalesce(cd_protocolo::text, '') = ''
	and		ie_tipo = '2'
	and 	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
	and		Obter_se_setor_regra_prescr(nr_sequencia, cd_setor_atendimento_w) = 'S'
	and		((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_prescritor_w, cd_especialidade) = 'S'))
	and		((coalesce(cd_doenca_cid::text, '') = '') or (obter_se_cid_atendimento(nr_atendimento_w,cd_doenca_cid) = 'S'))
	and		(((coalesce(ie_tipo_item,'TOD') = 'SOL') and (ie_agrupador_w = 4)) or
			 ((coalesce(ie_tipo_item,'TOD') = 'OUT') and (ie_agrupador_w <> 4)) or (coalesce(ie_tipo_item,'TOD') = 'TOD'))
	and     coalesce(ie_objetivo, coalesce(ie_objetivo_w, 'N')) = coalesce(ie_objetivo_w,'N')
	order by    cd_especialidade,
				nr_sequencia;


BEGIN

select	coalesce(max(ie_somar_dose_medic),'N')
into STRICT	ie_somar_dose_medic_w
from	parametro_medico
where	cd_estabelecimento = Wheb_usuario_pck.get_cd_estabelecimento;

ds_erro_p	:= '';
ds_erro2_p	:= '';

select	max(cd_material),
		max(cd_unidade_medida_dose),
		coalesce(max(qt_dose),0),
		max(nr_ocorrencia),
		max(ie_via_aplicacao),
		max(ds_justificativa),
		coalesce(max(qt_solucao),0),
		max(qt_solucao),
		coalesce(max(qt_dose),0),
		max(ie_agrupador),
		coalesce(max(nr_sequencia_solucao),0),
		coalesce(max(qt_hora_aplicacao),0),
		coalesce(max(qt_min_aplicacao),0),
		coalesce(max(ie_acm),'N'),
		coalesce(max(ie_se_necessario),'N'),
		coalesce(max(nr_seq_mat_cpoe),0),
		coalesce(max(hr_dose_especial),''),
		coalesce(max(qt_dose_especial),0),
		coalesce(max(ie_objetivo),'N')
into STRICT	cd_material_w,
		cd_unidade_medida_dose_w,
		qt_dose_ww,
		nr_ocorrencia_w,
		ie_via_aplicacao_w,
		ds_justificativa_w,
		qt_solucao_w,
		qt_ml_componente_w,
		qt_dose_www,
		ie_agrupador_w,
		nr_seq_solucao_w,
		qt_hora_aplic_w,
		qt_min_aplic_w,
		ie_acm_w,
		ie_se_necessario_w,
		nr_seq_mat_cpoe_w,
		hr_dose_especial_w,
		qt_dose_especial_w,
		ie_objetivo_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and		nr_sequencia	= nr_sequencia_p;

CALL Wheb_assist_pck.set_informacoes_usuario( Wheb_usuario_pck.get_cd_estabelecimento, obter_perfil_ativo, obter_usuario_ativo);
ie_param_170_f_w := Wheb_assist_pck.obterParametroFuncao(7010,170);

if (ie_somar_dose_medic_w = 'S') then
	-- Realizar a soma dos componentes de solucao
	select	coalesce(sum(obter_dose_convertida(cd_material, qt_dose, cd_unidade_medida_dose, cd_unidade_medida_dose_w)),0),
			coalesce(sum(nr_ocorrencia),0),
			coalesce(sum(qt_solucao),0)
	into STRICT	qt_dose_sol_w,
			nr_ocorrencia_sol_w,
			qt_solucao_sol_w
	from	prescr_material
	where	ie_agrupador = 4
	and		cd_material		= cd_material_w
	and		nr_prescricao	= nr_prescricao_p;
	
	--- NPT Adulta Antiga
	select	coalesce(sum(obter_dose_convertida(c.cd_material, coalesce(c.qt_dose,c.qt_volume), coalesce(c.cd_unidade_medida, lower(obter_unid_med_usua('ml'))), cd_unidade_medida_dose_w)),0),
			sum(1),
			coalesce(sum(c.qt_volume),0)
	into STRICT	qt_dose_npt_ad_w,
			nr_ocorrencia_npt_ad_w,
			qt_volume_npt_ad_w
	from	nut_paciente a,
			nut_paciente_elemento b,
			nut_pac_elem_mat c
	where	a.nr_sequencia = b.nr_seq_nut_pac
	and		b.nr_sequencia = c.nr_seq_nut_pac_ele
	and		a.nr_prescricao = nr_prescricao_p
	and		cd_material = cd_material_w;

	--- NPT Adulta Protocolo
	select	coalesce(sum(obter_dose_convertida(c.cd_material, coalesce(c.qt_dose,c.qt_volume), coalesce(c.cd_unidade_medida, lower(obter_unid_med_usua('ml'))), cd_unidade_medida_dose_w)),0),
			sum(1),
			coalesce(sum(c.qt_volume),0)
	into STRICT	qt_dose_npt_prot_w,
			nr_ocorrencia_npt_prot_w,
			qt_volume_npt_prot_w
	from	nut_pac a,
			nut_pac_elem_mat c
	where	a.nr_sequencia = c.nr_seq_nut_pac
	and		coalesce(a.ie_npt_adulta,'S') = 'S'
	and		a.nr_prescricao = nr_prescricao_p
	and		c.cd_material = cd_material_w;

	--- NPT Pediatrica e Neonatal
	select	coalesce(sum(obter_dose_convertida(d.cd_material, coalesce(c.qt_dose,c.qt_volume), coalesce(c.cd_unidade_medida, lower(obter_unid_med_usua('ml'))), cd_unidade_medida_dose_w)),0),
			sum(1),
			coalesce(sum(c.qt_volume),0)
	into STRICT	qt_dose_npt_ped_w,
			nr_ocorrencia_npt_ped_w,
			qt_volume_npt_ped_w
	from	nut_pac a,
			nut_pac_elemento b,
			nut_pac_elem_mat c,
			nut_elem_material d
	where	a.nr_sequencia = b.nr_seq_nut_pac
	and		b.nr_sequencia = c.nr_seq_pac_elem
	and		b.nr_seq_elemento = d.nr_seq_elemento
	and		d.nr_sequencia = c.nr_seq_elem_mat
	and		a.nr_prescricao = nr_prescricao_p
	and		d.cd_material = cd_material_w;
	
	qt_dose_sol_w := (qt_dose_sol_w + qt_dose_npt_ped_w + qt_dose_npt_prot_w + qt_dose_npt_ad_w);
	nr_ocorrencia_sol_w := (nr_ocorrencia_sol_w + nr_ocorrencia_npt_ped_w + nr_ocorrencia_npt_prot_w + nr_ocorrencia_npt_ad_w);
	qt_solucao_sol_w := (qt_solucao_sol_w + qt_volume_npt_ped_w + qt_volume_npt_prot_w + qt_volume_npt_ad_w);
		
	if (ie_agrupador_w = 1) then	
	--	 Realizar a soma dos medicamentos (incluindo o item principal)	
		select	coalesce(sum(obter_dose_convertida(cd_material, qt_dose, cd_unidade_medida_dose, cd_unidade_medida_dose_w)),0),
				coalesce(sum(nr_ocorrencia),0),
				coalesce(sum(qt_solucao),0)
		into STRICT	qt_dose_ww,
				nr_ocorrencia_w,
				qt_solucao_w
		from	prescr_material
		where	ie_agrupador = 1
		and		cd_material		= cd_material_w
		and		nr_prescricao	= nr_prescricao_p;
	end if;
end if;

select	max(cd_prescritor),
		coalesce(max(nr_horas_validade),24),
		max(cd_estabelecimento),
		max(cd_setor_atendimento),
		max(nr_atendimento)
into STRICT	cd_prescritor_w,
		nr_horas_validade_w,
		cd_estabelecimento_w,
		cd_setor_atendimento_w,
		nr_atendimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	max(nr_seq_agrupamento)
into STRICT	nr_seq_agrupamento_w
from	setor_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_w;

begin
if (coalesce(cd_material_w,0) > 0) and (cd_unidade_medida_dose_w IS NOT NULL AND cd_unidade_medida_dose_w::text <> '') and
	((coalesce(qt_dose_sol_w,0) + coalesce(qt_dose_ww,0)) > 0) then
	begin
	
	-- Informacoes da prescricao
	select	max(cd_setor_atendimento),
			coalesce(max((obter_idade_pf(cd_pessoa_fisica, clock_timestamp(), 'A'))::numeric ),0),
			coalesce(max(qt_peso),0),
			max(cd_pessoa_fisica)
	into STRICT	cd_setor_atendimento_w,
			qt_idade_w,
			qt_peso_w,
			cd_pessoa_fisica_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p;
	
	-- Informacoes do paciente
	select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA')),
			max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'M'))
	into STRICT	qt_idade_dia_w,
			qt_idade_mes_w
	from	pessoa_fisica b
	where	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	
	-- Informacoes do material
	select	coalesce(max(qt_max_prescricao),0),
			max(cd_unidade_medida_consumo),
			coalesce(max(cd_unid_med_limite), cd_unidade_medida_dose_w),
			coalesce(max(qt_limite_pessoa),0),
	  coalesce(max(ie_dose_limite),'DOSE')
	into STRICT	qt_max_prescricao_w,
			cd_unidade_medida_consumo_w,
			cd_unid_med_limite_w,
			qt_limite_pessoa_w,
			ie_dose_limite_w
	from	material
	where	cd_material	= cd_material_w;

	select	count(*)
	into STRICT	qt_regra_w
	from	material where		(qt_limite_pessoa IS NOT NULL AND qt_limite_pessoa::text <> '')
	and		cd_material	= cd_material_w LIMIT 1;

	if (nr_horas_validade_w	> 24) then
		nr_ocorrencia_ww	:= trunc(dividir((nr_ocorrencia_w * 24), nr_horas_validade_w));
	else
		nr_ocorrencia_ww	:= nr_ocorrencia_w;
	end if;
	
	
	if (nr_seq_mat_cpoe_w IS NOT NULL AND nr_seq_mat_cpoe_w::text <> '') and (nr_seq_mat_cpoe_w > 0)then
		
		select	max(obter_conversao_unid_med_cons(cd_material,cd_unidade_medida,qt_dose_maxima)),
			max(qt_dose_maxima),
			max(cd_unidade_medida),
			max(qt_dose_range_min)
		into STRICT	qt_dose_limite_dia_cpoe_w,
			qt_dose_limite_mensagem_w,
			cd_unid_med_limite_mensagem_w,
			qt_dose_range_min_w
		from	cpoe_material
		where	nr_sequencia = nr_seq_mat_cpoe_w;
	end if;

	
	if (qt_regra_w > 0) or (qt_dose_limite_dia_cpoe_w IS NOT NULL AND qt_dose_limite_dia_cpoe_w::text <> '') then
		begin
		
		if (qt_dose_limite_dia_cpoe_w IS NOT NULL AND qt_dose_limite_dia_cpoe_w::text <> '') then
			qt_limite_pessoa_w	:= qt_dose_limite_mensagem_w;
			ie_dose_limite_w	:= 'CPOEDIA';
			if (coalesce(qt_dose_range_min_w, 0) > 0) then
				qt_dose_ww	:= qt_dose_range_min_w;
			end if;
		end if;
		
		if (cd_unidade_medida_consumo_w = cd_unidade_medida_dose_w) then
			qt_conversao_dose_w	:= 1;
		else
			begin
			select	coalesce(max(qt_conversao),1)
			into STRICT	qt_conversao_dose_w
			from	material_conversao_unidade
			where	cd_material		= cd_material_w
			and	cd_unidade_medida	= cd_unidade_medida_dose_w;
			exception
				when others then
				qt_conversao_dose_w	:= 1;
			end;
		end if;
		if (coalesce(qt_solucao_w,0) > 0) then
			if (ie_agrupador_w = 4) then
				select	coalesce(qt_hora_infusao,0),
							coalesce(qt_tempo_infusao,0),
							coalesce(qt_tempo_aplicacao,0),
							coalesce(nr_etapas,0)
				into STRICT		qt_hora_infusao_w,
							qt_tempo_infusao_w,
							qt_tempo_aplicacao_w,
							nr_etapas_w
				from		prescr_solucao
				where		nr_prescricao = nr_prescricao_p
				and		nr_seq_solucao = nr_seq_solucao_w;
				qt_total_w		:= qt_ml_componente_w;
			else
				qt_total_w	:= coalesce(obter_volume_ml_medic_dil(nr_prescricao_p, nr_sequencia_p),qt_dose_ww);
			end if;
			
			if (qt_total_w > 0) then
				qt_dose_ww	:= dividir((qt_dose_ww * qt_solucao_w), qt_total_w);
			end if;
			qt_dose_w	:= dividir(trunc(dividir(qt_dose_ww * 1000, qt_conversao_dose_w)), 1000);
		else
			qt_dose_w	:= dividir(trunc(dividir(qt_dose_ww * 1000, qt_conversao_dose_w)), 1000);
		end if;

		if (qt_max_prescricao_w > 0) and (qt_max_prescricao_w < coalesce(qt_dose_w,0)) then
			-- A dose unitaria e maior que a usual prevista #@QT_MAX_PRESCRICAO_P#@ #@CD_UNIDADE_MEDIDA_CONSUMO_P#@
			ds_erro_p	:= wheb_mensagem_pck.get_texto(277286, 'QT_MAX_PRESCRICAO_P=' || qt_max_prescricao_w || ';CD_UNIDADE_MEDIDA_CONSUMO_P=' || cd_unidade_medida_consumo_w);
			qt_dose_limite_p := qt_max_prescricao_w;
			cd_unid_med_lim_p := cd_unidade_medida_consumo_w;
		end if;

		if (cd_unidade_medida_consumo_w = cd_unid_med_limite_w) then
			qt_conversao_dose_limite_w	:= 1;
		else
			begin
			select	coalesce(max(qt_conversao),1)
			into STRICT	qt_conversao_dose_limite_w
			from	material_conversao_unidade
			where	cd_material		= cd_material_w
			and		cd_unidade_medida	= cd_unid_med_limite_w;
			exception
				when others then
					qt_conversao_dose_limite_w	:= 1;
			end;
		end if;

		qt_dose_w			:= dividir(trunc(dividir(qt_dose_ww * 1000, qt_conversao_dose_w)), 1000);
		qt_dose_limite_w	:= dividir(trunc(dividir(qt_limite_pessoa_w * 1000, qt_conversao_dose_limite_w)), 1000);

		if (ie_dose_limite_w = 'DIA') then
			begin
			if (nr_horas_validade_w	> 24) then
				nr_ocorrencia_w	:= trunc(dividir((nr_ocorrencia_w * 24), nr_horas_validade_w));
			end if;
			qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
			qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p,cd_material_w);
			end;
		elsif (ie_dose_limite_w = 'AT') then
			begin
			qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
			qt_dose_w	:= qt_dose_w + obter_dose_medic_atend_dia(nr_prescricao_p,nr_sequencia_p,qt_dose_w,ie_utiliza_horarios_p,cd_material_w);
			end;
		elsif (ie_dose_limite_w = 'CPOEDIA') then
			begin
			qt_dose_w	:= qt_dose_w + obter_dose_medic_periodo(nr_atendimento_w,cd_material_w,dt_aprazamento_p-1,dt_aprazamento_p);
			ie_dose_limite_w	:= 'DIA';
			ds_erro2_w	:= obter_desc_expressao(970215);
			end;
		elsif (qt_peso_w > 0) and (ie_dose_limite_w = 'KG/DIA') then
			begin
			-- Por kg
					
			if (nr_horas_validade_w > 24) then
				nr_ocorrencia_w := trunc(dividir(nr_ocorrencia_w * 24, nr_horas_validade_w));
			end if;
					
			qt_dose_w	:= dividir(qt_dose_w, coalesce(qt_peso_w,1));

			qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
			qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p,cd_material_w);
			
			-- Por dia				

			-- Caso possua solucao prescrita, devera ser adicionada a conversao dos componentes a dose
			if (qt_solucao_sol_w > 0) then
				if (nr_horas_validade_w > 24) then
					nr_ocorrencia_sol_w	:= trunc(dividir((nr_ocorrencia_sol_w * 24), nr_horas_validade_w));
					qt_solucao_sol_w	:= qt_solucao_sol_w * nr_ocorrencia_sol_w;
				end if;
				
				qt_dose_w	:= qt_dose_w + obter_dose_convertida(cd_material_w, qt_solucao_sol_w, 'ml', cd_unidade_medida_consumo_w);
			end if;
			end;
		elsif (qt_peso_w > 0) and (ie_dose_limite_w = 'KG/D') then
			begin
			qt_dose_w	:= dividir(qt_dose_w, coalesce(qt_peso_w,1));/*por KG*/


			/*por dose*/


			/*if	(nr_horas_validade_w	> 24) then
				nr_ocorrencia_w	:= trunc(((nr_ocorrencia_w * 24) / nr_horas_validade_w));
			end if;*/

			--qt_dose_w	:= qt_dose_w * nvl(nr_ocorrencia_w,1);
			qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p,cd_material_w);
			end;
		elsif (ie_dose_limite_w = 'KG/H') then 	
				if (ie_agrupador_w = 4) then
					qt_dif_tempo_etapa_w := round(qt_tempo_aplicacao_w / nr_etapas_w);
					if (qt_hora_infusao_w = 0) and (qt_tempo_infusao_w = 0) and (qt_dif_tempo_etapa_w = qt_hora_fase_w) and (qt_tempo_aplicacao_w > 0) then
						qt_tempo_item_w := qt_tempo_aplicacao_w;
					elsif (qt_hora_infusao_w > 0) or (qt_tempo_infusao_w > 0) then
						qt_tempo_item_w := qt_hora_infusao_w + (qt_tempo_infusao_w / 60);
					else
						qt_tempo_item_w := qt_hora_fase_w;
					end if;
					qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
				elsif	((qt_hora_aplic_w > 0) or (qt_min_aplic_w > 0)) then
					qt_tempo_item_w := qt_hora_aplic_w + (qt_min_aplic_w/60);
					qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
				end if;
		elsif (ie_dose_limite_w = 'KG/MIN') then 	
				if (ie_agrupador_w = 4) then
					qt_dif_tempo_etapa_w := round(qt_tempo_aplicacao_w / nr_etapas_w);
					if (qt_hora_infusao_w = 0) and (qt_tempo_infusao_w = 0) and (qt_dif_tempo_etapa_w = qt_hora_fase_w) and (qt_tempo_aplicacao_w > 0) then
						qt_tempo_item_w := qt_tempo_aplicacao_w * 60;
					elsif (qt_hora_infusao_w > 0) or (qt_tempo_infusao_w > 0) then
						qt_tempo_item_w := (qt_hora_infusao_w * 60) + qt_tempo_infusao_w;
					else
						qt_tempo_item_w  := qt_hora_fase_w * 60;
					end if;
					qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
				elsif	((qt_hora_aplic_w > 0) or (qt_min_aplic_w > 0)) then
					qt_tempo_item_w := (qt_hora_aplic_w * 60) + qt_min_aplic_w;
					qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
				end if;	
		end if;
		
		if (qt_dose_limite_w > 0) and (qt_dose_limite_w < coalesce(qt_dose_w,0)) then
			-- A dose unitaria e maior que a dose limite #@QT_LIMITE_PESSOA_P#@ #@CD_UNID_MED_LIMITE_P#@ por #@DS_DOSE_LIMITE_P#@
			if (ds_erro2_w IS NOT NULL AND ds_erro2_w::text <> '') then
				ds_erro2_p	:= ds_erro2_w;
			else
				ds_erro2_p	:= wheb_mensagem_pck.get_texto(277256, 'QT_LIMITE_PESSOA_P=' || coalesce(qt_dose_limite_mensagem_w,qt_limite_pessoa_w) || ';CD_UNID_MED_LIMITE_P=' || coalesce(cd_unid_med_limite_mensagem_w,cd_unid_med_limite_w) || ';DS_DOSE_LIMITE_P=' || obter_valor_dominio(1851,ie_dose_limite_w));
			end if;
			qt_dose_limite_p := qt_limite_pessoa_w;
			cd_unid_med_lim_p := cd_unid_med_limite_w;
		end if;
		end;
	else
		begin
		-- Verifica se tem alguma regra para os dados informados 
		open c01;
		loop
		fetch c01 into
			qt_limite_pessoa_w,
			ie_dose_limite_w,
			cd_unid_med_limite_w,
			ie_justificativa_w,
			ds_observacao_w,
			ds_mensagem_regra_w,
			cd_doenca_cid_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			
			if (coalesce(qt_limite_pessoa_w::text, '') = '') then
				qt_limite_pessoa_ww := 0;
			else
				qt_limite_pessoa_ww := qt_limite_pessoa_w;
			end if;
			
			ds_erro2_p :=  null;
			
			if (cd_unidade_medida_consumo_w = cd_unidade_medida_dose_w) then
				qt_conversao_dose_w	:= 1;
			else
				begin
				select	coalesce(max(qt_conversao),1)
				into STRICT	qt_conversao_dose_w
				from	material_conversao_unidade
				where	cd_material		= cd_material_w
				and		cd_unidade_medida	= cd_unidade_medida_dose_w;
				exception
					when others then
						qt_conversao_dose_w	:= 1;
				end;
			end if;

			if (qt_max_prescricao_w > 0) and (qt_max_prescricao_w < coalesce(qt_dose_w,0)) then
				-- A dose unitaria e maior que a usual prevista #@QT_MAX_PRESCRICAO_P#@ #@CD_UNIDADE_MEDIDA_CONSUMO_P#@

				-- #@DS_OBSERVACAO_P#@
				ds_erro_p	:= substr(wheb_mensagem_pck.get_texto(278059, 'QT_MAX_PRESCRICAO_P=' || qt_max_prescricao_w ||';CD_UNIDADE_MEDIDA_CONSUMO_P=' || cd_unidade_medida_consumo_w ||';DS_OBSERVACAO_P=' || coalesce(ds_observacao_w, ' ')),1,255);
				qt_dose_limite_p := qt_max_prescricao_w;
				cd_unid_med_lim_p := cd_unidade_medida_consumo_w;
				if (ds_mensagem_regra_w IS NOT NULL AND ds_mensagem_regra_w::text <> '') then
					ds_erro_p := ds_mensagem_regra_w;
				end if;
			end if;

			if (cd_unidade_medida_consumo_w = cd_unid_med_limite_w) then
				qt_conversao_dose_limite_w	:= 1;
			else
				begin
				select	coalesce(max(qt_conversao),1)
				into STRICT	qt_conversao_dose_limite_w
				from	material_conversao_unidade
				where	cd_material		= cd_material_w
				and		cd_unidade_medida	= cd_unid_med_limite_w;
				exception
					when others then
						qt_conversao_dose_limite_w	:= 1;
				end;
			end if;
			
			if (coalesce(qt_solucao_w,0) > 0) then
				if (ie_agrupador_w = 4) then
				select	coalesce(qt_hora_infusao,0),
							coalesce(qt_tempo_infusao,0),
							coalesce(qt_tempo_aplicacao,0),
							coalesce(nr_etapas,0)
				into STRICT		qt_hora_infusao_w,
							qt_tempo_infusao_w,
							qt_tempo_aplicacao_w,
							nr_etapas_w
				from		prescr_solucao
				where		nr_prescricao = nr_prescricao_p
				and		nr_seq_solucao = nr_seq_solucao_w;
				
					qt_total_w		:= qt_ml_componente_w;
				else
					qt_total_w	:= coalesce(obter_volume_ml_medic_dil(nr_prescricao_p, nr_sequencia_p),qt_dose_www);
				end if;
			
				if (qt_total_w > 0) then
					qt_dose_ww	:= dividir((qt_total_w * qt_conversao_dose_limite_w), qt_conversao_dose_w);
				end if;
				
				qt_dose_w	:=  dividir((qt_dose_ww * qt_dose_www), qt_total_w);
			else
				qt_dose_w	:= dividir(trunc(dividir(qt_dose_ww * 1000, qt_conversao_dose_limite_w)), 1000);
			end if;
			
			if (coalesce(qt_solucao_w,0) = 0) then
				qt_dose_w		:= dividir(trunc(dividir(qt_dose_ww * 1000, qt_conversao_dose_w)), 1000);
			else
				qt_dose_w		:= dividir(trunc(dividir(qt_dose_w * 1000, qt_conversao_dose_limite_w)), 1000);
			end if;
			
			if (hr_dose_especial_w IS NOT NULL AND hr_dose_especial_w::text <> '') and (qt_dose_especial_w > 0) then
			
				if (coalesce(qt_solucao_w,0) = 0) then
					qt_dose_especial_w	:= dividir(trunc(dividir(qt_dose_especial_w * 1000, qt_conversao_dose_w)), 1000);
				else
					qt_dose_especial_w	:= dividir(trunc(dividir(qt_dose_especial_w * 1000, qt_conversao_dose_limite_w)), 1000);
				end if;
			end if;
			
			qt_dose_limite_w	:= dividir(trunc(dividir(qt_limite_pessoa_ww * 1000, qt_conversao_dose_limite_w)), 1000);
			
			if (ie_dose_limite_w = 'DOSE') and (qt_dose_especial_w > 0) and (round((qt_dose_especial_w)::numeric,3) > round((qt_dose_w)::numeric,3)) then

				qt_dose_w := qt_dose_especial_w;

			elsif (ie_dose_limite_w = 'DIA') then

				if (ie_acm_w = 'N') and (ie_se_necessario_w = 'N') then
					
					if (coalesce(qt_solucao_w,0) > 0) then
						ie_consistiu_dose_w	:= consiste_dose_periodo_ant(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'S',null,null,null,null,null,null,'N');
						
						if (substr(ie_consistiu_dose_w,1,1) = 'S') then
							ie_consistiu_dose_w := consiste_dose_periodo_dep(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'S',null,null,null,null,null,null,'N');
						end if;
					else
					
						ie_consistiu_dose_w	:= consiste_dose_periodo_ant(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'N',null,null,null,null,null,null,'N');
						
						if (substr(ie_consistiu_dose_w,1,1) = 'S') then
							ie_consistiu_dose_w	:= consiste_dose_periodo_dep(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'N',null,null,null,null,null,null,'N');
						end if;
					end if;
					
				elsif (dt_aprazamento_p IS NOT NULL AND dt_aprazamento_p::text <> '') then
					
					if (coalesce(qt_solucao_w,0) = 0) then						
						ie_consistiu_dose_w	:= consiste_dose_periodo_ant(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'N', dt_aprazamento_p,null,null,null,null,null,'N');
						
						if (substr(ie_consistiu_dose_w,1,1) = 'S') then
							ie_consistiu_dose_w	:= consiste_dose_periodo_dep(nr_atendimento_w, nr_prescricao_p, nr_sequencia_p, qt_dose_limite_w, 'N', dt_aprazamento_p,null,null,null,null,null,'N');
						end if;
					end if;				
				
				end if;

			elsif (ie_dose_limite_w = 'AT') then
				begin
				qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
				qt_dose_w	:= qt_dose_w + qt_dose_especial_w;
				qt_dose_w	:= qt_dose_w + obter_dose_medic_atend_dia(nr_prescricao_p,nr_sequencia_p,qt_dose_w,ie_utiliza_horarios_p,cd_material_w);
				end;
			elsif (ie_dose_limite_w = 'PF') then

				qt_dose_w := qt_dose_w * coalesce(nr_ocorrencia_w,1);
				qt_dose_w := qt_dose_w + qt_dose_especial_w;

				select	coalesce(sum(obter_dose_convertida(a.cd_material, a.qt_dose, a.cd_unidade_medida, cd_unidade_medida_consumo_w)),0)
				into STRICT	qt_dose_retorno_w
				from	prescr_material a,
					prescr_medica b
				where	a.nr_prescricao	= b.nr_prescricao
				and	a.cd_material	= cd_material_w
				and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
				and	a.nr_prescricao <> nr_prescricao_p;

				qt_dose_w := qt_dose_retorno_w + qt_dose_w;	
			elsif (qt_peso_w > 0) then
				if (ie_dose_limite_w = 'KG') then
					qt_dose_w 	:= qt_dose_w + qt_dose_especial_w;
					qt_dose_w	:= dividir(qt_dose_w, coalesce(qt_peso_w,1));
				elsif (ie_dose_limite_w = 'KG/DIA') then
					begin
					/*por KG*/

					
					if (nr_horas_validade_w > 24) then
						nr_ocorrencia_w := trunc(dividir(nr_ocorrencia_w * 24, nr_horas_validade_w));
					end if;
					
					qt_dose_w	:= dividir(qt_dose_w, coalesce(qt_peso_w,1));
					qt_dose_w	:= qt_dose_w * coalesce(nr_ocorrencia_w,1);
					
					if (hr_dose_especial_w IS NOT NULL AND hr_dose_especial_w::text <> '') and (qt_dose_especial_w > 0) then
					
						qt_dose_especial_w	:= dividir(qt_dose_especial_w, coalesce(qt_peso_w,1));
						qt_dose_w			:= qt_dose_w + qt_dose_especial_w;
					end if;					
					qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p,cd_material_w);
					-- Por dia

					-- Caso possua solucao prescrita, devera ser adicionada a conversao dos componentes a dose
					if (qt_solucao_sol_w > 0) then
						if (nr_horas_validade_w > 24) then
							nr_ocorrencia_sol_w	:= trunc(dividir((nr_ocorrencia_sol_w * 24), nr_horas_validade_w));
							qt_solucao_sol_w	:= qt_solucao_sol_w * nr_ocorrencia_sol_w;
						end if;
						
						qt_dose_w	:= qt_dose_w + obter_dose_convertida(cd_material_w, qt_solucao_sol_w, 'ml', cd_unidade_medida_consumo_w);
					end if;
					end;
				elsif (ie_dose_limite_w = 'KG/D') then
					qt_dose_w	:= qt_dose_w + qt_dose_especial_w;
					qt_dose_w	:= dividir(qt_dose_w, coalesce(qt_peso_w,1));/*por KG*/
					qt_dose_w	:= qt_dose_w + obter_dose_medic_dia(nr_prescricao_p,nr_sequencia_p,ie_utiliza_horarios_p,cd_material_w);
				elsif (ie_dose_limite_w = 'KG/H') then 	
						if (ie_agrupador_w = 4) then
							qt_dif_tempo_etapa_w := round(qt_tempo_aplicacao_w / nr_etapas_w);
							if (qt_hora_infusao_w = 0) and (qt_tempo_infusao_w = 0) and (qt_dif_tempo_etapa_w = qt_hora_fase_w) and (qt_tempo_aplicacao_w > 0) then
								qt_tempo_item_w := qt_tempo_aplicacao_w;
							elsif (qt_hora_infusao_w > 0) or (qt_tempo_infusao_w > 0) then
								qt_tempo_item_w := qt_hora_infusao_w + (qt_tempo_infusao_w / 60);
							else
								qt_tempo_item_w := qt_hora_fase_w;
							end if;
							qt_dose_w := qt_dose_w + qt_dose_especial_w;
							qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
						elsif	((qt_hora_aplic_w > 0) or (qt_min_aplic_w > 0)) then
							qt_tempo_item_w := qt_hora_aplic_w + (qt_min_aplic_w/60);
							qt_dose_w := qt_dose_w + qt_dose_especial_w;
							qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
						end if;
				elsif (ie_dose_limite_w = 'KG/MIN') then 	
						if (ie_agrupador_w = 4) then
							qt_dif_tempo_etapa_w := round(qt_tempo_aplicacao_w / nr_etapas_w);
							if (qt_hora_infusao_w = 0) and (qt_tempo_infusao_w = 0) and (qt_dif_tempo_etapa_w = qt_hora_fase_w) and (qt_tempo_aplicacao_w > 0) then
								qt_tempo_item_w := qt_tempo_aplicacao_w * 60;
							elsif (qt_hora_infusao_w > 0) or (qt_tempo_infusao_w > 0) then
								qt_tempo_item_w := (qt_hora_infusao_w * 60) + qt_tempo_infusao_w;
							else
								qt_tempo_item_w  := qt_hora_fase_w * 60;
							end if;
							qt_dose_w := qt_dose_w + qt_dose_especial_w;
							qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
						elsif	((qt_hora_aplic_w > 0) or (qt_min_aplic_w > 0)) then
							qt_tempo_item_w := (qt_hora_aplic_w * 60) + qt_min_aplic_w;
							qt_dose_w := qt_dose_w + qt_dose_especial_w;
							qt_dose_w := qt_dose_w / (qt_peso_w * qt_tempo_item_w);
						end if;	
				end if;
			end if;
			
			if	((substr(ie_consistiu_dose_w,1,1) = 'N') or 			
				(((qt_dose_limite_w > 0) or (qt_limite_pessoa_w = 0)) and (round((qt_dose_limite_w)::numeric,3) < coalesce(round((qt_dose_w)::numeric,3),0)))) then
				
				-- A dose unitaria e maior que a dose limite #@QT_LIMITE_PESSOA_P#@ #@CD_UNID_MED_LIMITE_P#@ por #@IE_DOSE_LIMITE_P#@

				--  #@DS_OBSERVACAO_P#@
				if (ie_dose_limite_w <> 'PF') then
					ds_erro2_p	:= substr(wheb_mensagem_pck.get_texto(278070, 'QT_LIMITE_PESSOA_P='||QT_LIMITE_PESSOA_WW||';CD_UNID_MED_LIMITE_P=' ||CD_UNID_MED_LIMITE_W||';IE_DOSE_LIMITE_P='||OBTER_VALOR_DOMINIO(1851 , IE_DOSE_LIMITE_W)||';DS_OBSERVACAO_P='||coalesce(DS_OBSERVACAO_W, ' ')),1,255);
				else
					ds_erro2_p	:= substr(wheb_mensagem_pck.get_texto(278070, 'QT_LIMITE_PESSOA_P='||QT_LIMITE_PESSOA_WW||';CD_UNID_MED_LIMITE_P=' ||CD_UNID_MED_LIMITE_W||';IE_DOSE_LIMITE_P='||obter_desc_expressao(295829)||';DS_OBSERVACAO_P='||coalesce(DS_OBSERVACAO_W, ' ')),1,255);
				end if;
				if (ds_mensagem_regra_w IS NOT NULL AND ds_mensagem_regra_w::text <> '') then
					ds_erro2_p := ds_mensagem_regra_w;
				end if;
				qt_dose_limite_p := qt_limite_pessoa_ww;
				cd_unid_med_lim_p := cd_unid_med_limite_w;
				if (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') then
					ds_erro2_p:= substr(ds_erro2_p||wheb_mensagem_pck.get_texto(495114,'DS_CID_DOENCA='||OBTER_DESC_CID(cd_doenca_cid_w)),1,255);
				end if;

				
				if ((ie_justificativa_w = 'S') or (nr_seq_mat_cpoe_w > 0 AND ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '')) then
					ie_tipo_erro_p := 'N';
				elsif ((ie_justificativa_w = 'N') and (coalesce(ds_justificativa_w::text, '') = '')) then	
					ie_tipo_erro_p := 'J';
				elsif (ie_param_170_f_w = 'S') then
					ie_tipo_erro_p := 'A';
				end if;
					
			end if;

			end;
			if (ds_erro2_p IS NOT NULL AND ds_erro2_p::text <> '') then
				exit;
			end if;
		end loop;
		close c01;

		end;
	end if;
	end;
end if;

exception when others then
	null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_dose_maxima ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_utiliza_horarios_p text, ds_erro_p INOUT text, ds_erro2_p INOUT text, dt_aprazamento_p timestamp default null, ie_tipo_erro_p INOUT text DEFAULT NULL, qt_dose_limite_p INOUT bigint DEFAULT NULL, cd_unid_med_lim_p INOUT text DEFAULT NULL) FROM PUBLIC;
