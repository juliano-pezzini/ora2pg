-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_situacao_pendencia ( nr_sequencia_p pls_pendencias_prestador.nr_sequencia%type ) RETURNS varchar AS $body$
DECLARE

    dt_prazo_w pls_pendencias_prestador.dt_prazo%type;
    ds_retorno_w varchar(1);

BEGIN
    select
        max(a.dt_prazo)
    into STRICT dt_prazo_w
    from 
        pls_pendencias_prestador   a 
    where 
        a.nr_sequencia = nr_sequencia_p;

    if ( dt_prazo_w > clock_timestamp() + interval '2 days' ) then
        ds_retorno_w := 1;
    elsif (dt_prazo_w < clock_timestamp()) then
        ds_retorno_w := 2;
    elsif (dt_prazo_w < clock_timestamp() + interval '2 days') then
        ds_retorno_w := 3;
    end if;

    return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_situacao_pendencia ( nr_sequencia_p pls_pendencias_prestador.nr_sequencia%type ) FROM PUBLIC;
