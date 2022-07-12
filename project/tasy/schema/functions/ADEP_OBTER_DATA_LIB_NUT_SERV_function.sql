-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_data_lib_nut_serv ( nr_seq_horario_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_liberacao_w		timestamp;

BEGIN

select	max(dt_liberacao)
into STRICT	dt_liberacao_w
from	nut_atend_serv_dia
where	nr_seq_horario = nr_seq_horario_p;

return dt_liberacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_data_lib_nut_serv ( nr_seq_horario_p bigint) FROM PUBLIC;

