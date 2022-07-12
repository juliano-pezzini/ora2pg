-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_saldo_imp_livro (nr_seq_livro_p bigint, ie_opcao_p text default '') RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p
I - valor ICMS devolucao
*/
vl_retorno_w		double precision;
vl_trib_saida_w		double precision;
vl_trib_entrada_w	double precision;
vl_icms_devolucao_w	fis_livro_fiscal.vl_icms_devolucao%type;


BEGIN

select	coalesce(sum(obter_valores_nf_icms(a.nr_sequencia, 'VT')),0) vl_tributo
into STRICT 	vl_trib_entrada_w
from  	natureza_operacao o,
	nota_fiscal a,
  	fis_lote f,
	fis_lote_nota_fiscal n,
	fis_lote_livro_fiscal l
where	n.nr_seq_nota_fiscal	= a.nr_sequencia
and	a.cd_natureza_operacao	= o.cd_natureza_operacao
and	f.nr_sequencia  	= n.nr_seq_lote
and	f.ie_tipo_lote  	= 'E'
and	n.nr_seq_lote		= l.nr_seq_lote
and	l.nr_seq_livro_fiscal 	= nr_seq_livro_p;


select	coalesce(sum(obter_valores_nf_icms(a.nr_sequencia, 'VT')),0) vl_tributo
into STRICT 	vl_trib_saida_w
from  	natureza_operacao o,
	nota_fiscal a,
  	fis_lote f,
	fis_lote_nota_fiscal n,
	fis_lote_livro_fiscal l
where	n.nr_seq_nota_fiscal	= a.nr_sequencia
and	a.cd_natureza_operacao	= o.cd_natureza_operacao
and	f.nr_sequencia  	= n.nr_seq_lote
and	f.ie_tipo_lote  	= 'S'
and	n.nr_seq_lote		= l.nr_seq_lote
and	l.nr_seq_livro_fiscal 	= nr_seq_livro_p;

select	vl_icms_devolucao
into STRICT	vl_icms_devolucao_w
from	fis_livro_fiscal
where	nr_Sequencia = nr_seq_livro_p;

vl_retorno_w := coalesce(vl_trib_saida_w,0) - coalesce(vl_trib_entrada_w,0);

if (coalesce(ie_opcao_p,'X') = 'I') then
	vl_retorno_w := coalesce(vl_retorno_w,0) - coalesce(vl_icms_devolucao_w,0);
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_saldo_imp_livro (nr_seq_livro_p bigint, ie_opcao_p text default '') FROM PUBLIC;
