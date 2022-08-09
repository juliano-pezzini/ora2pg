-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_inserir_material_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_material.nr_sequencia%type, nm_usuario_p prescr_medica.nm_usuario%type, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE


-- Duplicacao da procedure CPOE_REP_GENERATE_MATERIAL
						
nr_seq_material_w				prescr_material.nr_sequencia%type;
cd_material_w					prescr_material.cd_material%type;
cd_unidade_medida_dose_w		prescr_material.cd_unidade_medida_dose%type;
qt_dose_w						prescr_material.qt_dose%type;
ie_acm_w						prescr_material.ie_acm%type;
ie_se_necessario_w				prescr_material.ie_se_necessario%type;
ds_horarios_w					prescr_material.ds_horarios%type;
hr_prim_horario_w				prescr_material.hr_prim_horario%type;
hr_prim_horario_ww				prescr_material.hr_prim_horario%type;
cd_intervalo_w					prescr_material.cd_intervalo%type;
nr_dia_util_w					prescr_material.nr_dia_util%type;
ds_justificativa_w				prescr_material.ds_justificativa%type;
ds_observacao_w					prescr_material.ds_observacao%type;
nr_ocorrencia_w					prescr_material.nr_ocorrencia%type;
nr_agrupamento_w				prescr_material.nr_agrupamento%type;
nr_agrupamento_ww				prescr_material.nr_agrupamento%type := 0;

ie_administracao_w				cpoe_material.ie_administracao%type;
dt_prim_horario_w				cpoe_material.dt_inicio%type;
dt_fim_w						cpoe_material.dt_fim%type;

ie_duracao_w 					cpoe_material.ie_duracao%type:='C';
ie_urgencia_w					cpoe_material.ie_urgencia%type:='';
ds_horarios_aux_w				cpoe_material.ds_horarios%type:='';
		
qt_min_intervalo_w 				intervalo_prescricao.qt_min_intervalo%type;

ie_prescr_alta_agora_w	varchar(1);

ds_retorno_w					varchar(255);
					
material_cursor CURSOR FOR
SELECT	nr_sequencia,
		cd_material,
		cd_unidade_medida_dose,
		qt_dose,
		coalesce(ie_acm,'N'),
		coalesce(ie_se_necessario,'N'),
		ds_horarios,
		hr_prim_horario,
		cd_intervalo,
		nr_dia_util,
		nr_ocorrencia,
		ds_justificativa,
		ds_observacao,
		nr_agrupamento
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_sequencia_p;


BEGIN

ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);

open material_cursor;
loop
fetch material_cursor into	nr_seq_material_w,
				cd_material_w,
				cd_unidade_medida_dose_w,
				qt_dose_w,				
				ie_acm_w,
				ie_se_necessario_w,
				ds_horarios_w,
				hr_prim_horario_w,
				cd_intervalo_w,
				nr_dia_util_w,
				nr_ocorrencia_w,
				ds_justificativa_w,
				ds_observacao_w,
				nr_agrupamento_w;
EXIT WHEN NOT FOUND; /* apply on material_cursor */
	begin
	
	if (coalesce(ie_prescr_alta_agora_w,'N') = 'S') and (coalesce(ie_item_alta_p,'N') = 'S')	then
	
		ie_urgencia_w := 0;
		
		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, cd_material_w, clock_timestamp(), 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
		
		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
	
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
		dt_prim_horario_w	:= to_date(to_char(clock_timestamp(),'dd/mm/yyyy ') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
	
		if (dt_prim_horario_w < clock_timestamp()) then
			dt_prim_horario_w := dt_prim_horario_w + 1;
		end if;
	else	
		ie_urgencia_w := '';
		SELECT * FROM cpoe_atualizar_periodo_vig_ant(ds_horarios_w, hr_prim_horario_w, dt_prim_horario_w) INTO STRICT ds_horarios_w, hr_prim_horario_w, dt_prim_horario_w;
	end if;		
	
	dt_fim_w := ((to_date(to_char(dt_prim_horario_w, 'dd/mm/yyyy') || ' ' || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi')  + 1) - 1/86400);
	
	ie_administracao_w := 'P';
	if (ie_acm_w = 'S') then
		ie_administracao_w := 'C';
		hr_prim_horario_w := '';
		ds_horarios_w := '';
	elsif (ie_se_necessario_w = 'S') then
		ie_administracao_w := 'N';
		hr_prim_horario_w := '';
		ds_horarios_w := '';
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S') then -- retrograde/backward item
		dt_prim_horario_w := dt_inicio_p;
		dt_fim_w := (dt_prim_horario_w + 1) - 1/1440;
		ie_urgencia_w	:= null;
		ie_duracao_w	:= 'P';
		nr_ocorrencia_w	:= 0;
		ds_horarios_w	:= '';
		ds_horarios_aux_w	:= '';
		
		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, cd_material_w, dt_prim_horario_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
		
		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	end if;

	select	nextval('cpoe_material_seq')
	into STRICT	nr_seq_item_gerado_p
	;
	
	if (coalesce(cd_unidade_medida_dose_w::text, '') = '') then
		select max(cd_unidade_medida_consumo)
		into STRICT	cd_unidade_medida_dose_w
		from	material
		where	cd_material = cd_material_w;
	end if;

	insert into cpoe_material(
				nr_sequencia,
				nr_atendimento,					
				ie_administracao,
				ie_duracao,
				dt_inicio,
				dt_fim,
				cd_material,
				cd_unidade_medida,
				qt_dose,
				ie_acm,
				ie_se_necessario,
				ie_urgencia,
				ds_horarios,
				hr_prim_horario,
				cd_intervalo,					
				nr_dia_util,
				nr_ocorrencia,
				ds_justificativa,
				ds_observacao,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec,
				cd_perfil_ativo,
				ie_material,
				cd_pessoa_fisica,
				cd_funcao_origem,
				nr_seq_transcricao,
				ie_item_alta,
				ie_prescritor_aux,
				cd_medico,
				ie_retrogrado,
				nr_seq_pepo,
				nr_cirurgia,
				nr_cirurgia_patologia,
				nr_seq_agenda,
				ie_oncologia,
				nr_seq_conclusao_apae,
				ie_futuro,
				nr_seq_cpoe_order_unit)
			values (
				nr_seq_item_gerado_p,
				nr_atendimento_p,
				ie_administracao_w,
				ie_duracao_w,
				dt_prim_horario_w,
				dt_fim_w,
				cd_material_w,
				cd_unidade_medida_dose_w,
				qt_dose_w,
				ie_acm_w,
				ie_se_necessario_w,
				ie_urgencia_w,
				ds_horarios_w,
				hr_prim_horario_w,
				cd_intervalo_w,					
				nr_dia_util_w,
				nr_ocorrencia_w,
				ds_justificativa_w,
				ds_observacao_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				cd_perfil_p,
				'S',
				obter_cd_paciente_prescricao(nr_prescricao_p),
				2314,
				nr_seq_transcricao_p,
				ie_item_alta_p,
				ie_prescritor_aux_p,
				cd_medico_p,
				ie_retrogrado_p,
				nr_seq_pepo_p,
				nr_cirurgia_p,
				nr_cirurgia_patologia_p,
				nr_seq_agenda_p,
				ie_oncologia_p,
				nr_seq_conclusao_apae_p,
				ie_futuro_p,
				nr_seq_cpoe_order_unit_p);

	end;
end loop;
close material_cursor;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_inserir_material_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_material.nr_sequencia%type, nm_usuario_p prescr_medica.nm_usuario%type, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
