-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_get_val_ref_indicador ( nr_sequencia_p pls_indicador_cred_prest.nr_sequencia%type, nr_valor_p pls_indicador_cred_prest.vl_maximo%type ) RETURNS varchar AS $body$
DECLARE

ds_referencia_w pls_indicador_cred_prest.nr_sequencia%type;
ds_resultado_w varchar(10);


BEGIN
    select max(nr_sequencia)
    into STRICT ds_referencia_w
    from pls_indicador_cred_prest
    where nr_sequencia = nr_sequencia_p 
        and vl_minimo <= nr_valor_p 
        and vl_maximo >= nr_valor_p;

    if (coalesce(ds_referencia_w::text, '') = '') then
        ds_resultado_w := obter_expressao_idioma(928855);
    else
        ds_resultado_w := obter_expressao_idioma(928857);
    end if;
    return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_get_val_ref_indicador ( nr_sequencia_p pls_indicador_cred_prest.nr_sequencia%type, nr_valor_p pls_indicador_cred_prest.vl_maximo%type ) FROM PUBLIC;

