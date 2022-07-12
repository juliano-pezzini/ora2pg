-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resp_depto ( nr_seq_depto_p bigint, dt_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE

cd_pessoa_w	varchar(10);

c01 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	depto_medico_resp
	where	nr_seq_depto	= nr_seq_depto_p
	and	dt_inicio_vigencia <= dt_vigencia_p
	order by dt_inicio_vigencia;


BEGIN

open c01;
	loop
	fetch c01 into
		cd_pessoa_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
close c01;

return	cd_pessoa_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resp_depto ( nr_seq_depto_p bigint, dt_vigencia_p timestamp) FROM PUBLIC;
