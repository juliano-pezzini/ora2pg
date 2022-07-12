-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_bloqueado_caixa (nr_seq_caixa_saldo_p bigint) RETURNS bigint AS $body$
DECLARE


vl_bloqueado_w	double precision	:= 0;
nr_seq_caixa_w	bigint	:= null;
dt_saldo_w	timestamp		:= null;
nr_seq_ultimo_saldo_w		bigint;


BEGIN

select	nr_seq_caixa,
	dt_saldo
into STRICT	nr_seq_caixa_w,
	dt_saldo_w
from	caixa_saldo_diario
where	nr_sequencia	= nr_seq_caixa_saldo_p;

select	coalesce(sum(a.vl_transacao),0)
into STRICT	vl_bloqueado_w
from	parametro_tesouraria d,
	caixa c,
	transacao_financeira b,
	movto_trans_financ a
where	a.nr_seq_trans_financ   = b.nr_sequencia
and	a.nr_seq_caixa          = c.nr_sequencia
and	c.cd_estabelecimento    = d.cd_estabelecimento
and	b.ie_caixa              = 'T'
and (b.ie_saldo_caixa        = 'S' or
        exists (SELECT  1
                  from    transacao_financeira x
                  where   x.nr_sequencia          = d.nr_seq_trans_troco
                  and     x.nr_seq_trans_transf   = a.nr_seq_trans_financ)
        )
and	coalesce(a.nr_seq_movto_transf::text, '') = ''
and	a.nr_seq_caixa_od       = nr_seq_caixa_w
and	a.dt_transacao between trunc(dt_saldo_w,'dd') and trunc(dt_saldo_w)+86399/86400; 	-- Edgar 26/10/2010, OS 260278, não colocar o fim_dia, problema de performance
if (vl_bloqueado_w	= 0) then

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_ultimo_saldo_w
	from	caixa_saldo_diario a
	where	a.dt_saldo	=	(SELECT	max(x.dt_saldo)
					from	caixa_saldo_diario x
					where	x.nr_seq_caixa	= a.nr_seq_caixa)
	and	a.nr_seq_caixa	= 	nr_seq_caixa_w;

	if (nr_seq_ultimo_saldo_w = nr_seq_caixa_saldo_p) then
		select	coalesce(sum(a.vl_transacao),0)
		into STRICT	vl_bloqueado_w
		from	caixa_saldo_diario e,
			parametro_tesouraria d,
			caixa c,
			transacao_financeira b,
			movto_trans_financ a
		where	a.nr_seq_trans_financ   = b.nr_sequencia
		and	a.nr_seq_caixa          = c.nr_sequencia
		and	c.cd_estabelecimento    = d.cd_estabelecimento
		and	a.nr_seq_saldo_caixa	= e.nr_sequencia
		and	b.ie_caixa              = 'T'
		and (b.ie_saldo_caixa        = 'S' or
		        exists (SELECT  1
		                  from    transacao_financeira x
		                  where   x.nr_sequencia          = d.nr_seq_trans_troco
		                  and     x.nr_seq_trans_transf   = a.nr_seq_trans_financ)
		        )
		and	coalesce(a.nr_seq_movto_transf::text, '') = ''
		and	a.nr_seq_caixa_od       = nr_seq_caixa_w
		and	a.dt_transacao		>= trunc(dt_saldo_w,'dd');

	end if;
end if;

return vl_bloqueado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_bloqueado_caixa (nr_seq_caixa_saldo_p bigint) FROM PUBLIC;

