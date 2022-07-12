-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_questao_opcao_ant ( nr_seq_que_questao_opcao_p bigint, nr_seq_que_questao_p bigint, nr_atendimento_atual_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_seq_ultimo_questionamento_w	que_atendimento_questao.nr_sequencia%type;
ds_retorno_w			varchar(1);


BEGIN 
 
select	max(b.nr_sequencia) 
into STRICT	nr_seq_ultimo_questionamento_w 
from	que_atendimento a, 
	que_atendimento_questao b, 
	atendimento_paciente c, 
	atendimento_Paciente d 
where	b.nr_seq_que_atendimento = a.nr_sequencia 
and	a.nr_atendimento <> nr_atendimento_atual_p 
and	a.nr_atendimento = c.nr_atendimento 
and	d.nr_atendimento = nr_atendimento_atual_p 
and	c.cd_pessoa_fisica = d.cd_pessoa_fisica 
and	b.nr_seq_questao = nr_seq_que_questao_p;
 
select	CASE WHEN coalesce(max(nr_seq_que_questao_opcao)::text, '') = '' THEN 'N'  ELSE 'S' END  
into STRICT	ds_retorno_w 
from	que_atendimento_questao_op 
where	nr_seq_que_atend_questao = nr_seq_ultimo_questionamento_w 
and	nr_seq_que_questao_opcao = nr_seq_que_questao_opcao_p;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_questao_opcao_ant ( nr_seq_que_questao_opcao_p bigint, nr_seq_que_questao_p bigint, nr_atendimento_atual_p bigint) FROM PUBLIC;

