-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado_nbs ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_nbs_w	varchar(255);


BEGIN

select	substr(obter_result_nbs(qt_pontuacao),1,255)
into STRICT	ds_nbs_w
from	escala_nbs
where	nr_sequencia = (SELECT max(nr_sequencia) from escala_nbs where nr_atendimento = nr_atendimento_p);

return	ds_nbs_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado_nbs ( nr_atendimento_p bigint) FROM PUBLIC;
