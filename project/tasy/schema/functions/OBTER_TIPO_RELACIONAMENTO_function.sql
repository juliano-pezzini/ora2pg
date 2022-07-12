-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_relacionamento ( nr_seq_tipo_compl_adic_p bigint, nr_seq_parentesco_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
if (nr_seq_tipo_compl_adic_p IS NOT NULL AND nr_seq_tipo_compl_adic_p::text <> '') then
			select  max(ds_tipo_complemento)
      into STRICT    ds_retorno_w
      from    tipo_complemento_adicional
      where   nr_sequencia = nr_seq_tipo_compl_adic_p;
elsif (nr_seq_parentesco_p IS NOT NULL AND nr_seq_parentesco_p::text <> '') then
      select  max(ds_parentesco)
      into STRICT    ds_retorno_w
      from    grau_parentesco
      where   nr_sequencia = nr_seq_parentesco_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_relacionamento ( nr_seq_tipo_compl_adic_p bigint, nr_seq_parentesco_p bigint) FROM PUBLIC;
