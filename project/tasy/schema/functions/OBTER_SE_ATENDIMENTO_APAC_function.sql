-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atendimento_apac (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_apac_w			varchar(01) := 'N';
cd_convenio_w			bigint;
ie_tipo_convenio_w		bigint;
ie_tipo_atendimento_w		bigint;


BEGIN 
 
ie_apac_w	:= 'N';
 
select	max(obter_convenio_atendimento(nr_atendimento_p)) 
into STRICT	cd_convenio_w
;
 
select	max(ie_tipo_convenio) 
into STRICT	ie_tipo_convenio_w 
from	convenio 
where	cd_convenio		= cd_convenio_w;
 
select	max(ie_tipo_atendimento) 
into STRICT	ie_tipo_atendimento_w 
from	atendimento_paciente 
where 	nr_atendimento		= nr_atendimento_p;
 
if (ie_tipo_convenio_w = 3) and (ie_tipo_atendimento_w not in (1,3)) then 
	ie_apac_w	:= 'S';
end if;	
 
return	ie_apac_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atendimento_apac (nr_atendimento_p bigint) FROM PUBLIC;

