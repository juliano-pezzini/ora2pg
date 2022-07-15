-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_concil_cartao_santander (nr_seq_extrato_arq_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_gerar_movto_banco_w		varchar(1);
cd_estabelecimento_w		smallint;
nr_seq_parcela_w		bigint;
dt_prev_pagto_w			timestamp;
nr_seq_extrato_w		bigint;
vl_saldo_concil_fin_w		double precision;
nr_seq_conta_banco_res_w	bigint;
nr_seq_grupo_w			bigint;
nr_seq_conta_banco_w		bigint;
nr_seq_trans_indevido_w		bigint;
nr_seq_movto_trans_w		bigint;
vl_ajuste_w			double precision;
nr_seq_movto_w			bigint;
ds_mensagem_w			varchar(255);
ie_movto_banco_w		extrato_cartao_cr.ie_movto_banco%type;
ie_tipo_cartao_w 		movto_cartao_cr.ie_tipo_cartao%type;
ie_valor_movto_bco_w 		bandeira_cartao_cr.ie_valor_movto_bco%type;
nr_sequencia_w		bandeira_cartao_cr.nr_sequencia%type;
vl_lote_w		movto_cartao_cr_parcela.vl_parcela%type;
nr_seq_trans_financ_w 		bandeira_cartao_cr.nr_seq_trans_financ%type;
nr_seq_trans_fin_desp_w		bandeira_cartao_cr.nr_seq_trans_fin_desp%type;
nr_seq_conta_regra_w		bandeira_cartao_cr.nr_seq_conta_banco%type;
ds_bandeira_w			bandeira_cartao_cr.ds_bandeira%type;
/*Despesas com equipamento*/

nr_seq_trans_desp_w		grupo_bandeira_cr.nr_seq_trans_desp_equip%type;
vl_despesa_w			extrato_cartao_cr_desp.vl_liquido%type;
dt_pagto_desp_w			extrato_cartao_cr_desp.dt_prev_pagto%type;

c01 CURSOR FOR
SELECT	b.nr_seq_parcela,
	a.dt_prev_pagto,
	a.nr_seq_conta_banco,
	b.vl_ajuste,
	b.nr_sequencia
from	extrato_cartao_cr_movto b,
	extrato_cartao_cr_res a
where	(b.nr_seq_parcela IS NOT NULL AND b.nr_seq_parcela::text <> '')
and	a.nr_sequencia		= b.nr_seq_extrato_res
and	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p

union

SELECT	d.nr_sequencia,
	a.dt_prev_pagto,
	a.nr_seq_conta_banco,
	b.vl_ajuste,
	b.nr_sequencia
from	movto_cartao_cr_parcela d,
	extrato_cartao_cr_parcela c,
	extrato_cartao_cr_movto b,
	extrato_cartao_cr_res a
where	c.nr_sequencia			= d.nr_seq_extrato_parcela
and	b.nr_seq_extrato_parcela	= c.nr_sequencia
and	a.nr_sequencia			= b.nr_seq_extrato_res
and	a.nr_seq_extrato_arq		= nr_seq_extrato_arq_p;

c02 CURSOR FOR
SELECT	b.vl_saldo_concil_fin,
	a.dt_prev_pagto,
	a.nr_seq_conta_banco
from	extrato_cartao_cr_movto b,
	extrato_cartao_cr_res a
where	b.ie_pagto_indevido	= 'S'
and	a.nr_sequencia		= b.nr_seq_extrato_res
and	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p;

c03 CURSOR FOR
SELECT	a.vl_liquido,
	a.dt_prev_pagto
from	extrato_cartao_cr_desp a
where	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p;

c04 CURSOR FOR
	SELECT d.ie_tipo_cartao,
			f.ie_valor_movto_bco,
			f.nr_sequencia
	from    extrato_cartao_cr_res a
	join    extrato_cartao_cr_movto b on a.nr_sequencia  =  b.nr_seq_extrato_res
	join    movto_cartao_cr_parcela c on b.nr_seq_parcela = c.nr_sequencia
	join    movto_cartao_cr d on c.nr_seq_movto = d.nr_sequencia
	join    bandeira_cartao_cr f on d.nr_seq_bandeira = f.nr_sequencia
	where   d.ie_tipo_cartao = 'D' and a.nr_seq_extrato_arq      =   nr_seq_extrato_arq_p
	group by   d.ie_tipo_cartao,
			f.ie_valor_movto_bco,
			f.nr_sequencia
	
union all

	SELECT d.ie_tipo_cartao,
			f.ie_valor_movto_bco,
			f.nr_sequencia
	from    extrato_cartao_cr_res a
	join    extrato_cartao_cr_movto b on a.nr_sequencia  =  b.nr_seq_extrato_res
	join    movto_cartao_cr_parcela c on b.nr_seq_parcela = c.nr_sequencia
	join    movto_cartao_cr d on c.nr_seq_movto = d.nr_sequencia
	join    bandeira_cartao_cr f on d.nr_seq_bandeira = f.nr_sequencia
	where   d.ie_tipo_cartao = 'C' and a.nr_seq_extrato_arq      =   nr_seq_extrato_arq_p
	group by   d.ie_tipo_cartao,
			f.ie_valor_movto_bco,
			f.nr_sequencia;


BEGIN

select	max(b.cd_estabelecimento),
	max(b.nr_sequencia),
	max(b.nr_seq_grupo),
	coalesce(max(b.ie_movto_banco),'P')
into STRICT	cd_estabelecimento_w,
	nr_seq_extrato_w,
	nr_seq_grupo_w,
	ie_movto_banco_w
from	extrato_cartao_cr b,
	extrato_cartao_cr_arq a
where	a.nr_seq_extrato	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_extrato_arq_p;

if (ie_movto_banco_w = 'P') then
	ie_gerar_movto_banco_w	:= 'S';
else
	ie_gerar_movto_banco_w	:= 'N';
end if;

/* gerar movimentacao para os pagamentos indevidos */

select	max(a.nr_seq_conta_banco),
	max(a.nr_seq_trans_indevido_cred),
	max(a.nr_seq_trans_desp_equip)
into STRICT	nr_seq_conta_banco_w,
	nr_seq_trans_indevido_w,
	nr_seq_trans_desp_w
from	grupo_bandeira_cr a
where	a.nr_sequencia	= nr_seq_grupo_w;

/* baixar as parcelas */

open	c01;
loop
fetch	c01 into
	nr_seq_parcela_w,
	dt_prev_pagto_w,
	nr_seq_conta_banco_res_w,
	vl_ajuste_w,
	nr_seq_movto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	CALL ajustar_parcela_cartao_cr(nr_seq_parcela_w,nr_seq_grupo_w,vl_ajuste_w,nm_usuario_p,nr_seq_movto_w);
	CALL baixar_parcela_cartao_cr(	nr_seq_parcela_w,
					coalesce(dt_prev_pagto_w,clock_timestamp()),
					nm_usuario_p,
					'S',
					'S',
					wheb_mensagem_pck.get_texto(305551,'NR_SEQ_EXTRATO_W='||nr_seq_extrato_w), --'Baixa gerada a partir do extrato ' || nr_seq_extrato_w || ' do grupo CIELO.',
					ie_gerar_movto_banco_w,
					'N',
					0,
					null,
					coalesce(nr_seq_conta_banco_res_w,nr_seq_conta_banco_w));

end	loop;
close	c01;
if (ie_movto_banco_w = 'L') then
		open	c04;
		loop
		fetch	c04 into
			ie_tipo_cartao_w ,
			ie_valor_movto_bco_w ,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */

			if (ie_valor_movto_bco_w = 'S') then

				select	(obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_TRANS_FINANC'))::numeric ,
					(obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_TRANS_FIN_DESP'))::numeric ,
					(obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_CONTA_BANCO'))::numeric ,
					sum(c.vl_parcela) ,
					sum(c.vl_despesa),
					f.ds_bandeira
				 into STRICT   nr_seq_trans_financ_w ,
					nr_seq_trans_fin_desp_w ,
					nr_seq_conta_regra_w,
					vl_lote_w,
					vl_despesa_w,
					ds_bandeira_w
				from    extrato_cartao_cr_res a
				join    extrato_cartao_cr_movto b on a.nr_sequencia  =  b.nr_seq_extrato_res
				join    movto_cartao_cr_parcela c on b.nr_seq_parcela = c.nr_sequencia
				join    movto_cartao_cr d on c.nr_seq_movto = d.nr_sequencia
				join    bandeira_cartao_cr f on d.nr_seq_bandeira = f.nr_sequencia
				where   d.ie_tipo_cartao = ie_tipo_cartao_w
				and a.nr_seq_extrato_arq      =   nr_seq_extrato_arq_p
				and d.nr_seq_bandeira = nr_sequencia_w
				group by (obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_TRANS_FINANC'))::numeric ,
					 (obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_TRANS_FIN_DESP'))::numeric ,
					 (obter_valor_bandeira_estab(f.nr_sequencia,d.cd_estabelecimento,'NR_SEQ_CONTA_BANCO'))::numeric ,
					 f.ds_bandeira;

			else

				select	sum(vl_baixa),
					sum(vl_despesa),
					max(nr_seq_trans_financ),
					max(nr_seq_trans_financ_desp),
					max(nr_seq_conta_banco),
					max(ds_bandeira)
				into STRICT	vl_lote_w,
					vl_despesa_w,
					nr_seq_trans_financ_w,
					nr_seq_trans_fin_desp_w,
					nr_seq_conta_regra_w,
					ds_bandeira_w
				from (SELECT	obter_valor_baixa_cartao(c.nr_seq_movto, c.nr_sequencia, 'UB') vl_baixa,
						obter_valor_baixa_cartao(c.nr_seq_movto, c.nr_sequencia, 'DB') vl_despesa,
						g.ds_bandeira,
						(obter_valor_bandeira_estab(g.nr_sequencia,f.cd_estabelecimento,'NR_SEQ_TRANS_FINANC'))::numeric  nr_seq_trans_financ,
						(obter_valor_bandeira_estab(g.nr_sequencia,f.cd_estabelecimento,'NR_SEQ_TRANS_FIN_DESP'))::numeric nr_seq_trans_financ_desp,
						(obter_valor_bandeira_estab(g.nr_sequencia,f.cd_estabelecimento,'NR_SEQ_CONTA_BANCO'))::numeric  nr_seq_conta_banco
					from	extrato_cartao_cr_res a ,
						extrato_cartao_cr_movto b,
						movto_cartao_cr_parcela c,
						movto_cartao_cr f,
						bandeira_cartao_cr g
					where	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p
					and	a.nr_sequencia		=  b.nr_seq_extrato_res
					and	b.nr_seq_parcela	= c.nr_sequencia
					and	c.nr_seq_movto		= f.nr_sequencia
					and	f.nr_seq_bandeira	= g.nr_sequencia
					and	a.nr_seq_bandeira	= nr_sequencia_w
					and	f.ie_tipo_cartao	= ie_tipo_cartao_w) alias14;
			end if;

			if (coalesce(nr_seq_trans_financ_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1199949,ds_bandeira_w);
			end if;

			select	nextval('movto_trans_financ_seq')
			into STRICT	nr_seq_movto_trans_w
			;
			begin
			insert	into movto_trans_financ(nr_sequencia,
				dt_transacao,
				nr_seq_trans_financ,
				vl_transacao,
				dt_atualizacao,
				nm_usuario,
				nr_lote_contabil,
				ie_conciliacao,
				nr_seq_lote_cartao,
				nr_seq_banco,
				dt_referencia_saldo)
			values (nr_seq_movto_trans_w,
				coalesce(dt_prev_pagto_w,clock_timestamp()),
				nr_seq_trans_financ_w,
				vl_lote_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				'N',
				null,
				coalesce(coalesce(nr_seq_conta_banco_res_w,nr_seq_conta_banco_w),nr_seq_conta_regra_w),
				clock_timestamp());

			end;


			if (vl_despesa_w <> 0) and (nr_seq_trans_fin_desp_w IS NOT NULL AND nr_seq_trans_fin_desp_w::text <> '') then

				insert	into movto_trans_financ(nr_sequencia,
					dt_transacao,
					nr_seq_trans_financ,
					vl_transacao,
					dt_atualizacao,
					nm_usuario,
					nr_lote_contabil,
					ie_conciliacao,
					nr_seq_lote_cartao,
					nr_seq_banco,
					dt_referencia_saldo)
				values (nextval('movto_trans_financ_seq'),
					coalesce(dt_prev_pagto_w,clock_timestamp()),
					nr_seq_trans_fin_desp_w,
					vl_despesa_w,
					clock_timestamp(),
					nm_usuario_p,
					0,
					'N',
					null,
					coalesce(nr_seq_conta_banco_res_w,nr_seq_conta_banco_w),
					clock_timestamp());

			end if;
		end loop;
	close c04;
end if;
open	c02;
loop
fetch	c02 into
	vl_saldo_concil_fin_w,
	dt_prev_pagto_w,
	nr_seq_conta_banco_res_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	if (coalesce(nr_seq_trans_indevido_w::text, '') = '') then
		/* Falta informar a transacao de pagamento indevido no cadastro do grupo de bandeiras. */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(186815);
	end if;

	select	nextval('movto_trans_financ_seq')
	into STRICT	nr_seq_movto_trans_w
	;

	insert	into movto_trans_financ(dt_atualizacao,
		dt_transacao,
		ie_conciliacao,
		nm_usuario,
		nr_lote_contabil,
		nr_seq_banco,
		nr_seq_trans_financ,
		nr_sequencia,
		vl_transacao)
	values (clock_timestamp(),
		coalesce(dt_prev_pagto_w,clock_timestamp()),
		'N',
		nm_usuario_p,
		0,
		coalesce(nr_seq_conta_banco_res_w,nr_seq_conta_banco_w),
		nr_seq_trans_indevido_w,
		nr_seq_movto_trans_w,
		vl_saldo_concil_fin_w);
			
	CALL atualizar_transacao_financeira(cd_estabelecimento_w,nr_seq_movto_trans_w,nm_usuario_p,'I');

end	loop;
close	c02;

if (nr_seq_trans_desp_w IS NOT NULL AND nr_seq_trans_desp_w::text <> '') and (nr_seq_conta_banco_w IS NOT NULL AND nr_seq_conta_banco_w::text <> '') then
	open c03;
	loop
	fetch c03 into
		vl_despesa_w,
		dt_pagto_desp_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		CALL gerar_movto_despesa_equip(vl_despesa_w,nr_seq_trans_desp_w,nr_seq_conta_banco_w,coalesce(dt_pagto_desp_w,clock_timestamp()),nm_usuario_p,'N');
	end loop;
	close c03;
end if;

update	extrato_cartao_cr_arq
set	dt_baixa	= clock_timestamp(),
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_extrato_arq_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_concil_cartao_santander (nr_seq_extrato_arq_p bigint, nm_usuario_p text) FROM PUBLIC;

