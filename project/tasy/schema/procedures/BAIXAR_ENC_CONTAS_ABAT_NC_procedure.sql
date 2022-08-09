-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_enc_contas_abat_nc ( dt_baixa_p timestamp, nm_usuario_p text, nr_seq_nf_p bigint) AS $body$
DECLARE


nr_titulo_pagar_w		bigint;
nr_titulo_receber_w		bigint;
vl_saldo_tit_receb_w		double precision;
vl_saldo_tit_pag_w		double precision;
cd_estabelecimento_pag_w	bigint;
ie_tipo_pagamento_pag_w		varchar(50);
nr_seq_trans_fin_baixa_pag_w	bigint;
cd_estabelecimento_receb_w	bigint;
cd_tipo_recebimento_receb_w	bigint;
nr_seq_trans_fin_baixa_receb_w	bigint;
cd_tipo_baixa_pag_w		parametros_contas_pagar.cd_tipo_baixa_padrao%type;
nr_seq_trans_abat_pag_w		parametros_contas_pagar.nr_seq_trans_fin_abat%type;
nr_seq_trans_financ_receb_w	bigint;
cd_tipo_recebimento_w		tipo_recebimento.cd_tipo_recebimento%type;
nr_seq_trans_fin_receb_w	bigint;
nr_seq_baixa_tit_pag_w		bigint;
nr_seq_liq_rec_w		bigint;
nr_estorno_pag_w		bigint;
nr_estorno_rec_w		bigint;
ie_nota_credito_w		varchar(255);
nr_seq_nf_w			bigint;
ie_nota_credito_cr_w	parametro_contas_receber.ie_nota_credito%type;
vl_nota_credito_w		titulo_receber_liq.vl_nota_credito%type;
vl_saldo_tit_w			titulo_receber.vl_saldo_titulo%type;
vl_imposto_cpa_w		titulo_pagar_baixa.vl_imposto%type;
qt_trib_w				bigint;
nr_sequencia_trib_w		titulo_receber_trib.nr_sequencia%type;
vl_tit_baixa_w			titulo_receber_trib_baixa.vl_baixa%type;
ie_gerar_baixa_trib_w	varchar(1) := 'S';
ie_generate_settlement_cn_w	operacao_nota.ie_generate_settlement_cn%type;
C01 CURSOR FOR
	SELECT	b.nr_titulo nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.cd_tipo_recebimento cd_tipo_recebimento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_receber b
	where	b.nr_seq_nf_saida	= nr_seq_nf_w	
	and	b.nr_titulo		= b.nr_titulo
	order by nr_titulo;

C02 CURSOR FOR
	SELECT	b.nr_titulo nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.ie_tipo_pagamento ie_tipo_pagamento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_pagar b
	where	b.nr_seq_nota_fiscal 	= nr_seq_nf_p
	and	b.nr_titulo		= b.nr_titulo
	order by nr_titulo;
/*AAMFIRMO OS 1085767 - 08/06/2016 - Os cursores 03 e 04 para fazer a tratativa inverso*/
	
C03 CURSOR FOR
	SELECT	b.nr_titulo nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.ie_tipo_pagamento ie_tipo_pagamento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_pagar b
	where	b.nr_seq_nota_fiscal 	= nr_seq_nf_w
	and	b.nr_titulo		= b.nr_titulo
	order by nr_titulo;
C04 CURSOR FOR
	SELECT	b.nr_titulo nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.cd_tipo_recebimento cd_tipo_recebimento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_receber b
	where	b.nr_seq_nf_saida	= nr_seq_nf_p	
	and	b.nr_titulo		= b.nr_titulo
	order by nr_titulo;	
	

BEGIN

SELECT	nr_sequencia_ref
into STRICT	nr_seq_nf_w
FROM	nota_fiscal
WHERE	nr_sequencia = nr_seq_nf_p;

select	coalesce(max(ie_nota_credito),'N'),
		coalesce(max(ie_generate_settlement_cn),'N')
into STRICT	ie_nota_credito_w,
		ie_generate_settlement_cn_w					
from	operacao_nota o,
	nota_fiscal a
where	a.nr_sequencia 		= nr_seq_nf_p
and	a.cd_operacao_nf 	= o.cd_operacao_nf;

