-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_copia_recomendacao (nr_prescricao_orig_p bigint, nr_prescricao_p bigint, nr_seq_regra_p bigint, dt_prescricao_p timestamp, cd_intervalo_p text, cd_item_p text, qt_item_p bigint, ie_modificar_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_estende_inc_p text, ie_copia_agora_p text) AS $body$
DECLARE


nr_sequencia_w			integer;
nr_seq_anterior_w		bigint;
ie_destino_rec_w		varchar(3);
ds_recomendacao_w		varchar(4000);
nr_seq_classif_w		bigint;
cd_recomendacao_w		bigint;
qt_w				bigint;
ds_horarios_w			varchar(2000);
ds_observacao_w			varchar(255);
ie_loop_w			varchar(1);
qt_itens_w			bigint;
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w		timestamp;
dt_suspensao_progr_w		timestamp;
nr_prescricao_original_w	bigint;
nr_seq_original_w		integer;
hr_prim_horario_w		varchar(5);
qt_inconsistencia_w		bigint;
dt_prescricao_w			timestamp;
cd_intervalo_w			varchar(7);
dt_primeiro_horario_w		timestamp;
nr_ocorrencia_w			bigint;
ds_horarios2_w			varchar(2000);
dt_inicio_interv_w		timestamp;
nr_horas_validade_w		integer;
hr_prim_horario_rec_w		varchar(255);
VarPrimHorarioRec_w		varchar(50);
ie_acm_w			varchar(1);
ie_regra_horarios_w	varchar(10);
ie_se_necessario_w		varchar(1);
ie_urgencia_w			varchar(1);
nr_seq_agrupamento_w	bigint;
cd_setor_prescricao_w	bigint;
ie_seleciona_kit_rec_w	varchar(1);
ie_copia_kit_rec_w		varchar(1);
cd_convenio_w			bigint;
cd_kit_w				bigint;
cd_protocolo_prescr_w		prescr_medica.cd_protocolo%type;
nr_seq_prot_prescr_w		prescr_medica.nr_seq_protocolo%type;
ie_atualizar_kit_rec_w 		varchar(1);
qt_min_intervalo_w			prescr_recomendacao.qt_min_intervalo%type;
dt_suspensao_w			prescr_recomendacao.dt_suspensao%type;
nr_prescricao_estender_w  bigint;

C01 CURSOR FOR
SELECT	cd_kit
from	kit_mat_recomendacao
where	((coalesce(cd_perfil,0) = 0) or (cd_perfil = obter_perfil_ativo))
and		((coalesce(cd_setor_atendimento,0) = 0) or (cd_setor_atendimento = cd_setor_prescricao_w))
and		((coalesce(cd_convenio::text, '') = '') or (cd_convenio = cd_convenio_w))
and		((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento = nr_seq_agrupamento_w))
and		cd_recomendacao  	= cd_recomendacao_w;


BEGIN

select	dt_inicio_prescr,
		dt_validade_prescr,
		to_char(dt_inicio_prescr,'hh24:mi'),
		dt_prescricao,
		dt_primeiro_horario,
		nr_horas_validade,
		cd_setor_atendimento,
		obter_convenio_atendimento(nr_atendimento)
into STRICT	dt_inicio_prescr_w,
		dt_validade_prescr_w,
		hr_prim_horario_w,
		dt_prescricao_w,
		dt_primeiro_horario_w,
		nr_horas_validade_w,
		cd_setor_prescricao_w,
		cd_convenio_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p  LIMIT 1;

select	max(nr_seq_agrupamento)
into STRICT	nr_seq_agrupamento_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_prescricao_w;

select 	coalesce(max(a.nr_seq_anterior),max(a.nr_sequencia)),
		max(a.ie_destino_rec),
		substr(max(a.ds_recomendacao),1,4000),
		max(a.nr_seq_classif),
		max(a.cd_recomendacao),
		max(a.ds_horarios),
		max(a.ds_observacao),
		max(a.dt_suspensao_progr),
		coalesce(max(a.nr_prescricao_original), max(a.nr_prescricao)),
		max(a.nr_sequencia),
		max(a.cd_intervalo),
		coalesce(max(a.ie_acm),'N'),
		coalesce(max(a.ie_se_necessario),'N'),
		max(cd_kit),
		max(a.ie_urgencia),
		count(*),
		max(a.qt_min_intervalo)
