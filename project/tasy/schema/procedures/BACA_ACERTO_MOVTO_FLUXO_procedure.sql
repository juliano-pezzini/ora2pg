-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_movto_fluxo () AS $body$
DECLARE


nr_sequencia_w	bigint;

c01 CURSOR FOR
SELECT 	a.nr_sequencia
from	transacao_financeira b,
	movto_trans_financ a
where	(a.nr_seq_banco_od IS NOT NULL AND a.nr_seq_banco_od::text <> '')
and	coalesce(a.ie_origem_lancamento::text, '') = ''
and	a.nr_seq_trans_financ 	= b.nr_sequencia
and	b.ie_banco		<> 'N'
and	b.ie_caixa		<> 'N'
and	a.dt_transacao		between to_date('01/03/2008','dd/mm/yyyy') and to_date('01/05/2008','dd/mm/yyyy')
and	(a.nr_seq_banco IS NOT NULL AND a.nr_seq_banco::text <> '')
and	exists (select	1
		from	movto_trans_financ x
		where	x.nr_seq_banco_od	= a.nr_seq_banco_od
		and	(x.nr_seq_caixa IS NOT NULL AND x.nr_seq_caixa::text <> '')
		and	coalesce(x.nr_seq_banco::text, '') = ''
		and	x.vl_transacao		= a.vl_transacao
		and	x.nr_seq_trans_financ	= a.nr_seq_trans_financ
		and	x.dt_transacao		= a.dt_transacao);


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	update	movto_trans_financ
	set	ie_origem_lancamento	= 'T'
	where	nr_sequencia		= nr_sequencia_w
	and	coalesce(ie_origem_lancamento::text, '') = '';

end loop;
close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_movto_fluxo () FROM PUBLIC;
