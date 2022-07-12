-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ar_gerar_resultado_pck.obter_total_mensalidade ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, vl_total_mensalidade_p pls_ar_mensalidade.vl_item%type) RETURNS bigint AS $body$
DECLARE

vl_total_mensalidade_w	pls_ar_mensalidade.vl_item%type;

BEGIN
vl_total_mensalidade_w	:= vl_total_mensalidade_p;

if (vl_total_mensalidade_w = 0) then
	select	sum(vl_item)
	into STRICT	vl_total_mensalidade_w
	from	pls_ar_mensalidade
	where	nr_seq_lote	= nr_seq_lote_p;
end if;

return vl_total_mensalidade_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ar_gerar_resultado_pck.obter_total_mensalidade ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, vl_total_mensalidade_p pls_ar_mensalidade.vl_item%type) FROM PUBLIC;