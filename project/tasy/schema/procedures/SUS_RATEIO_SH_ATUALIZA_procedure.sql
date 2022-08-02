-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_rateio_sh_atualiza ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_tot_original_w		double precision;
vl_tot_preco_w		double precision;
nr_sequencia_w		bigint;
vl_preco_w		double precision;
tx_item_w			double precision;
vl_receita_w		double precision;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.vl_preco
	from	w_conta_sus_sh a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	a.vl_preco		<> 0
	and	((a.ie_origem_proced	<> 2) or (cd_item = 99080012));

/* Conforme Marcos (Custos - Caridade) para o procedimento de diária 99080012, tambem deverá receber o rateio,
pois o valro SH do procedimento principal que o SUS paga envolve tanto materias, taxas e diárias*/
BEGIN

select	sum(vl_original)
into STRICT	vl_tot_original_w
from	w_conta_sus_sh
where	nr_interno_conta 	= nr_interno_conta_p
and	ie_origem_proced	= 2;

select	sum(vl_preco)
into STRICT	vl_tot_preco_w
from	w_conta_sus_sh
where	nr_interno_conta 	= nr_interno_conta_p
and	ie_origem_proced	<> 2;

OPEN C01;
LOOP
FETCH 	C01 into
	nr_sequencia_w,
	vl_preco_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	tx_item_w 		:= round((vl_preco_w * 100) / vl_tot_preco_w,4);
	vl_receita_w		:= ((tx_item_w * vl_tot_original_w) / 100);
	update w_conta_sus_sh
	set	vl_receita 	= vl_receita_w,
		tx_rateio		= tx_item_w
	where	nr_sequencia	= nr_sequencia_w;
	END;
END LOOP;
CLOSE C01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_rateio_sh_atualiza ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

