-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_cartao_integracao_pck.truncar_cartao (nr_cartao_credito_p pls_contrato_pagador_fin.nr_cartao_credito%type) RETURNS varchar AS $body$
BEGIN
        if coalesce(nr_cartao_credito_p::text, '') = '' then
            return null;
        end if;
        return substr(nr_cartao_credito_p, 1, 6) || lpad('*', length(nr_cartao_credito_p) - 10, '*') || substr(nr_cartao_credito_p,
                                                                                                               -4);
    end;

    /*
    procedimento para buscar parametros para tokenizar o carcao
    %param cd_estabelecimento_p Cogigo do estabelecimento
    %param parametros_p retona cursor dos parametros com campos merchant_id, merchant_key e ambiente
    */


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_cartao_integracao_pck.truncar_cartao (nr_cartao_credito_p pls_contrato_pagador_fin.nr_cartao_credito%type) FROM PUBLIC;
