-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Consistir o valor e alguns dados da nota vinculada manualmente
CREATE OR REPLACE PROCEDURE pls_pp_nota_fiscal_pck.pls_consistir_prest_nota_pgto ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, nr_seq_pp_prest_nota_p pls_pp_prest_nota.nr_sequencia%type, vl_vinculado_p pls_pp_prest_nota.vl_vinculado%type) AS $body$
DECLARE


cd_cgc_prest_w			pessoa_juridica.cd_cgc%type;
cd_cgc_nota_w			pessoa_juridica.cd_cgc%type;
cd_pessoa_fisica_prest_w	pessoa_fisica.cd_pessoa_fisica%type;
cd_pessoa_fisica_nota_w		pessoa_fisica.cd_pessoa_fisica%type;
vl_total_nota_w			nota_fiscal.vl_total_nota%type := 0;
vl_vinculado_w			pls_pp_prest_nota.vl_vinculado%type := 0;


BEGIN

select	max(vl_total_nota)
into STRICT	vl_total_nota_w
from	nota_fiscal
where	nr_sequencia	= nr_seq_nota_fiscal_p;

select	coalesce(sum(vl_vinculado),0)
into STRICT	vl_vinculado_w
from	pls_pp_prest_nota
where	nr_seq_nota_fiscal	= nr_seq_nota_fiscal_p
and	nr_sequencia		!= nr_seq_pp_prest_nota_p;

if	(vl_total_nota_w < (vl_vinculado_p + vl_vinculado_w)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(114035,'VL_VINC=' || (vl_vinculado_p + vl_vinculado_w) || ';' || 'VL_NOTA=' || vl_total_nota_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_nota_fiscal_pck.pls_consistir_prest_nota_pgto ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type, nr_seq_pp_prest_nota_p pls_pp_prest_nota.nr_sequencia%type, vl_vinculado_p pls_pp_prest_nota.vl_vinculado%type) FROM PUBLIC;
