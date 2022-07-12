-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_submotivo_alta_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_submotivo_alta_w bigint;
ds_submotivo_alta_w varchar(180);

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 select max(nr_submotivo_alta) 
 into STRICT nr_submotivo_alta_w 
 from atendimento_paciente 
 where nr_atendimento = nr_atendimento_p;
 
 if (coalesce(nr_submotivo_alta_w,0) > 0) then 
 ds_submotivo_alta_w := substr(obter_desc_submotivo_alta(nr_submotivo_alta_w),1,180);
 end if;
 
end if;
 
return ds_submotivo_alta_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_submotivo_alta_atend (nr_atendimento_p bigint) FROM PUBLIC;