into STRICT	nr_seq_anterior_w,
		ie_destino_rec_w,
		ds_recomendacao_w,
		nr_seq_classif_w,
		cd_recomendacao_w,
		ds_horarios_w,
		ds_observacao_w,
		dt_suspensao_progr_w,
		nr_prescricao_original_w,
		nr_seq_original_w,
		cd_intervalo_w,
		ie_acm_w,
		ie_se_necessario_w,
		cd_kit_w,
		ie_urgencia_w,
		qt_w,
		qt_min_intervalo_w
FROM prescr_recomendacao a
LEFT OUTER JOIN tipo_recomendacao b ON (a.cd_recomendacao = b.cd_tipo_recomendacao)
WHERE a.nr_prescricao		= nr_prescricao_orig_p and coalesce(to_char(a.cd_recomendacao),a.ds_recomendacao) = cd_item_p and coalesce(a.cd_intervalo,'XPTO') = coalesce(cd_intervalo_p,'XPTO') and (coalesce(a.qt_recomendacao,0) = coalesce(qt_item_p,0)) and ((coalesce(ie_copia_agora_p,'S')	= 'S') or
		((ie_copia_agora_p = 'N') and (coalesce(a.ie_urgencia,'N') = 'N')));

select	max(a.ie_regra_geral)
into STRICT	ie_regra_horarios_w
from	rep_regra_copia_crit a
where	a.ie_tipo_item	= 'REC'
and		((a.nr_seq_regra	= nr_seq_regra_p) or (coalesce(nr_seq_regra_p,0) = 0))
and (coalesce(ie_agora,'S') = 'S' or
		 coalesce(ie_urgencia_w,'N') <> 'S')  LIMIT 1;
		
CALL PLT_consiste_extensao_item(dt_inicio_prescr_w, dt_validade_prescr_w, nr_prescricao_orig_p, nr_seq_original_w, 'R', nr_seq_regra_p, nm_usuario_p, cd_perfil_p, cd_estabelecimento_p);

select	count(nr_sequencia)
into STRICT	qt_inconsistencia_w
from	w_copia_plano
where	nr_prescricao	= nr_prescricao_orig_p
and		nr_seq_item	= nr_seq_original_w
and		ie_tipo_item	= 'R'
and		nm_usuario	= nm_usuario_p
and		((ie_permite	= 'N') or (ie_estende_inc_p = 'N'))  LIMIT 1;
	
