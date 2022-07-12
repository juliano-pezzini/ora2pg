-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_usuario_atecaco (nr_atendimento_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


cd_usuario_convenio_w	varchar(30);


BEGIN

select	MAX(cd_usuario_convenio)
into STRICT	cd_usuario_convenio_w
from	atend_categoria_convenio
where	nr_atendimento		= nr_atendimento_p
and	cd_convenio		= cd_convenio_p
and	dt_inicio_vigencia	= (	SELECT	MAX(dt_inicio_vigencia)
			  		from	atend_categoria_convenio
			  		where	nr_atendimento	= nr_atendimento_p
					and	cd_convenio	= cd_convenio_p);

return	cd_usuario_convenio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_usuario_atecaco (nr_atendimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;
