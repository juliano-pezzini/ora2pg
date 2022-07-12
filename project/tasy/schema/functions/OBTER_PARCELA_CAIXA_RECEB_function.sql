-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_parcela_caixa_receb ( nr_seq_caixa_rec_p bigint, dt_parcela_p timestamp) RETURNS varchar AS $body$
DECLARE


dt_recebimento_w	caixa_receb.dt_recebimento%type;
nr_seq_cartao_w		movto_cartao_cr.nr_sequencia%type;
dt_cartao_w		movto_cartao_cr_parcela.dt_parcela%type;
nr_seq_cheque_w		cheque_cr.nr_seq_cheque%type;
dt_cheque_w		cheque_cr.dt_vencimento%type;
dt_verific_w		timestamp;
ds_parcela_w		varchar(10);
qt_parcela_w		bigint;
qt_tot_parcelas_w	bigint;
ie_cartao_w		varchar(1)	:= 'N';

C01 CURSOR FOR
SELECT	max(b.nr_sequencia) nr_sequencia,
	trunc(fim_mes(c.dt_parcela)) dt_parcela
from	movto_cartao_cr b,
	movto_cartao_cr_parcela c
where	b.nr_sequencia			= c.nr_seq_movto
and	b.nr_seq_caixa_rec		= nr_seq_caixa_rec_p
and	trunc(fim_mes(c.dt_parcela))	> dt_verific_w
group by fim_mes(c.dt_parcela);


C02 CURSOR FOR
SELECT	max(b.nr_seq_cheque) nr_seq_cheque,
	trunc(fim_mes(b.dt_vencimento)) dt_vencimento
from	cheque_cr b
where	b.nr_seq_caixa_rec		= nr_seq_caixa_rec_p
and	trunc(fim_mes(b.dt_vencimento))	> dt_verific_w
group by fim_mes(b.dt_vencimento);


BEGIN

select	trunc(fim_mes(a.dt_recebimento)) dt_recebimento
into STRICT	dt_recebimento_w
from	caixa_receb a
where	a.nr_sequencia	= nr_seq_caixa_rec_p;

qt_tot_parcelas_w	:= coalesce(qt_tot_parcelas_w,0) + 1;
dt_verific_w		:= dt_recebimento_w;

if (dt_verific_w	= trunc(fim_mes(dt_parcela_p))) then
	qt_parcela_w	:= qt_tot_parcelas_w;
end if;

open C01;
loop
fetch C01 into
	nr_seq_cartao_w,
	dt_cartao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_cartao_w		:= 'S';
	qt_tot_parcelas_w	:= qt_tot_parcelas_w + 1;
	dt_verific_w		:= dt_cartao_w;

	if (dt_verific_w	= trunc(fim_mes(dt_parcela_p))) then
		qt_parcela_w	:= qt_tot_parcelas_w;
	end if;

	open C02;
	loop
	fetch C02 into
		nr_seq_cheque_w,
		dt_cheque_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		qt_tot_parcelas_w	:= qt_tot_parcelas_w + 1;
		dt_verific_w		:= dt_cheque_w;

		if (dt_verific_w	= trunc(fim_mes(dt_parcela_p))) then
			qt_parcela_w	:= qt_tot_parcelas_w;
		end if;

		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

if (qt_tot_parcelas_w = 1) and (ie_cartao_w = 'N') then
	open C02;
	loop
	fetch C02 into
		nr_seq_cheque_w,
		dt_cheque_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		qt_tot_parcelas_w	:= qt_tot_parcelas_w + 1;
		dt_verific_w		:= dt_cheque_w;

		if (dt_verific_w	= trunc(fim_mes(dt_parcela_p))) then
			qt_parcela_w	:= qt_tot_parcelas_w;
		end if;

		end;
	end loop;
	close C02;
end if;

ds_parcela_w	:= qt_tot_parcelas_w;

if (dt_parcela_p IS NOT NULL AND dt_parcela_p::text <> '') then
	ds_parcela_w	:=  qt_parcela_w|| '/' || qt_tot_parcelas_w;
end if;

return	ds_parcela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_parcela_caixa_receb ( nr_seq_caixa_rec_p bigint, dt_parcela_p timestamp) FROM PUBLIC;

