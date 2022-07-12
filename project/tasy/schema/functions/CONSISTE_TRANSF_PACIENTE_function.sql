-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_transf_paciente (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255) := null;
dt_alta_w		timestamp;


BEGIN 
 
select	dt_alta 
into STRICT	dt_alta_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(306616, null); -- Este atendimento já teve alta informada 
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_transf_paciente (nr_atendimento_p bigint) FROM PUBLIC;