if (ie_nota_credito_w = 'S') and
	((philips_param_pck.get_cd_pais = 2) or (ie_generate_settlement_cn_w='S')) then
	begin
		
	open C01;
	loop
	fetch C01 into
		nr_titulo_receber_w,
		vl_saldo_tit_receb_w,
		cd_estabelecimento_receb_w,
		cd_tipo_recebimento_receb_w,
		nr_seq_trans_fin_baixa_receb_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		open C02;
		loop
		fetch C02 into
			nr_titulo_pagar_w,
			vl_saldo_tit_pag_w,
			cd_estabelecimento_pag_w,
			ie_tipo_pagamento_pag_w,
			nr_seq_trans_fin_baixa_pag_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (coalesce(vl_saldo_tit_receb_w,0) <> 0) and (coalesce(vl_saldo_tit_pag_w,0) <> 0) then

				select	max(a.cd_tipo_baixa_padrao),
					max(a.nr_seq_trans_fin_abat)
				into STRICT	cd_tipo_baixa_pag_w,
					nr_seq_trans_abat_pag_w
				from	parametros_contas_pagar a
				where	a.cd_estabelecimento	= cd_estabelecimento_pag_w;

				select	coalesce(nr_seq_trans_fin_baixa_receb_w,max(a.nr_seq_trans_fin_abat))
				into STRICT	nr_seq_trans_fin_receb_w
				from	parametro_contas_receber a
				where	a.cd_estabelecimento	= cd_estabelecimento_receb_w;

				select	max(a.cd_tipo_recebimento),
					coalesce(nr_seq_trans_fin_receb_w,max(a.nr_seq_trans_fin))
				into STRICT	cd_tipo_recebimento_w,
					nr_seq_trans_financ_receb_w
				from	tipo_recebimento a
				where	a.ie_tipo_consistencia	= 12 /* tipo abatimento */
				and     ((a.cd_estabelecimento = cd_estabelecimento_receb_w) or (coalesce(a.cd_estabelecimento::text, '') = ''));
				
				select	coalesce(max(a.ie_nota_credito),'N')
				into STRICT	ie_nota_credito_cr_w
				from	parametro_contas_receber a
				where	cd_estabelecimento	= cd_estabelecimento_receb_w;

				if (coalesce(cd_tipo_recebimento_w::text, '') = '') then
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(197089);
				end if;


				if (coalesce(vl_saldo_tit_receb_w,0) > coalesce(vl_saldo_tit_pag_w,0))then

					vl_saldo_tit_receb_w := (coalesce(vl_saldo_tit_receb_w,0) - coalesce(vl_saldo_tit_pag_w,0));

					CALL Baixa_titulo_pagar( cd_estabelecimento_pag_w,
								coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
								nr_titulo_pagar_w,
								coalesce(vl_saldo_tit_pag_w,0),
								nm_usuario_p,
								coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
								null,
								null,
								dt_baixa_p,
								null);
					
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p); --Atualizar o saldo aqui, pois e nesse momento que gera o VL_IMPOSTO na baixa do titulo, e precisa dele para verificar na baixa do titulo a receber.
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);	
								
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;			
					/*Verificar se a baixa gerada no titulo a pagar gerou imposto*/
			
					select	coalesce(max(a.vl_imposto),0)
					into STRICT	vl_imposto_cpa_w
					from	titulo_pagar_baixa a
					where	a.nr_sequencia 	= nr_seq_baixa_tit_pag_w
					and		a.nr_titulo		= nr_titulo_pagar_w;	
					/*O padrao dessa variavel e S (sempre gerar). */

					if (coalesce(vl_imposto_cpa_w,0) <> 0) then
						ie_gerar_baixa_trib_w := 'S';
					else
						ie_gerar_baixa_trib_w := 'N';
					end if;
											
					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								coalesce(vl_saldo_tit_pag_w,0),
								dt_baixa_p,
								nm_usuario_p,
								null, --glosa
								null, --bordero
								null, --nr_seq_Conta_banco
								null, --vl_rec_maior_p
								null, --vl_perdas_p
								null, --nr_seq_movto_trans_fin_p
								null, --vl_baixa_pend_estrang_p
								null, --vl_cotacao_pend_p
								null, --cd_moeda_pend_p
								null, --nr_seq_lote_enc_p 
								null, --nr_seq_movto_bco_pend_p
								coalesce(ie_gerar_baixa_trib_w,'S') );
															
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_pag_w;
						vl_saldo_tit_pag_w	:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;			

					vl_saldo_tit_pag_w := 0;

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
				
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0),
						vl_recebido		= coalesce(vl_saldo_tit_pag_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;

					/*Tem que atualizar aqui de novo por causa da nota de credito que fez update em cima*/

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;	
					

					/*ajustar valor da baixa do tributo no titulo a receber, que deve ter por base o gerado no titulo a pagar*/

					select	coalesce(max(a.vl_imposto),0)
					into STRICT	vl_imposto_cpa_w
					from	titulo_pagar_baixa a
					where	a.nr_sequencia 	= nr_seq_baixa_tit_pag_w
					and		a.nr_titulo		= nr_titulo_pagar_w;
					
					if ( coalesce(vl_imposto_cpa_w,0) <> 0 ) then

						select	count(*)
						into STRICT	qt_trib_w
						from	titulo_receber_trib
						where	nr_titulo = nr_titulo_receber_w
						and		vl_tributo > 0;
						
						if (qt_trib_w = 1) then
							
							select	max(nr_sequencia)
							into STRICT	nr_sequencia_trib_w
							from	titulo_receber_trib
							where	nr_titulo = nr_titulo_receber_w
							and 	vl_tributo > 0;
						
							update	titulo_receber_trib_baixa a
							set		a.vl_baixa		 	= vl_imposto_cpa_w
							where	a.nr_seq_tit_liq	= nr_seq_liq_rec_w
							and		a.nr_titulo			= nr_titulo_receber_w
							and		a.nr_seq_tit_trib	= nr_sequencia_trib_w;
								
							select	sum(vl_baixa)
							into STRICT	vl_tit_baixa_w
							from 	titulo_receber_trib_baixa
							where 	nr_seq_tit_trib	= nr_sequencia_trib_w;

							update	titulo_receber_trib
							set		vl_saldo 		= vl_tributo - vl_tit_baixa_w
							where	nr_sequencia 	= nr_sequencia_trib_w;

							end if;
						
					end if;
					

				elsif (vl_saldo_tit_receb_w = vl_saldo_tit_pag_w) then
					CALL Baixa_titulo_pagar(	cd_estabelecimento_pag_w,
								coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
								nr_titulo_pagar_w,
								vl_saldo_tit_pag_w,
								nm_usuario_p,
								coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
								null,
								null,
								dt_baixa_p,
								null);

					vl_saldo_tit_pag_w := 0;
					
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_receb_w;
						vl_saldo_tit_receb_w:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;

					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								vl_saldo_tit_receb_w,
								dt_baixa_p,
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null);
					
					vl_saldo_tit_receb_w := 0;

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;
					
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;
					
				else

					vl_saldo_tit_pag_w := coalesce(vl_saldo_tit_pag_w,0) - coalesce(vl_saldo_tit_receb_w,0);
					
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_receb_w;
						vl_saldo_tit_w      := vl_saldo_tit_receb_w;
						vl_saldo_tit_receb_w:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;
					
					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								vl_saldo_tit_receb_w,
								dt_baixa_p,
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null);
								
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_saldo_tit_receb_w := vl_saldo_tit_w;
					end if;
								
					CALL Baixa_titulo_pagar(	cd_estabelecimento_pag_w,
							coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
							nr_titulo_pagar_w,
							vl_saldo_tit_receb_w,
							nm_usuario_p,
							coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
							null,
							null,
							dt_baixa_p,
							null);

					vl_saldo_tit_receb_w := 0;

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;
					
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;
				end if;
			end if;
			end;
		end loop;
		close C02;
		end;
	end loop;
	close C01;	

	open C03;
	loop
	fetch C03 into	
		nr_titulo_pagar_w,
		vl_saldo_tit_pag_w,
		cd_estabelecimento_pag_w,
		ie_tipo_pagamento_pag_w,
		nr_seq_trans_fin_baixa_pag_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		open C04;
		loop
		fetch C04 into	
			nr_titulo_receber_w,
			vl_saldo_tit_receb_w,
			cd_estabelecimento_receb_w,
			cd_tipo_recebimento_receb_w,
			nr_seq_trans_fin_baixa_receb_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin

			if (coalesce(vl_saldo_tit_receb_w,0) <> 0) and (coalesce(vl_saldo_tit_pag_w,0) <> 0) then

				select	max(a.cd_tipo_baixa_padrao),
					max(a.nr_seq_trans_fin_abat)
				into STRICT	cd_tipo_baixa_pag_w,
					nr_seq_trans_abat_pag_w
				from	parametros_contas_pagar a
				where	a.cd_estabelecimento	= cd_estabelecimento_pag_w;

				select	coalesce(nr_seq_trans_fin_baixa_receb_w,max(a.nr_seq_trans_fin_abat))
				into STRICT	nr_seq_trans_fin_receb_w
				from	parametro_contas_receber a
				where	a.cd_estabelecimento	= cd_estabelecimento_receb_w;

				select	max(a.cd_tipo_recebimento),
					coalesce(nr_seq_trans_fin_receb_w,max(a.nr_seq_trans_fin))
				into STRICT	cd_tipo_recebimento_w,
					nr_seq_trans_financ_receb_w
				from	tipo_recebimento a
				where	a.ie_tipo_consistencia	= 12 /* tipo abatimento */
				and     ((a.cd_estabelecimento = cd_estabelecimento_receb_w) or (coalesce(a.cd_estabelecimento::text, '') = ''));

				if (coalesce(cd_tipo_recebimento_w::text, '') = '') then
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(197089);
				end if;
				
				select	coalesce(max(a.ie_nota_credito),'N')
				into STRICT	ie_nota_credito_cr_w
				from	parametro_contas_receber a
				where	cd_estabelecimento	= cd_estabelecimento_receb_w;

				if (coalesce(vl_saldo_tit_receb_w,0) > coalesce(vl_saldo_tit_pag_w,0))then

					vl_saldo_tit_receb_w := (coalesce(vl_saldo_tit_receb_w,0) - coalesce(vl_saldo_tit_pag_w,0));

					CALL Baixa_titulo_pagar( cd_estabelecimento_pag_w,
								coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
								nr_titulo_pagar_w,
								coalesce(vl_saldo_tit_pag_w,0),
								nm_usuario_p,
								coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
								null,
								null,
								dt_baixa_p,
								null,
								null,
								null,
								null,
								null,
								nr_seq_nf_p);
								
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_pag_w;
						vl_saldo_tit_w      := vl_saldo_tit_pag_w;
						vl_saldo_tit_pag_w	:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;			
					
					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								coalesce(vl_saldo_tit_pag_w,0),
								dt_baixa_p,
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null);

					vl_saldo_tit_pag_w := 0;

					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;
					
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;			
					

				elsif (vl_saldo_tit_receb_w = vl_saldo_tit_pag_w) then

					CALL Baixa_titulo_pagar(	cd_estabelecimento_pag_w,
								coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
								nr_titulo_pagar_w,
								vl_saldo_tit_pag_w,
								nm_usuario_p,
								coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
								null,
								null,
								dt_baixa_p,
								null,
								null,
								null,
								null,
								null,
								nr_seq_nf_p);

					vl_saldo_tit_pag_w := 0;
					
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_receb_w;
						vl_saldo_tit_w      := vl_saldo_tit_receb_w;
						vl_saldo_tit_receb_w:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;						

					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								vl_saldo_tit_receb_w,
								dt_baixa_p,
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null);
					
					vl_saldo_tit_receb_w := 0;

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;
					
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;
					
				else

					vl_saldo_tit_pag_w := coalesce(vl_saldo_tit_pag_w,0) - coalesce(vl_saldo_tit_receb_w,0);
					
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_nota_credito_w	:= vl_saldo_tit_receb_w;
						vl_saldo_tit_w      := vl_saldo_tit_receb_w;
						vl_saldo_tit_receb_w:= 0;
					else
						vl_nota_credito_w	:= 0;
					end if;
					
					CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
								cd_tipo_recebimento_w,
								nr_titulo_receber_w,
								nr_seq_trans_financ_receb_w,
								vl_saldo_tit_receb_w,
								dt_baixa_p,
								nm_usuario_p,
								null,
								null,
								null,
								null,
								null);
								
					if (coalesce(ie_nota_credito_cr_w,'N') = 'S') then
						vl_saldo_tit_receb_w := vl_saldo_tit_w;
					end if;
					

					CALL Baixa_titulo_pagar(	cd_estabelecimento_pag_w,
							coalesce(ie_tipo_pagamento_pag_w, cd_tipo_baixa_pag_w),
							nr_titulo_pagar_w,
							vl_saldo_tit_receb_w,
							nm_usuario_p,
							coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
							null,
							null,
							dt_baixa_p,
							null,
							null,
							null,
							null,
							null,
							nr_seq_nf_p);

					vl_saldo_tit_receb_w := 0;

					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_baixa_tit_pag_w
					from	titulo_pagar_baixa a
					where	a.nr_titulo		= nr_titulo_pagar_w;
					
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_liq_rec_w
					from	titulo_receber_liq a
					where	a.nr_titulo	= nr_titulo_receber_w;
					
					update	titulo_receber_liq
					set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
						nr_tit_pagar	= nr_titulo_pagar_w,
						vl_nota_credito = coalesce(vl_nota_credito_w,0)
					where	nr_titulo = nr_titulo_receber_w
					and	nr_sequencia	= nr_seq_liq_rec_w;
					
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					
					update 	titulo_pagar_baixa
					set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
						nr_tit_receber = nr_titulo_receber_w
					where	nr_titulo = nr_titulo_pagar_w
					and	nr_sequencia	= nr_seq_baixa_tit_pag_w;
				end if;
			end if;
			end;
		end loop;
		close C04;
		
		end;
	end loop;
	close C03;
	
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_enc_contas_abat_nc ( dt_baixa_p timestamp, nm_usuario_p text, nr_seq_nf_p bigint) FROM PUBLIC;
