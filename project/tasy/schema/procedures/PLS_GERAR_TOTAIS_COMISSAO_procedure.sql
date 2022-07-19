-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_totais_comissao ( nr_seq_comissao_p bigint) AS $body$
DECLARE


vl_lancamento_w		pls_repasse_lanc.vl_lanc_aplicado%type;
vl_adiantamento_w	titulo_pagar_adiant.vl_adiantamento%type;
vl_titulo_w		pls_comissao_titulo.vl_titulo%type;
vl_folha_pag_w		pls_comissao_titulo.vl_folha_pag%type;


BEGIN

select	sum(vl_lanc_aplicado)
into STRICT	vl_lancamento_w
from	pls_repasse_lanc
where	nr_seq_comissao = nr_seq_comissao_p;

select	sum(a.vl_adiantamento)
into STRICT	vl_adiantamento_w
from	titulo_pagar_adiant	a,
	pls_comissao_titulo	b
where	a.nr_titulo = b.nr_titulo
and	b.nr_seq_comissao = nr_seq_comissao_p;

select	sum(vl_titulo),
	sum(vl_folha_pag)
into STRICT	vl_titulo_w,
	vl_folha_pag_w
from	pls_comissao_titulo
where	nr_seq_comissao = nr_seq_comissao_p;

update	pls_comissao
set	vl_lancamento 	= coalesce(vl_lancamento_w,0),
	vl_adiantamento = coalesce(vl_adiantamento_w,0),
	vl_titulo	= coalesce(vl_titulo_w,0),
	vl_folha_pag	= coalesce(vl_folha_pag_w,0)
where	nr_sequencia = nr_seq_comissao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_totais_comissao ( nr_seq_comissao_p bigint) FROM PUBLIC;

