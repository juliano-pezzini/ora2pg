-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_liberacao_lote (nr_seq_av_p bigint) RETURNS timestamp AS $body$
DECLARE

 
dt_retorno_w	timestamp;			
			 

BEGIN 
 
select max(l.dt_liberacao) 
into STRICT dt_retorno_w 
from med_avaliacao_paciente p, 
 med_avaliacao_lote l 
where p.nr_seq_lote = l.nr_sequencia  
and p.nr_sequencia = nr_seq_av_p;
 
 
return	dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_liberacao_lote (nr_seq_av_p bigint) FROM PUBLIC;

