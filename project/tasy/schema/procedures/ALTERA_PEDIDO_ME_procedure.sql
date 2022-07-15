-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_pedido_me ( nr_ordem_compra_p text, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w			integer;
ie_erro_w			varchar(1) := 'N';

codigofornecedor_w		varchar(20);
dataprevistaentrega_w		timestamp;
codigocondicaopagamento_w	varchar(20);
observacao_w			varchar(4000);
valorfrete_w			double precision;
tipofrete_w			varchar(20);
numeropedidome_w		varchar(20);
filial_w			varchar(50);
nr_seq_pedido_w			bigint;
nr_seq_item_w			bigint;
qt_regra_fabric_mat_w		bigint;

codigoproduto_w			varchar(50);
prazoentrega_w			timestamp;
quantidade_w			double precision;
quantidade_ww			double precision;
qt_fator_w			double precision;
qt_total_w			double precision;
qt_total_ww			double precision;
valorunitario_w			double precision;
percentualdesconto_w		double precision;
percentualipi_w			double precision;
valornormal_w			double precision;
codigounidade_w			varchar(30);
fabricante_w			varchar(50);
qt_diferenca_w			double precision;

cd_estabelecimento_w		bigint;
cd_condicao_pagamento_w		bigint;
cd_material_w			bigint;
cd_unidade_medida_w		varchar(30);
vl_item_liquido_w		double precision;
nr_item_oci_w			bigint;
cd_tributo_w			bigint;
vl_tributo_w			double precision;

data_w				timestamp;
quant_w				double precision;

nr_seq_fabric_int_w		bigint;
nr_seq_fabric_mat_w		bigint;

nr_ordem_compra_w		ordem_compra.nr_ordem_compra%type;
nr_ordem_compra_ww		ordem_compra.nr_ordem_compra%type;
nr_item_oci_ww			ordem_compra_item.nr_item_oci%type;
nr_seq_oci_entrega_w	ordem_compra_item_entrega.nr_sequencia%type;
nr_sequencia_w			w_me_altera_pedido.nr_sequencia%type;
qt_registros_w			bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		codigoproduto,
		prazoentrega,
		quantidade,
		valorunitario,
		percentualdesconto,
		percentualipi,
		valornormal,
		codigounidade,
		observacao,
		fabricante
	from	w_me_altera_pedido_item
	where	nr_seq_pedido = nr_seq_pedido_w;

c02 CURSOR FOR
	SELECT	nr_item_oci
	from	ordem_compra_item
	where	nr_ordem_compra = substr(nr_ordem_compra_p||'@',1,position('@'  nr_ordem_compra_p||'@')-1)
	and	cd_material = cd_material_w;

c03 CURSOR FOR
	SELECT	pkg_date_utils.start_of(data, 'DD', null),
		quantidade
	from	w_me_altera_ped_item_ent
	where	nr_seq_item = nr_seq_item_w;

c04 CURSOR FOR
	SELECT	qt_material,
		nr_ordem_compra,
		nr_item_oci
	from	ordem_compra_item
	where	nr_ordem_compra = substr(nr_ordem_compra_p||'@',1,position('@'  nr_ordem_compra_p||'@')-1)
	and	cd_material = cd_material_w;


BEGIN


select	substr(nr_ordem_compra_p||'@',1,position('@' in nr_ordem_compra_p||'@')-1)
into STRICT	nr_ordem_compra_ww
;


select	count(*)
into STRICT	qt_existe_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_ww;

if (qt_existe_w = 0) then
	ie_erro_w := 'S';
	/*Não existe OC no Tasy. OC nº #@NR_ORDEM_COMPRA#@.*/

	CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297067,'NR_ORDEM_COMPRA=' || nr_ordem_compra_ww), '000001', nm_usuario_p,'A','');
end if;

