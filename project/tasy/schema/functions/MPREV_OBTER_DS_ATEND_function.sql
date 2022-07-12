-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_ds_atend ( ie_individual_coletivo_p mprev_atendimento.ie_individual_coletivo%type, nr_seq_mprev_atendimento_p mprev_atendimento.nr_sequencia%type, nr_seq_atend_pac_p mprev_atend_paciente.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w         varchar(255);


BEGIN 
 
if (ie_individual_coletivo_p IN ('I','P')) then 
	begin 
    select obter_nome_pf(b.cd_pessoa_fisica) 
    into STRICT  ds_retorno_w 
    from  mprev_atend_paciente a, 
        mprev_participante b 
    where  a.nr_sequencia = nr_seq_atend_pac_p 
    and   b.nr_sequencia = a.nr_seq_participante;
    end;
elsif (ie_individual_coletivo_p = 'C') then 
    begin 
    select substr(mprev_obter_nm_turma(nr_seq_turma),1,80) 
    into STRICT  ds_retorno_w 
    from  mprev_atendimento 
    where  nr_sequencia = nr_seq_mprev_atendimento_p;
    end;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_ds_atend ( ie_individual_coletivo_p mprev_atendimento.ie_individual_coletivo%type, nr_seq_mprev_atendimento_p mprev_atendimento.nr_sequencia%type, nr_seq_atend_pac_p mprev_atend_paciente.nr_sequencia%type) FROM PUBLIC;

