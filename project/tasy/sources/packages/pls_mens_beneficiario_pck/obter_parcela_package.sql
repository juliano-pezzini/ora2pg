-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_beneficiario_pck.obter_parcela ( dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type) RETURNS bigint AS $body$
DECLARE

nr_parcela_w	bigint;

BEGIN
select	trunc(months_between(dt_referencia_p,trunc(dt_contratacao_p,'month'))) + 1
into STRICT	nr_parcela_w
;

return coalesce(nr_parcela_w,0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_beneficiario_pck.obter_parcela ( dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type) FROM PUBLIC;