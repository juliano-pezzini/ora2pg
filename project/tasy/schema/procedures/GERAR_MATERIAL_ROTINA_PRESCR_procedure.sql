-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_material_rotina_prescr ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, qt_material_p bigint, nm_usuario_p text, cd_intervalo_p text, ds_justificativa_p text) AS $body$
DECLARE


cd_material_w			material.cd_material%type;
nr_seq_material_w		integer;
cd_unid_med_consumo_w	varchar(30);
nr_agrupamento_w		double precision;
dt_prescricao_w			timestamp;
dt_primeiro_horario_w	timestamp;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_erro_w				bigint;
cd_intervalo_w			intervalo_prescricao.cd_intervalo%type;
hr_prim_horario_w		varchar(5);
nr_horas_validade_w		integer;
nr_intervalo_w			bigint;
ds_horarios_w			varchar(2000);
ds_horarios2_w			varchar(2000);
ds_justificativa_w		varchar(2000);
qt_total_dispensar_w	double precision;
qt_material_w			double precision;
ie_justific_padrao_w	varchar(2);
ds_erro_w				varchar(255);
ie_regra_disp_w			varchar(1);/* Rafael em 15/3/8 OS86206 */
cd_interv_param_w		varchar(7);
ie_agora_w				varchar(2) := 'N';
qt_dose_w 				double precision;
ds_cor_rotina_w			varchar(15);
ie_prescr_mat_sem_lib_w	char(1);
ie_check_tipo_interv_w	char(1);
qt_conversao_dose_w	   	double precision;
qt_unitaria_w   		double precision;


BEGIN

select	coalesce(max(nr_sequencia),0),
		coalesce(max(nr_agrupamento),0)
into STRICT	nr_seq_material_w,
		nr_agrupamento_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p;

select	max(dt_prescricao),
		max(dt_primeiro_horario),
		max(cd_setor_atendimento),
		max(cd_estabelecimento),
		coalesce(max(nr_horas_validade),24)
into STRICT	dt_prescricao_w,
		dt_primeiro_horario_w,
		cd_setor_atendimento_w,
		cd_estabelecimento_w,
		nr_horas_validade_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

CALL Wheb_assist_pck.set_informacoes_usuario(cd_estabelecimento_p, cd_perfil_p, nm_usuario_p);
cd_interv_param_w := Wheb_assist_pck.obterValorParametroREP(49, cd_interv_param_w);
ie_prescr_mat_sem_lib_w := Wheb_assist_pck.obterValorParametroREP(530, ie_prescr_mat_sem_lib_w);
ie_justific_padrao_w := Wheb_assist_pck.obterValorParametroREP(640, ie_justific_padrao_w);
ie_check_tipo_interv_w := Wheb_assist_pck.obterValorParametroREP(809, ie_check_tipo_interv_w);

if (coalesce(cd_interv_param_w::text, '') = '') then
	begin
	select	cd_intervalo_padrao
	into STRICT	cd_intervalo_w
	from	parametro_medico
	where	cd_estabelecimento = cd_estabelecimento_w;
	exception
	when others then
	--	Não existe um intervalo padrão definido para a geração dos materiais, favor verificar!

	--	É necessário definir um através do parâmetro [49] da Prescrição Eletrônica Paciente - REP, ou ainda, através dos parâmetros médicos em: Cadastros Gerais / Aplicação Principal / Médico / Parâmetros PEP.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(176610);
	end;
else
	cd_intervalo_w	:= cd_interv_param_w;
end if;
	
select 	coalesce(max(ie_agora),'N'),
		max(hr_prim_horario),
		max(coalesce(cd_intervalo,cd_intervalo_w)), 
		max(coalesce(qt_dose,1)), 
		max(ds_cor_rotina),
		max(cd_unidade_medida),
		max(cd_material)
into STRICT	ie_agora_w,
		hr_prim_horario_w,
		cd_intervalo_w, 
		qt_dose_w, 
		ds_cor_rotina_w,
		cd_unid_med_consumo_w,
		cd_material_w
