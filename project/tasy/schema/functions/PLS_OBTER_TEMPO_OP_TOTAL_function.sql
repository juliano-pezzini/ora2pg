-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tempo_op_total ( nr_seq_operador_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_retorno		double precision;
qt_atend_w		numeric(20);
qt_tempo_w		numeric(20);


BEGIN

select	count(nr_sequencia) valor
into STRICT	qt_atend_w
from	pls_atendimento
where	nr_seq_operador = nr_seq_operador_p
and	Trunc(dt_inicio) between trunc(dt_inicio_p) and fim_dia(dt_fim_p);

select	sum(b.qt_tempo_atendimento)
into STRICT	qt_tempo_w
from	pls_atendimento_operador b
where	nr_seq_operador = nr_seq_operador_p
and	Trunc(b.dt_inicio_atendimento) between trunc(dt_inicio_p) and fim_dia(dt_fim_p);

nr_retorno := ((qt_tempo_w /qt_atend_w) / 60);

return	nr_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tempo_op_total ( nr_seq_operador_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

