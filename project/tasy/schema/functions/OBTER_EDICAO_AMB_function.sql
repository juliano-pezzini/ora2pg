-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_edicao_amb (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE


cd_edicao_amb_w		bigint;

C01 CURSOR FOR
	SELECT	cd_edicao_amb
	from	convenio_amb
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_convenio		= cd_convenio_p
	and	cd_categoria		= cd_categoria_p
	and 	coalesce(ie_situacao,'A')	= 'A'
	and	dt_inicio_vigencia	=
		(SELECT	max(dt_inicio_vigencia)
		from	convenio_amb a
		where	a.cd_estabelecimento	= cd_estabelecimento_p
		and	a.cd_convenio		= cd_convenio_p
		and	a.cd_categoria		= cd_categoria_p
	   	and 	coalesce(ie_situacao,'A')	= 'A'
		and	a.dt_inicio_vigencia 	<= dt_vigencia_p)
	order by ie_prioridade desc;

BEGIN

/*Edilson em 02/05/07 OS 56179 Coloquei cursor pois trazia mais de um registro */

cd_edicao_amb_w	:= null;

OPEN C01;
LOOP
FETCH C01 into
	cd_edicao_amb_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	cd_edicao_amb_w	:= cd_edicao_amb_w;
	end;
END LOOP;
CLOSE C01;

return	cd_edicao_amb_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_edicao_amb (cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp) FROM PUBLIC;

