-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_ordem_serv_etapa ( nr_seq_etapa_gpi_p bigint) RETURNS varchar AS $body$
DECLARE


c01 CURSOR FOR
SELECT	nr_sequencia
from	man_ordem_servico
where	nr_seq_etapa_gpi = nr_seq_etapa_gpi;

ds_retorno_w	varchar(255)	:= '';

vet01	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w	:=  vet01.nr_sequencia;
	else
		ds_retorno_w	:= substr(ds_retorno_w || ', '  || vet01.nr_sequencia, 1, 255);
	end if;

end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_ordem_serv_etapa ( nr_seq_etapa_gpi_p bigint) FROM PUBLIC;