if (ie_erro_w = 'N') then

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	w_me_altera_pedido
	where	somente_numero(numeropedidowpd) = nr_ordem_compra_ww
	and 	ie_lido = 'N';

	select	codigofornecedor,
		dataprevistaentrega,
		codigocondicaopagamento,
		observacao,
		valorfrete,
		tipofrete,
		numeropedidome,
		filial,
		nr_sequencia
	into STRICT	codigofornecedor_w,
		dataprevistaentrega_w,
		codigocondicaopagamento_w,
		observacao_w,
		valorfrete_w,
		tipofrete_w,
		numeropedidome_w,
		filial_w,
		nr_seq_pedido_w
	from	w_me_altera_pedido
	where	nr_sequencia = nr_sequencia_w;

	delete from log_me
	where nr_prepedido = numeropedidome_w;

	select	obter_conversao_interna_int(null,'ESTABELECIMENTO','CD_ESTABELECIMENTO',filial_w,'ME'),
		obter_conversao_interna_int(null,'CONDICAO_PAGAMENTO','CD_CONDICAO_PAGAMENTO',codigocondicaopagamento_w,'ME')
	into STRICT	cd_estabelecimento_w,
		cd_condicao_pagamento_w
	;

	select	count(*)
	into STRICT	qt_existe_w
	from	estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (qt_existe_w = 0) then
		ie_erro_w := 'S';
		/*Não existe conversão válida para a filial #@DS_FILIAL#@.*/

		CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297069,'DS_FILIAL=' || filial_w), '000002', nm_usuario_p,'A',numeropedidome_w);
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	condicao_pagamento
	where	cd_condicao_pagamento = cd_condicao_pagamento_w;

	if (qt_existe_w = 0) then
		ie_erro_w := 'S';
		/*Não existe conversão válida para a condição de pagamento #@CD_CONDICAO_PAGTO#@.*/

		CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297070, 'CD_CONDICAO_PAGTO=' || codigocondicaopagamento_w), '000003', nm_usuario_p,'A',numeropedidome_w);
	end if;

	select	count(*)
	into STRICT	qt_existe_w
	from	pessoa_juridica
	where	cd_cgc = codigofornecedor_w;

	if (qt_existe_w = 0) then
		ie_erro_w := 'S';
		/*Fornecedor não cadastrado no Tasy. Fornecedor #@CD_FORNECEDOR#@.*/

		CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297071, 'CD_FORNECEDOR=' || codigofornecedor_w), '000004', nm_usuario_p,'A',numeropedidome_w);
	end if;

	if (ie_erro_w = 'N') then

		update	ordem_compra
		set	cd_cgc_fornecedor = codigofornecedor_w,
			dt_entrega = dataprevistaentrega_w,
			cd_condicao_pagamento = cd_condicao_pagamento_w,
			ds_observacao = observacao_w,
			vl_frete = valorfrete_w,
			ie_frete = tipofrete_w,
			nr_documento_externo = numeropedidome_w
		where	nr_ordem_compra = nr_ordem_compra_ww;

	end if;

	if (ie_erro_w = 'N') then

		open c01;
		loop
		fetch c01 into
			nr_seq_item_w,
			codigoproduto_w,
			prazoentrega_w,
			quantidade_w,
			valorunitario_w,
			percentualdesconto_w,
			percentualipi_w,
			valornormal_w,
			codigounidade_w,
			observacao_w,
			fabricante_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			select	coalesce(obter_cod_int_material(codigoproduto_w,'ME',cd_estabelecimento_w),0)
			into STRICT	cd_material_w
			;

			select	count(*)
			into STRICT	qt_existe_w
			from	material
			where	cd_material = cd_material_w;

			if (qt_existe_w = 0) then
				ie_erro_w := 'S';
				/*Não existe conversão válida para o código do produto #@CD_PRODUTO#@.*/

				CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297074, 'CD_PRODUTO=' || codigoproduto_w), '000006', nm_usuario_p,'A',numeropedidome_w);
			end if;

			select	count(*)
			into STRICT	qt_existe_w
			from	ordem_compra_item
			where	cd_material = cd_material_w;

			if (qt_existe_w = 0) then
				ie_erro_w := 'S';
				/*Produto não existente na OC. Produto #@CD_PRODUTO#@.*/

				CALL inserir_log_me('OC', nr_ordem_compra_ww, 'ERRO', 'ROC', wheb_mensagem_pck.get_texto(297076, 'CD_PRODUTO=' || codigoproduto_w), '000007', nm_usuario_p,'A',numeropedidome_w);
			end if;

			vl_item_liquido_w := 0;
			vl_item_liquido_w := coalesce(quantidade_w,0) * coalesce(valorunitario_w,0);

			if (percentualdesconto_w > 0) then
				vl_item_liquido_w := vl_item_liquido_w - dividir((percentualdesconto_w * 100),vl_item_liquido_w);
			end if;

			if (ie_erro_w = 'N') and (fabricante_w IS NOT NULL AND fabricante_w::text <> '') then

				select	somente_numero(obter_conversao_interna_int(null,'MAT_FABRICANTE','NR_SEQUENCIA',fabricante_w,'ME'))
				into STRICT	nr_seq_fabric_int_w
				;

				select	count(*)
				into STRICT	qt_regra_fabric_mat_w
				from	regra_fabric_integracao
				where	cd_material = cd_material_w
				and (coalesce(cd_estabelecimento::text, '') = '' or cd_estabelecimento = cd_estabelecimento_w)
				and (ie_integracao = 'S' or ie_integracao = 'ME');

				select	coalesce(max(nr_seq_fabric),0)
				into STRICT	nr_seq_fabric_mat_w
				from	material
				where	cd_material = cd_material_w;

				if (nr_seq_fabric_int_w > 0) and (nr_seq_fabric_mat_w > 0) and (nr_seq_fabric_mat_w <> nr_seq_fabric_int_w) then

					ie_erro_w := 'S';
					/*O fabricante #@CD_FABRICANTE#@ é inválido para o material #@CD_PRODUTO#@.*/

					CALL inserir_log_me('OC', nr_ordem_compra_ww, '112', 'ROC', wheb_mensagem_pck.get_texto(297078, 'CD_FABRICANTE=' || fabricante_w || ';CD_PRODUTO=' || codigoproduto_w), '000023', nm_usuario_p,'A', numeropedidome_w, nr_seq_pedido_w);

				elsif (qt_regra_fabric_mat_w > 0) and (nr_seq_fabric_mat_w = 0) and (nr_seq_fabric_int_w > 0) then

					select	count(*)
					into STRICT	qt_existe_w
					from	regra_fabric_integracao
					where	cd_material = cd_material_w
					and	nr_seq_fabric = nr_seq_fabric_int_w
					and (coalesce(cd_estabelecimento::text, '') = '' or cd_estabelecimento = cd_estabelecimento_w)
					and (ie_integracao = 'S' or ie_integracao = 'ME');

					if (qt_existe_w = 0) then
						ie_erro_w := 'S';
						/*O fabricante #@CD_FABRICANTE#@ é inválido para o material #@CD_PRODUTO#@.*/

						CALL inserir_log_me('OC', nr_ordem_compra_ww, '112', 'ROC', wheb_mensagem_pck.get_texto(297078, 'CD_FABRICANTE=' || fabricante_w || ';CD_PRODUTO=' || codigoproduto_w), '000024', nm_usuario_p,'A', numeropedidome_w,nr_seq_pedido_w);
					end if;
				end if;
			end if;

			select	sum(qt_material)
			into STRICT	qt_total_w
			from	ordem_compra_item
			where	nr_ordem_compra = nr_ordem_compra_ww
			and	cd_material = cd_material_w;

			if (ie_erro_w = 'N') then

				select	count(*)
				into STRICT	qt_existe_w
				from	w_me_altera_ped_item_ent
				where	nr_seq_item = nr_seq_item_w;

				if (qt_existe_w > 0) then

					open C04;
					loop
					fetch C04 into
						quantidade_ww,
						nr_ordem_compra_w,
						nr_item_oci_ww;
					EXIT WHEN NOT FOUND; /* apply on C04 */
						begin

						delete	FROM ordem_compra_item_entrega
						where	nr_item_oci = nr_item_oci_ww
						and	nr_ordem_compra = nr_ordem_compra_ww;

						end;
					end loop;
					close C04;

					open c03;
					loop
					fetch c03 into
						data_w,
						quant_w;
					EXIT WHEN NOT FOUND; /* apply on c03 */
						begin

						open C04;
						loop
						fetch C04 into
							quantidade_ww,
							nr_ordem_compra_w,
							nr_item_oci_ww;
						EXIT WHEN NOT FOUND; /* apply on C04 */
							begin

							qt_fator_w := quantidade_ww / qt_total_w;
							quantidade_ww := quant_w;
							quantidade_ww := quantidade_ww * qt_fator_w;
							quantidade_ww := trunc(quantidade_ww);


							select	count(*)
							into STRICT	qt_registros_w
							from	ordem_compra_item_entrega
							where	nr_ordem_compra = nr_ordem_compra_ww
							and	nr_item_oci = nr_item_oci_ww
							and	dt_prevista_entrega = data_w;

							if (qt_registros_w = 0) then

								select	nextval('ordem_compra_item_entrega_seq')
								into STRICT	nr_seq_oci_entrega_w
								;

								insert into ordem_compra_item_entrega(
									nr_sequencia,
									nr_ordem_compra,
									nr_item_oci,
									dt_prevista_entrega,
									qt_prevista_entrega,
									dt_atualizacao,
									nm_usuario,
									dt_entrega_original,
									dt_entrega_limite)
								values (	nr_seq_oci_entrega_w,
									nr_ordem_compra_ww,
									nr_item_oci_ww,
									data_w,
									quantidade_ww,
									clock_timestamp(),
									nm_usuario_p,
									data_w,
									data_w);
							else
								update	ordem_compra_item_entrega
								set	qt_prevista_entrega = qt_prevista_entrega + quantidade_ww
								where	nr_ordem_compra = nr_ordem_compra_ww
								and	nr_item_oci = nr_item_oci_ww
								and	dt_prevista_entrega = data_w;

							end if;
							end;
						end loop;
						close C04;

						end;
					end loop;
					close c03;
				end if;

				open C04;
				loop
				fetch C04 into
					quantidade_ww,
					nr_ordem_compra_w,
					nr_item_oci_ww;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin

					qt_fator_w := quantidade_w / qt_total_w;
					quantidade_ww := quantidade_ww * qt_fator_w;
					quantidade_ww := trunc(quantidade_ww);

					update	ordem_compra_item
					set	qt_material = quantidade_ww,
						vl_unitario_material = valorunitario_w,
						pr_descontos = percentualdesconto_w,
						vl_item_liquido = vl_item_liquido_w,
						ds_observacao = substr(ds_observacao || observacao_w,1,255),
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_p,
						vl_total_item = round(( quantidade_ww * valorunitario_w)::numeric,4)
					where	nr_ordem_compra = nr_ordem_compra_ww
					and	nr_item_oci = nr_item_oci_ww;

					end;
				end loop;
				close C04;

				select	sum(qt_material)
				into STRICT	qt_total_ww
				from	ordem_compra_item
				where	nr_ordem_compra = nr_ordem_compra_ww
				and	cd_material = cd_material_w;

				qt_diferenca_w := coalesce(quantidade_w - qt_total_ww,0);

				if (qt_diferenca_w <> 0) then
					update	ordem_compra_item
					set	qt_material = qt_material + qt_diferenca_w,
						vl_total_item = round(( (qt_material + qt_diferenca_w) * vl_unitario_material),4)
					where	nr_ordem_compra = nr_ordem_compra_ww
					and	nr_item_oci = nr_item_oci_ww;
				end if;

				open C04;
				loop
				fetch C04 into
					quantidade_ww,
					nr_ordem_compra_w,
					nr_item_oci_ww;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin

					select	sum(b.qt_prevista_entrega)
					into STRICT	qt_total_ww
					from	ordem_compra_item a,
						ordem_compra_item_entrega b
					where	a.nr_ordem_compra = b.nr_ordem_compra
					and	a.nr_item_oci = b.nr_item_oci
					and	a.nr_ordem_compra = nr_ordem_compra_ww
					and	a.nr_item_oci = nr_item_oci_ww;

					qt_diferenca_w := coalesce(quantidade_ww - qt_total_ww,0);

					select	max(nr_sequencia)
					into STRICT	nr_seq_oci_entrega_w
					from	ordem_compra_item_entrega
					where	nr_ordem_compra = nr_ordem_compra_ww
					and	nr_item_oci = nr_item_oci_ww;

					if (qt_diferenca_w <> 0) then
						update	ordem_compra_item_entrega
						set	qt_prevista_entrega = qt_prevista_entrega + qt_diferenca_w
						where	nr_ordem_compra = nr_ordem_compra_ww
						and	nr_item_oci = nr_item_oci_ww
						and	nr_sequencia = nr_seq_oci_entrega_w;
					end if;
				end;
				end loop;
				close C04;

				if (percentualipi_w > 0) then

						select	coalesce(min(cd_tributo),0)
						into STRICT	cd_tributo_w
						from	tributo
						where	ie_situacao = 'A'
						and	ie_tipo_tributo = 'IPI'
						and	ie_corpo_item = 'I';

						if (cd_tributo_w > 0) then

							vl_tributo_w := 0;
							vl_tributo_w := (dividir(percentualipi_w,100) * vl_item_liquido_w);

						end if;
				end if;

				open c02;
				loop
				fetch c02 into
					nr_item_oci_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */
					begin

					update	ordem_compra_item_entrega
					set	dt_prevista_entrega = dataprevistaentrega_w,
						dt_entrega_limite = dataprevistaentrega_w,
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_p
					where	nr_item_oci = nr_item_oci_w
					and	nr_ordem_compra = nr_ordem_compra_ww;

					if (percentualipi_w > 0) then

						update	ordem_compra_item_trib
						set	pr_tributo = percentualipi_w,
							cd_tributo = cd_tributo_w,
							vl_tributo = vl_tributo_w,
							dt_atualizacao = clock_timestamp(),
							nm_usuario = nm_usuario_p
						where	nr_item_oci = nr_item_oci_w
						and	nr_ordem_compra = nr_ordem_compra_ww;

					end if;

					end;
				end loop;
				close c02;

			end if;
			end;
		end loop;
		close c01;

	update	w_me_altera_pedido
	set	ie_lido = 'S'
	where	somente_numero(numeropedidowpd) = nr_ordem_compra_ww;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_pedido_me ( nr_ordem_compra_p text, nm_usuario_p text) FROM PUBLIC;

