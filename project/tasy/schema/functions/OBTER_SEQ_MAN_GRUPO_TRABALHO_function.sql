-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_man_grupo_trabalho (nr_seq_ordem_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w  bigint;


BEGIN
  if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then
    begin
      select nr_grupo_trabalho
      into STRICT ds_retorno_w
      from man_ordem_servico
      where nr_sequencia = nr_seq_ordem_p;
    end;
  end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_man_grupo_trabalho (nr_seq_ordem_p bigint) FROM PUBLIC;
