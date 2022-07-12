-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medicos_adicionais ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

 
nm_medico_w	varchar(255);
medicos_w	varchar(4000)	:= '';

C01 CURSOR FOR 
	SELECT	 
		SUBSTR(OBTER_NOME_PF(p1.CD_PESSOA_FISICA),0,255) nm_medico 
	from 	prescr_medica b, 
		prescr_procedimento c, 
		pessoa_fisica p1, 
        pessoa_fisica p2, 
		atend_categoria_convenio a, 
		convenio a1, 
		setor_atendimento s, 
        result_laboratorio z, 
        exame_lab_resultado j, 
        exame_lab_result_item i, 
        exame_laboratorio d 
    where  b.nr_prescricao 	= c.nr_prescricao 
    and   i.nr_seq_resultado	= j.nr_seq_resultado 
	and   j.nr_prescricao     = b.nr_prescricao 
    and	z.nr_seq_prescricao   = i.nr_seq_prescr 
    and	i.nr_seq_prescr     = c.nr_sequencia 
    and 	c.nr_seq_exame     = d.nr_seq_exame 
    and	p1.cd_pessoa_fisica 	= coalesce(c.cd_medico_solicitante, b.cd_medico) 
    and	p2.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
    and	z.nr_seq_prescricao 	= i.nr_seq_prescr 
    and	z.nr_prescricao 	= b.nr_prescricao 
    and	a.nr_atendimento	= b.nr_atendimento 
    and	a1.cd_convenio 		= a.cd_convenio 
    and	b.cd_Setor_atendimento 	= s.cd_setor_atendimento 
    and	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')	 
    and   z.nr_prescricao     = nr_prescricao_p 
    and   z.nr_sequencia     = nr_sequencia_p 
    and	obter_ds_status_result_exame(c.nr_prescricao, c.nr_sequencia, nm_usuario_p, cd_estabelecimento_p) <> obter_desc_expressao(347424) 
	
union
 
    SELECT	 
		SUBSTR(OBTER_NOME_PF(p1.CD_PESSOA_FISICA),0,255) nm_medico 
	from  	prescr_medica b, 
		prescr_procedimento c,	 
        pessoa_fisica p1, 
        pessoa_fisica p2, 
        atend_categoria_convenio a, 
        convenio a1, 
        setor_atendimento s, 
        result_laboratorio z, 
        exame_lab_resultado j, 
        exame_lab_result_item i,  
        exame_laboratorio d,  
        PRESCR_MEDICA_PROF_ADIC x  
    where 	b.nr_prescricao 	= c.nr_prescricao 
	and   i.nr_seq_resultado	= j.nr_seq_resultado 
    and	j.nr_prescricao     = b.nr_prescricao 
    and	z.nr_seq_prescricao   = i.nr_seq_prescr 
    and	i.nr_seq_prescr     = c.nr_sequencia 
    and 	c.nr_seq_exame     = d.nr_seq_exame 
    and	p2.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
    and	z.nr_seq_prescricao 	= i.nr_seq_prescr 
    and	z.nr_prescricao 	= b.nr_prescricao 
    and	a.nr_atendimento	= b.nr_atendimento 
    and	a1.cd_convenio 		= a.cd_convenio 
    and	b.cd_Setor_atendimento 	= s.cd_setor_atendimento 
    and	p1.cd_pessoa_fisica   = x.cd_medico_solicitante 
    and	x.nr_prescricao     = b.nr_prescricao 
    and	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')	 
	and   z.nr_prescricao     = nr_prescricao_p 
	and   z.nr_sequencia     = nr_sequencia_p 
	and	obter_ds_status_result_exame(c.nr_prescricao, c.nr_sequencia, nm_usuario_p, cd_estabelecimento_p) <> obter_desc_expressao(347424) 
	
