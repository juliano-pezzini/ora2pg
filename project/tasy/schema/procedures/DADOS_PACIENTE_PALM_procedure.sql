-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dados_paciente_palm ( nr_cirurgia_p bigint, nr_atendimento_p bigint, nm_paciente_p INOUT text, nr_idade_p INOUT bigint, ds_procedimento_p INOUT text, ds_sala_p INOUT text, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, ds_medico_cirurgiao_p INOUT text, IE_NECESSITA_DEMARCACAO_P INOUT text, dt_nascimento_p INOUT text) AS $body$
DECLARE

	nr_seq_interno_sala_cir_w       bigint;
	nr_atendimento_w                numeric(20);
	nm_paciente_w                   varchar(255);
	nr_idade_w                      bigint;
	ds_procedimento_w               varchar(255);
	ds_medico_cirurgiao_w           varchar(255);
	ie_necessita_demarcacao_w		varchar(255);
	nr_seq_interno_sala_cir_ww		agenda_paciente.nr_seq_interno_sala_cir%type;
	dt_nascimento_w					pessoa_fisica.dt_nascimento%type;
	
	expressao1_w	varchar(255) := obter_desc_expressao_idioma(327113, null, wheb_usuario_pck.get_nr_seq_idioma);--Sim
	expressao2_w	varchar(255) := obter_desc_expressao_idioma(327114, null, wheb_usuario_pck.get_nr_seq_idioma);--Nao
	expressao3_w	varchar(255) := obter_desc_expressao_idioma(293950, null, wheb_usuario_pck.get_nr_seq_idioma);--Nao se aplica
	
	c01 CURSOR FOR
			SELECT  substr(obter_nome_pf(a.cd_pessoa_fisica),1,255), 
					substr(obter_dados_pf(a.cd_pessoa_fisica,'I'),1,10), 
					SUBSTR(obter_desc_proc_painel(b.nr_sequencia,3),1,255), 
					substr(obter_nome_pf(a.cd_medico_cirurgiao),1,255), 
					CASE WHEN coalesce(b.ie_necessita_demarcacao,c.ie_necessita_demarcacao)='S' THEN expressao1_w WHEN coalesce(b.ie_necessita_demarcacao,c.ie_necessita_demarcacao)='N' THEN expressao2_w WHEN coalesce(b.ie_necessita_demarcacao,c.ie_necessita_demarcacao)='NP' THEN expressao3_w END , 
					nr_seq_interno_sala_cir,
					substr(obter_dados_pf(a.cd_pessoa_fisica,'DN'),1,10)
			FROM cirurgia a, agenda_paciente b
LEFT OUTER JOIN proc_interno c ON (b.nr_seq_proc_interno = c.nr_sequencia)
WHERE a.nr_cirurgia = b.nr_cirurgia  and (((a.nr_cirurgia = nr_cirurgia_p) and (coalesce(nr_atendimento_p,0) = 0)) 
			or       ((a.nr_atendimento = nr_atendimento_p) and (coalesce(nr_cirurgia_p,0) = 0))) and coalesce(a.dt_termino::text, '') = '' order by coalesce(a.dt_inicio_real,a.dt_inicio_prevista);
	
BEGIN
 
	nr_atendimento_w := nr_atendimento_p;
 
	if (coalesce(nr_atendimento_w,0) = 0) then 
			select  max(nr_atendimento) 
			into STRICT    nr_atendimento_w 
			from    cirurgia 
			where   nr_cirurgia = nr_cirurgia_p;
	end if;
 
	open C01;
	loop 
	fetch C01 into 
			nm_paciente_w, 
			nr_idade_w, 
			ds_procedimento_w, 
			ds_medico_cirurgiao_w, 
			ie_necessita_demarcacao_w,
			nr_seq_interno_sala_cir_ww,
			dt_nascimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			nm_paciente_p           	:= nm_paciente_w;
			nr_idade_p              	:= nr_idade_w;
			ds_procedimento_p       	:= ds_procedimento_w;
			ds_medico_cirurgiao_p   	:= ds_medico_cirurgiao_w;
			ie_necessita_demarcacao_p 	:= ie_necessita_demarcacao_w;
			nr_seq_interno_sala_cir_w	:= nr_seq_interno_sala_cir_ww;
			dt_nascimento_p				:= dt_nascimento_w;
			end;
	end loop;
	close C01;
 
	select  max(a.ds_sala) 
	into STRICT    ds_sala_p 
	from    unidade_atendimento c, 
			setor_atendimento b, 
			sala_cirurgia a 
	where   a.nr_seq_interno = c.nr_seq_interno 
	and     a.cd_setor_atendimento = b.cd_setor_atendimento 
	and     a.nr_seq_interno = nr_seq_interno_sala_cir_w;
 
	if (coalesce(nr_atendimento_w,0) > 0) then 
			cd_unidade_basica_p     := Obter_Unidade_Atendimento(nr_atendimento_w,'IA','S');
			cd_unidade_compl_p      := Obter_Unidade_Atendimento(nr_atendimento_w,'IA','UB');
	end if;
 
	end;
	
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dados_paciente_palm ( nr_cirurgia_p bigint, nr_atendimento_p bigint, nm_paciente_p INOUT text, nr_idade_p INOUT bigint, ds_procedimento_p INOUT text, ds_sala_p INOUT text, cd_unidade_basica_p INOUT text, cd_unidade_compl_p INOUT text, ds_medico_cirurgiao_p INOUT text, IE_NECESSITA_DEMARCACAO_P INOUT text, dt_nascimento_p INOUT text) FROM PUBLIC;

