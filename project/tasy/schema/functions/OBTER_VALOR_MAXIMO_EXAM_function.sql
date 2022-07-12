-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_maximo_exam (nr_seq_exame_p bigint) RETURNS bigint AS $body$
DECLARE


qt_valor_min_w		double precision;				
				

BEGIN

select	coalesce(max(qt_maxima),0)
into STRICT	qt_valor_min_w
from 	exame_lab_padrao
where 	nr_seq_exame = nr_seq_exame_p;

return	qt_valor_min_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_maximo_exam (nr_seq_exame_p bigint) FROM PUBLIC;

