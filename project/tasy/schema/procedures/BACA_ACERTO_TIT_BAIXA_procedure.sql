-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_tit_baixa () AS $body$
DECLARE


nr_titulo_w		bigint;
nr_sequencia_w		bigint;
vl_descontos_w		double precision;
vl_outras_deducoes_w	double precision;
vl_juros_w		double precision;
vl_multa_w		double precision;
vl_outros_acrescimos_w	double precision;
vl_pago_w		double precision;
vl_devolucao_w		double precision;
vl_ir_w			double precision;
vl_moeda_orig_w		double precision;
vl_imposto_munic_w	double precision;
vl_inss_w		double precision;

c01 CURSOR FOR
SELECT	nr_titulo,
	nr_sequencia,
	coalesce(vl_descontos, 0),
	coalesce(vl_outras_deducoes, 0),
	coalesce(vl_juros, 0),
	coalesce(vl_multa, 0),
	coalesce(vl_outros_acrescimos, 0),
	coalesce(vl_pago, 0),
	coalesce(vl_devolucao, 0),
	coalesce(vl_ir, 0),
	coalesce(vl_moeda_orig, 0),
	coalesce(vl_imposto_munic, 0),
	coalesce(vl_inss, 0)
from	titulo_pagar_baixa
where	dt_atualizacao		> to_date('01/07/2006', 'dd/mm/yyyy')
and	vl_baixa		< 0
and	vl_pago			> 0
and	coalesce(nr_lote_contabil,0)	= 0;


BEGIN

open c01;
loop
fetch c01 into
	nr_titulo_w,
	nr_sequencia_w,
	vl_descontos_w,
	vl_outras_deducoes_w,
	vl_juros_w,
	vl_multa_w,
	vl_outros_acrescimos_w,
	vl_pago_w,
	vl_devolucao_w,
	vl_ir_w,
	vl_moeda_orig_w,
	vl_imposto_munic_w,
	vl_inss_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (vl_descontos_w > 0) then
		vl_descontos_w		:= -1 * vl_descontos_w;
	end if;

	if (vl_outras_deducoes_w > 0) then
		vl_outras_deducoes_w	:= -1 * vl_outras_deducoes_w;
	end if;

	if (vl_juros_w > 0) then
		vl_juros_w		:= -1 * vl_juros_w;
	end if;

	if (vl_multa_w > 0) then
		vl_multa_w		:= -1 * vl_multa_w;
	end if;

	if (vl_outros_acrescimos_w > 0) then
		vl_outros_acrescimos_w	:= -1 * vl_outros_acrescimos_w;
	end if;

	if (vl_pago_w > 0) then
		vl_pago_w		:= -1 * vl_pago_w;
	end if;

	if (vl_devolucao_w > 0) then
		vl_devolucao_w		:= -1 * vl_devolucao_w;
	end if;

	if (vl_ir_w > 0) then
		vl_ir_w			:= -1 * vl_ir_w;
	end if;

	if (vl_moeda_orig_w > 0) then
		vl_moeda_orig_w		:= -1 * vl_moeda_orig_w;
	end if;

	if (vl_imposto_munic_w > 0) then
		vl_imposto_munic_w	:= -1 * vl_imposto_munic_w;
	end if;

	if (vl_inss_w > 0) then
		vl_inss_w		:= -1 * vl_inss_w;
	end if;

	update	titulo_pagar_baixa
	set	vl_descontos		= vl_descontos_w,
		vl_outras_deducoes	= vl_outras_deducoes_w,
		vl_juros		= vl_juros_w,
		vl_multa		= vl_multa_w,
		vl_outros_acrescimos	= vl_outros_acrescimos_w,
		vl_pago			= vl_pago_w,
		vl_devolucao		= vl_devolucao_w,
		vl_ir			= vl_ir_w,
		vl_moeda_orig		= vl_moeda_orig_w,
		vl_imposto_munic	= vl_imposto_munic_w,
		vl_inss			= vl_inss_w
	where	nr_titulo		= nr_titulo_w
	and	nr_sequencia		= nr_sequencia_w;

	commit;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_tit_baixa () FROM PUBLIC;

