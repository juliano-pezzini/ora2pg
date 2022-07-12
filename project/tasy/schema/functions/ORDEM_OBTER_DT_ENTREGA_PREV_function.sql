-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ordem_obter_dt_entrega_prev (nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

select	max(dt_fim)
into STRICT 	ds_retorno_w
from 	escala_diaria b,
		desenv_acordo_os a
where 	b.nr_seq_escala = 21
and 	b.dt_inicio = a.dt_entrega_prev
and 	a.nr_seq_ordem_servico = nr_seq_ordem_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ordem_obter_dt_entrega_prev (nr_seq_ordem_p bigint) FROM PUBLIC;

