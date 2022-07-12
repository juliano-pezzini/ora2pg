-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estipulante_atend (cd_pessoa_fisica_p text, ie_dado_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255);

 

BEGIN 
 
 
/*if	((ie_dado_p  = 'CD') and (nr_atendimento_p > 0)) then 
 
	select 	substr(obter_nome_pf_pj(0, cd_cgc_estipulante),1,200) 
	into	ds_retorno_w 
	from  	PLS_CONTRATO a, 
		PLS_SEGURADO b, 
		atendimento_paciente c 
	where 	b.nr_seq_contrato = a.nr_sequencia 
	and  	b.cd_pessoa_fisica = c.cd_pessoa_fisica 
	and  	c.nr_atendimento = nr_atendimento_p 
	and	rownum = 1; 
end if; */
 
 
if	(ie_dado_p  = 'CD' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
 
	select 	substr(obter_nome_pf_pj(0, cd_cgc_estipulante),1,200) 
	into STRICT	ds_retorno_w 
	from  	PLS_CONTRATO a, 
		PLS_SEGURADO b 
	where 	b.nr_seq_contrato = a.nr_sequencia 
	and  	b.cd_pessoa_fisica = cd_pessoa_fisica_p  LIMIT 1;
end if;
 
 
/*if	((ie_dado_p  = 'DT') and (nr_atendimento_p > 0)) then 
 
	select 	to_char(b.dt_contratacao,'dd/mm/yy') 
	into	ds_retorno_w 
	from  	PLS_SEGURADO b, 
		atendimento_paciente c 
	where 	b.cd_pessoa_fisica = c.cd_pessoa_fisica 
	and  	c.nr_atendimento = nr_atendimento_p 
	and	rownum = 1; 
end if;*/
 
 
if	(ie_dado_p  = 'DT' AND cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
 
	select 	to_char(b.dt_contratacao,'dd/mm/yy') 
	into STRICT	ds_retorno_w 
	from  	PLS_SEGURADO b 
	where 	b.cd_pessoa_fisica = cd_pessoa_fisica_p  LIMIT 1;
end if;
	 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estipulante_atend (cd_pessoa_fisica_p text, ie_dado_p text) FROM PUBLIC;
