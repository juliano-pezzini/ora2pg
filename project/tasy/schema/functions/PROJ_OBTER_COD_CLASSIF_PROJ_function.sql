-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_cod_classif_proj (nr_seq_proj_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w bigint;


BEGIN

    select coalesce(max(a.nr_seq_classif),0)
    into STRICT ds_retorno_w
    from proj_projeto a
    where a.nr_sequencia = nr_seq_proj_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_cod_classif_proj (nr_seq_proj_p bigint) FROM PUBLIC;

