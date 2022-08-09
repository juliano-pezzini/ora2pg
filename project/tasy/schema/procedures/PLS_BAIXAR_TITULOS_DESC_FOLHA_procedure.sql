-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baixar_titulos_desc_folha ( nr_seq_cobranca_p bigint, ie_acao_p text, ie_checados_p text, nm_usuario_p text, dt_baixa_p timestamp) AS $body$
DECLARE


nr_titulo_w			bigint;
cd_estabelecimento_w		smallint;
cd_banco_w			banco.cd_banco%type;
ds_observacao_titulo_w		varchar(4000);
nr_cobranca_w			bigint;
nr_seq_hist_cob_w		bigint;
ie_dt_liq_cobr_w		varchar(1);
nr_sequencia_w			bigint;
vl_credito_w			double precision;
vl_desconto_w			double precision;
vl_acrescimo_w			double precision;
vl_juros_w			double precision;
vl_cobranca_total_w		double precision;
pr_comissao_w			double precision;
vl_comissao_w			double precision;
vl_total_comissao_w		double precision;
ie_tipo_titulo_w		varchar(2);
cd_matricula_w			varchar(20);
vl_titulo_w			double precision;
ds_inconsistencia_w		varchar(255);
qt_baixas_tit_w			bigint;
dt_baixa_lote_desc_folha_w	timestamp;
ie_transacao_controle_banc_w	pls_desc_empresa.ie_transacao_controle_bancario%type;
nr_seq_conta_banco_w		cobranca_escritural.nr_seq_conta_banco%type;
nr_seq_trans_financ_w		transacao_financeira.nr_sequencia%type;
vl_recebido_w			titulo_receber_liq.vl_recebido%type;
vl_baixa_w			double precision;
vl_baixa_retorno_w		double precision;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_titulo,
		coalesce(a.vl_liquidacao,0),
		coalesce(a.vl_desconto,0),
		coalesce(a.vl_acrescimo,0),
		coalesce(a.vl_juros,0),
		b.ie_tipo_titulo,
		b.vl_titulo,
		b.ds_observacao_titulo,
		c.dt_recebimento
	from	cobranca_escritural	c,
		titulo_receber		b,
		titulo_receber_cobr	a
	where	a.nr_seq_cobranca	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_cobranca_p
	and	((ie_checados_p = 'N') or (ie_checados_p = 'S' AND a.ie_verificacao = 'S'))
	and (ie_dt_liq_cobr_w = 'N' or (a.dt_liquidacao IS NOT NULL AND a.dt_liquidacao::text <> ''))
	and	a.nr_titulo	= b.nr_titulo
	and	((coalesce(ie_acao_p,'I') <> 'I' and (a.dt_liquidacao IS NOT NULL AND a.dt_liquidacao::text <> '')) or (b.vl_saldo_titulo > 0 and a.vl_liquidacao > 0 and coalesce(a.vl_liquidacao,0) + coalesce(a.vl_despesa_bancaria,0) - coalesce(a.vl_acrescimo,0) > 0));

c02 CURSOR FOR
	SELECT	a.nr_titulo,
		b.nr_seq_hist_cobr,
		to_char(clock_timestamp(),'dd/mm/yyyy') || ' ' || b.cd_ocorrencia || ' - ' || b.ds_ocorrencia ||
			' - Inclusao Automatica Cob. Escitural nr ' || to_char(nr_seq_cobranca_p),
		d.nr_sequencia
	from	cobranca		d,
		titulo_receber		c,
		banco_ocorr_escrit_ret	b,
		titulo_receber_cobr	a
	where	a.nr_seq_cobranca	= nr_seq_cobranca_p
	and	coalesce(c.ie_tipo_carteira,'0') 	= coalesce(0,coalesce(c.ie_tipo_carteira,'0'))
	and	a.nr_titulo		= c.nr_titulo
	and	a.nr_seq_ocorrencia_ret	= b.nr_sequencia
	and	d.nr_titulo		= c.nr_titulo
	and	ie_acao_p		= 'I'
	and	(b.nr_seq_hist_cobr IS NOT NULL AND b.nr_seq_hist_cobr::text <> '');

BEGIN

select	a.cd_estabelecimento,
	b.cd_banco,
	coalesce(c.ie_transacao_controle_bancario,'N'),
	a.nr_seq_conta_banco
into STRICT	cd_estabelecimento_w,
	cd_banco_w,
	ie_transacao_controle_banc_w,
	nr_seq_conta_banco_w
from	pls_desc_empresa	c,
	banco_estabelecimento	b,
	cobranca_escritural	a
where	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_seq_empresa	= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobranca_p;

select	coalesce(max(ie_dt_liq_cobr),'N')
into STRICT	ie_dt_liq_cobr_w
from	banco
where	cd_banco	= coalesce(cd_banco_w,-1)
and	ie_situacao	= 'A';

