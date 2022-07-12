-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_qt_carga_curso (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	double precision;


BEGIN

select	sum(coalesce(qt_carga_horaria,0))
into STRICT	qt_retorno_w
from	tre_curso_modulo
where	nr_seq_curso = nr_sequencia_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_qt_carga_curso (nr_sequencia_p bigint) FROM PUBLIC;

