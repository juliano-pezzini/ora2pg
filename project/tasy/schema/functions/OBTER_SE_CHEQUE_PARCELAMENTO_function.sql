-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cheque_parcelamento ( nr_seq_caixa_rec_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_trans_financ_w	bigint;
ds_retorno_w		varchar(1);
qt_regra_w		bigint;
vl_cheque_w		double precision;
qt_cheque_w		bigint;


BEGIN

select	sum(a.vl_cheque),
	count(*)
into STRICT	vl_cheque_w,
	qt_cheque_w
from	cheque_cr a
where	a.nr_seq_caixa_rec	= nr_seq_caixa_rec_p;

select	max(a.nr_seq_trans_financ)
into STRICT	nr_seq_trans_financ_w
from	caixa_receb a
where	a.nr_sequencia	= nr_seq_caixa_rec_p;

select	count(*)
into STRICT	qt_regra_w
from	trans_financ_regra_cheque a
where	a.qt_max_cheques	< qt_cheque_w
and	vl_cheque_w		between	a.vl_inicial and a.vl_final
and	a.nr_seq_tras_financ	= nr_seq_trans_financ_w;

if (qt_regra_w	> 0) then
	ds_retorno_w	:= 'N';
else
	ds_retorno_w	:= 'S';
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cheque_parcelamento ( nr_seq_caixa_rec_p bigint) FROM PUBLIC;
