-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_dt_retirada_laudo (nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retirada_w		timestamp;


BEGIN

select TO_DATE(to_char(MAX(dt_retirada),'dd/mm/yyyy hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
into STRICT 	dt_retirada_w
from 	laudo_paciente_loc
where	nr_sequencia = nr_sequencia_p;

return	dt_retirada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_dt_retirada_laudo (nr_sequencia_p bigint) FROM PUBLIC;
