-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_pck.get_data_obito ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type ) RETURNS timestamp AS $body$
DECLARE

    ds_retorno_w pessoa_fisica.dt_obito%type;

BEGIN
    select  max(p.dt_obito)
    into STRICT    ds_retorno_w
    from    pessoa_fisica p
    where   p.cd_pessoa_fisica = cd_pessoa_fisica_p;

    return ds_retorno_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_pck.get_data_obito ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type ) FROM PUBLIC;