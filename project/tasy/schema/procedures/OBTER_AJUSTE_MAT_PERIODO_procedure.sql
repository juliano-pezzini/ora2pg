-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_ajuste_mat_periodo ( nr_sequencia_p bigint, vl_material_p bigint, tx_ajuste_mat_p bigint, ie_origem_preco_p text, tx_ajuste_periodo_p INOUT bigint) AS $body$
DECLARE


qt_regras_w		bigint;
tx_ajuste_w		double precision;
ie_origem_preco_w	varchar(5);
c01 CURSOR FOR
SELECT	tx_ajuste
from	regra_ajuste_indice_dif
where	nr_seq_regra	= nr_sequencia_p
and	position(ie_origem_preco_w  coalesce(ie_origem_preco,ie_origem_preco_w))	> 0
and	vl_material_p	between vl_inicial and vl_final;


BEGIN
ie_origem_preco_w	:= coalesce(ie_origem_preco_p,'0');
select	count(*)
into STRICT	qt_regras_w
from	regra_ajuste_indice_dif
where	nr_seq_regra	= nr_sequencia_p
and	position(ie_origem_preco_w in coalesce(ie_origem_preco,ie_origem_preco_w))	> 0;

if (qt_regras_w	= 0) then
	tx_ajuste_w	:= tx_ajuste_mat_p;
elsif (qt_regras_w	> 0) then
	open c01;
	loop
	fetch c01 into
		tx_ajuste_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
	if (coalesce(tx_ajuste_w::text, '') = '') then
		tx_ajuste_w	:= tx_ajuste_mat_p;
	end if;
end if;

tx_ajuste_periodo_p	:= tx_ajuste_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_ajuste_mat_periodo ( nr_sequencia_p bigint, vl_material_p bigint, tx_ajuste_mat_p bigint, ie_origem_preco_p text, tx_ajuste_periodo_p INOUT bigint) FROM PUBLIC;
