-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_ultimo_anexo ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_anexo_w		timestamp;


BEGIN

select dt_ultimo_anexo
into STRICT	dt_anexo_w
  from (
    SELECT dt_atualizacao_nrec as dt_ultimo_anexo
      from pep_pac_ci_anexo 
      where nr_seq_pac_ci = nr_sequencia_p
      order by dt_atualizacao_nrec desc
  ) alias0 LIMIT 1;

return	dt_anexo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_ultimo_anexo ( nr_sequencia_p bigint) FROM PUBLIC;
