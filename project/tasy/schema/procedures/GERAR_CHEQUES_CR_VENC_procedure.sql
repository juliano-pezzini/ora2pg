-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cheques_cr_venc (nr_cheque_inicial_p text, cd_pessoa_fisica_p text, cd_cgc_p text, vl_total_p bigint, cd_condicao_pagamento_p bigint, cd_banco_p bigint, cd_agencia_p text, nr_conta_p text, dt_base_p timestamp, ds_observacao_p text, cd_estabelecimento_p bigint, ie_origem_cheque_p text, qt_parcelas_p bigint, qt_dias_parcela_p bigint, ie_arredonda_p text, nr_seq_trans_caixa_p bigint, nr_seq_caixa_rec_p bigint, nm_usuario_p text, nr_adiantamento_p bigint, ie_venc_util_p text, ie_lido_p text, cd_moeda_p bigint default null, vl_cotacao_p bigint default null, vl_total_estrang_p bigint default null) AS $body$
DECLARE


tx_fracao_parcela_w	double precision	:= 0;
nr_cheque_w		numeric(20);
nr_seq_cheque_w		bigint;
ds_vencimentos_w	varchar(2000);
dt_vencimento_w		timestamp;
vl_vencimento_w		double precision	:= 0;
qt_vencimentos_w	integer;
cont_w			integer;
qt_cheques_gerados_w	integer := 0;
vl_dizima_w		double precision;
ie_lib_caixa_w		varchar(1):= 'S';
ie_cheque_cr_w		varchar(2):= 'N';
dt_recebimento_w	timestamp;
cd_tipo_portador_w	integer;
cd_portador_w		bigint;
dt_venc_util_w		timestamp;
cd_banco_w		w_cheque_cr.cd_banco%type;
cd_agencia_bancaria_w	varchar(8);
nr_conta_w		varchar(20);
cd_camara_w		varchar(5);
nr_seq_camara_w		bigint;
nr_seq_w_cheque_cr_w	bigint;
ds_nr_cheque_w		varchar(20);
ds_cmc7_w		varchar(255);
pr_taxa_juro_padrao_w	double precision	:= null;
pr_taxa_multa_padrao_w	double precision	:= null;
cd_tipo_taxa_juro_w	bigint	:= null;
cd_tipo_taxa_multa_w	bigint	:= null;
/* Projeto Multimoeda - Variaveis */

vl_venc_estrang_w	double precision;
vl_complemento_w	double precision;
vl_cotacao_w		cotacao_moeda.vl_cotacao%type;
cd_moeda_estrang_w	integer;
cd_moeda_empresa_w	integer;
ie_moeda_estrang_w	boolean := false;
vl_dizima_estrang_w	double precision;

c01 CURSOR FOR
SELECT	tx_fracao_parcela
from	parcela
where	cd_condicao_pagamento = cd_condicao_pagamento_p
order by nr_parcela;


BEGIN
nr_cheque_w	:= somente_numero(nr_cheque_inicial_p);

/* Projeto Multimoeda - Busca a moeda padrao da empresa para verificar se o cheque sera gerado em moeda estrangeira ou moeda nacional.
		Caso seja moeda estrangeira, ira calcular os valores em moeda estrangeira da mesma forma que e feito em moeda nacional
		para gravar os cheques em moeda estrangeira. Caso seja moeda nacional ira limpar as variaveis antes de gravar os cheques. */
select	obter_moeda_padrao_empresa(cd_estabelecimento_p,'E')
into STRICT	cd_moeda_empresa_w
;
if (cd_moeda_p IS NOT NULL AND cd_moeda_p::text <> '') then
	cd_moeda_estrang_w := cd_moeda_p;
else
	cd_moeda_estrang_w := cd_moeda_empresa_w;
end if;
if (coalesce(cd_moeda_estrang_w,cd_moeda_empresa_w) <> cd_moeda_empresa_w) then
	if (coalesce(vl_total_estrang_p,0) <> 0 and coalesce(vl_cotacao_p,0) <> 0) then
		ie_moeda_estrang_w := true;
	else
		ie_moeda_estrang_w := false;
	end if;
else
	ie_moeda_estrang_w := false;
end if;

