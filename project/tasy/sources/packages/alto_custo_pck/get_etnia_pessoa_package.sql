-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_pck.get_etnia_pessoa (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w      varchar(255);

BEGIN
    select  coalesce(max(cd_etnia),6)
    into STRICT    ds_retorno_w
    from    pessoa_fisica_aux a,
            origem_etnica b
    where   a.nr_seq_origem_etnica = b.nr_sequencia
    and     a.cd_pessoa_fisica = cd_pessoa_fisica_p;

    return elimina_caracteres_especiais(ds_retorno_w);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_pck.get_etnia_pessoa (cd_pessoa_fisica_p text) FROM PUBLIC;
