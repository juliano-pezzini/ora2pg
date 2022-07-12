-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pessoa_laudo (nr_seq_grupo_laudo_p bigint) RETURNS varchar AS $body$
DECLARE

			 
ds_retorno_w varchar(255);

BEGIN
 
select (max(substr(obter_pessoa_atendimento(l.nr_atendimento,'n'),1,255))) 
into STRICT	ds_retorno_w 
from  	laudo_questao_item i, 
	laudo_grupo_questao g, 
	laudo_paciente l 
where 	i.nr_seq_laudo_grupo = g.nr_sequencia 
and  	l.nr_sequencia = g.nr_seq_laudo 
and	i.nr_seq_laudo_grupo = nr_seq_grupo_laudo_p;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pessoa_laudo (nr_seq_grupo_laudo_p bigint) FROM PUBLIC;