if (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') then
	ie_lib_caixa_w	:= 'N';

	select	dt_recebimento
	into STRICT	dt_recebimento_w
	from	caixa_receb
	where	nr_sequencia	= nr_seq_caixa_rec_p;
end if;

select	max(pr_juro_padrao),
	max(pr_multa_padrao),
	max(cd_tipo_taxa_juro),
	max(cd_tipo_taxa_multa)
into STRICT	pr_taxa_juro_padrao_w,
	pr_taxa_multa_padrao_w,
	cd_tipo_taxa_juro_w,
	cd_tipo_taxa_multa_w
from	parametro_contas_receber
where	cd_estabelecimento	= cd_estabelecimento_p;

if (cd_condicao_pagamento_p IS NOT NULL AND cd_condicao_pagamento_p::text <> '') then
	begin
	SELECT * FROM Calcular_Vencimento(
		cd_estabelecimento_p, cd_condicao_pagamento_p, dt_base_p, qt_vencimentos_w, ds_vencimentos_w) INTO STRICT qt_vencimentos_w, ds_vencimentos_w;

	open c01;
	loop
	fetch c01 into
		tx_fracao_parcela_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		dt_vencimento_w	:= To_Date(substr(ds_vencimentos_w,1,10),'dd/mm/yyyy');
		ds_vencimentos_w	:= substr(ds_vencimentos_w,12, length(ds_vencimentos_w));		
		vl_vencimento_w	:= dividir((vl_total_p * tx_fracao_parcela_w),100);
		/* Projeto Multimoeda - Quando cheque em moeda estrangeira, calcula os valores para gravar no cheque, caso contrario limpa as variaveis.*/

		if (ie_moeda_estrang_w = true) then
			vl_cotacao_w := vl_cotacao_p;
			vl_venc_estrang_w := dividir((vl_total_estrang_p * tx_fracao_parcela_w),100);
			vl_vencimento_w := vl_venc_estrang_w * vl_cotacao_w;
			vl_complemento_w := vl_vencimento_w - vl_venc_estrang_w;
		else
			vl_venc_estrang_w := null;
			vl_complemento_w := null;
			vl_cotacao_w := null;
		end if;

		select	nextval('cheque_cr_seq')
		into STRICT	nr_seq_cheque_w
		;

		if (nr_seq_trans_caixa_p IS NOT NULL AND nr_seq_trans_caixa_p::text <> '') then
			select	coalesce(ie_cheque_cr,'N'),
				cd_tipo_portador,
				cd_portador
			into STRICT	ie_cheque_cr_w,
				cd_tipo_portador_w,
				cd_portador_w
			from	transacao_financeira
			where	nr_sequencia	= nr_seq_trans_caixa_p;

			if (ie_cheque_cr_w = 'V') then
				if (PKG_DATE_UTILS.start_of(dt_vencimento_w,'dd', 0) > PKG_DATE_UTILS.start_of(clock_timestamp(),'dd', 0)) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265330,'');
					--Mensagem: A transacao selecionada e a vista e a data de vencimento e maior que a atual!
				end if;
			end if;
		end if;
		
		/* Francisco - OS 65267 - 13/08/07 - Tratamento dia util */

		if (ie_venc_util_p = 'S') then
			dt_venc_util_w	:= obter_proximo_dia_util(cd_estabelecimento_p,dt_vencimento_w);
		end if;

		if (ie_lido_p	= 'S') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_w_cheque_cr_w
			from	w_cheque_cr a
			where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p
			and	coalesce(dt_geracao::text, '') = ''
			and	nr_cheque	=	(SELECT	min(x.nr_cheque)
							from	w_cheque_cr x
							where	x.nr_seq_caixa_rec = a.nr_seq_caixa_rec
							and	coalesce(x.dt_geracao::text, '') = '');		

			if (nr_seq_w_cheque_cr_w IS NOT NULL AND nr_seq_w_cheque_cr_w::text <> '') then
				select	cd_banco,
					cd_agencia_bancaria,
					nr_conta,
					cd_camara,
					nr_cheque,
					ds_cmc7
				into STRICT	cd_banco_w,
					cd_agencia_bancaria_w,
					nr_conta_w,
					cd_camara_w,
					ds_nr_cheque_w,
					ds_cmc7_w
				from	w_cheque_cr
				where	nr_sequencia	= nr_seq_w_cheque_cr_w;

				select	max(nr_sequencia)
				into STRICT	nr_seq_camara_w
				from	camara_compensacao
				where	cd_camara	= cd_camara_w;

				select	count(*)
				into STRICT	cont_w
				from	banco
				where	(cd_banco_w)::numeric 	= cd_banco;

				if (cont_w = 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265336,'TO_NUMBER=' ||(cd_banco_w)::numeric );
					--Mensagem: O banco ' || to_number(cd_banco_w) || ' nao esta cadastrado, favor verifique!
				end if;	

				select	count(*)
				into STRICT	cont_w
				from	cheque_cr
				where	cd_banco		= cd_banco_w
				and	cd_agencia_bancaria	= cd_agencia_bancaria_w
				and	nr_conta		= nr_conta_w
				and	nr_cheque		= ds_nr_cheque_w
				and	coalesce(dt_devolucao::text, '') = '';

				if (cont_w > 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265341, 'chr(13)=' ||chr(13)|| 'chr(10)=' ||chr(10)|| 'ds_cheque='||ds_nr_cheque_w);
					--Mensagem: Ja existe um cheque cadastrado com o mesmo numero para este banco/agencia/conta! || chr(13) || chr(10) || 

					--Cheque nr || ds_nr_cheque_w);
				end if;	

				insert into cheque_cr(nr_seq_cheque,
					cd_banco,
					cd_agencia_bancaria,
					nr_conta,
					nr_cheque,
					vl_cheque,
					cd_moeda,
					vl_terceiro,
				 	dt_vencimento,
				 	dt_contabil,
				 	ds_observacao,
				 	cd_pessoa_fisica,
				 	cd_cgc,
				 	dt_atualizacao,
				 	nm_usuario,
				 	cd_estabelecimento,
				 	ie_origem_cheque,
				 	ie_lib_caixa,
				 	nr_seq_trans_caixa,
				 	nr_seq_caixa_rec,
				 	nr_adiantamento,
				 	dt_vencimento_atual,
				 	cd_tipo_portador,
				 	cd_portador,
					nr_seq_camara,
					ds_cmc7,
					tx_juros_cobranca,
					tx_multa_cobranca,
					cd_tipo_taxa_juros,
					cd_tipo_taxa_multa,
					vl_cheque_estrang,
					vl_complemento,
					vl_cotacao)
				values (nr_seq_cheque_w,
					(cd_banco_w)::numeric ,
					cd_agencia_bancaria_w,
					nr_conta_w,
					ds_nr_cheque_w,
					vl_vencimento_w,
					coalesce(cd_moeda_estrang_w,obter_moeda_padrao(cd_estabelecimento_p,'R')),
					0,
					CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
					coalesce(dt_recebimento_w,clock_timestamp()),
					ds_observacao_p,
					cd_pessoa_fisica_p,
					cd_cgc_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_estabelecimento_p,
					ie_origem_cheque_p,
					ie_lib_caixa_w,
					nr_seq_trans_caixa_p,
					nr_seq_caixa_rec_p,
					nr_adiantamento_p,
					CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
					cd_tipo_portador_w,
					cd_portador_w,
					nr_seq_camara_w,
					ds_cmc7_w,
					pr_taxa_juro_padrao_w,
					pr_taxa_multa_padrao_w,
					cd_tipo_taxa_juro_w,
					cd_tipo_taxa_multa_w,
					vl_venc_estrang_w,
					vl_complemento_w,
					vl_cotacao_w);

				update	w_cheque_cr
				set	dt_geracao	= clock_timestamp()
				where	nr_sequencia	= nr_seq_w_cheque_cr_w;
			else
				wheb_mensagem_pck.exibir_mensagem_abort(265349,'');
				--Mensagem: A quantidade de cheques lidos nao confere com a quantidade de parcelas!
			end if;
		else
		
			insert into cheque_cr(nr_seq_cheque,
				cd_banco,
				cd_agencia_bancaria,
				nr_conta,
				nr_cheque,
				vl_cheque,
				cd_moeda,
				vl_terceiro,
				dt_vencimento,
				dt_contabil,
				ds_observacao,
				cd_pessoa_fisica,
				cd_cgc,
				dt_atualizacao,
				nm_usuario,
				cd_estabelecimento,
				ie_origem_cheque,
				ie_lib_caixa,
				nr_seq_trans_caixa,
				nr_seq_caixa_rec,
				nr_adiantamento,
				dt_vencimento_atual,
				cd_tipo_portador,
				cd_portador,
				tx_juros_cobranca,
				tx_multa_cobranca,
				cd_tipo_taxa_juros,
				cd_tipo_taxa_multa,
				vl_cheque_estrang,
				vl_complemento,
				vl_cotacao)
			values (nr_seq_cheque_w,
				cd_banco_p,
				cd_agencia_p,
				nr_conta_p,
				lpad(to_char(nr_cheque_w),length(nr_cheque_inicial_p),0),
				vl_vencimento_w,
				coalesce(cd_moeda_estrang_w,obter_moeda_padrao(cd_estabelecimento_p,'R')),
				0,
				CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
				coalesce(dt_recebimento_w,clock_timestamp()),
				ds_observacao_p,
				cd_pessoa_fisica_p,
				cd_cgc_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento_p,
				ie_origem_cheque_p,
				ie_lib_caixa_w,
				nr_seq_trans_caixa_p,
				nr_seq_caixa_rec_p,
				nr_adiantamento_p,
				CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
				cd_tipo_portador_w,
				cd_portador_w,
				pr_taxa_juro_padrao_w,
				pr_taxa_multa_padrao_w,
				cd_tipo_taxa_juro_w,
				cd_tipo_taxa_multa_w,
				vl_venc_estrang_w,
				vl_complemento_w,
				vl_cotacao_w);
		
			nr_cheque_w	:= nr_cheque_w + 1;

		end if;

		end;
	end loop;
	close c01;
	end;
