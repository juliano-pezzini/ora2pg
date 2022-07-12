-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_atend_pa ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
dt_medicacao_w			timestamp;
dt_lib_medico_w			timestamp;
dt_atend_medico_w		timestamp;
dt_fim_consulta_w		timestamp;
dt_inicio_atendimento_w		timestamp;
dt_fim_triagem_w		timestamp;
dt_alta_w			timestamp;
dt_chamada_paciente_w		timestamp;
ds_prescricao_w			varchar(255);
ds_retorno_w			varchar(20);
ie_internado_w			varchar(1);
dt_liberacao_enfermagem_w	timestamp;
dt_reavalicao_enfermagem_w	timestamp;
nr_atend_alta_w			bigint;
ie_medic_adm_sem_baixa_w	varchar(1);
ie_medic_adm_w			varchar(1);
cd_estabelecimento_w		bigint;
IE_MOSTRA_MEDIC_ESTAGIO_PA_w	varchar(1);
ie_prescr_proced_atend_w	varchar(1);


BEGIN 
 
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
into STRICT	dt_alta_w, 
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
 
 
select 	coalesce(max(ie_mostra_medic_estagio_pa),'N') 
into STRICT	ie_mostra_medic_estagio_pa_w 
from	parametro_medico 
where 	cd_estabelecimento = cd_estabelecimento_w;
 
if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
	ds_retorno_w	:= 'AL'; --Alta 
elsif (ie_internado_w = 'S') or (nr_atend_alta_w IS NOT NULL AND nr_atend_alta_w::text <> '') then
	ds_retorno_w	:= 'IN'; --Internado 
elsif	((position(obter_desc_expressao(293040) in ds_prescricao_w) > 0) or (position(obter_desc_expressao(726412) in ds_prescricao_w) > 0)) and
	((ie_medic_adm_w = 'N') or (IE_MOSTRA_MEDIC_ESTAGIO_PA_w = 'N')) then 
	ds_retorno_w	:= 'PL'; --Prescrição liberada 
elsif (dt_lib_medico_w IS NOT NULL AND dt_lib_medico_w::text <> '') then
	ds_retorno_w	:= 'LM'; --Liberado médico 
elsif (dt_liberacao_enfermagem_w IS NOT NULL AND dt_liberacao_enfermagem_w::text <> '') then
	ds_retorno_w	:= 'LE'; --Liberado enfermagem 
elsif (dt_reavalicao_enfermagem_w IS NOT NULL AND dt_reavalicao_enfermagem_w::text <> '') then
	ds_retorno_w	:= 'RM'; --Reavalição médico 
elsif (ie_medic_adm_w	= 'S') and (IE_MOSTRA_MEDIC_ESTAGIO_PA_w = 'S') then
	ds_retorno_w	:= 'MA'; --Medicamento administrado 
elsif (dt_medicacao_w IS NOT NULL AND dt_medicacao_w::text <> '') or (ie_prescr_proced_atend_w = 'S') then
	ds_retorno_w	:= 'PA'; --Prescrição atendida 
elsif (dt_fim_consulta_w IS NOT NULL AND dt_fim_consulta_w::text <> '') then
	ds_retorno_w	:= 'FC'; --Fim consulta 
elsif (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') then
	ds_retorno_w	:= 'IC'; --Início consulta 
elsif (dt_chamada_paciente_w IS NOT NULL AND dt_chamada_paciente_w::text <> '') then
	ds_retorno_w	:= 'CP'; --Chamada paciente 
elsif (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
	ds_retorno_w	:= 'FT'; --Fim triagem 
elsif (dt_inicio_atendimento_w IS NOT NULL AND dt_inicio_atendimento_w::text <> '') then
	ds_retorno_w	:= 'TR'; --Triagem 
else
	ds_retorno_w	:= 'NA'; --Não atendido 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_atend_pa ( nr_atendimento_p bigint) FROM PUBLIC;
