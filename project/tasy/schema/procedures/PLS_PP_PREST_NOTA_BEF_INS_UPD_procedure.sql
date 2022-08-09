-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pp_prest_nota_bef_ins_upd ( nr_seq_prestador_p pls_pp_prest_nota.nr_seq_lote%type, nr_seq_lote_p pls_pp_prest_nota.nr_seq_prestador%type, is_update_p text, vl_vinculado_old_p pls_pp_prest_nota.vl_vinculado%type, vl_vinculado_p pls_pp_prest_nota.vl_vinculado%type, vl_titulo_pagar_p bigint, nr_seq_nota_fiscal_p pls_pp_prest_nota.nr_seq_nota_fiscal%type, nr_seq_pp_prest_nota_p pls_pp_prest_nota.nr_sequencia%type) AS $body$
DECLARE


vl_total_vinculado_w	double precision;


BEGIN

select	coalesce(sum(vl_vinculado),0)
into STRICT	vl_total_vinculado_w
from	pls_pp_prest_nota
where	nr_seq_lote = nr_seq_lote_p
and		nr_seq_prestador = nr_seq_prestador_p;

if (is_update_p = 'S') then
	vl_total_vinculado_w := vl_total_vinculado_w - vl_vinculado_old_p;
end if;

if ((vl_total_vinculado_w + vl_vinculado_p) > vl_titulo_pagar_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1087780);
end if;

CALL pls_pp_nota_fiscal_pck.pls_consistir_prest_nota_pgto(nr_seq_prestador_p, nr_seq_nota_fiscal_p, nr_seq_pp_prest_nota_p, vl_vinculado_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_prest_nota_bef_ins_upd ( nr_seq_prestador_p pls_pp_prest_nota.nr_seq_lote%type, nr_seq_lote_p pls_pp_prest_nota.nr_seq_prestador%type, is_update_p text, vl_vinculado_old_p pls_pp_prest_nota.vl_vinculado%type, vl_vinculado_p pls_pp_prest_nota.vl_vinculado%type, vl_titulo_pagar_p bigint, nr_seq_nota_fiscal_p pls_pp_prest_nota.nr_seq_nota_fiscal%type, nr_seq_pp_prest_nota_p pls_pp_prest_nota.nr_sequencia%type) FROM PUBLIC;
