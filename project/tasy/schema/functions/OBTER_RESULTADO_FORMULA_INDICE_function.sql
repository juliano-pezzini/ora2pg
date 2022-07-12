-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_resultado_formula_indice (ds_indice_p text, dt_vencimento_parcela_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_seq_reajuste_w bigint;
valor_indice_w bigint;


BEGIN

  select max(nr_sequencia) into STRICT nr_seq_reajuste_w from tipo_indice_reajuste_fin where ds_indice = ds_indice_p;
  valor_indice_w := obter_taxa_ajuste(nr_seq_reajuste_w, dt_vencimento_parcela_p);

  return valor_indice_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_resultado_formula_indice (ds_indice_p text, dt_vencimento_parcela_p timestamp) FROM PUBLIC;