if	((qt_inconsistencia_w	= 0) or (ie_modificar_p	= 'S')) and (qt_w > 0) then
	nr_sequencia_w 	:= 1;
	ie_loop_w	:= 'S';
		
	while(ie_loop_w = 'S') loop
		select	count(*)
		into STRICT	qt_itens_w
		from	prescr_recomendacao
		where	nr_prescricao	= nr_prescricao_p
		and		nr_sequencia	= nr_sequencia_w  LIMIT 1;
			
		if (qt_itens_w	= 0) then
			ie_loop_w	:= 'N';
		else	
			nr_sequencia_w	:= nr_sequencia_w + 1;
		end if;
	end loop;
	
	dt_inicio_interv_w	:= converte_char_data(to_char(dt_primeiro_horario_w,'dd/mm/yyyy'),hr_prim_horario_w,null);
	nr_ocorrencia_w		:= 0;
	
	select	max(Obter_primeiro_horario(cd_intervalo_w, nr_prescricao_p, 0, null))
	into STRICT	hr_prim_horario_rec_w
	;
	
	begin
	VarPrimHorarioRec_w := obter_Param_Usuario(924, 208, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, VarPrimHorarioRec_w);
	ie_seleciona_kit_rec_w := Obter_Param_Usuario(924, 458, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_seleciona_kit_rec_w);
	ie_copia_kit_rec_w := Obter_Param_Usuario(924, 933, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_copia_kit_rec_w);
	ie_atualizar_kit_rec_w := Obter_Param_Usuario(924, 1181, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atualizar_kit_rec_w);
	exception when others then
		null;
	end;
		
	if (hr_prim_horario_rec_w IS NOT NULL AND hr_prim_horario_rec_w::text <> '') and (VarPrimHorarioRec_w = 'S') then
		hr_prim_horario_w   := hr_prim_horario_rec_w;
		dt_inicio_interv_w  := converte_char_data(to_char(dt_primeiro_horario_w,'dd/mm/yyyy'),hr_prim_horario_rec_w, null);
	end if;
	
	if (coalesce(ie_regra_horarios_w,'H') <> 'I') then
		SELECT * FROM Calcular_Horario_Prescricao(
					nr_prescricao_p, cd_intervalo_w, coalesce(dt_inicio_prescr_w,dt_prescricao_w), dt_inicio_interv_w, nr_horas_validade_w, null, null, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w, 'N', null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios2_w;
		
		ds_horarios_w := ds_horarios_w || ds_horarios2_w;
	end if;
	
	ds_horarios_w := reordenar_horarios(dt_inicio_interv_w, ds_horarios_w) || ' ';
	
	if (ie_acm_w = 'S') then
		ds_horarios_w	:= wheb_mensagem_pck.get_texto(309807); -- ACM
	end if;

	if (ie_atualizar_kit_rec_w = 'S') then
		select 	MAX(cd_protocolo),
				MAX(nr_seq_protocolo)
		into STRICT	cd_protocolo_prescr_w,
				nr_seq_prot_prescr_w
		from   	PRESCR_MEDICA
		where 	nr_prescricao = nr_prescricao_p;
		
		if (cd_protocolo_prescr_w IS NOT NULL AND cd_protocolo_prescr_w::text <> '')
			and (nr_seq_prot_prescr_w IS NOT NULL AND nr_seq_prot_prescr_w::text <> '') then
					select	coalesce(max(cd_kit),cd_kit_w)
					into STRICT	cd_kit_w
					from	protocolo_medic_rec
					where	cd_recomendacao = cd_recomendacao_w
					and		cd_protocolo = cd_protocolo_prescr_w
					and		nr_sequencia = nr_seq_prot_prescr_w;
		end if;
	end if;
	
	Insert into Prescr_recomendacao(
		nr_prescricao,
		nr_sequencia,
		ie_destino_rec,
		dt_atualizacao,
		nm_usuario,
		ds_recomendacao,
		qt_recomendacao,
		ie_suspenso,
		cd_intervalo,
		nr_seq_classif,
		cd_recomendacao,
		ds_horarios,
		ds_observacao,
		dt_suspensao_progr,
		nr_prescricao_original,
		nr_seq_anterior,
		hr_prim_horario,
		ie_acm,
		ie_se_necessario,
		cd_kit)
	values (nr_prescricao_p,
		nr_sequencia_w,
		ie_destino_rec_w,
		dt_prescricao_p,
		nm_usuario_p,
		ds_recomendacao_w,
		CASE WHEN qt_item_p=0 THEN null  ELSE qt_item_p END ,
		'N',
		cd_intervalo_p,
		nr_seq_classif_w,
		cd_recomendacao_w,
		ds_horarios_w,
		ds_observacao_w,
		dt_suspensao_progr_w,
		nr_prescricao_original_w,
		nr_seq_anterior_w,
		hr_prim_horario_w,
		ie_acm_w,
		ie_se_necessario_w,
		cd_kit_w);

		
	if (ie_seleciona_kit_rec_w = 'N') then
		open C01;
		loop
		fetch C01 into	
			cd_kit_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			CALL Inserir_kit_recomendacao(nm_usuario_p, nr_prescricao_p, nr_sequencia_w, cd_recomendacao_w, cd_kit_w);
		end loop;
		close C01;
	elsif (ie_copia_kit_rec_w = 'S') then
		select max(dt_suspensao)
		into STRICT dt_suspensao_w
		from prescr_recomendacao 
		where nr_prescricao = nr_prescricao_original_w;

		if (coalesce(dt_suspensao_w,clock_timestamp() + interval '1 days') = clock_timestamp() + interval '1 days') then
		    nr_prescricao_estender_w := nr_prescricao_original_w;
		else
		    nr_prescricao_estender_w := nr_prescricao_orig_p;
		end if;
		
		select	coalesce(coalesce(Max(a.cd_kit),Max(z.cd_kit)),0) cd_kit_rec
		into STRICT 	cd_kit_w
		from	kit_prescr_recomendacao z,
				prescr_recomendacao a
		where	a.nr_prescricao		= nr_prescricao_estender_w
		and	a.nr_sequencia		= nr_seq_anterior_w
		and	z.nr_prescricao		= a.nr_prescricao
		and	((a.nr_sequencia = z.nr_seq_recomendacao) or (z.cd_recomendacao = a.cd_recomendacao))
		and	coalesce(a.ie_suspenso,'N')	= 'N';

		if (cd_kit_w > 0) then
			update 	prescr_recomendacao
			set 	cd_kit = cd_kit_w
			where 	nr_prescricao = nr_prescricao_p
			and 	nr_sequencia = nr_sequencia_w;
		end if;
	end if;	
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_copia_recomendacao (nr_prescricao_orig_p bigint, nr_prescricao_p bigint, nr_seq_regra_p bigint, dt_prescricao_p timestamp, cd_intervalo_p text, cd_item_p text, qt_item_p bigint, ie_modificar_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, ie_estende_inc_p text, ie_copia_agora_p text) FROM PUBLIC;