from	material_rotina
where	nr_sequencia = nr_sequencia_p
and		((cd_setor_atendimento = cd_setor_atendimento_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
and		((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento));

if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
	begin
	if (coalesce(cd_unid_med_consumo_w::text, '') = '') then
		select	max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30))
		into STRICT	cd_unid_med_consumo_w
		from	material
		where	cd_material	= cd_material_w;		
	end if;

	if (coalesce(hr_prim_horario_w::text, '') = '') then
		hr_prim_horario_w	:= obter_primeiro_horario(cd_intervalo_w,nr_prescricao_p,cd_material_w,null);
	end if;

	qt_material_w	:= 1;

	if (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') then
		qt_material_w := qt_dose_w;
	end if;

	cd_intervalo_w := coalesce(cd_intervalo_p, cd_intervalo_w);
		
	select	max(cd_intervalo)
	into STRICT	cd_intervalo_w
	from	intervalo_prescricao
	where	cd_intervalo = coalesce(cd_intervalo_w,'XPTO');

	if (qt_material_p IS NOT NULL AND qt_material_p::text <> '') and (qt_material_p > 0) then
		qt_dose_w := qt_material_p;
	end if;

	SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, cd_intervalo_w, dt_primeiro_horario_w, dt_primeiro_horario_w, nr_horas_validade_w, cd_material_w, 0, 0, nr_intervalo_w, ds_horarios_w, ds_horarios2_w, 'N', null) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_horarios2_w;

	ds_horarios_w	:= ds_horarios_w || ds_horarios2_w;

	if (ie_check_tipo_interv_w = 'S') and (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') and (coalesce(ie_agora_w,'N') = 'N') then
		Select	coalesce(coalesce(max(ie_agora),ie_agora_w),'N')
		into STRICT	ie_agora_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;
	end if;	

	if (ie_agora_w = 'S') then
		hr_prim_horario_w 	:= to_char(clock_timestamp(),'hh24:mi');
		ds_horarios_w		:= to_char(clock_timestamp(),'hh24:mi');
		nr_intervalo_w		:= 1;
	end if;

	qt_conversao_dose_w	:= obter_conversao_unid_med(cd_material_w,cd_unid_med_consumo_w);

	qt_unitaria_w := dividir(trunc(dividir(qt_dose_w * 1000,qt_conversao_dose_w)),1000);

	SELECT * FROM Obter_Quant_Dispensar(cd_estabelecimento_w, cd_material_w, nr_prescricao_p, 0, cd_intervalo_w, NULL, coalesce(qt_unitaria_w,1), 0, nr_intervalo_w, NULL, NULL, cd_unid_med_consumo_w, NULL, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, 'N', 'N') INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;

	nr_seq_material_w	:= nr_seq_material_w + 1;
	nr_agrupamento_w	:= nr_agrupamento_w + 1;
		
	if (ie_justific_padrao_w = 'S') and (coalesce(ds_justificativa_p::text, '') = '') then
		select	max(ds_justificativa)
		into STRICT	ds_justificativa_w
		from	rep_justificativa_material
		where	obter_se_justif_padrao_medic(cd_material_w, nr_sequencia,cd_estabelecimento_w,'N','N') = 'S';
	else
	ds_justificativa_w := ds_justificativa_p; --OS 688085
	end if;

	insert into prescr_material(
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
		nr_agrupamento,
		cd_motivo_baixa,
		ie_utiliza_kit,
		cd_unidade_medida_dose,
		qt_conversao_dose,
		ie_urgencia,
		nr_ocorrencia,
		qt_total_dispensar,
		ds_horarios,
		hr_prim_horario,
		ie_medicacao_paciente,
		ie_suspenso,
		ie_agrupador,
		ie_se_necessario,
		ie_bomba_infusao,
		ie_aplic_bolus,
		ie_aplic_lenta,
		ie_acm,
		ie_cultura_cih,
		ie_antibiograma,
		ie_uso_antimicrobiano,
		ie_recons_diluente_fixo,
		ie_sem_aprazamento,
		ie_regra_disp,
		ds_justificativa)
	values (	nr_prescricao_p,
		nr_seq_material_w,
		'R',
		cd_material_w,
		cd_unid_med_consumo_w,
		coalesce(qt_dose_w,1),
		coalesce(qt_unitaria_w,1),
		coalesce(qt_material_w,1),
		clock_timestamp(),
		nm_usuario_p,
		cd_intervalo_w,
		nr_agrupamento_w,
		0,
		'N',
		cd_unid_med_consumo_w,
		coalesce(qt_conversao_dose_w,1),
		ie_agora_w,--'N'
		nr_intervalo_w,
		qt_total_dispensar_w,
		ds_horarios_w,
		hr_prim_horario_w,
		'N',
		'N',
		2,
		'N',
		'N',
		'N',
		'N',
		'N',
		'N',
		'N',
		'N',
		'N',
		'N',
		ie_regra_disp_w,
		ds_justificativa_w);
		
	if (ie_prescr_mat_sem_lib_w = 'S') THEN
		CALL Gerar_prescr_mat_sem_dt_lib(nr_prescricao_p,nr_seq_material_w,cd_perfil_p,'N',nm_usuario_p,null);
	end if;	
		
	nr_erro_w := Consistir_Prescr_Material(nr_prescricao_p, nr_seq_material_w, nm_usuario_p, obter_perfil_ativo, nr_erro_w);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_material_rotina_prescr ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, qt_material_p bigint, nm_usuario_p text, cd_intervalo_p text, ds_justificativa_p text) FROM PUBLIC;
