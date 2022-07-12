-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_itens_limite_pck.add_valor_regra ( indice_regra_p bigint, vl_item_p bigint) AS $body$
BEGIN

if (coalesce(vl_item_p,0) <> 0) then
	current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[indice_regra_p].vl_item_gerado_mes	:= current_setting('pls_mens_itens_limite_pck.regra_limite_item_w')::vetor[indice_regra_p].vl_item_gerado_mes + vl_item_p;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_itens_limite_pck.add_valor_regra ( indice_regra_p bigint, vl_item_p bigint) FROM PUBLIC;
