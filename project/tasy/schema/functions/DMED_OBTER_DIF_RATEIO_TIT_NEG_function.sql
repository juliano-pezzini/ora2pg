-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dmed_obter_dif_rateio_tit_neg ( vl_negociado_p bigint, vl_desconto_p bigint, vl_juros_p bigint, vl_multa_p bigint, nr_seq_negociacao_p bigint) RETURNS bigint AS $body$
DECLARE


vl_diferenca_rateio_w	double precision;
vl_total_negociado_w	double precision;
vl_total_titulos_w	double precision;


BEGIN
vl_total_negociado_w := (vl_negociado_p - vl_desconto_p) + vl_multa_p + vl_juros_p;

select 	sum(round(((vl_total_negociado_w / vl_negociado_p) * (vl_parcela)), 2))
into STRICT 	vl_total_titulos_w
from 	negociacao_cr_boleto
where 	nr_seq_negociacao	= nr_seq_negociacao_p;

vl_diferenca_rateio_w	:= vl_total_negociado_w - vl_total_titulos_w;

return vl_diferenca_rateio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dmed_obter_dif_rateio_tit_neg ( vl_negociado_p bigint, vl_desconto_p bigint, vl_juros_p bigint, vl_multa_p bigint, nr_seq_negociacao_p bigint) FROM PUBLIC;
