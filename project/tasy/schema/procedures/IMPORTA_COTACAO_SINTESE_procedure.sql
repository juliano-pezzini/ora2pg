-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_cotacao_sintese ( nr_cot_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cotacao_sintese_w			bigint;
cd_requisicao_w				varchar(10);
ds_obs_cotacao_w				varchar(4000);
nr_seq_fornec_sintese_w			bigint;
nr_seq_fornec_tasy_w			bigint;
cd_cnpj_w				varchar(14);
cd_condicao_pagamento_w			bigint;
ds_observacao_fornec_w			varchar(4000);
qt_registro_w				bigint;
cd_estabelecimento_w			bigint;
cd_moeda_padrao_w			bigint;
qt_prazo_entrega_w			smallint;
cd_produto_w				bigint;
qt_produto_total_w				double precision;
cd_cnpj_oferta_w				varchar(14);
ds_marca_w				varchar(30);
vl_preco_produto_w			double precision;
pr_ipi_produto_w				double precision;
ds_obs_item_fornec_w			varchar(4000);
ds_observacao_w				varchar(4000);
ds_justificativa_compra_w			varchar(255);
nr_seq_fornec_w				bigint;
nr_sequencia_item_w			bigint;
nr_item_cotacao_w				bigint;
vl_total_w				double precision := 0;
cd_tributo_w				bigint;
vl_tributo_w				double precision := 0;
ie_erro_w					varchar(1) := 'N';
ds_erro_w				varchar(255);
nr_cot_compra_w				w_sintese_cotacao.cd_requisicao%type;
ie_selecao_oferta_w			varchar(5);
nr_seq_resumo_w				bigint;
vl_unitario_liquido_w			double precision;
vl_preco_liquido_w			double precision;
vl_frete_rateio_w			double precision;
vl_presente_w				double precision;
vl_preco_w				double precision;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_fornecedor,
	a.cd_condicao_pagamento,
	a.qt_prz_minimo_entrega,
	a.ds_observacao
from	w_sintese_cot_fornec a
where	a.nr_seq_cotacao = nr_seq_cotacao_sintese_w
and exists (
	SELECT	1
	from	w_sintese_cot_prod x,
		w_sintese_cot_proposta y
	where	x.nr_sequencia = y.nr_seq_cot_prod
	and	x.nr_seq_cotacao = a.nr_seq_cotacao
	and	y.cd_fornecedor_oferta = a.cd_fornecedor);

c02 CURSOR FOR
SELECT	a.cd_produto,
	coalesce(b.qt_entrega, 0),
	b.cd_fornecedor_oferta,
	substr(b.ds_marca,1,30),
	coalesce(b.vl_preco_produto,0),
	coalesce(b.pr_ipi_produto,0),
	b.ds_observacao,
	b.ds_justificativa_compra,
	upper(b.ie_selecao_oferta)
from	w_sintese_cot_prod a,
	w_sintese_cot_proposta b
where	a.nr_sequencia = b.nr_seq_cot_prod
and	a.nr_seq_cotacao = nr_seq_cotacao_sintese_w;


BEGIN

select	max(cd_requisicao)
into STRICT	nr_cot_compra_w
from	w_sintese_cotacao
where	nr_sequencia = nr_cot_compra_p;

delete from log_sintese
where	nr_cot_compra	= nr_cot_compra_w
and	ds_entidade	= 'COTACAO';

delete from w_sintese_oc;

select	count(*)
into STRICT	qt_registro_w
from	w_sintese_cotacao
where	cd_requisicao = nr_cot_compra_w;

if (qt_registro_w > 0) then

	select	max(nr_sequencia),
		max(substr(cd_cotacao,1,10)),
		max(ds_observacao)
	into STRICT	nr_seq_cotacao_sintese_w,
		cd_requisicao_w,
		ds_obs_cotacao_w
	from	w_sintese_cotacao
	where	cd_requisicao = nr_cot_compra_w;

	if (coalesce(cd_requisicao_w::text, '') = '') then
		CALL inserir_log_sintese('ERRO','COTACAO', wheb_mensagem_pck.get_texto(302903), '00007', nr_cot_compra_w, '', nm_usuario_p);
		ie_erro_w := 'S';
		ds_erro_w := wheb_mensagem_pck.get_texto(302903); /*NÃO FOI INFORMADO O CAMPO CD_COTACAO.*/
	end if;

end if;

select	count(*)
into STRICT	qt_registro_w
from	cot_compra
where	nr_cot_compra = nr_cot_compra_w;

/*Somente entra aqui se a cotação enviada pela sintese existe no Tasy*/

if (qt_registro_w > 0) then

	select	ds_observacao,
		cd_estabelecimento
	into STRICT	ds_observacao_w,
		cd_estabelecimento_w
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_w;

	select	cd_moeda_padrao
	into STRICT	cd_moeda_padrao_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		ds_observacao_w := substr(ds_observacao_w || chr(13) || chr(10) || ds_obs_cotacao_w,1,4000);
	else
		ds_observacao_w := ds_obs_cotacao_w;
	end if;


	open C01;
	loop
	fetch C01 into
		nr_seq_fornec_sintese_w,
		cd_cnpj_w,
		cd_condicao_pagamento_w,
		qt_prazo_entrega_w,
		ds_observacao_fornec_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	count(*)
		into STRICT	qt_registro_w
		from	pessoa_juridica
		where	cd_cgc = cd_cnpj_w;

		if (qt_registro_w = 0) then
			CALL inserir_log_sintese('ERRO','COTACAO', wheb_mensagem_pck.get_texto(302905, 'CD_CNPJ=' || cd_cnpj_w), '00008', nr_cot_compra_w, '', nm_usuario_p);
			ie_erro_w := 'S';
			ds_erro_w := wheb_mensagem_pck.get_texto(302905, 'CD_CNPJ=' || cd_cnpj_w); /*NÃO EXISTE NO TASY O CNPJ #@CD_CNPJ#@.*/
		end if;

		if (coalesce(cd_condicao_pagamento_w::text, '') = '') then
			CALL inserir_log_sintese('ERRO','COTACAO', wheb_mensagem_pck.get_texto(302906, 'CD_CNPJ=' || cd_cnpj_w), '00021', nr_cot_compra_w, '', nm_usuario_p);
			ie_erro_w := 'S';
			ds_erro_w := wheb_mensagem_pck.get_texto(302906, 'CD_CNPJ=' || cd_cnpj_w); /*NÃO VEIO CONDIÇÃO DE PAGAMENTO PARA O FORNECEDOR #@CD_CNPJ#@.*/
		else

			select	count(*)
			into STRICT	qt_registro_w
			from	condicao_pagamento
			where	cd_condicao_pagamento = cd_condicao_pagamento_w;

			if (qt_registro_w = 0) then
				CALL inserir_log_sintese('ERRO','COTACAO',wheb_mensagem_pck.get_texto(302907, 'CD_CONDICAO_PAGTO=' || cd_condicao_pagamento_w), '00009', nr_cot_compra_w, '', nm_usuario_p);
				ie_erro_w := 'S';
				ds_erro_w := wheb_mensagem_pck.get_texto(302907, 'CD_CONDICAO_PAGTO=' || cd_condicao_pagamento_w); /*NÃO EXISTE NO TASY A CONDIÇÃO DE PAGAMENTO #@CD_CONDICAO_PAGTO#@.*/
			end if;
		end if;

		select	count(*)
		into STRICT	qt_registro_w
		from	cot_compra_forn
		where	nr_cot_compra = nr_cot_compra_w
		and	cd_cgc_fornecedor = cd_cnpj_w;

		if (qt_registro_w > 0) then
			CALL inserir_log_sintese('ERRO','COTACAO', wheb_mensagem_pck.get_texto(302909, 'CD_CNPJ=' || cd_cnpj_w || ';NR_COT_COMPRA=' || nr_cot_compra_w), '00006', nr_cot_compra_w, '', nm_usuario_p);
			ie_erro_w := 'S';
			ds_erro_w := wheb_mensagem_pck.get_texto(302909, 'CD_CNPJ=' || cd_cnpj_w || ';NR_COT_COMPRA=' || nr_cot_compra_w);
				/*O FORNECEDOR #@CD_CNPJ#@ JÁ EXISTE NA COTAÇÃO #@NR_COT_COMPRA#@.*/

		end if;

		if (ie_erro_w = 'N') then

			select	nextval('cot_compra_forn_seq')
			into STRICT	nr_seq_fornec_tasy_w
			;

			insert into cot_compra_forn(
				nr_cot_compra,
				cd_cgc_fornecedor,
				cd_condicao_pagamento,
				cd_moeda,
				ie_frete,
				dt_atualizacao,
				nm_usuario,
				vl_previsto_frete,
				dt_documento,
				qt_dias_entrega,
				ds_observacao,
				nr_sequencia,
				vl_desconto,
				ie_liberada_internet,
				ie_status_envio_email_lib)
			values (	nr_cot_compra_w,
				cd_cnpj_w,
				cd_condicao_pagamento_w,
				cd_moeda_padrao_w,
				'C',
				clock_timestamp(),
				nm_usuario_p,
				0,
				trunc(clock_timestamp(),'dd'),
				qt_prazo_entrega_w,
				ds_observacao_fornec_w,
				nr_seq_fornec_tasy_w,
				0,'N','N');
		end if;
		end;
	end loop;
	close C01;

	if (ie_erro_w = 'N') then

		open C02;
		loop
		fetch C02 into
			cd_produto_w,
			qt_produto_total_w,
			cd_cnpj_oferta_w,
			ds_marca_w,
			vl_preco_produto_w,
			pr_ipi_produto_w,
			ds_obs_item_fornec_w,
			ds_justificativa_compra_w,
			ie_selecao_oferta_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_fornec_tasy_w
			from	cot_compra_forn
			where	nr_cot_compra = nr_cot_compra_w
			and	cd_cgc_fornecedor = cd_cnpj_oferta_w;

			if (nr_seq_fornec_tasy_w > 0) then

				select	coalesce(min(a.nr_item_cot_compra),0)
				into STRICT	nr_item_cotacao_w
				from	cot_compra_item a
				where	a.nr_cot_compra	= nr_cot_compra_w
				and	a.cd_material = cd_produto_w
				and not exists (	SELECT	b.nr_item_cot_compra
							from	cot_compra_forn_item b
							where	b.nr_cot_compra = nr_cot_compra_w
							and	b.nr_seq_cot_forn = nr_seq_fornec_tasy_w
							and	b.nr_item_cot_compra = a.nr_item_cot_compra);


				if (nr_item_cotacao_w > 0) then

					update	cot_compra_item
					set	ie_situacao		= 'A',
						ds_motivo_venc_alt	= ds_justificativa_compra_w
					where	nr_cot_compra 		= nr_cot_compra_w
					and	nr_item_cot_compra 	= nr_item_cotacao_w;

					if (qt_produto_total_w = 0) then

						select	qt_material
						into STRICT	qt_produto_total_w
						from	cot_compra_item
						where	nr_cot_compra		= nr_cot_compra_w
						and	nr_item_cot_compra	= nr_item_cotacao_w;

					end if;

					vl_total_w	:= qt_produto_total_w * vl_preco_produto_w;

					select	nextval('cot_compra_forn_item_seq')
					into STRICT	nr_sequencia_item_w
					;

					insert into cot_compra_forn_item(
						nr_sequencia,
						nr_seq_cot_forn,
						nr_cot_compra,
						nr_item_cot_compra,
						cd_cgc_fornecedor,
						qt_material,
						vl_unitario_material,
						dt_atualizacao,
						nm_usuario,
						vl_preco_liquido,
						vl_total_liquido_item,
						ie_situacao,
						ds_marca,
						ds_marca_fornec,
						cd_material,
						ds_observacao)
					values (	nr_sequencia_item_w,
						nr_seq_fornec_tasy_w,
						nr_cot_compra_w,
						nr_item_cotacao_w,
						cd_cnpj_oferta_w,
						qt_produto_total_w,
						vl_preco_produto_w,
						clock_timestamp(),
						nm_usuario_p,
						vl_total_w,
						vl_total_w,
						'A',
						ds_marca_w,
						ds_marca_w,
						cd_produto_w,
						ds_obs_item_fornec_w);


					if (pr_ipi_produto_w > 0) then

						select	coalesce(min(cd_tributo),0)
						into STRICT	cd_tributo_w
						from	tributo
						where	ie_situacao		= 'A'
						and	ie_tipo_tributo		= 'IPI'
						and	ie_corpo_item		= 'I';

						if (cd_tributo_w > 0) then

							vl_tributo_w	:= 0;
							vl_tributo_w	:= (dividir(pr_ipi_produto_w,100) * vl_total_w);

							insert into cot_compra_forn_item_tr(
								nr_cot_compra,
								nr_item_cot_compra,
								cd_cgc_fornecedor,
								cd_tributo,
								pr_tributo,
								vl_tributo,
								dt_atualizacao,
								nm_usuario,
								nr_sequencia,
								nr_seq_cot_item_forn,
								dt_atualizacao_nrec,
								nm_usuario_nrec)
							values (	nr_cot_compra_w,
								nr_item_cotacao_w,
								cd_cnpj_oferta_w,
								cd_tributo_w,
								pr_ipi_produto_w,
								vl_tributo_w,
								clock_timestamp(),
								nm_usuario_p,
								nextval('cot_compra_forn_item_tr_seq'),
								nr_sequencia_item_w,
								clock_timestamp(),
								nm_usuario_p);
						end if;
					end if;

					CALL calcular_cot_compra_liquida(nr_cot_compra_w, nm_usuario_p);

					if (ie_selecao_oferta_w = 'SIM') then
						select	a.vl_unitario_liquido,
							a.vl_preco_liquido,
							a.vl_frete_rateio,
							a.vl_presente,
							a.vl_preco
						into STRICT	vl_unitario_liquido_w,
							vl_preco_liquido_w,
							vl_frete_rateio_w,
							vl_presente_w,
							vl_preco_w
						from	cot_compra_forn_item a
						where	a.nr_sequencia		= nr_sequencia_item_w;

						select	nextval('cot_compra_resumo_seq')
						into STRICT	nr_seq_resumo_w
						;

						insert into cot_compra_resumo(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_cot_compra,
							nr_item_cot_compra,
							nr_seq_cot_forn,
							nr_seq_cot_item_forn,
							qt_material,
							vl_unitario_material,
							vl_unitario_liquido,
							vl_preco_liquido,
							vl_frete_rateio,
							vl_presente,
							vl_preco,
							qt_prioridade,
							pr_desconto,
							vl_unid_fornec)
						values ( nr_seq_resumo_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_cot_compra_w,
							nr_item_cotacao_w,
							nr_seq_fornec_tasy_w,
							nr_sequencia_item_w,
							qt_produto_total_w,
							vl_preco_produto_w,
							vl_unitario_liquido_w,
							vl_preco_liquido_w,
							vl_frete_rateio_w,
							vl_presente_w,
							vl_preco_w,
							100,
							null,
							null);
					end if;

				end if;
			end if;

			end;
		end loop;
		close C02;
	end if;


	update	cot_compra
	set	nr_documento_externo	= cd_requisicao_w,
		ds_observacao		= ds_observacao_w
	where	nr_cot_compra		= nr_cot_compra_w;
else
		CALL inserir_log_sintese('ERRO','COTACAO', wheb_mensagem_pck.get_texto(302911, 'NR_COT_COMPRA=' || nr_cot_compra_w), '00005', nr_cot_compra_w, '', nm_usuario_p);
		ie_erro_w := 'S';
end if;

select	count(*)
into STRICT	qt_registro_w
from	cot_compra_forn
where	nr_cot_compra = nr_cot_compra_w;

if (qt_registro_w > 0) and (ie_erro_w = 'N') then
	CALL inserir_log_sintese('OK','COTACAO', wheb_mensagem_pck.get_texto(302913, 'NR_COT_COMPRA=' || nr_cot_compra_w), '', nr_cot_compra_w, '', nm_usuario_p);
	begin
	CALL gerar_historico_cotacao(nr_cot_compra_w, wheb_mensagem_pck.get_texto(302914) /*Cotação importada com sucesso*/
,
				wheb_mensagem_pck.get_texto(302915) /*Cotação importada com sucesso do portal Sintese.*/
, 'S', nm_usuario_p);
	exception
	when others then
		ds_erro_w := ds_erro_w;
	end;

elsif (ie_erro_w = 'S') then
	delete from cot_compra_forn where nr_cot_compra = nr_cot_compra_w;
	begin
	CALL gerar_historico_cotacao(nr_cot_compra_w, wheb_mensagem_pck.get_texto(302916),
				wheb_mensagem_pck.get_texto(302917, 'DS_ERRO=' || ds_erro_w),'S',nm_usuario_p);
	exception
	when others then
		ds_erro_w := ds_erro_w;
	end;
end if;

delete from w_sintese_cotacao
where	nr_sequencia = nr_cot_compra_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_cotacao_sintese ( nr_cot_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

