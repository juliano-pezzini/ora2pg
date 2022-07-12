-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_rec_menor_titulo (nr_titulo_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_Rec_a_menor_w		double precision := 0;
vl_saldo_titulo_w		double precision := 0;


BEGIN

vl_Rec_a_menor_w		:= 0;

select vl_saldo_titulo
into STRICT	vl_saldo_titulo_w
from titulo_receber
where nr_titulo = nr_titulo_p;

if (vl_saldo_titulo_w > 0)  then
	select coalesce(sum(vl_amenor),0)
	into STRICT	vl_rec_a_menor_w
	from	convenio_retorno_item
	where nr_titulo		= nr_titulo_p;
end if;

Return vl_Rec_a_menor_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_rec_menor_titulo (nr_titulo_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

