-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_valor_classif_result ( nr_seq_ind_inf_p bigint, nr_seq_formula_p bigint) RETURNS bigint AS $body$
DECLARE


cd_ano_w			smallint;
cd_periodo_w			smallint;
nr_seq_indicador_w			bigint;
nr_seq_classif_ind_w		bigint;
nr_seq_classif_regra_w		bigint;
qt_real_w				double precision;
vl_resultado_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_seq_result,
	a.vl_resultado
from	bsc_regra_form_item a
where	a.nr_seq_formula	= nr_seq_formula_p
and	nr_seq_classif_ind_w <> 0
order by nr_Seq_calc;


BEGIN
/* Indicador de referência*/

select	nr_seq_ind_ref
into STRICT	nr_seq_indicador_w
from	bsc_regra_formula
where	nr_sequencia	= nr_seq_formula_p;

/* Ano/período que está sendo calculado */

select	cd_ano,
	cd_periodo
into STRICT	cd_ano_w,
	cd_periodo_w
from	bsc_ind_inf
where	nr_sequencia 	= nr_seq_ind_inf_p;

/*Quantidade Real no período do Indicador de Referencia que está sendo utilizado para comparar os valores*/

select	coalesce(max(nr_seq_result),0)
into STRICT	nr_seq_classif_ind_w
from	bsc_ind_inf
where	nr_seq_indicador	= nr_seq_indicador_w
and	cd_ano		= cd_ano_w
and	cd_periodo	= cd_periodo_w;

open C01;
loop
fetch C01 into
	nr_seq_classif_regra_w,
	vl_resultado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/* Se o resultado do indicador for (Bom,médio ou ruim) então o valor do indicador superior será o VL_RESULTADO_W*/

	if (nr_seq_classif_regra_w = nr_seq_classif_ind_w) then
		qt_real_w	:= vl_resultado_w;
	end if;

	end;
end loop;
close C01;

return	qt_real_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_valor_classif_result ( nr_seq_ind_inf_p bigint, nr_seq_formula_p bigint) FROM PUBLIC;

