-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_param_exec (cd_relatorio_p bigint, cd_parametro_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_w		bigint;


BEGIN

select coalesce(max(nr_sequencia),0)
into STRICT nr_seq_w
from relatorio_param_exec
where cd_relatorio = cd_relatorio_p
  and cd_parametro = cd_parametro_p;

return nr_seq_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_param_exec (cd_relatorio_p bigint, cd_parametro_p text) FROM PUBLIC;

