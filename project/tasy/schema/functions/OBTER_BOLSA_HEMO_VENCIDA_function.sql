-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_bolsa_hemo_vencida (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE



bolsa_vencida_w		varchar(1);


BEGIN

select  coalesce(max('S'),'N')
into STRICT	bolsa_vencida_w
from    san_producao b,
        san_reserva_prod a
where   b.nr_sequencia = a.nr_seq_producao
and 	san_obter_dt_venc_producao(b.nr_sequencia) <= clock_timestamp()
and		a.nr_sequencia = nr_sequencia_p;

return	bolsa_vencida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_bolsa_hemo_vencida (nr_sequencia_p bigint) FROM PUBLIC;

