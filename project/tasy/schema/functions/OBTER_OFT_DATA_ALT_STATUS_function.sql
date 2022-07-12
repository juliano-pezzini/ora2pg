-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_oft_data_alt_status (nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_alteracao_status_w	timestamp;


BEGIN

select	max(dt_atualizacao)
into STRICT	dt_alteracao_status_w
from	oft_status_consulta_hist
where	nr_seq_consulta = nr_sequencia_p;


return	dt_alteracao_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_oft_data_alt_status (nr_sequencia_p bigint) FROM PUBLIC;

