-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_atend_pa_nova (nr_atendimento_p bigint, dt_alta_p timestamp, dt_medicacao_p timestamp, dt_lib_medico_p timestamp, dt_atend_medico_p timestamp, dt_fim_consulta_p timestamp, dt_inicio_atendimento_p timestamp, dt_fim_triagem_p timestamp, dt_chamada_paciente_p timestamp, dt_liberacao_enfermagem_p timestamp, dt_reavaliacao_medica_p timestamp, nr_atend_alta_p bigint, cd_estabelecimento_p bigint, dt_fim_reavaliacao_p timestamp default null, dt_inicio_observacao_p timestamp default null, dt_fim_observacao_p timestamp default null, dt_chamada_reavaliacao_p timestamp default null, dt_inicio_reavaliacao_p timestamp default null, ie_chamado_p text default null, dt_chamada_enfermagem_p timestamp default null, dt_chamada_medic_p timestamp default null, dt_chegada_medic_p timestamp default null) RETURNS varchar AS $body$
DECLARE


ds_prescricao_w					varchar(255);
ds_retorno_w					varchar(20);
ie_internado_w					varchar(1);
ie_medic_adm_sem_baixa_w		varchar(1);
ie_medic_adm_w					varchar(1) := 'N';
ie_mostra_medic_estagio_pa_w	varchar(1);
ie_prescr_proced_atend_w		varchar(1);
nr_atend_alta_w					bigint;
cd_estabelecimento_w			bigint;
dt_medicacao_w					timestamp;
dt_lib_medico_w					timestamp;
dt_atend_medico_w				timestamp;
dt_fim_consulta_w				timestamp;
dt_inicio_atendimento_w			timestamp;
dt_fim_triagem_w				timestamp;
dt_alta_w						timestamp;
dt_chamada_paciente_w			timestamp;
dt_liberacao_enfermagem_w		timestamp;
dt_reavalicao_enfermagem_w		timestamp;
dt_chamada_reavaliacao_w		timestamp;
dt_inicio_reavaliacao_w			timestamp;
ie_consistir_status_pl_pa_w		varchar(1);
ie_consistir_status_pa_pa_w		varchar(1);
ie_prescr_sae_mentor_w			varchar(1);
ie_prescricao_atend_medico_w	varchar(1);
ie_prescricao_liberada_w		boolean;


BEGIN
/*
select	dt_alta,
	dt_medicacao,
	dt_lib_medico,
	dt_atend_medico,
	dt_fim_consulta,
	dt_inicio_atendimento,
	dt_fim_triagem,
	dt_chamada_paciente,
	substr(Obter_qt_prescr_Atend(nr_atendimento),1,255),
	substr(Obter_se_pa_internado(nr_atendimento),1,1),
	dt_liberacao_enfermagem,
	dt_reavaliacao_medica,
	nr_atend_alta,
	Obter_se_atend_administrado_pa(nr_atendimento),
	cd_estabelecimento,
	obter_se_prescr_proc_atend_pa(cd_estabelecimento,nr_atendimento)
into	dt_alta_w,
	dt_medicacao_w,
	dt_lib_medico_w,
	dt_atend_medico_w,
	dt_fim_consulta_w,
	dt_inicio_atendimento_w,
	dt_fim_triagem_w,
	dt_chamada_paciente_w,
	ds_prescricao_w,
	ie_internado_w,
	dt_liberacao_enfermagem_w,
	dt_reavalicao_enfermagem_w,
	nr_atend_alta_w,
	ie_medic_adm_w,
	cd_estabelecimento_w,
	ie_prescr_proced_atend_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_p;

*/
cd_estabelecimento_w		:= cd_estabelecimento_p;
nr_atend_alta_w				:= nr_atend_alta_p;
dt_reavalicao_enfermagem_w	:= dt_reavaliacao_medica_p;
dt_liberacao_enfermagem_w	:= dt_liberacao_enfermagem_p;
dt_alta_w					:= dt_alta_p;
dt_medicacao_w				:= dt_medicacao_p;
dt_lib_medico_w				:= dt_lib_medico_p;
dt_atend_medico_w			:= dt_atend_medico_p;
dt_fim_consulta_w			:= dt_fim_consulta_p;
dt_inicio_atendimento_w		:= dt_inicio_atendimento_p;
dt_fim_triagem_w			:= dt_fim_triagem_p;
dt_chamada_paciente_w		:= dt_chamada_paciente_p;
dt_chamada_reavaliacao_w	:= dt_chamada_reavaliacao_p;
dt_inicio_reavaliacao_w		:= dt_inicio_reavaliacao_p;

