-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancelar_rec_mensalidade ( nr_seq_lote_p bigint, dt_cancelamento_p timestamp, nr_seq_motivo_canc_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_cancel_rec_mens_w	bigint;
nr_seq_mensalidade_w		bigint;
----------------------------------------------------------------------------- 
nr_titulo_w			bigint;
nr_seq_mensalidade_seg_w		bigint;
nr_seq_mensalidade_est_w		bigint;
nr_seq_mens_seg_novo_w		bigint;
nr_seq_mens_seg_item_w		bigint;
nr_seq_lote_w			bigint;
nr_seq_mens_seg_adic_w		bigint;

nr_seq_nota_fiscal_w		bigint;
ds_retorno_w			varchar(255)	:= '';
nr_nota_fiscal_w			varchar(255);
dt_contabilizacao_w		timestamp;
ie_mes_fechado_w			varchar(1);

nr_seq_regra_ctb_mensal_deb_w	bigint;
nr_seq_regra_ctb_mensal_w		bigint;
cd_conta_estorno_deb_w		varchar(20);
cd_historico_estorno_deb_w		varchar(20);
cd_conta_estorno_rec_w		varchar(20);
cd_historico_estorno_rec_w		varchar(20);

qt_cobranca_w			bigint;
nr_seq_cobranca_w		bigint;

vl_pro_rata_dia_w			double precision;
vl_antecipacao_w			double precision;
qt_beneficiarios_w			bigint;
vl_pos_estab_w			double precision;
vl_pre_estab_w			double precision;
vl_adicionais_w			double precision;
vl_coparticipacao_w		double precision;
vl_outros_w			double precision;
vl_mensalidade_w			double precision;
nr_seq_mens_trib_w		bigint;
nm_pagador_w			varchar(255);
ie_canc_titulo_cobr_escrit_w		varchar(1);
ie_considerar_dt_liq_cancel_w	varchar(1)	:= 'N';

ds_geracao_w			varchar(255);

ie_cancelamento_w			varchar(1);
ie_situacao_nota_w			varchar(1);

C00 CURSOR FOR 
	SELECT	c.nr_sequencia, 
		c.nr_seq_mensalidade, 
		substr(obter_nome_pf_pj(b.cd_pessoa_fisica, b.cd_cgc),1,255) 
	from	pls_mensalidade			a, 
		pls_contrato_pagador		b, 
		pls_cancel_rec_mensalidade	c 
	where	c.nr_seq_mensalidade	= a.nr_sequencia 
	and	a.nr_seq_pagador	= b.nr_sequencia 
	and	c.nr_seq_lote		= nr_seq_lote_p 
	and	c.ie_status		= 'C';

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_mensalidade_segurado 
	where	nr_seq_mensalidade	= nr_seq_mensalidade_w;

C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_mensalidade_seg_item 
	where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_w;

C03 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_mensalidade_seg_adic 
	where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_w;

C04 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_mensalidade_trib 
	where	nr_seq_mensalidade	= nr_seq_mensalidade_w;


BEGIN 
 
select	dt_referencia 
into STRICT	dt_contabilizacao_w 
from	pls_cancel_rec_mens_lote 
where	nr_sequencia	= nr_seq_lote_p;
 
select	pls_obter_se_mes_fechado(dt_contabilizacao_w,'T',cd_estabelecimento_p) 
into STRICT	ie_mes_fechado_w
;
 
if (ie_mes_fechado_w = 'S') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 191649, null);
end if;
 
begin 
select	coalesce(ie_considerar_dt_liq_cancel,'N') 
into STRICT	ie_considerar_dt_liq_cancel_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
exception 
when others then 
	ie_considerar_dt_liq_cancel_w	:= 'N';
end;
 
ie_canc_titulo_cobr_escrit_w := obter_param_usuario(1205, 18, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_canc_titulo_cobr_escrit_w);
 
CALL gravar_processo_longo('Cancelamento das mensalidades' ,'PLS_CANCEL_MENSALIDADE_FUTURA',0);
 
