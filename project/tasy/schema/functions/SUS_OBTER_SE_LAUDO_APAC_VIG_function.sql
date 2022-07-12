-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_laudo_apac_vig ( nr_seq_interno_p sus_laudo_paciente.nr_seq_interno%type) RETURNS varchar AS $body$
DECLARE

					 
ds_retorno_w		varchar(15) := 'S';


BEGIN 
 
begin 
select	coalesce(max('S'),'N') 
into STRICT	ds_retorno_w 
from	sus_laudo_paciente 
where	nr_seq_interno = nr_seq_interno_p 
and	trunc(clock_timestamp()) between trunc(dt_inicio_val_apac) and trunc(dt_fim_val_apac);
exception 
when others then 
	ds_retorno_w := 'S';
end;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_laudo_apac_vig ( nr_seq_interno_p sus_laudo_paciente.nr_seq_interno%type) FROM PUBLIC;

