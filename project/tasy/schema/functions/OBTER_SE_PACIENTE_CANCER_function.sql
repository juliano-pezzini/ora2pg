-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_cancer (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(1) := 'N';
qt_registro_w	bigint;


BEGIN 
 
select	count(*) 
into STRICT	qt_registro_w 
from	can_ordem_prod b, 
	atendimento_paciente a 
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
and	a.nr_atendimento	= nr_atendimento_p 
and	b.dt_prevista		>= a.dt_entrada 
and	b.dt_prevista between trunc(clock_timestamp()) and fim_dia(trunc(clock_timestamp()));
 
if (qt_registro_w > 0) then 
	ds_retorno_w	:= 'S';
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_cancer (nr_atendimento_p bigint) FROM PUBLIC;
