-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dmed_obter_desc_tit_nc ( nr_titulo_receber_p bigint, nr_seq_tit_receber_liq_p bigint, dt_vigencia_p timestamp) RETURNS bigint AS $body$
DECLARE

					
vl_desconto_nc_w	double precision;


BEGIN

select  coalesce(sum(vl_total),0)
into STRICT	vl_desconto_nc_w
from (
			SELECT 	coalesce(b.vl_baixa, 0) vl_total
			from  	nota_credito c,
					nota_credito_baixa b
			where  	c.nr_sequencia = b.nr_seq_nota_credito
			and 	c.nr_titulo_receber = nr_titulo_receber_p
			and    	c.nr_seq_baixa_origem = nr_seq_tit_receber_liq_p
			and 	c.ie_situacao = 'L'
			and 	PKG_DATE_UTILS.start_of(b.dt_baixa, 'YEAR', 0) = PKG_DATE_UTILS.start_of(dt_vigencia_p, 'YEAR', 0)
			
union all

			SELECT	coalesce(vl_devolver,0) vl_total
			from	pls_solic_resc_fin_item a,
					pls_solic_rescisao_fin b,
					pls_solic_resc_fin_venc c,
					pls_segurado d
			where  	b.nr_sequencia = a.nr_seq_solic_resc_fin
			and    	b.nr_sequencia = c.nr_seq_solic_resc_fin
			and    	d.nr_sequencia = a.nr_seq_segurado
			and    	(b.dt_devolucao IS NOT NULL AND b.dt_devolucao::text <> '')
			and		a.nr_titulo = nr_titulo_receber_p
			and    exists (	select 1
                      from  nota_credito x
                      where x.nr_sequencia = c.nr_seq_nota_credito
                      and   x.ie_situacao = 'L')) alias8;

return vl_desconto_nc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dmed_obter_desc_tit_nc ( nr_titulo_receber_p bigint, nr_seq_tit_receber_liq_p bigint, dt_vigencia_p timestamp) FROM PUBLIC;