open C00;
loop 
fetch C00 into	 
	nr_seq_cancel_rec_mens_w, 
	nr_seq_mensalidade_w, 
	nm_pagador_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin 
	CALL gravar_processo_longo(nm_pagador_w,'PLS_CANCEL_MENSALIDADE_FUTURA',-1);
	 
	select	b.nr_sequencia, 
		a.ie_cancelamento 
	into STRICT	nr_seq_lote_w, 
		ie_cancelamento_w 
	from	pls_mensalidade		a, 
		pls_lote_mensalidade	b 
	where	a.nr_seq_lote	= b.nr_sequencia 
	and	a.nr_sequencia	= nr_seq_mensalidade_w;
	 
	if (ie_canc_titulo_cobr_escrit_w = 'N') then 
		select	count(*) 
		into STRICT	qt_cobranca_w 
		from	pls_mensalidade		a, 
			titulo_receber		b, 
			titulo_receber_cobr	c 
		where	b.nr_seq_mensalidade	= a.nr_sequencia 
		and	c.nr_titulo		= b.nr_titulo 
		and	a.nr_sequencia		= nr_seq_mensalidade_w;
		 
		if (qt_cobranca_w <> 0) then 
			select	max(d.nr_sequencia) 
			into STRICT	nr_seq_cobranca_w 
			from	pls_mensalidade		a, 
				titulo_receber		b, 
				titulo_receber_cobr	c, 
				cobranca_escritural	d 
			where	b.nr_seq_mensalidade	= a.nr_sequencia 
			and	c.nr_titulo		= b.nr_titulo 
			and	c.nr_seq_cobranca	= d.nr_sequencia 
			and	a.nr_sequencia		= nr_seq_mensalidade_w;
			 
			CALL wheb_mensagem_pck.exibir_mensagem_abort( 191651, 'NM_PAGADOR=' || nm_pagador_w || ';NR_SEQ_COBRANCA=' || nr_seq_cobranca_w );
		end if;
	end if;
	 
	update	pls_mensalidade 
	set	nr_seq_cobranca	 = NULL 
	where	nr_sequencia	= nr_seq_mensalidade_w 
	and	(nr_seq_cobranca IS NOT NULL AND nr_seq_cobranca::text <> '');
	 
	select	max(nr_sequencia), 
		max(somente_numero(nr_nota_fiscal)) 
	into STRICT	nr_seq_nota_fiscal_w, 
		nr_nota_fiscal_w 
	from	nota_fiscal 
	where	nr_seq_mensalidade	= nr_seq_mensalidade_w;
	 
	begin 
	select	b.nr_titulo 
	into STRICT	nr_titulo_w 
	from	pls_mensalidade	a, 
		titulo_receber	b 
	where	b.nr_seq_mensalidade	= a.nr_sequencia 
	and	a.nr_sequencia		= nr_seq_mensalidade_w;
	exception 
	when others then 
		nr_titulo_w	:= null;
	end;
	 
	if (coalesce(nr_seq_nota_fiscal_w::text, '') = '') then 
		if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then 
			CALL cancelar_titulo_receber(nr_titulo_w, 
						nm_usuario_p, 
						'N', 
						clock_timestamp());
			 
			if (ie_considerar_dt_liq_cancel_w = 'S') then 
				update	titulo_receber 
				set	dt_liquidacao	= dt_cancelamento_p 
				where	nr_titulo	= nr_titulo_w;
			end if;
		end if;
	end if;
	 
	if (nr_seq_nota_fiscal_w IS NOT NULL AND nr_seq_nota_fiscal_w::text <> '') then 
		select	ie_situacao 
		into STRICT	ie_situacao_nota_w 
		from	nota_fiscal 
		where	nr_sequencia	= nr_seq_nota_fiscal_w;
		 
		if (ie_situacao_nota_w <> '3') then 
			ds_retorno_w := consiste_estornar_nota_fiscal(	nr_seq_nota_fiscal_w, 'N', 'S', ds_retorno_w, nm_usuario_p, 'N');
			 
			if (ds_retorno_w <> '') then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 191650, 'NR_NOTA_FISCAL=' || nr_nota_fiscal_w || ';' || 'DS_RETORNO=' || ds_retorno_w );
			else 
				CALL estornar_nota_fiscal(	nr_seq_nota_fiscal_w, 
							nm_usuario_p);
				 
				if (ie_considerar_dt_liq_cancel_w = 'S') then 
					update	titulo_receber 
					set	dt_liquidacao	= dt_cancelamento_p 
					where	nr_titulo	= nr_titulo_w;
				end if;
			end if;
		end if;
	end if;
	 
	select	nextval('pls_mensalidade_seq') 
	into STRICT	nr_seq_mensalidade_est_w 
	;
	 
	insert into pls_mensalidade(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_pagador, 
		dt_referencia, 
		vl_mensalidade, 
		nr_seq_lote,ds_observacao, 
		dt_vencimento, 
		nr_seq_contrato, 
		nr_parcela, 
		ie_cancelamento, 
		dt_cancelamento, 
		nm_usuario_cancelamento, 
		nr_seq_forma_cobranca, 
		ie_apresentacao, 
		ie_tipo_formacao_preco, 
		ie_nota_titulo, 
		nr_seq_compl_pf_tel_adic, 
		nr_seq_pagador_fin, 
		qt_beneficiarios, 
		nr_seq_conta_banco, 
		ie_endereco_boleto, 
		nr_seq_compl_pj, 
		nr_seq_cancel_rec_mens, 
		nr_seq_tipo_compl_adic, 
		nr_seq_conta_banco_deb_aut) 
	(SELECT	nr_seq_mensalidade_est_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_pagador, 
		dt_referencia, 
		vl_mensalidade * -1, 
		nr_seq_lote, 
		ds_observacao, 
		dt_vencimento, 
		nr_seq_contrato, 
		nr_parcela, 
		'E', 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_forma_cobranca, 
		ie_apresentacao, 
		ie_tipo_formacao_preco, 
		ie_nota_titulo, 
		nr_seq_compl_pf_tel_adic, 
		nr_seq_pagador_fin, 
		qt_beneficiarios, 
		nr_seq_conta_banco, 
		ie_endereco_boleto, 
		nr_seq_compl_pj, 
		nr_seq_cancel_rec_mens_w, 
		nr_seq_tipo_compl_adic, 
		nr_seq_conta_banco_deb_aut 
	from	pls_mensalidade 
	where	nr_sequencia	= nr_seq_mensalidade_w);
	 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_mensalidade_seg_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		 
		select	nextval('pls_mensalidade_segurado_seq') 
		into STRICT	nr_seq_mens_seg_novo_w 
		;
		 
		delete	from pls_repasse_mens_item a 
		where	exists (SELECT	1 
				from	pls_repasse_mens	x 
				where	a.nr_seq_repasse	= x.nr_sequencia 
				and	x.nr_seq_mens_seg	= nr_seq_mensalidade_seg_w);
		 
		delete	from pls_repasse_mens 
		where	nr_seq_mens_seg = nr_seq_mensalidade_seg_w 
		and	coalesce(nr_seq_repasse::text, '') = '';
		 
		update	pls_conta_coparticipacao 
		set	nr_seq_mensalidade_seg	 = NULL, 
			ie_status_mensalidade 	= 'L', 
			dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p 
		where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_w;
		 
		update	pls_segurado_carteira 
		set	nr_seq_mensalidade_seg	 = NULL, 
			dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p 
		where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_w;
		 
		update	pls_conta_pos_estabelecido 
		set	nr_seq_mensalidade_seg	 = NULL, 
			dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p 
		where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_w;
		 
		update	pls_lancamento_mensalidade 	a 
		set	ie_situacao			= 'A', 
			a.nr_seq_mensalidade_item	 = NULL 
		where	exists (SELECT	1 
				from	pls_mensalidade_seg_item x 
				where	x.nr_seq_lancamento_mens = a.nr_sequencia 
				and	x.nr_seq_mensalidade_seg = nr_seq_mensalidade_seg_w);
				 
		update	pls_lancamento_mensalidade 
		set	nr_seq_mensalidade_item  = NULL, 
			ie_situacao		= 'A' 
		where	nr_seq_mensalidade_item in (SELECT	z.nr_sequencia 
							from	pls_mensalidade_seg_item z, 
								pls_mensalidade_segurado x 
							where	x.nr_sequencia		= z.nr_seq_mensalidade_seg 
							and	x.nr_sequencia		= nr_seq_mensalidade_seg_w);
		 
		insert into pls_mensalidade_segurado(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_segurado, 
			vl_mensalidade, 
			nr_seq_mensalidade, 
			qt_idade, 
			dt_mesano_referencia, 
			nr_parcela, 
			nr_seq_contrato, 
			nr_parcela_contrato, 
			nr_seq_intercambio, 
			nr_seq_reajuste, 
			nr_seq_segurado_preco, 
			nr_seq_plano) 
		(SELECT	nr_seq_mens_seg_novo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_segurado, 
			vl_mensalidade * -1, 
			nr_seq_mensalidade_est_w, 
			qt_idade, 
			dt_mesano_referencia, 
			nr_parcela, 
			nr_seq_contrato, 
			nr_parcela_contrato, 
			nr_seq_intercambio, 
			nr_seq_reajuste, 
			nr_seq_segurado_preco, 
			nr_seq_plano 
		from	pls_mensalidade_segurado 
		where	nr_sequencia	= nr_seq_mensalidade_seg_w);
		 
		open c02;
		loop 
		fetch c02 into 
			nr_seq_mens_seg_item_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin 
			update	pls_segurado_mensalidade 
			set	nr_seq_item_mensalidade	 = NULL, 
				ie_situacao		= 'A', 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_item_mensalidade	= nr_seq_mens_seg_item_w;
			 
			update	pls_segurado_agravo_parc 
			set	nr_seq_mensalidade_item	 = NULL, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_mensalidade_item	= nr_seq_mens_seg_item_w;
			 
			select	coalesce(max(nr_seq_regra_ctb_mensal_deb),0), 
				coalesce(max(nr_seq_regra_ctb_mensal),0) 
			into STRICT	nr_seq_regra_ctb_mensal_deb_w, 
				nr_seq_regra_ctb_mensal_w 
			from	pls_mensalidade_seg_item 
			where	nr_sequencia	= nr_seq_mens_seg_item_w;
			 
			if (nr_seq_regra_ctb_mensal_deb_w <> 0) then 
				select	cd_conta_estorno, 
					cd_historico_estorno 
				into STRICT	cd_conta_estorno_deb_w, 
					cd_historico_estorno_deb_w 
				from	pls_regra_ctb_mensal 
				where	nr_sequencia	= nr_seq_regra_ctb_mensal_deb_w;
			end if;
			if (nr_seq_regra_ctb_mensal_w <> 0) then 
				select	cd_conta_estorno, 
					cd_historico_estorno 
				into STRICT	cd_conta_estorno_rec_w, 
					cd_historico_estorno_rec_w 
				from	pls_regra_ctb_mensal 
				where	nr_sequencia	= nr_seq_regra_ctb_mensal_w;
			end if;
			 
			insert into pls_mensalidade_seg_item(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_mensalidade_seg, 
				ie_tipo_item, 
				vl_item, 
				nr_seq_preco, 
				nr_seq_reajuste, 
				nr_seq_protocolo, 
				nr_seq_conta, 
				ds_observacao, 
				cd_conta_rec, 
				cd_conta_deb, 
				cd_historico, 
				ie_tipo_mensalidade, 
				vl_pro_rata_dia, 
				vl_antecipacao, 
				nr_parcela_sca, 
				nr_seq_tipo_lanc, 
				nr_seq_vinculo_sca, 
				nr_seq_bonificacao_vinculo, 
				nr_seq_seg_preco_origem, 
				dt_retroativa, 
				nr_seq_plano, 
				dt_antecipacao, 
				dt_antecipacao_baixa, 
				qt_dias_pro_rata_dia, 
				qt_dias_antecipacao, 
				nr_seq_item_cancel, 
				vl_ato_cooperado_pro_rata, 
				vl_ato_cooperado_antec, 
				vl_ato_auxiliar_pro_rata, 
				vl_ato_auxiliar_antec, 
				vl_ato_nao_coop_pro_rata, 
				vl_ato_nao_coop_antec, 
				cd_historico_rev_antec_baixa, 
				nr_seq_processo_copartic, 
				nr_lote_contabil_cancel, 
				nr_seq_regra_acrescimo, 
				nr_seq_tipo_acrescimo, 
				vl_ato_nao_cooperado, 
				vl_ato_auxiliar, 
				vl_ato_cooperado) 
			(SELECT	nextval('pls_mensalidade_seg_item_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_mens_seg_novo_w, 
				ie_tipo_item, 
				vl_item * -1, 
				nr_seq_preco, 
				nr_seq_reajuste, 
				nr_seq_protocolo, 
				nr_seq_conta, 
				ds_observacao, 
				cd_conta_estorno_rec_w, 
				cd_conta_estorno_deb_w, 
				cd_historico_estorno_rec_w, 
				ie_tipo_mensalidade, 
				vl_pro_rata_dia *-1, 
				vl_antecipacao *-1, 
				nr_parcela_sca, 
				nr_seq_tipo_lanc, 
				nr_seq_vinculo_sca, 
				nr_seq_bonificacao_vinculo, 
				nr_seq_seg_preco_origem, 
				dt_retroativa, 
				nr_seq_plano, 
				dt_antecipacao, 
				dt_antecipacao_baixa, 
				qt_dias_pro_rata_dia, 
				qt_dias_antecipacao, 
				nr_sequencia, 
				vl_ato_cooperado_pro_rata * -1, 
				vl_ato_cooperado_antec * -1, 
				vl_ato_auxiliar_pro_rata * -1, 
				vl_ato_auxiliar_antec * -1, 
				vl_ato_nao_coop_pro_rata * -1, 
				vl_ato_nao_coop_antec * -1, 
				cd_historico_rev_antec_baixa, 
				nr_seq_processo_copartic, 
				nr_lote_contabil_cancel, 
				nr_seq_regra_acrescimo, 
				nr_seq_tipo_acrescimo, 
				vl_ato_nao_cooperado * -1, 
				vl_ato_auxiliar * -1, 
				vl_ato_cooperado * -1 
			from	pls_mensalidade_seg_item 
			where	nr_sequencia	= nr_seq_mens_seg_item_w);
			end;
		end loop;
		close c02;
		 
		open C03;
		loop 
		fetch C03 into	 
			nr_seq_mens_seg_adic_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			insert into pls_mensalidade_seg_adic(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_mensalidade_seg, 
				nr_seq_tipo_lanc, 
				vl_adicional, 
				nr_seq_trans_financ, 
				ds_observacao) 
			(SELECT	nextval('pls_mensalidade_seg_adic_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_mens_seg_novo_w, 
				nr_seq_tipo_lanc, 
				vl_adicional * -1, 
				nr_seq_trans_financ, 
				null 
			from	pls_mensalidade_seg_adic 
			where	nr_sequencia	= nr_seq_mens_seg_adic_w);
			end;
		end loop;
		close C03;
	end loop;
	close c01;
	 
	open C04;
	loop 
	fetch C04 into	 
		nr_seq_mens_trib_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin 
		insert into pls_mensalidade_trib(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_tributo, 
			tx_tributo, 
			vl_tributo, 
			vl_base_calculo, 
			vl_trib_nao_retido, 
			vl_base_nao_retido, 
			vl_trib_adic, 
			vl_base_adic, 
			nr_seq_mensalidade) 
		(SELECT	nextval('pls_mensalidade_trib_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_tributo, 
			tx_tributo, 
			vl_tributo * -1, 
			vl_base_calculo * -1, 
			vl_trib_nao_retido * -1, 
			vl_base_nao_retido * -1, 
			vl_trib_adic * -1, 
			vl_base_adic * -1, 
			nr_seq_mensalidade_est_w 
		from	pls_mensalidade_trib 
		where	nr_sequencia	= nr_seq_mens_trib_w);
		end;
	end loop;
	close C04;
	 
	update	pls_pagador_amortizacao 
	set	nr_seq_mensalidade	 = NULL 
	where	nr_seq_mensalidade	= nr_seq_mensalidade_w;
	 
	update	pls_mensalidade 
	set	ie_cancelamento 	= 'C', 
		dt_cancelamento		= dt_cancelamento_p, 
		nr_seq_motivo_canc	= nr_seq_motivo_canc_p, 
		ds_observacao		= substr(CASE WHEN ds_observacao = NULL THEN null  ELSE ds_observacao || chr(13) || chr(10) END  || ds_observacao_p,1,255), 
		nm_usuario_cancelamento	= nm_usuario_p 
	where	nr_sequencia		= nr_seq_mensalidade_w;
	 
	select	sum(a.vl_pro_rata_dia), 
		sum(a.vl_antecipacao), 
		sum(a.qt_beneficiarios), 
		sum(a.vl_pos_estabelecido), 
		sum(a.vl_pre_estabelecido), 
		sum(a.vl_adicionais), 
		sum(a.vl_coparticipacao), 
		sum(a.vl_outros), 
		sum(a.vl_mensalidade) 
	into STRICT	vl_pro_rata_dia_w, 
		vl_antecipacao_w, 
		qt_beneficiarios_w, 
		vl_pos_estab_w, 
		vl_pre_estab_w, 
		vl_adicionais_w, 
		vl_coparticipacao_w, 
		vl_outros_w, 
		vl_mensalidade_w 
	from	pls_mensalidade		a 
	where	a.nr_sequencia	= nr_seq_mensalidade_w;
	 
	update	pls_lote_mensalidade 
	set	vl_pro_rata_dia		= coalesce(vl_pro_rata_dia,0) - coalesce(vl_pro_rata_dia_w,0), 
		vl_antecipacao		= coalesce(vl_antecipacao,0) - coalesce(vl_antecipacao_w,0), 
		qt_beneficiario_lote	= coalesce(qt_beneficiario_lote,0) - coalesce(qt_beneficiarios_w,0), 
		vl_pos_estabelecido	= coalesce(vl_pos_estabelecido,0) - coalesce(vl_pos_estab_w,0), 
		vl_pre_estabelecido	= coalesce(vl_pre_estabelecido,0) - coalesce(vl_pre_estab_w,0), 
		vl_adicionais		= coalesce(vl_adicionais,0) - coalesce(vl_adicionais_w,0), 
		vl_coparticipacao	= coalesce(vl_coparticipacao,0) - coalesce(vl_coparticipacao_w,0), 
		vl_outros		= coalesce(vl_outros,0) - coalesce(vl_outros_w,0), 
		vl_lote			= coalesce(vl_lote,0) - coalesce(vl_mensalidade_w,0), 
		qt_pagadores_lote	= coalesce(qt_pagadores_lote,0) - 1 
	where	nr_sequencia		= nr_seq_lote_w;
	 
	CALL pls_gravar_historico_mens(nr_seq_mensalidade_w, 'C', 'N', cd_estabelecimento_p, nm_usuario_p);
	 
	update	pls_cancel_rec_mensalidade 
	set	ie_status	= 'D' 
	where	nr_sequencia	= nr_seq_cancel_rec_mens_w;
	end;
end loop;
close C00;
 
update	pls_cancel_rec_mens_lote 
set	ie_status		= 'D', 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp(), 
	dt_cancelamento		= clock_timestamp() 
where	nr_sequencia		= nr_seq_lote_p;
 
CALL pls_atualizar_codificacao_pck.pls_atualizar_codificacao(dt_cancelamento_p);
/* Atualizar as contas contábeis */
 
CALL ctb_pls_atualizar_cancel_mens(	nr_seq_lote_p, 
				null, 
				null, 
				nm_usuario_p, 
				cd_estabelecimento_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancelar_rec_mensalidade ( nr_seq_lote_p bigint, dt_cancelamento_p timestamp, nr_seq_motivo_canc_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

