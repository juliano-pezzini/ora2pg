-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_qt_distribuicao (cd_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	double precision;


BEGIN
	if (cd_sequencia_p IS NOT NULL AND cd_sequencia_p::text <> '') then
		begin
		select	sum(a.qt_distribuicao)
		into STRICT	ds_retorno_w
		from	criterio_distr_orc_dest a
		where	a.cd_sequencia_criterio	= cd_sequencia_p;
		end;
	end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_qt_distribuicao (cd_sequencia_p bigint) FROM PUBLIC;
