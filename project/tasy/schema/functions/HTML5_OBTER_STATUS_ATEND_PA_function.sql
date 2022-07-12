-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION html5_obter_status_atend_pa (nr_atendimento_p bigint, dt_alta_p timestamp, dt_medicacao_p timestamp, dt_lib_medico_p timestamp, dt_atend_medico_p timestamp, dt_fim_consulta_p timestamp, dt_inicio_atendimento_p timestamp, dt_fim_triagem_p timestamp, dt_chamada_paciente_p timestamp, dt_liberacao_enfermagem_p timestamp, dt_reavaliacao_medica_p timestamp, nr_atend_alta_p bigint, cd_estabelecimento_p bigint, dt_fim_reavaliacao_p timestamp default null, dt_inicio_observacao_p timestamp default null, dt_fim_observacao_p timestamp default null, dt_chamada_reavaliacao_p timestamp default null, dt_inicio_reavaliacao_p timestamp default null) RETURNS varchar AS $body$
DECLARE


ds_prescricao_w					varchar(255);
ds_retorno_w					varchar(20);
ie_internado_w					varchar(1);
ie_medic_adm_sem_baixa_w		varchar(1);
ie_medic_adm_w					varchar(1) := 'N';
IE_MOSTRA_MEDIC_ESTAGIO_PA_w	varchar(1);
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


BEGIN

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

if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
	return 'AL'; --Alta
end if;

if (dt_inicio_observacao_p IS NOT NULL AND dt_inicio_observacao_p::text <> '') and (coalesce(dt_fim_observacao_p::text, '') = '') then
	Return 'OB'; --Em observação
end if;

if (nr_atend_alta_w IS NOT NULL AND nr_atend_alta_w::text <> '') then
	return 'IN';--Internado
end if;



if (dt_chamada_reavaliacao_w IS NOT NULL AND dt_chamada_reavaliacao_w::text <> '') and (coalesce(dt_inicio_reavaliacao_w::text, '') = '') then
	return 'CR'; --Chamada paciente reavaliação
end if;

if (dt_reavalicao_enfermagem_w IS NOT NULL AND dt_reavalicao_enfermagem_w::text <> '') and (coalesce(dt_fim_reavaliacao_p::text, '') = '')then
	return 'RM'; --Reavalição médico
end if;


if (dt_lib_medico_w IS NOT NULL AND dt_lib_medico_w::text <> '') then
	return 'LM'; --Liberado médico
end if;

if (dt_liberacao_enfermagem_w IS NOT NULL AND dt_liberacao_enfermagem_w::text <> '') then
	return 'LE'; --Liberado enfermagem
end if;

if (dt_fim_consulta_w IS NOT NULL AND dt_fim_consulta_w::text <> '') then
	return 'FC'; --Fim consulta
end if;

if (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') then
	return 'IC'; --Início consulta
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

return 'NA'; --Não atendido
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION html5_obter_status_atend_pa (nr_atendimento_p bigint, dt_alta_p timestamp, dt_medicacao_p timestamp, dt_lib_medico_p timestamp, dt_atend_medico_p timestamp, dt_fim_consulta_p timestamp, dt_inicio_atendimento_p timestamp, dt_fim_triagem_p timestamp, dt_chamada_paciente_p timestamp, dt_liberacao_enfermagem_p timestamp, dt_reavaliacao_medica_p timestamp, nr_atend_alta_p bigint, cd_estabelecimento_p bigint, dt_fim_reavaliacao_p timestamp default null, dt_inicio_observacao_p timestamp default null, dt_fim_observacao_p timestamp default null, dt_chamada_reavaliacao_p timestamp default null, dt_inicio_reavaliacao_p timestamp default null) FROM PUBLIC;
