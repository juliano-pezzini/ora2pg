-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_titulos_cobranca_partic ( nr_seq_cobranca_p bigint, cd_convenio_p bigint, ie_tipo_carteira_p text, dt_baixa_p timestamp, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
	NAO DAR COMMIT NESTA PROCEDURE
	
	ie_acao_p
		I - Inclusao
		E - Estorno
-------------------------------------------------------------------------------------------------------------------

Referencias:
	BAIXAR_TITULOS_COBRANCA_ESCRIT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_acao_w				varchar(3);
ie_dt_liq_cobr_w			varchar(1);
ie_movto_bco_cobr_escrit_w		varchar(1);
ie_gerar_movto_banco_w			varchar(1);
ie_somente_liquidacao_w			varchar(1);
ie_gerar_nc_pag_duplic_w		varchar(1)	:= 'N';
ie_baixar_w				varchar(1)	:= 'N';
ie_gerar_baixa_w			varchar(1)	:= 'S';
ie_titulos_zerados_w			varchar(1)	:= 'N';
ie_gerar_nc_tit_mens_canc_w		varchar(1)	:= 'N';
ie_gerar_nc_tit_resc_w			varchar(1)	:= 'N';
ie_inadimplente_w			varchar(1);
ie_dt_baixa_cobr_escrit_w		varchar(1);
ie_despesa_bancaria_w			varchar(1);
vl_transacao_w				double precision;
vl_credito_W				double precision;
vl_desconto_w				double precision;
vl_acrescimo_w				double precision;
vl_juros_w				double precision;
vl_despesa_bancaria_w			double precision;
vl_descontar_w				double precision	:= 0;
vl_descontar_ww				double precision	:= 0;
nr_seq_conta_banco_w			bigint;
nr_seq_trans_financ_w			bigint;
nr_seq_movto_w				bigint;
nr_sequencia_w				bigint;
nr_titulo_w				bigint;
nr_seq_baixa_w				bigint;
nr_seq_empresa_w			bigint;
nr_seq_tit_rec_cobr_w			bigint;
qt_registro_w				bigint;
nr_seq_regra_w				bigint;
nr_seq_trans_desp_banco_w		bigint;
nr_seq_trans_inadimplencia_w		bigint;
cd_estabelecimento_w			smallint;
cd_banco_w				banco.cd_banco%type;
dt_transacao_w				timestamp;
dt_credito_bancario_w			timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_titulo,
		coalesce(a.vl_liquidacao,0) + CASE WHEN coalesce(ie_despesa_bancaria_w,'N')='S' THEN coalesce(a.vl_despesa_bancaria,0)  ELSE 0 END ,
		coalesce(a.vl_desconto,0),
		coalesce(a.vl_acrescimo,0),
		coalesce(a.vl_juros,0)
	FROM titulo_receber b, titulo_receber_cobr a
LEFT OUTER JOIN banco_ocorr_escrit_ret c ON (a.nr_seq_ocorrencia_ret = c.nr_sequencia)
WHERE a.nr_seq_cobranca	= nr_seq_cobranca_p and (obter_tipo_carteira_tit_rec(a.nr_titulo) = '1' or coalesce(ie_tipo_carteira_p,'0') = '0' or coalesce(cd_convenio_p,0) <> 0) and (ie_dt_liq_cobr_w = 'N' or (a.dt_liquidacao IS NOT NULL AND a.dt_liquidacao::text <> '')) and a.nr_titulo		= b.nr_titulo and ((coalesce(ie_acao_p,'I') <> 'I' and (a.dt_liquidacao IS NOT NULL AND a.dt_liquidacao::text <> '')) or
		(((b.vl_saldo_titulo > 0) or (ie_titulos_zerados_w = 'S'))
			and a.vl_liquidacao > 0 and coalesce(a.vl_liquidacao,0) + coalesce(a.vl_despesa_bancaria,0) - coalesce(a.vl_acrescimo,0) > 0)) and (coalesce(cd_convenio_p,0) = 0 or coalesce(b.cd_convenio_conta,obter_convenio_tit_rec(b.nr_titulo)) = cd_convenio_p) and (exists (SELECT	1
			from	titulo_receber_liq x
			where	x.nr_titulo	= a.nr_titulo
			and	x.nr_seq_cobranca = nr_seq_cobranca_p) or coalesce(ie_acao_p,'I') = 'I') /* Francisco - 08/08/2011 - garantir que o estorno so ocorra caso 

ja tenha baixa */
  and (ie_somente_liquidacao_w = 'N' or c.ie_rejeitado = 'L');

C02 CURSOR FOR
	SELECT	coalesce(a.vl_liquidacao,0) + CASE WHEN coalesce(ie_despesa_bancaria_w,'N')='S' THEN coalesce(a.vl_despesa_bancaria,0)  ELSE 0 END ,
		pls_obter_se_tit_baixa_inad(a.nr_titulo),
		a.nr_titulo,
		a.nr_sequencia
	FROM titulo_receber_cobr a
LEFT OUTER JOIN banco_ocorr_escrit_ret c ON (a.nr_seq_ocorrencia_ret = c.nr_sequencia)
WHERE trunc(coalesce(dt_credito_bancario_w,coalesce(CASE WHEN ie_movto_bco_cobr_escrit_w='D' THEN a.dt_liquidacao  ELSE dt_baixa_p END ,clock_timestamp())),'dd')	= dt_transacao_w and a.nr_seq_cobranca		= nr_seq_cobranca_p  and (ie_somente_liquidacao_w	= 'N' or c.ie_rejeitado = 'L');

C03 CURSOR FOR
	SELECT	sum(coalesce(a.vl_liquidacao,0) + CASE WHEN c.ie_rejeitado='T' THEN 0  ELSE CASE WHEN coalesce(ie_despesa_bancaria_w,'N')='S' THEN coalesce(a.vl_despesa_bancaria,0)  ELSE 0 END  END ) vl_transacao,
		coalesce(sum(a.vl_despesa_bancaria),0) vl_despesa_bancaria,
		trunc(coalesce(	dt_credito_bancario_w,
				coalesce(	CASE WHEN 	ie_movto_bco_cobr_escrit_w='D' THEN						a.dt_liquidacao  ELSE dt_baixa_p END ,
					clock_timestamp())),'dd') dt_transacao
	FROM titulo_receber_cobr a
LEFT OUTER JOIN banco_ocorr_escrit_ret c ON (a.nr_seq_ocorrencia_ret = c.nr_sequencia)
WHERE a.nr_seq_cobranca		= nr_seq_cobranca_p  and (ie_somente_liquidacao_w 	= 'N' or c.ie_rejeitado = 'L') group by
		trunc(coalesce(dt_credito_bancario_w,coalesce(CASE WHEN ie_movto_bco_cobr_escrit_w='D' THEN a.dt_liquidacao  ELSE dt_baixa_p END ,clock_timestamp())),'dd');


BEGIN

begin
select	a.cd_estabelecimento,
	b.cd_banco,
	b.nr_sequencia,
	a.nr_seq_empresa,
	coalesce(a.ie_gerar_movto_banco, 'S'),
	trunc(a.dt_credito_bancario, 'dd')
into STRICT	cd_estabelecimento_w,
	cd_banco_w,
	nr_seq_conta_banco_w,
	nr_seq_empresa_w,
	ie_gerar_movto_banco_w,
	dt_credito_bancario_w
from	banco_estabelecimento	b,
	cobranca_escritural	a
where	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobranca_p;
exception when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(238658);
end;

select	coalesce(max(ie_dt_liq_cobr),'N')
into STRICT	ie_dt_liq_cobr_w
from	banco
where	cd_banco	= coalesce(cd_banco_w, -1)
and	ie_situacao	= 'A';

select	coalesce(max(ie_movto_bco_cobr_escrit), 'N'),
	max(a.nr_seq_trans_desp_banco),
	coalesce(max(ie_dt_baixa_cobr_escrit), 'A'),
	max(a.nr_seq_trans_cobr_escrit)
into STRICT	ie_movto_bco_cobr_escrit_w,
	nr_seq_trans_desp_banco_w,
	ie_dt_baixa_cobr_escrit_w,
	nr_seq_trans_financ_w
from	parametro_contas_receber a
where	cd_estabelecimento	= cd_estabelecimento_w;

SELECT * FROM obter_regra_acao_pag_duplic(	dt_baixa_p, cd_estabelecimento_w, nm_usuario_p, nr_seq_regra_w, ie_acao_w) INTO STRICT nr_seq_regra_w, ie_acao_w;

select	coalesce(max(ie_gerar_nc_tit_mens_canc), 'N'),
	coalesce(max(ie_gerar_nc_tit_resc), 'N'),
	max(nr_seq_trans_inadimplencia)
into STRICT	ie_gerar_nc_tit_mens_canc_w,
	ie_gerar_nc_tit_resc_w,
	nr_seq_trans_inadimplencia_w
from	pls_parametros_cr
where	cd_estabelecimento	= cd_estabelecimento_w;

if	((ie_acao_w in ('NC', 'NCM')) or (ie_gerar_nc_tit_mens_canc_w = 'S') or (ie_gerar_nc_tit_resc_w = 'S') or (nr_seq_trans_inadimplencia_w IS NOT NULL AND nr_seq_trans_inadimplencia_w::text <> '')) then
	ie_titulos_zerados_w	:= 'S';
end if;

if (coalesce(nr_seq_empresa_w,0) > 0) then /* Paulo - 31/05/2010 (OS 221085) Nao lancar movimentacao bancaria se o lote for de desconto em folha */
	ie_movto_bco_cobr_escrit_w	:= 'N';
end if;

ie_somente_liquidacao_w := obter_param_usuario(815, 11, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_somente_liquidacao_w);
ie_despesa_bancaria_w := obter_param_usuario(815, 35, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_despesa_bancaria_w);

if (coalesce(ie_tipo_carteira_p, '0') = '0') then
	update	cobranca_escritural
	set	dt_recebimento	= CASE WHEN ie_acao_p='I' THEN  coalesce(dt_baixa_p, clock_timestamp())  ELSE null END ,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_cobranca_p;
end if;


if (ie_movto_bco_cobr_escrit_w in ('C', 'D')) and /* "Movimentacao unica para a cobranca" ou "Lancar um movimento para cada data de liquidacao do arquivo" */
	(ie_gerar_movto_banco_w <> 'N') then /* Christian Theilacker -  OS 227061  -  Tratada movimentacao bancaria por lote */
	if (coalesce(nr_seq_trans_financ_w::text, '') = '') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_trans_financ_w
		from	transacao_financeira
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	ie_acao			= 20
		and	ie_situacao		= 'A';

		if (coalesce(nr_seq_trans_financ_w::text, '') = '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_trans_financ_w
			from	transacao_financeira
			where	coalesce(cd_estabelecimento::text, '') = ''
			and	ie_acao			= 20
			and	ie_situacao		= 'A';
	
			if (coalesce(nr_seq_trans_financ_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(204131);
			end if;
		end if;

	end if;
	
	open C03;
	loop
	fetch C03 into
		vl_transacao_w,
		vl_despesa_bancaria_w,
		dt_transacao_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
	
		/* Fazer um select do valor dos recebimentos de inadimplencia e descontar do valor total */

		if (nr_seq_trans_inadimplencia_w IS NOT NULL AND nr_seq_trans_inadimplencia_w::text <> '') then
			open C02;
			loop
			fetch C02 into	
				vl_descontar_w,
				ie_inadimplente_w,
				nr_titulo_w,
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				if (ie_inadimplente_w = 'S') then
					vl_descontar_ww	:= vl_descontar_ww + vl_descontar_w;
				end if;
				end;
			end loop;
			close C02;
		end if;
	
		vl_transacao_w	:= vl_transacao_w - vl_descontar_ww;
	
		if (nr_seq_trans_desp_banco_w IS NOT NULL AND nr_seq_trans_desp_banco_w::text <> '') and (coalesce(vl_despesa_bancaria_w, 0) <> 0) then
			select	nextval('movto_trans_financ_seq')
			into STRICT	nr_seq_movto_w
			;

			insert into movto_trans_financ(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nr_seq_trans_financ,
				vl_transacao,
				nr_seq_banco,
				dt_transacao,
				ie_conciliacao,
				nr_lote_contabil,
				dt_referencia_saldo)
			values (nr_seq_movto_w,
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_trans_desp_banco_w,
				CASE WHEN ie_acao_p='I' THEN  vl_despesa_bancaria_w  ELSE vl_despesa_bancaria_w * -1 END ,
				nr_seq_conta_banco_w,
				dt_transacao_w,
				'N',
				0,
				trunc(coalesce(dt_baixa_p, trunc(clock_timestamp(), 'dd')),'month'));

			CALL atualizar_transacao_financeira(	cd_estabelecimento_w,
							nr_seq_movto_w,
							nm_usuario_p,
							ie_acao_p);

			vl_transacao_w	:= coalesce(vl_transacao_w, 0) /*+ nvl(vl_despesa_bancaria_w, 0)*/;
		end if;

		select	nextval('movto_trans_financ_seq')
		into STRICT	nr_seq_movto_w
		;

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
		values (nr_seq_movto_w,
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_trans_financ_w,
			CASE WHEN ie_acao_p='I' THEN  vl_transacao_w  ELSE vl_transacao_w * -1 END ,
			nr_seq_conta_banco_w,
			dt_transacao_w,
			'N',
			0,
			nr_seq_cobranca_p,
			trunc(coalesce(dt_baixa_p, trunc(clock_timestamp(), 'dd')),'month'));

		CALL atualizar_transacao_financeira(	cd_estabelecimento_w,
						nr_seq_movto_w,
						nm_usuario_p,
						ie_acao_p);

	end loop;
	close C03;
else
	open C01;
	loop
	fetch C01 into
		nr_sequencia_w,
		nr_titulo_w,
		vl_credito_w,
		vl_desconto_w,
		vl_acrescimo_w,
		vl_juros_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		
		ie_gerar_baixa_w	:= 'S';
		
		if (vl_credito_w <> 0) or (vl_desconto_w <> 0) or (vl_acrescimo_w <> 0) or (vl_juros_w <> 0) then
			if (ie_gerar_baixa_w = 'S') then /* OS - 309605 - Ha situacoes onde a baixa nao sera gerada */
				CALL baixar_titulo_rec_cobr(nr_sequencia_w,ie_acao_p,nm_usuario_p,coalesce(dt_credito_bancario_w,dt_baixa_p),null);

				select	max(nr_sequencia)
				into STRICT	nr_seq_baixa_w
				from	titulo_receber_liq
				where	nr_titulo	= nr_titulo_w;

				if	(ie_movto_bco_cobr_escrit_w = 'S' AND nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') and (ie_gerar_movto_banco_w <> 'N') then /* Christian Theilacker -  OS 227061  -  Tratada movimentacao bancaria por lote */
					CALL gerar_movto_tit_baixa(	nr_titulo_w,
								nr_seq_baixa_w,
								'R',
								nm_usuario_p,
								'N');
				end if;
			end if;
		end if;
		
	end loop;
	close C01;
end if;


if (coalesce(ie_tipo_carteira_p, '0') <> '0') then /* Se for baixa por tipo de carteira, deve gravar em uma tabela filha */
	if (ie_acao_p = 'I') and (coalesce(cd_convenio_p::text, '') = '') then /* ahoffelder - 01/06/2010 - inclui o "cd_convenio_p is null" pq o registro da baixa por convenio ja sera gerado na 

BAIXAR_TITULOS_COBRANCA_ESCRIT */
		begin
		insert into cobr_escrit_baixa(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_cobranca,
			ie_tipo_carteira,
			dt_baixa)
		values (nextval('cobr_escrit_baixa_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_cobranca_p,
			ie_tipo_carteira_p,
			coalesce(dt_baixa_p,clock_timestamp()));
		exception
		when unique_violation then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(204132,	'DS_TIPO_CARTEIRA_W=' || substr(obter_valor_dominio(3132,ie_tipo_carteira_p),1,255));
		end;

	else
		delete	from cobr_escrit_baixa
		where	nr_seq_cobranca		= nr_seq_cobranca_p
		and	ie_tipo_carteira	= ie_tipo_carteira_p;

		update	cobranca_escritural
		set	nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_cobranca_p;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_titulos_cobranca_partic ( nr_seq_cobranca_p bigint, cd_convenio_p bigint, ie_tipo_carteira_p text, dt_baixa_p timestamp, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;
