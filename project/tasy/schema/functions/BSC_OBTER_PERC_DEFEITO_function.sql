-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_perc_defeito ( dt_referencia_p timestamp, nr_seq_gerencia_p bigint default 0) RETURNS bigint AS $body$
DECLARE


pr_retorno_w	double precision;


BEGIN
select	sum(Obter_informacao_os_ger_loc(dt_referencia_p, nr_seq_gerencia_p, 'PREX', null,0))
into STRICT	pr_retorno_w
;

return	pr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_perc_defeito ( dt_referencia_p timestamp, nr_seq_gerencia_p bigint default 0) FROM PUBLIC;