vl_recebido_w		:= 0;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_titulo_w,
	vl_credito_w,
	vl_desconto_w,
	vl_acrescimo_w,
	vl_juros_w,
	ie_tipo_titulo_w,
	vl_titulo_w,
	ds_observacao_titulo_w,
	dt_baixa_lote_desc_folha_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	vl_baixa_w	:= 0;
	
	if (vl_credito_w > vl_titulo_w) then
		if (ds_observacao_titulo_w IS NOT NULL AND ds_observacao_titulo_w::text <> '') then
			ds_observacao_titulo_w	:= ds_observacao_titulo_w || ' - O valor pago pelo(a) pagador(a) ('||campo_mascara_virgula(vl_credito_w)||'), e superior ao valor do titulo.';
		else
			ds_observacao_titulo_w	:= ds_observacao_titulo_w || 'O valor pago pelo(a) pagador(a) ('||campo_mascara_virgula(vl_credito_w)||'), e superior ao valor do titulo.';
		end if;
		
		update	titulo_receber
		set	ds_observacao_titulo	= ds_observacao_titulo_w
		where	nr_titulo	= nr_titulo_w;
	end if;
	
	if (ie_tipo_titulo_w = '9') then
		select	count(1)
		into STRICT	qt_baixas_tit_w
		from	titulo_receber_liq
		where	nr_titulo	= nr_titulo_w;
		
		if	((vl_credito_w <> 0) or (vl_desconto_w <> 0) or (vl_acrescimo_w <> 0) or (vl_juros_w <> 0)) and
			((coalesce(dt_baixa_lote_desc_folha_w::text, '') = '') or (dt_baixa_lote_desc_folha_w IS NOT NULL AND dt_baixa_lote_desc_folha_w::text <> '' AND qt_baixas_tit_w = 0)) then
			vl_baixa_w := pls_baixa_tit_rec_desc_folha(nr_sequencia_w, ie_acao_p, nm_usuario_p, dt_baixa_p, vl_baixa_w);
		end if;
	else
		begin
		select	c.cd_matricula
		into STRICT	cd_matricula_w
		from	titulo_receber		a,
			pls_mensalidade		b,
			pls_contrato_pagador_fin c
		where	a.nr_seq_mensalidade	= b.nr_sequencia
		and	b.nr_seq_pagador	= c.nr_seq_pagador
		and	b.dt_referencia between c.dt_inicio_vigencia and fim_dia(coalesce(c.dt_fim_vigencia,b.dt_referencia));
		exception
		when others then
			cd_matricula_w	:= '';
		end;
		
		ds_inconsistencia_w	:= 'Nao foi efetuada a baixa do titulo '||nr_titulo_w||' pois o tipo do titulo nao e de desconto em folha!';
		insert	into	pls_desc_inconsistencia(	nr_sequencia, nr_seq_cobranca, cd_estabelecimento,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, nr_matricula, vl_titulo,
				ds_inconsistencia)
			values (	nextval('pls_desc_inconsistencia_seq'), nr_seq_cobranca_p, cd_estabelecimento_w,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, cd_matricula_w, vl_titulo_w,
				ds_inconsistencia_w);
	end if;
	vl_recebido_w	:= vl_recebido_w + vl_baixa_w;
end loop;
close c01;

/* Gerar a comissao */

select	max(c.pr_comissao),
	max(c.vl_comissao)
into STRICT	pr_comissao_w,
	vl_comissao_w
from	cobranca_escritural	a,
	pls_desc_empresa	b,
	pls_desc_empresa_regra	c
where	b.nr_sequencia		= a.nr_seq_empresa
and	b.nr_sequencia		= c.nr_seq_empresa
and	a.nr_sequencia		= nr_seq_cobranca_p;

select	sum(vl_cobranca)
into STRICT	vl_cobranca_total_w
from	titulo_receber_cobr
where	nr_seq_cobranca	= nr_seq_cobranca_p
and	((ie_checados_p = 'N') or (ie_checados_p = 'S' AND ie_verificacao = 'S'));

vl_total_comissao_w := (coalesce(vl_cobranca_total_w,0) * (coalesce(pr_comissao_w,0) / 100)) + coalesce(vl_comissao_w,0);
	
update	cobranca_escritural
set	dt_recebimento	= CASE WHEN ie_acao_p='I' THEN coalesce(dt_baixa_p, clock_timestamp())  ELSE null END ,
	vl_comissao_empresa = vl_total_comissao_w,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_cobranca_p;

if	(ie_transacao_controle_banc_w = 'C' AND vl_recebido_w <> 0) then	
	select	max(nr_seq_trans_cobr_escrit)
	into STRICT	nr_seq_trans_financ_w
	from	parametro_contas_receber
	where	cd_estabelecimento	= cd_estabelecimento_w;
	
	insert into movto_trans_financ(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nr_seq_trans_financ,
		vl_transacao,
		nr_seq_banco,
		dt_transacao,
		ie_conciliacao,
		nr_lote_contabil,
		nr_seq_cobr_escrit,
		dt_referencia_saldo)
	values (nextval('movto_trans_financ_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_trans_financ_w,
		vl_recebido_w,
		nr_seq_conta_banco_w,
		dt_baixa_p,
		'N',
		0,
		nr_seq_cobranca_p,
		dt_baixa_p);
end if;

/* altera observacao e insere o historico na cobranca */

open c02;
loop
fetch c02 into
	nr_titulo_w,
	nr_seq_hist_cob_w,
	ds_observacao_titulo_w,
	nr_cobranca_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	update	titulo_receber
	set	ds_observacao_titulo	= ds_observacao_titulo_w
	where	nr_titulo		= nr_titulo_w;
	
	insert	into cobranca_historico(ds_historico,
		dt_atualizacao,
		dt_historico,
		nm_usuario,
		nr_seq_cobranca,
		nr_seq_historico,
		nr_sequencia)
	values (ds_observacao_titulo_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nr_cobranca_w,
		nr_seq_hist_cob_w,
		nextval('cobranca_historico_seq'));
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baixar_titulos_desc_folha ( nr_seq_cobranca_p bigint, ie_acao_p text, ie_checados_p text, nm_usuario_p text, dt_baixa_p timestamp) FROM PUBLIC;
