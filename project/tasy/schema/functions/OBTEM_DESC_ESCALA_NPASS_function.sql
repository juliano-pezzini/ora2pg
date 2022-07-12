-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtem_desc_escala_npass (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_pontuacao	smallint;


BEGIN

select max(qt_score) into STRICT qt_pontuacao
from (
	SELECT qt_score
 	  from escala_npass
 	where nr_atendimento = nr_atendimento_p
	order by dt_avaliacao
) alias1 LIMIT 1;

return	qt_pontuacao;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtem_desc_escala_npass (nr_atendimento_p bigint) FROM PUBLIC;