elsif (qt_parcelas_p <> 0) then
	
	dt_vencimento_w		:= dt_base_p;

	while(qt_cheques_gerados_w < qt_parcelas_p) loop

		vl_vencimento_w		:= dividir_sem_round(vl_total_p,qt_parcelas_p);
		vl_dizima_w		:= coalesce(vl_total_p - (vl_vencimento_w * qt_parcelas_p),0);

		if (qt_dias_parcela_p IS NOT NULL AND qt_dias_parcela_p::text <> '') and (qt_cheques_gerados_w > 0) then
			dt_vencimento_w	:= dt_vencimento_w + qt_dias_parcela_p;
		elsif (coalesce(qt_dias_parcela_p::text, '') = '') and (qt_cheques_gerados_w > 0) then
			dt_vencimento_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_vencimento_w,1,0);
		end if;
		
		if (vl_dizima_w <> 0) and (ie_arredonda_p <> 'N') then
		   if (qt_cheques_gerados_w = 0 and ie_arredonda_p = 'P') or (qt_cheques_gerados_w = qt_parcelas_p - 1 and ie_arredonda_p = 'U') then
			vl_vencimento_w	:= vl_vencimento_w + vl_dizima_w;
		   end if;			
		end if;
		
		/* Projeto Multimoeda - Quando cheque em moeda estrangeira, calcula os valores para gravar no cheque, caso contrario limpa as variaveis.*/

		if (ie_moeda_estrang_w = true) then
			vl_cotacao_w 	:= vl_cotacao_p;
			vl_venc_estrang_w := dividir_sem_round(vl_total_estrang_p,qt_parcelas_p);
			vl_vencimento_w	:= vl_venc_estrang_w * vl_cotacao_w;
			vl_complemento_w := vl_vencimento_w - vl_venc_estrang_w;
			vl_dizima_estrang_w := coalesce(vl_total_estrang_p - (vl_venc_estrang_w * qt_parcelas_p),0);
			/* Verifica diferenca entre o valor de cada cheque e o valor total dos cheques, para incluir a diferenca no primeiro ou no ultimo cheque*/

			if (vl_dizima_estrang_w <> 0) and (ie_arredonda_p <> 'N') then
				if (qt_cheques_gerados_w = 0 and ie_arredonda_p = 'P') or (qt_cheques_gerados_w = qt_parcelas_p - 1 and ie_arredonda_p = 'U') then
					vl_venc_estrang_w := vl_venc_estrang_w + vl_dizima_estrang_w;
					vl_vencimento_w := vl_venc_estrang_w * vl_cotacao_w;
					vl_complemento_w := vl_vencimento_w - vl_venc_estrang_w;
				end if;
			end if;
		else
			vl_venc_estrang_w := null;
			vl_complemento_w := null;
			vl_cotacao_w := null;
		end if;

		select	nextval('cheque_cr_seq')
		into STRICT	nr_seq_cheque_w
		;

		if (nr_seq_trans_caixa_p IS NOT NULL AND nr_seq_trans_caixa_p::text <> '') then
			select	coalesce(ie_cheque_cr,'N'),
				cd_tipo_portador,
				cd_portador
			into STRICT	ie_cheque_cr_w,
				cd_tipo_portador_w,
				cd_portador_w
			from	transacao_financeira
			where	nr_sequencia	= nr_seq_trans_caixa_p;

			if (ie_cheque_cr_w = 'V') then
				if (PKG_DATE_UTILS.start_of(dt_vencimento_w,'dd', 0) > PKG_DATE_UTILS.start_of(clock_timestamp(),'dd', 0)) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265330,'');
					--Mensagem: A transacao selecionada e a vista e a data de vencimento e maior que a atual!
				end if;
			end if;
		end if;

		/* Francisco - OS 65267 - 13/08/07 - Tratamento dia util */

		dt_venc_util_w		:= dt_vencimento_w;
		if (ie_venc_util_p = 'S') then
			dt_venc_util_w	:= obter_proximo_dia_util(cd_estabelecimento_p,dt_vencimento_w);
		end if;

		if (ie_lido_p = 'S') then
						
			select	max(nr_sequencia)
			into STRICT	nr_seq_w_cheque_cr_w
			from	w_cheque_cr a
			where	nr_seq_caixa_rec	= nr_seq_caixa_rec_p
			and	coalesce(dt_geracao::text, '') = ''
			and	nr_cheque	=	(SELECT	min(x.nr_cheque)
							from	w_cheque_cr x
							where	x.nr_seq_caixa_rec = a.nr_seq_caixa_rec
							and	coalesce(x.dt_geracao::text, '') = '');				

			if (nr_seq_w_cheque_cr_w IS NOT NULL AND nr_seq_w_cheque_cr_w::text <> '') then
				select	cd_banco,
					cd_agencia_bancaria,
					nr_conta,
					cd_camara,
					nr_cheque,
					ds_cmc7
				into STRICT	cd_banco_w,
					cd_agencia_bancaria_w,
					nr_conta_w,
					cd_camara_w,
					ds_nr_cheque_w,
					ds_cmc7_w
				from	w_cheque_cr
				where	nr_sequencia	= nr_seq_w_cheque_cr_w;

				select	max(nr_sequencia)
				into STRICT	nr_seq_camara_w
				from	camara_compensacao
				where	cd_camara	= cd_camara_w;

				select	count(*)
				into STRICT	cont_w
				from	banco
				where	(cd_banco_w)::numeric 	= cd_banco;

				if (cont_w = 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265336,'TO_NUMBER=' ||(cd_banco_w)::numeric );
					--Mensagem: O banco || to_number(cd_banco_w)  || nao esta cadastrado, favor verifique!
				end if;	

				select	count(*)
				into STRICT	cont_w
				from	cheque_cr
				where	cd_banco		= cd_banco_w
				and	cd_agencia_bancaria	= cd_agencia_bancaria_w
				and	nr_conta		= nr_conta_w
				and	nr_cheque		= ds_nr_cheque_w
				and	coalesce(dt_devolucao::text, '') = '';

				if (cont_w > 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(265341, 'chr(13)=' ||chr(13)|| 'chr(10)=' ||chr(10)|| 'ds_cheque=' ||ds_nr_cheque_w);
					--Mensagem: Ja existe um cheque cadastrado com o mesmo numero para este banco/agencia/conta! || chr(13) || chr(10) || 

					--Cheque nr || ds_nr_cheque_w);
				end if;	

				insert into cheque_cr(nr_seq_cheque,
					cd_banco,
					cd_agencia_bancaria,
					nr_conta,
					nr_cheque,
					vl_cheque,
					cd_moeda,
					vl_terceiro,
				 	dt_vencimento,
				 	dt_contabil,
				 	ds_observacao,
				 	cd_pessoa_fisica,
				 	cd_cgc,
				 	dt_atualizacao,
				 	nm_usuario,
				 	cd_estabelecimento,
				 	ie_origem_cheque,
				 	ie_lib_caixa,
				 	nr_seq_trans_caixa,
				 	nr_seq_caixa_rec,
				 	nr_adiantamento,
				 	dt_vencimento_atual,
				 	cd_tipo_portador,
				 	cd_portador,
					nr_seq_camara,
					ds_cmc7,
					tx_juros_cobranca,
					tx_multa_cobranca,
					cd_tipo_taxa_juros,
					cd_tipo_taxa_multa,
					vl_cheque_estrang,
					vl_complemento,
					vl_cotacao)
				values (nr_seq_cheque_w,
					(cd_banco_w)::numeric ,
					cd_agencia_bancaria_w,
					nr_conta_w,
					ds_nr_cheque_w,
					vl_vencimento_w,
					coalesce(cd_moeda_estrang_w,obter_moeda_padrao(cd_estabelecimento_p,'R')),
					0,
					CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
					coalesce(dt_recebimento_w,clock_timestamp()),
					ds_observacao_p,
					cd_pessoa_fisica_p,
					cd_cgc_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_estabelecimento_p,
					ie_origem_cheque_p,
					ie_lib_caixa_w,
					nr_seq_trans_caixa_p,
					nr_seq_caixa_rec_p,
					nr_adiantamento_p,
					CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
					cd_tipo_portador_w,
					cd_portador_w,
					nr_seq_camara_w,
					ds_cmc7_w,
					pr_taxa_juro_padrao_w,
					pr_taxa_multa_padrao_w,
					cd_tipo_taxa_juro_w,
					cd_tipo_taxa_multa_w,
					vl_venc_estrang_w,
					vl_complemento_w,
					vl_cotacao_w);
				
				update	w_cheque_cr
				set	dt_geracao	= clock_timestamp()
				where	nr_sequencia	= nr_seq_w_cheque_cr_w;
			else
				wheb_mensagem_pck.exibir_mensagem_abort(265349,'');
				--Mensagem: A quantidade de cheques lidos nao confere com a quantidade de parcelas!
			end if;
		else
			insert into cheque_cr(nr_seq_cheque,
				cd_banco,
				cd_agencia_bancaria,
				nr_conta,
				nr_cheque,
				vl_cheque,
				cd_moeda,
				vl_terceiro,
				dt_vencimento,
				dt_contabil,
				ds_observacao,
				cd_pessoa_fisica,
				cd_cgc,
				dt_atualizacao,
				nm_usuario,
				cd_estabelecimento,
				ie_origem_cheque,
				ie_lib_caixa,
				nr_seq_trans_caixa,
				nr_seq_caixa_rec,
				nr_adiantamento,
				dt_vencimento_atual,
				cd_tipo_portador,
				cd_portador,
				tx_juros_cobranca,
				tx_multa_cobranca,
				cd_tipo_taxa_juros,
				cd_tipo_taxa_multa,
				vl_cheque_estrang,
				vl_complemento,
				vl_cotacao)
			values (nr_seq_cheque_w,
				cd_banco_p,
				cd_agencia_p,
				nr_conta_p,
				lpad(to_char(nr_cheque_w),length(nr_cheque_inicial_p),0),
				vl_vencimento_w,
				coalesce(cd_moeda_estrang_w,obter_moeda_padrao(cd_estabelecimento_p,'R')),
				0,
				CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
				coalesce(dt_recebimento_w,clock_timestamp()),
				ds_observacao_p,
				cd_pessoa_fisica_p,
				cd_cgc_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_estabelecimento_p,
				ie_origem_cheque_p,
				ie_lib_caixa_w,
				nr_seq_trans_caixa_p,
				nr_seq_caixa_rec_p,
				nr_adiantamento_p,
				CASE WHEN dt_venc_util_w=dt_vencimento_w THEN dt_vencimento_w  ELSE dt_venc_util_w END ,
				cd_tipo_portador_w,
				cd_portador_w,
				pr_taxa_juro_padrao_w,
				pr_taxa_multa_padrao_w,
				cd_tipo_taxa_juro_w,
				cd_tipo_taxa_multa_w,
				vl_venc_estrang_w,
				vl_complemento_w,
				vl_cotacao_w);
		end if;

		nr_cheque_w		:= nr_cheque_w + 1;
		qt_cheques_gerados_w	:= qt_cheques_gerados_w + 1;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cheques_cr_venc (nr_cheque_inicial_p text, cd_pessoa_fisica_p text, cd_cgc_p text, vl_total_p bigint, cd_condicao_pagamento_p bigint, cd_banco_p bigint, cd_agencia_p text, nr_conta_p text, dt_base_p timestamp, ds_observacao_p text, cd_estabelecimento_p bigint, ie_origem_cheque_p text, qt_parcelas_p bigint, qt_dias_parcela_p bigint, ie_arredonda_p text, nr_seq_trans_caixa_p bigint, nr_seq_caixa_rec_p bigint, nm_usuario_p text, nr_adiantamento_p bigint, ie_venc_util_p text, ie_lido_p text, cd_moeda_p bigint default null, vl_cotacao_p bigint default null, vl_total_estrang_p bigint default null) FROM PUBLIC;
