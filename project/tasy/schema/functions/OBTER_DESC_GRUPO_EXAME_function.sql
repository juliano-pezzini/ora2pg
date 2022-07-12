-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_grupo_exame ( NR_SEQ_GRUPO_EXAME_P bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(100);


BEGIN

        select  a.ds_grupo_exame ds
        into STRICT    ds_retorno_w
        from    med_grupo_exame a
        where   nr_sequencia = NR_SEQ_GRUPO_EXAME_P;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_grupo_exame ( NR_SEQ_GRUPO_EXAME_P bigint) FROM PUBLIC;
