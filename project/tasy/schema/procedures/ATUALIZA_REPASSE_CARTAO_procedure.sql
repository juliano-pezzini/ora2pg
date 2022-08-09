-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_repasse_cartao (nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w		bigint;
nr_seq_protocolo_w		bigint;
vl_recebido_w			double precision;
vl_total_recebido_w		double precision;
nr_seq_caixa_rec_w		bigint;
vl_cartao_w			double precision;
vl_cartao_baixa_w		double precision;
vl_cartao_despesa_w		double precision;
ie_desp_repasse_cartao_w	varchar(2);
pr_proporcional_w		double precision;
vl_proporcional_w		double precision;
cd_estabelecimento_w		smallint;
ie_repasse_cartao_w		varchar(1);
dt_fechamento_w			timestamp;
vl_troco_w			double precision;
vl_outros_receb_w		double precision;
nr_seq_trans_troco_w		bigint;
vl_total_monetario_w		double precision;
vl_total_cartao_w		double precision;
nr_seq_movto_cartao_w		double precision;
nr_seq_parcela_w		movto_cartao_cr_baixa.nr_seq_parcela%type;
nr_seq_forma_pagto_w		forma_pagto_regra.nr_sequencia%type;
nr_adiantamento_w		adiantamento.nr_adiantamento%type;
ie_lib_adiantamento_w		parametro_repasse.ie_lib_adiantamento%type;

/* Contas */

c01 CURSOR FOR
SELECT	b.nr_interno_conta,
	b.nr_seq_protocolo,
	coalesce(sum(a.vl_recebido),0)
from	titulo_receber b,
	titulo_receber_liq a
where	a.nr_titulo		= b.nr_titulo
and	a.nr_seq_caixa_rec	= nr_seq_caixa_rec_w
and	'N' = ie_lib_adiantamento_w
group by
	b.nr_interno_conta,
	b.nr_seq_protocolo

union	all

PERFORM	b.nr_interno_conta,
	b.nr_seq_protocolo,
	coalesce(sum(a.vl_recebido),0)
from	titulo_receber b,
	titulo_receber_liq a
where	a.nr_titulo		= b.nr_titulo
and	a.nr_adiantamento	= nr_adiantamento_w
and	'S' = ie_lib_adiantamento_w
group by
	b.nr_interno_conta,
	b.nr_seq_protocolo;
	

BEGIN

if (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then

	select	b.nr_seq_caixa_rec,
		b.cd_estabelecimento,
		a.vl_baixa, /* a.vl_baixa + nvl(a.vl_despesa,0) */
		coalesce(a.vl_despesa,0),
		b.nr_sequencia,
		a.nr_seq_parcela
	into STRICT	nr_seq_caixa_rec_w,
		cd_estabelecimento_w,
		vl_cartao_baixa_w,
		vl_cartao_despesa_w,
		nr_seq_movto_cartao_w,
		nr_seq_parcela_w
	from	movto_cartao_cr b,
		movto_cartao_cr_baixa a
	where	a.nr_seq_movto	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_baixa_p;
	
	if (nr_seq_caixa_rec_w IS NOT NULL AND nr_seq_caixa_rec_w::text <> '') then

		select	coalesce(max(ie_desp_repasse_cartao),'S')
		into STRICT	ie_desp_repasse_cartao_w
		from	parametro_faturamento
		where	cd_estabelecimento	= cd_estabelecimento_w;
		
		begin
		select	coalesce(ie_lib_adiantamento,'N')
		into STRICT	ie_lib_adiantamento_w
		from	parametro_repasse
		where	cd_estabelecimento = cd_estabelecimento_w;
		exception
		when others then
			ie_lib_adiantamento_w	:= 'N';
		end;
		
		if (ie_desp_repasse_cartao_w = 'S') then
			vl_cartao_w	:=	vl_cartao_baixa_w + vl_cartao_despesa_w;
		else
			vl_cartao_w	:=	vl_cartao_baixa_w;	
		end if;
		
		select	coalesce(sum(a.vl_recebido),0)
		into STRICT	vl_total_recebido_w
		from	titulo_receber b,
			titulo_receber_liq a
		where	a.nr_titulo		= b.nr_titulo
		and	a.nr_seq_caixa_rec	= coalesce(nr_seq_caixa_rec_w,0);

		if (ie_lib_adiantamento_w = 'S') and (coalesce(vl_total_recebido_w,0) = 0) then
			select	max(a.nr_adiantamento)
			into STRICT	nr_adiantamento_w
			from	adiantamento a
			where	a.nr_seq_caixa_rec = coalesce(nr_seq_caixa_rec_w,0);
			
			select	coalesce(sum(a.vl_recebido),0)
			into STRICT	vl_total_recebido_w
			from	titulo_receber_liq a
			where	a.nr_adiantamento = nr_adiantamento_w;
			
		end if;
		
		select	coalesce(max(ie_repasse_cartao),'N')
		into STRICT	ie_repasse_cartao_w
		from	parametro_contas_receber
		where	cd_estabelecimento	= cd_estabelecimento_w;

		select	max(nr_seq_trans_troco)
		into STRICT	nr_seq_trans_troco_w
		from	parametro_tesouraria
		where	cd_estabelecimento	= cd_estabelecimento_w;

		select	max(dt_fechamento)
		into STRICT	dt_fechamento_w
		from	caixa_receb
		where	nr_sequencia	= nr_seq_caixa_rec_w;

		select	coalesce(sum(vl_transacao),0)
		into STRICT	vl_troco_w
		from	movto_trans_financ
		where	nr_seq_caixa_rec	= nr_seq_caixa_rec_w
		and	nr_seq_trans_financ	= nr_seq_trans_troco_w;

		select	coalesce(sum(a.vl_transacao),0)
		into STRICT	vl_outros_receb_w
		from	transacao_financeira b,
			movto_trans_financ a
		where	a.nr_seq_trans_financ	= b.nr_sequencia
		and	a.nr_seq_caixa_rec	= nr_seq_caixa_rec_w
		and	b.ie_acao		= 0
		and	b.ie_caixa		= 'D'
		and	a.dt_transacao		< dt_fechamento_w;

		select	sum(coalesce(CASE WHEN ie_desp_repasse_cartao_w='S' THEN a.vl_parcela WHEN ie_desp_repasse_cartao_w='D' THEN  a.vl_parcela  ELSE a.vl_parcela - a.vl_despesa END ,b.vl_transacao))
		into STRICT	vl_total_cartao_w
		from	movto_cartao_cr b,
			movto_cartao_cr_parcela a
		where	a.nr_seq_movto	= b.nr_sequencia
		and	a.nr_seq_movto	= nr_seq_movto_cartao_w;

		vl_total_monetario_w	:= obter_valores_caixa_rec(nr_seq_caixa_rec_w,'VT');
		
		vl_troco_w		:= dividir_sem_round(vl_cartao_w,vl_total_monetario_w) * vl_troco_w;

		vl_outros_receb_w	:= dividir_sem_round(vl_cartao_w,vl_total_monetario_w) * vl_outros_receb_w;
		
		if (vl_outros_receb_w <> 0 or vl_troco_w <> 0) then
			vl_cartao_w		:= vl_cartao_w -
							(dividir_sem_round(vl_cartao_w,vl_total_cartao_w) * vl_troco_w) - 
							(dividir_sem_round(vl_cartao_w,vl_total_cartao_w) * vl_outros_receb_w);
			vl_total_cartao_w	:= vl_total_cartao_w - vl_troco_w - vl_outros_receb_w;
		end if;
		
		if (nr_seq_caixa_rec_w IS NOT NULL AND nr_seq_caixa_rec_w::text <> '') and (vl_total_recebido_w > 0) and (ie_repasse_cartao_w = 'P') then
			
			if (vl_cartao_w <> 0) then
				
				pr_proporcional_w	:= dividir(vl_cartao_w * 100,vl_total_recebido_w);

				open c01;
				loop
				fetch c01 into
					nr_interno_conta_w,
					nr_seq_protocolo_w,
					vl_recebido_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					
					vl_proporcional_w	:= dividir(vl_recebido_w * pr_proporcional_w,100);
					
					CALL atualizar_repasse_valor(nr_seq_protocolo_w,nr_interno_conta_w,vl_proporcional_w,nm_usuario_p,nr_seq_baixa_p,vl_total_cartao_w,nr_seq_parcela_w);
				end loop;
				close c01;
			end if;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_repasse_cartao (nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
