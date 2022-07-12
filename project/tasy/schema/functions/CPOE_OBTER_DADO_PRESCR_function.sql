-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_dado_prescr (nr_sequencia_p bigint, ie_tipo_item_p text, ie_opcao_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, nr_atendimento_p atendimento_paciente.nr_atendimento%type default null) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
F - DT_LIBERACAO_FARMACIA
UF - Usuário liberação farmácia
LE - DT_LIBERACAO_ENFERMAGEM
UE - Usuário liberação enfermagem
AF - NM_USUARIO_ANALISE_FARM
IMG - Se prescrição possui imagem
HO - NR_SEQ_ATENDIMENTO com histórico
PI - Prescrição intervenção
IL - Intervenção não liberada
DR - DT_REVISAO
SA - CD_SETOR_ATENDIMENTO
NA - número prescrição da agenda
DIAF- DT_INICIO_ANALISE_FARM
DIAE - data início análise enfermagem
AE - usuário análise enfermagem
URE - usuário revisão enfermagem
*/
				
ds_retorno_w				varchar(2000);
nr_prescricao_w				prescr_medica.nr_prescricao%type;
dt_liberacao_farmacia_w		prescr_medica.dt_liberacao_farmacia%type;
dt_liberacao_enfermagem_w	prescr_medica.dt_liberacao%type;
nm_usuario_analise_farm_w	prescr_medica.nm_usuario_analise_farm%type;
cd_farmac_lib_w				prescr_medica.cd_farmac_lib%type;
nm_usuario_lib_enf_w		prescr_medica.nm_usuario_lib_enf%type;
dt_revisao_w				prescr_medica.dt_revisao%type;
cd_setor_atendimento_w		prescr_medica.cd_setor_atendimento%type;
nr_seq_agenda_w				prescr_medica.nr_seq_agenda%type;
dt_inicio_analise_farm_w	prescr_medica.dt_inicio_analise_farm%type;
nm_usuario_revisao_w		prescr_medica.nm_usuario_revisao%type;
dt_analise_enf_w			prescr_medica_compl.DT_INICIO_ANALISE_ENF%type;
nm_usuario_analise_enf_w	prescr_medica_compl.NM_USUARIO_ANALISE_ENF%type;


BEGIN

nr_prescricao_w	:= obter_prescr_item_cpoe(nr_sequencia_p,ie_tipo_item_p, nr_atendimento_p, cd_pessoa_fisica_p);

if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then

	if (ie_opcao_p	not in ('DIAE','AE')) then

		select	max(dt_liberacao_farmacia),
			MAX(nm_usuario_analise_farm),
			MAX(cd_farmac_lib),
			max(dt_liberacao),
			max(nm_usuario_lib_enf),
			max(dt_revisao),
			max(cd_setor_atendimento),
			max(nr_seq_agenda),
			max(dt_inicio_analise_farm),
			max(nm_usuario_revisao)
		into STRICT	dt_liberacao_farmacia_w,
			nm_usuario_analise_farm_w,
			cd_farmac_lib_w,
			dt_liberacao_enfermagem_w,
			nm_usuario_lib_enf_w,
			dt_revisao_w,
			cd_setor_atendimento_w,
			nr_seq_agenda_w,
			dt_inicio_analise_farm_w,
			nm_usuario_revisao_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_w;
		
		if (ie_opcao_p	= 'F') then
			ds_retorno_w	:= to_char(dt_liberacao_farmacia_w,'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p	= 'AF') then	
			ds_retorno_w	:= nm_usuario_analise_farm_w;
		elsif (ie_opcao_p	= 'UF') then
			ds_retorno_w	:= obter_nome_pf(cd_farmac_lib_w);
		elsif (ie_opcao_p	= 'IMG') then
			select	CASE WHEN count(nr_prescricao)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ds_retorno_w
			from	prescr_medica_imagem
			where	nr_prescricao	= nr_prescricao_w;
		elsif (ie_opcao_p	= 'HO') then
			ds_retorno_w	:= obter_hist_alter_pac_atend(nr_prescricao_w);
		elsif (ie_opcao_p	= 'PI') then
			ds_retorno_w	:= obter_prescr_interv_farmacia(nr_prescricao_w);	
		elsif (ie_opcao_p	= 'IL') then
			ds_retorno_w	:= obter_prescr_interv_farm_lib(nr_prescricao_w);
		elsif (ie_opcao_p	= 'LE') then
			ds_retorno_w	:= to_char(dt_liberacao_enfermagem_w,'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p	= 'UE') then
			ds_retorno_w	:= obter_pf_usuario(nm_usuario_lib_enf_w,'N');
		elsif (ie_opcao_p	= 'DR') then
			ds_retorno_w	:= to_char(dt_revisao_w,'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p	= 'SA') then
			ds_retorno_w	:= cd_setor_atendimento_w;
		elsif (ie_opcao_p	= 'NA') then
			ds_retorno_w	:= nr_seq_agenda_w;
		elsif (ie_opcao_p	= 'DIAF') then
			ds_retorno_w	:= to_char(dt_inicio_analise_farm_w,'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p	= 'URE') then
			ds_retorno_w	:= obter_pf_usuario(nm_usuario_revisao_w,'N');
		end if;	
	elsif (ie_opcao_p	in ('DIAE','AE')) then
		select	max(dt_inicio_analise_enf),
				max(nm_usuario_analise_enf)
		into STRICT	dt_analise_enf_w,
				nm_usuario_analise_enf_w
		from	prescr_medica_compl
		where	nr_prescricao = nr_prescricao_w;
		
		if (ie_opcao_p	= 'DIAE') then
			ds_retorno_w	:= to_char(dt_analise_enf_w,'dd/mm/yyyy hh24:mi:ss');
		elsif (ie_opcao_p	= 'AE') then
			ds_retorno_w	:= nm_usuario_analise_enf_w;
		end if;	
		
	end if;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dado_prescr (nr_sequencia_p bigint, ie_tipo_item_p text, ie_opcao_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, nr_atendimento_p atendimento_paciente.nr_atendimento%type default null) FROM PUBLIC;
