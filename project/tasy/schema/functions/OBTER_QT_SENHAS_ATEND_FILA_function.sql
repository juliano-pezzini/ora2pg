-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_senhas_atend_fila (nr_seq_fila_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_senha_fila_w	bigint;


BEGIN

select	count(nr_seq_pac_senha_fila)
into STRICT	qt_senha_fila_w
from	atendimentos_senha
where	(dt_inicio_atendimento IS NOT NULL AND dt_inicio_atendimento::text <> '')
and	(dt_fim_atendimento IS NOT NULL AND dt_fim_atendimento::text <> '')
and	nr_seq_fila_espera = nr_seq_fila_p
and 	trunc(dt_inicio_atendimento) between trunc(dt_inicio_p) and trunc(dt_fim_p);


return	qt_senha_fila_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_senhas_atend_fila (nr_seq_fila_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

