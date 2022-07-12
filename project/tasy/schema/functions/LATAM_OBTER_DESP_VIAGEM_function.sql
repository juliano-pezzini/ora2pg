-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION latam_obter_desp_viagem (nr_seq_viagem_p bigint) RETURNS bigint AS $body$
DECLARE

ds_retorno_w		double precision;
nr_seq_parametro_w	bigint;
nr_pessoas_w		bigint;
qt_dias_viagem_w	bigint;
vl_passagem_w		double precision;


BEGIN

select 	nr_seq_parametro,
		nr_pessoas,
		qt_dias_viagem
into STRICT	nr_seq_parametro_w,
		nr_pessoas_w,
		qt_dias_viagem_w
from	latam_viagem
where	nr_sequencia = nr_seq_viagem_p;


select (vl_hospedagem + vl_transporte + vl_alimentacao + vl_lavanderia),
		(vl_passagem)
into STRICT	ds_retorno_w,
		vl_passagem_w
from	latam_parametros
where	nr_sequencia = nr_seq_parametro_w;


ds_retorno_w := (ds_retorno_w * nr_pessoas_w * qt_dias_viagem_w) + (vl_passagem_w * 2 * nr_pessoas_w);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION latam_obter_desp_viagem (nr_seq_viagem_p bigint) FROM PUBLIC;