select 	coalesce(max(ie_mostra_medic_estagio_pa), 'N'),
		coalesce(max(ie_consistir_status_pl_pa), 'N'),
		coalesce(max(ie_prescricao_atend_medico), 'N')
into STRICT	ie_mostra_medic_estagio_pa_w,
		ie_consistir_status_pl_pa_w,
		ie_prescricao_atend_medico_w
from	parametro_medico
where 	cd_estabelecimento = cd_estabelecimento_w;

if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
	return 'AL'; --Alta
end if;

if (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') and (dt_chamada_medic_p IS NOT NULL AND dt_chamada_medic_p::text <> '') and (coalesce(dt_chegada_medic_p::text, '') = '') then
	return 'CM'; --Chamada medicamento / procedimento
end if;

if (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') and (dt_chamada_medic_p IS NOT NULL AND dt_chamada_medic_p::text <> '') and (dt_chegada_medic_p IS NOT NULL AND dt_chegada_medic_p::text <> '') then
	return 'BM'; --Chegada medicamento / procedimento
end if;


if (ie_chamado_p  = 'X') then
	return 'PN'; --Pac nao compareceu
end if;

if (dt_reavalicao_enfermagem_w IS NOT NULL AND dt_reavalicao_enfermagem_w::text <> '') and (coalesce(dt_inicio_reavaliacao_w::text, '') = '')then
	return 'RM'; --Reavalicao medico
end if;

if (dt_inicio_observacao_p IS NOT NULL AND dt_inicio_observacao_p::text <> '') and (coalesce(dt_fim_observacao_p::text, '') = '') then
	Return 'OB'; --Em observacao
end if;

if (nr_atend_alta_w IS NOT NULL AND nr_atend_alta_w::text <> '') then
	return 'IN';--Internado
end if;
ie_internado_w := substr(Obter_se_pa_internado(nr_atendimento_p), 1, 1);

if (ie_internado_w = 'S')  then
	return 'IN'; --Internado
end if;

if (dt_chamada_reavaliacao_w IS NOT NULL AND dt_chamada_reavaliacao_w::text <> '') and (coalesce(dt_inicio_reavaliacao_w::text, '') = '') then
	return 'CR'; --Chamada paciente reavaliacao
end if;

if (dt_inicio_reavaliacao_w IS NOT NULL AND dt_inicio_reavaliacao_w::text <> '') and (coalesce(dt_fim_reavaliacao_p::text, '') = '')then
	return 'ER'; --Em reavaliacao
end if;

ds_prescricao_w := substr(Obter_qt_prescr_Atend(nr_atendimento_p), 1, 255);

if (ie_mostra_medic_estagio_pa_w = 'S') then
	ie_medic_adm_w := Obter_se_atend_administrado_pa(nr_Atendimento_p);
end if;

ie_prescr_proced_atend_w := obter_se_prescr_proc_atend_pa(cd_estabelecimento_p, nr_Atendimento_p);

ie_consistir_status_pa_pa_w := obter_se_prescr_atendida_pa(nr_atendimento_p,cd_estabelecimento_p);

if ((dt_medicacao_w IS NOT NULL AND dt_medicacao_w::text <> '') or (ie_prescr_proced_atend_w = 'S')) and (ie_consistir_status_pa_pa_w = 'S') then

	return 'PA'; --Prescricao atendida
end if;


ie_prescricao_liberada_w := (((position('Med' in ds_prescricao_w) > 0) or (position('Enf' in ds_prescricao_w) > 0) or
							((position('Die' in ds_prescricao_w) > 0) and (coalesce(dt_medicacao_w::text, '') = '')) or
							((ie_consistir_status_pl_pa_w  = 'S') and ((ds_prescricao_w IS NOT NULL AND ds_prescricao_w::text <> '') or ds_prescricao_w <> '') and (coalesce(dt_medicacao_w::text, '') = ''))) and
							((ie_medic_adm_w = 'N') or (ie_mostra_medic_estagio_pa_w = 'N')));

select	coalesce(max('S'),'N')
into STRICT	ie_prescr_sae_mentor_w
from	prescr_medica a
where	a.nr_atendimento = nr_Atendimento_p
and		(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
and (exists (SELECT 1
	 		 from   prescr_material b, pe_prescr_proc c
			 where  a.nr_prescricao = b.nr_prescricao
			 and	   b.nr_seq_pe_proc = c.nr_sequencia
			 and	   (c.nr_seq_prescr IS NOT NULL AND c.nr_seq_prescr::text <> ''))
	or 	(nr_seq_pend_pac_acao IS NOT NULL AND nr_seq_pend_pac_acao::text <> ''));
	
if (ie_prescricao_atend_medico_w = 'S') and (ie_prescricao_liberada_w) and (ie_prescr_sae_mentor_w = 'S') and (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') and (coalesce(dt_atend_medico_w::text, '') = '') then
	return 'FP'; --Fim triagem/ Prescricao liberada
end if;
	
if (ie_prescricao_liberada_w) then
	return 'PL'; --Prescricao liberada
end if;

if (dt_lib_medico_w IS NOT NULL AND dt_lib_medico_w::text <> '') and ((coalesce(dt_liberacao_enfermagem_w::text, '') = '') or (dt_liberacao_enfermagem_w < dt_lib_medico_w)) then
	return 'LM'; --Liberado medico
end if;

if (dt_liberacao_enfermagem_w IS NOT NULL AND dt_liberacao_enfermagem_w::text <> '') then
	return 'LE'; --Liberado enfermagem
end if;

if (ie_medic_adm_w = 'S') and (ie_mostra_medic_estagio_pa_w = 'S') then
	return 'MA'; --Medicamento administrado
end if;

if (dt_fim_consulta_w IS NOT NULL AND dt_fim_consulta_w::text <> '') then
	return 'FC'; --Fim consulta
end if;

if (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') then
	return 'IC'; --Inicio consulta
end if;

if (dt_chamada_paciente_w IS NOT NULL AND dt_chamada_paciente_w::text <> '') then
	return 'CP'; --Chamada paciente
end if;

if (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
	return 'FT'; --Fim triagem
end if;

if (dt_inicio_atendimento_w IS NOT NULL AND dt_inicio_atendimento_w::text <> '') then
	return 'TR'; --Triagem
end if;

if (dt_chamada_enfermagem_p IS NOT NULL AND dt_chamada_enfermagem_p::text <> '') then
	return 'CE'; --Pac chamado enf
end if;

return 'NA'; --Nao atendido
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_atend_pa_nova (nr_atendimento_p bigint, dt_alta_p timestamp, dt_medicacao_p timestamp, dt_lib_medico_p timestamp, dt_atend_medico_p timestamp, dt_fim_consulta_p timestamp, dt_inicio_atendimento_p timestamp, dt_fim_triagem_p timestamp, dt_chamada_paciente_p timestamp, dt_liberacao_enfermagem_p timestamp, dt_reavaliacao_medica_p timestamp, nr_atend_alta_p bigint, cd_estabelecimento_p bigint, dt_fim_reavaliacao_p timestamp default null, dt_inicio_observacao_p timestamp default null, dt_fim_observacao_p timestamp default null, dt_chamada_reavaliacao_p timestamp default null, dt_inicio_reavaliacao_p timestamp default null, ie_chamado_p text default null, dt_chamada_enfermagem_p timestamp default null, dt_chamada_medic_p timestamp default null, dt_chegada_medic_p timestamp default null) FROM PUBLIC;
