-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_usuario_validade (nr_atendimento_p bigint, cd_convenio_p bigint, nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_usuario_convenio_w	varchar(30);
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;


BEGIN 
 
select	dt_periodo_inicial, 
	dt_periodo_final 
into STRICT	dt_periodo_inicial_w, 
	dt_periodo_final_w 
from	conta_paciente 
where	nr_interno_conta = nr_interno_conta_p;
 
select	MAX(cd_usuario_convenio) 
into STRICT	cd_usuario_convenio_w 
from	atend_categoria_convenio 
where	nr_atendimento		= nr_atendimento_p 
and	cd_convenio		= cd_convenio_p 
and	dt_inicio_vigencia	= (	SELECT	MAX(dt_inicio_vigencia) 
			 		from	atend_categoria_convenio 
			 		where	nr_atendimento	= nr_atendimento_p 
					and	cd_convenio	= cd_convenio_p 
					and	coalesce(dt_inicio_vigencia, clock_timestamp()) between coalesce(dt_periodo_inicial_w, clock_timestamp()) and coalesce(dt_periodo_final_w, clock_timestamp()));
 
return	cd_usuario_convenio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_usuario_validade (nr_atendimento_p bigint, cd_convenio_p bigint, nr_interno_conta_p bigint) FROM PUBLIC;
