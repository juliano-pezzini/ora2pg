-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_recomemdacao_rotina ( cd_protocolo_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_rec_p bigint, nm_usuario_p text, cd_intervalo_p text default null) AS $body$
DECLARE


nr_seq_recomendacao_w	bigint;
cd_intervalo_w			varchar(7);
cd_setor_atendimento_w	integer;
cd_estabelecimento_w	bigint;
dt_prescricao_w			timestamp;
dt_primeiro_horario_w	timestamp;
dt_inicio_prescr_w		timestamp;
hr_prim_horario_w		varchar(5);
ds_horarios_w			varchar(2000);
ds_horarios2_w			varchar(2000);
nr_ocorrencia_w			bigint;
nr_horas_validade_w		integer;
ie_interv_setor_w		varchar(1);
dt_inicio_interv		timestamp;
ie_limpa_prim_hor_w		varchar(1) := 'N';
nr_atendimento_w		bigint;
ie_prescr_rec_sem_lib_w	varchar(255);
cd_perfil_w				integer	:= obter_perfil_ativo;
cd_recomendacao_w		protocolo_medic_rec.cd_recomendacao%type;
cd_kit_w				protocolo_medic_rec.cd_kit%type;


BEGIN

select	coalesce(max(nr_sequencia),0)+1
into STRICT		nr_seq_recomendacao_w
from		prescr_recomendacao
where	nr_prescricao		= nr_prescricao_p;

select	max(cd_estabelecimento),
		max(dt_prescricao),
		max(dt_primeiro_horario),
		max(dt_inicio_prescr),
		max(cd_setor_atendimento),
		max(nr_horas_validade),
		max(nr_atendimento)
into STRICT		cd_estabelecimento_w,
		dt_prescricao_w,
		dt_primeiro_horario_w,
		dt_inicio_prescr_w,
		cd_setor_atendimento_w,
		nr_horas_validade_w,
		nr_atendimento_w
from		prescr_medica
where	nr_prescricao	= nr_prescricao_p;

ie_prescr_rec_sem_lib_w := Obter_Param_Usuario(924, 530, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_prescr_rec_sem_lib_w);

if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then
	cd_intervalo_w	:= cd_intervalo_p;
end if;

if (coalesce(cd_intervalo_w::text, '') = '') then
        select	max(cd_intervalo)
        into STRICT	cd_intervalo_w
        from	protocolo_medic_rec
        where	cd_protocolo = cd_protocolo_p
        and	nr_sequencia = nr_sequencia_p
        and	nr_seq_rec = nr_seq_rec_p;
end if;

if (coalesce(cd_intervalo_w::text, '') = '') then
        select  obter_interv_prescr_padrao(cd_estabelecimento_w)
        into STRICT	cd_intervalo_w
;
end if;


select	Obter_se_setor_intervalo(cd_intervalo_w,cd_setor_atendimento_w,cd_estabelecimento_w,null,null,obter_unid_atend_setor_atual(nr_atendimento_w,cd_setor_atendimento_w,'UB'))
into STRICT		ie_interv_setor_w
;

if (ie_interv_setor_w = 'S') then
	hr_prim_horario_w	:= obter_primeiro_horario(cd_intervalo_w,nr_prescricao_p,null,null);
end if;

dt_inicio_interv	:= to_date(to_char(dt_primeiro_horario_w,'dd/mm/yyyy ') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
nr_ocorrencia_w		:= 0;
	
SELECT * FROM Calcular_Horario_Prescricao(
	nr_prescricao_p, cd_intervalo_w, coalesce(dt_inicio_prescr_w,dt_prescricao_w), dt_inicio_interv, nr_horas_validade_w, null, null, null, nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w;
	
	
ds_horarios_w := ds_horarios_w || ds_horarios2_w;

select	reordenar_horarios(dt_inicio_interv, ds_horarios_w) || ' '
into STRICT		ds_horarios_w
;

if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
	
	select	coalesce(ie_limpa_prim_hor,'N')
	into STRICT		ie_limpa_prim_hor_w
	from		intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w;
	
end if;

select	max(cd_recomendacao),
		max(cd_kit)
into STRICT	cd_recomendacao_w,
		cd_kit_w
from	protocolo_medic_rec
where	cd_protocolo = cd_protocolo_p
and		nr_sequencia = nr_sequencia_p
and		nr_seq_rec = nr_seq_rec_p;

insert into prescr_recomendacao(
		nr_prescricao,
		nr_sequencia,
		ie_destino_rec,
		dt_atualizacao,
		nm_usuario,
		cd_recomendacao,
		nr_seq_classif,
		ie_suspenso,
		ds_horarios,
		nr_seq_apres,
		cd_kit,
		cd_intervalo,
		hr_prim_horario,
		ie_acm,
		ie_se_necessario,
		ie_urgencia,
		nr_seq_topografia
		)
SELECT	nr_prescricao_p,
		nr_seq_recomendacao_w,
		'E',
		clock_timestamp(),
		nm_usuario_p,
		cd_recomendacao,
		nr_seq_classif,
		'N',
		CASE WHEN ie_limpa_prim_hor_w='N' THEN CASE WHEN ie_urgencia='S' THEN to_char(clock_timestamp(),'hh24:mi')  ELSE CASE WHEN ie_acm='S' THEN 'ACM'  ELSE CASE WHEN ie_se_necessario='S' THEN 'SN'  ELSE coalesce(ds_horarios_w, ds_horarios) END  END  END   ELSE null END ,
		nr_seq_apres,
		cd_kit,
		coalesce(coalesce(cd_intervalo_p, cd_intervalo), cd_intervalo_w),
		CASE WHEN ie_limpa_prim_hor_w='N' THEN hr_prim_horario_w  ELSE null END ,
		ie_acm,
		ie_se_necessario,
		ie_urgencia,
		nr_seq_topografia
from	protocolo_medic_rec
where	cd_protocolo = cd_protocolo_p
and		nr_sequencia = nr_sequencia_p
and		nr_seq_rec = nr_seq_rec_p
order by coalesce(nr_seq_apres,999);

if (cd_kit_w IS NOT NULL AND cd_kit_w::text <> '') then
	CALL inserir_kit_recomendacao(	nm_usuario_p => nm_usuario_p,
								nr_prescricao_p => nr_prescricao_p,
								nr_seq_recomendacao_p => nr_seq_recomendacao_w,
								cd_recomendacao_p => cd_recomendacao_w,
								cd_kit_p => cd_kit_w
							);

	CALL gerar_kit_rec_prescricao(	cd_estabelecimento_p => cd_estabelecimento_w,
								nr_prescricao_p => nr_prescricao_p,
								nr_seq_item_p => nr_seq_recomendacao_w,
								nm_usuario_p => nm_usuario_p,
								ie_diluicao_p => 'N',
								ie_manual_p => 'N'
							);
end if;

if (ie_prescr_rec_sem_lib_w = 'S') then
	CALL Gerar_prescr_hor_sem_lib(nr_prescricao_p,null,cd_perfil_w,'N',nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_recomemdacao_rotina ( cd_protocolo_p bigint, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_rec_p bigint, nm_usuario_p text, cd_intervalo_p text default null) FROM PUBLIC;
