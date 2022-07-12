-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cargas_ger_import_finalizada (nr_sequencia_p ger_tipo_carga_arq.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(2);
nm_tabela_w     ger_tipo_carga_arq.nm_tabela%type;


BEGIN

ds_retorno_w    := 'N';-- @TODO
select  nm_tabela
into STRICT    nm_tabela_w
from    ger_tipo_carga_arq
where   nr_sequencia = nr_sequencia_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cargas_ger_import_finalizada (nr_sequencia_p ger_tipo_carga_arq.nr_sequencia%type) FROM PUBLIC;

