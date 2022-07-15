-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_processo_adep_js ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_etapa_p bigint, ie_tipo_p text, nm_usuario_p text, ie_acm_sn_p INOUT text, ie_setor_ge_p INOUT text, nr_processo_p INOUT bigint) AS $body$
DECLARE

 
dt_horario_w		timestamp;
nr_sequencia_w		bigint;
ie_acm_sn_w		varchar(1);
ie_setor_gedipa_w	varchar(1);


BEGIN 
 
ie_setor_gedipa_w := obter_se_setor_processo_gedipa(obter_unidade_atendimento(nr_atendimento_p,'IAA','CS'));
 
if (ie_tipo_p = 'M') then 
 
	select 	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_sequencia_w 
	from 	adep_processo 
	where 	nr_atendimento = nr_atendimento_p 
	and 	nr_prescricao = nr_prescricao_p 
	and 	nr_seq_material = nr_seq_item_p 
	and 	nr_etapa = nr_etapa_p;
 
	select 	coalesce(max('S'),'N') 
	into STRICT	ie_acm_sn_w 
	from 	prescr_material 
	where 	nr_prescricao = nr_prescricao_p 
	and 	nr_sequencia = nr_seq_item_p 
	and 	obter_se_acm_sn(ie_acm, ie_se_necessario) = 'S';
else 
 
	select 	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_sequencia_w	 
	from 	adep_processo 
	where 	nr_atendimento = nr_atendimento_p 
	and 	nr_prescricao = nr_prescricao_p 
	and 	nr_seq_procedimento = nr_seq_item_p 
	and 	nr_etapa = nr_etapa_p;
	 
	select 	coalesce(max('S'),'N') 
	into STRICT	ie_acm_sn_w 	 
	from 	prescr_procedimento 
	where 	nr_prescricao = nr_prescricao_p 
	and 	nr_sequencia = nr_seq_item_p 
	and 	obter_se_acm_sn(ie_acm, ie_se_necessario) = 'S';
 
end if;
 
ie_acm_sn_p 	:= ie_acm_sn_w;
ie_setor_ge_p 	:= ie_setor_gedipa_w;
nr_processo_p	:= nr_sequencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_processo_adep_js ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_etapa_p bigint, ie_tipo_p text, nm_usuario_p text, ie_acm_sn_p INOUT text, ie_setor_ge_p INOUT text, nr_processo_p INOUT bigint) FROM PUBLIC;