union
 
	select	 
		SUBSTR(OBTER_NOME_PF(p1.CD_PESSOA_FISICA),0,255) nm_medico 
	from  	prescr_medica b, 
		prescr_procedimento c,	 
        pessoa_fisica p1, 
        pessoa_fisica p2, 
        atend_categoria_convenio a, 
        convenio a1, 
        setor_atendimento s, 
        result_laboratorio z, 
        exame_lab_resultado j, 
        exame_lab_result_item i,  
        exame_laboratorio d,  
        PRESCR_MEDICA_PROF_ADIC x  
    where 	b.nr_prescricao 	= c.nr_prescricao 
	and    i.nr_seq_resultado	= j.nr_seq_resultado 
	and	j.nr_prescricao     = b.nr_prescricao 
	and	z.nr_seq_prescricao   = i.nr_seq_prescr 
	and	i.nr_seq_prescr     = c.nr_sequencia 
	and 	c.nr_seq_exame     = d.nr_seq_exame 
	and	p2.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and	z.nr_seq_prescricao 	= i.nr_seq_prescr 
	and	z.nr_prescricao 	= b.nr_prescricao 
	and	a.nr_atendimento	= b.nr_atendimento 
	and	a1.cd_convenio 		= a.cd_convenio 
	and	b.cd_Setor_atendimento 	= s.cd_setor_atendimento 
	and	p1.cd_pessoa_fisica   = x.cd_medico_solicitante 
	and	x.nr_prescricao     = b.nr_prescricao 
	and	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')	 
	and    z.nr_prescricao     = nr_prescricao_p 
	and    z.nr_sequencia     = nr_sequencia_p 
	and	obter_ds_status_result_exame(c.nr_prescricao, c.nr_sequencia, nm_usuario_p, cd_estabelecimento_p) <> obter_desc_expressao(347424) 
	
union
 
	select	 
		SUBSTR(OBTER_NOME_PF(p1.CD_PESSOA_FISICA),0,255) nm_medico 
	from  	prescr_medica b, 
		prescr_procedimento c,	 
        pessoa_fisica p1, 
        pessoa_fisica p2, 
        atend_categoria_convenio a, 
        convenio a1, 
        setor_atendimento s, 
        result_laboratorio z, 
        exame_lab_resultado j, 
        exame_lab_result_item i, 
        exame_laboratorio d, 
        PRESCR_proced_prof_ADIC x 
    where 	b.nr_prescricao 	= c.nr_prescricao 
	and    i.nr_seq_resultado	= j.nr_seq_resultado 
	and	j.nr_prescricao     = b.nr_prescricao 
	and	z.nr_seq_prescricao   = i.nr_seq_prescr 
	and	i.nr_seq_prescr     = c.nr_sequencia 
	and 	c.nr_seq_exame     = d.nr_seq_exame 
	and	p1.cd_pessoa_fisica   = x.cd_profissional 
	and	p2.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and	z.nr_seq_prescricao 	= i.nr_seq_prescr 
    and	z.nr_prescricao 	= b.nr_prescricao 
    and	a.nr_atendimento	= b.nr_atendimento 
	and	a1.cd_convenio 		= a.cd_convenio 
	and	b.cd_Setor_atendimento 	= s.cd_setor_atendimento 
	and	x.nr_prescricao     = b.nr_prescricao 
	and 	x.nr_seq_procedimento  = c.nr_sequencia 
	and	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')	 
	and    z.nr_prescricao     = nr_prescricao_p 
	and    z.nr_sequencia     = nr_sequencia_p 
	and	obter_ds_status_result_exame(c.nr_prescricao, c.nr_sequencia, nm_usuario_p, cd_estabelecimento_p) <> obter_desc_expressao(347424);

 

BEGIN 
open C01;
loop 
fetch C01 into	 
	nm_medico_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (length(medicos_w) > 1)	then 
		medicos_w :=	medicos_w || ' , ';
	end if;
		medicos_w :=	medicos_w || nm_medico_w;
	end;
end loop;
close C01;
 
return	medicos_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medicos_adicionais ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

