-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gerar_nf_prescricao ( nr_seq_nota_fiscal_p bigint, nr_prescricao_p bigint, ds_mensagem_p INOUT text, cd_estabelecimento_p bigint, ie_gerar_nf_cons_devol_p text, nm_usuario_p text) AS $body$
DECLARE


/*ie_gerar_nf_cons_devol_p
	T - Gera a nota de consumo e devolução
	C - Gera somente nota de consumo
	D - Gera somente nota de devolução
*/
/* Variaveis C01 */

cd_material_presc_w  		integer;
cd_material_presc_ant_w  		integer;
qt_unitaria_presc_w			double precision;

/* Variaveis C02 */

cd_material_item_nota_w		integer;
nr_item_nf_w			integer;
qt_item_nf_w			double precision;
nr_seq_lote_fornec_w		bigint;

/* Variaveis nota fiscal Atendida */

nr_seq_nf_atend_w			bigint;
qt_nota_fiscal_atend_w		smallint;
qt_item_nf_atend_w		double precision;
nr_nota_fiscal_atend_w		varchar(255);

/* Variaveis nota fiscal não Atendida */

nr_seq_nf_nao_atend_w		bigint;
qt_nota_fiscal_nao_atend_w		smallint;
qt_item_nf_nao_atend_w		double precision;
nr_nota_fiscal_nao_atend_w		varchar(255);

qt_existe_material_w		smallint;
nr_nota_observacao_w		varchar(255);
nr_item_nf_ww			integer;

/*Operação e Natureza nos parâmetros [282] [283] [289] [290]*/

ie_operacao_nota_consumo_w	smallint;
ie_natureza_nota_consumo_w	smallint;
ie_operacao_nota_devolucao_w	smallint;
ie_natureza_nota_devolucao_w	smallint;
cd_local_estoque_consumo_w	bigint;
cd_local_estoque_devol_w		bigint;
cd_cond_pagto_consumo_w		bigint;
cd_cond_pagto_devol_w		bigint;
ie_atualiza_estoque_w           operacao_estoque.ie_atualiza_estoque%type;

/*Série informada no parâmetro [300]*/

cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;

cd_oper_nf_corresp_w		smallint;
nr_atendimento_w			bigint;
dt_validade_w			timestamp;
ie_validade_indeterminada_w		varchar(1);
ds_lote_fornec_w			varchar(20);

ds_lista_nota_ger_w		varchar(255);
nr_seq_nota_entrada_w		bigint;
ds_obs_padrao_nf_dev_w		varchar(4000);
vl_unitario_item_nf_w		double precision;
vl_desconto_w			double precision;
vl_total_item_nf_w			double precision;
vl_liquido_w			double precision;
qt_item_estoque_w		nota_fiscal_item.qt_item_estoque%type;
qt_item_estoque_ww		nota_fiscal_item.qt_item_estoque%type;
ie_existe_nf_consumo_w		varchar(1);
nr_prescricao_w			prescr_medica.nr_prescricao%type;

cd_cgc_emitente_w		pessoa_juridica.cd_cgc%type;
cd_cgc_destinatario_w		pessoa_juridica.cd_cgc%type;

nr_seq_ordem_compra_w		ordem_compra.nr_ordem_compra%type;
dt_emissao_w			nota_fiscal.dt_emissao%type;
dt_entrada_saida_w		nota_fiscal.dt_entrada_saida%type;
nr_danfe_referencia_w		nota_fiscal.nr_danfe_referencia%type;


C00 CURSOR FOR
	SELECT	nr_seq_nf_entrada
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p
	group by	nr_seq_nf_entrada;

C01 CURSOR FOR
	SELECT	cd_material,
		nr_item_nf,
		qt_item_nf,
		qt_item_estoque
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nota_entrada_w
	order by cd_material;

C02 CURSOR FOR
	SELECT	cd_material,
		qt_unitaria,
		nr_seq_lote_fornec,
		obter_ordem_compra_presc(nr_prescricao,qt_material,nr_sequencia) nr_seq_ordem_compra
	from	prescr_material a
	where	nr_prescricao = nr_prescricao_p
	and	nr_seq_nf_entrada = nr_seq_nota_entrada_w
	and	coalesce(ie_gerar_nf_cons_devol_p,'T') in ('T','C')
	and	ie_existe_nf_consumo_w = 'N'
	and (ie_atualiza_estoque_w = 'N' or obter_saldo_disp_consig(cd_estabelecimento_p, cd_fornec_consignado, cd_material, coalesce(cd_local_estoque_consumo_w,cd_local_estoque)) >= qt_unitaria);


BEGIN

begin
select	nr_prescricao
into STRICT	nr_prescricao_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;
exception
when others then
	nr_prescricao_w	:=	null;
end;

ie_operacao_nota_consumo_w	:= coalesce(obter_valor_param_usuario(900, 282, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'0');
ie_natureza_nota_consumo_w	:= coalesce(obter_valor_param_usuario(900, 283, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'0');
ie_natureza_nota_devolucao_w	:= coalesce(obter_valor_param_usuario(900, 290, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'0');
cd_serie_nf_w			:= coalesce(obter_valor_param_usuario(900, 300, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'0');
cd_local_estoque_consumo_w	:= coalesce(obter_valor_param_usuario(900, 508, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),0);
cd_local_estoque_devol_w		:= coalesce(obter_valor_param_usuario(900, 509, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),0);
cd_cond_pagto_consumo_w		:= obter_valor_param_usuario(900, 510, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
cd_cond_pagto_devol_w		:= obter_valor_param_usuario(900, 511, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

select	obter_cgc_estabelecimento(cd_estabelecimento_p)
into STRICT	cd_cgc_emitente_w
;

if (ie_operacao_nota_consumo_w = '0') then
	/*É necessário informar a operação da nota para geração da mesma.
	Verifique o parâmetro [282].*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(194575);
end if;

if (ie_natureza_nota_consumo_w = '0') then
	/*É necessário informar a natureza da nota para geração da mesma.
	Verifique o parâmetro [283].*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(194576);
end if;

if (ie_natureza_nota_devolucao_w = '0') then
	/*É necessário informar a natureza da nota para geração da mesma.
	Verifique o parâmetro [290].*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(194578);
end if;

open C00;
loop
fetch c00 into
	nr_seq_nota_entrada_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
	begin

	qt_nota_fiscal_nao_atend_w	:= 0;
	qt_item_nf_nao_atend_w 		:= 0;
	qt_nota_fiscal_atend_w		:= 0;
	qt_item_nf_atend_w		:= 0;
	qt_existe_material_w		:= 0;

	select	max(dt_emissao),
		max(dt_entrada_saida),
		max(nr_danfe)
	into STRICT	dt_emissao_w,
		dt_entrada_saida_w,
		nr_danfe_referencia_w
	from	nota_fiscal a
	where	a.nr_sequencia = nr_seq_nota_entrada_w;

	select	coalesce(max(b.cd_oper_nf_corresp),0)
	into STRICT	cd_oper_nf_corresp_w
	from	nota_fiscal a,
		operacao_nota b
	where	a.cd_operacao_nf = b.cd_operacao_nf
	and	a.nr_sequencia = nr_seq_nota_entrada_w;

	if (cd_oper_nf_corresp_w > 0) then
		ie_operacao_nota_devolucao_w	:= cd_oper_nf_corresp_w;
	else
		ie_operacao_nota_devolucao_w	:= coalesce(obter_valor_param_usuario(900, 289, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'0');
	end if;

	if (ie_operacao_nota_devolucao_w = '0') then
		/*É necessário informar a operação da nota de devolução para geração da mesma.
		Essa informação pode ser cadastrada no no parâmetro [289] ou no campo Operação correspondente no cadastro da operação da nota fiscal.*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(194577);
	end if;

	select	obter_atendimento_prescr(nr_prescricao_p)
	into STRICT	nr_atendimento_w
	;

	select	substr(obter_dados_nota_fiscal(nr_seq_nota_entrada_w,'0'),1,255)
	into STRICT	nr_nota_observacao_w
	;

	begin
	select	'S'
	into STRICT	ie_existe_nf_consumo_w
	from	nota_fiscal x,
		nota_fiscal_item y
	where	x.nr_sequencia = y.nr_sequencia
	and	y.nr_atendimento = nr_atendimento_w
	and	x.ie_situacao = '1'
	and	x.nr_seq_nf_ref_consumo = nr_seq_nota_entrada_w  LIMIT 1;
	exception
	when others then
		ie_existe_nf_consumo_w := 'N';
	end;

	select max(coalesce(ie_atualiza_estoque,'N'))
	into STRICT   ie_atualiza_estoque_w
	from   operacao_estoque a,
	       operacao_nota b
        where  a.cd_operacao_estoque = b.cd_operacao_estoque
	and    b.cd_operacao_nf = ie_operacao_nota_consumo_w;


	open C02;
	loop
	fetch C02 into
		cd_material_presc_w,
		qt_unitaria_presc_w,
		nr_seq_lote_fornec_w,
		nr_seq_ordem_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		cd_material_presc_ant_w := null;

		open C01;
		loop
		fetch C01 into
			cd_material_item_nota_w,
			nr_item_nf_w,
			qt_item_nf_w,
			qt_item_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (cd_material_presc_ant_w = cd_material_item_nota_w) then
				cd_material_item_nota_w := null;
			elsif (cd_material_presc_w = cd_material_item_nota_w) then
				begin
				if (qt_nota_fiscal_atend_w = 0) then
					begin

					select	substr(
						replace_macro(
						replace_macro(
						replace_macro(
						replace_macro(
						replace_macro(
						replace_macro(ds_obs_padrao_nf_dev,
							'@nr_nota_fiscal', nr_nota_observacao_w),
							'@dt_emissao', coalesce(dt_emissao_w, trunc(clock_timestamp()))),
							'@dt_entrada_saida', coalesce(dt_entrada_saida_w, clock_timestamp())),
							'@ds_motivo_dev', WHEB_MENSAGEM_PCK.get_texto(281063)),
							'@nr_ordem_compra', nr_seq_ordem_compra_w),
							'@nr_danfe_referencia', nr_danfe_referencia_w),1,4000)
					into STRICT	ds_obs_padrao_nf_dev_w
					from	parametro_compras
					where	cd_estabelecimento = cd_estabelecimento_p;

					if (ds_obs_padrao_nf_dev_w IS NOT NULL AND ds_obs_padrao_nf_dev_w::text <> '') then
						ds_obs_padrao_nf_dev_w := ds_obs_padrao_nf_dev_w;
					else
						ds_obs_padrao_nf_dev_w := substr(WHEB_MENSAGEM_PCK.get_texto(281064) || nr_nota_observacao_w,1,4000);
					end if;

					select	nextval('nota_fiscal_seq')
					into STRICT	nr_seq_nf_atend_w
					;
					/*Geração da nota de consumo*/

					insert into nota_fiscal(
						nr_sequencia,
						cd_estabelecimento,
						cd_cgc_emitente,
						cd_cgc,
						cd_serie_nf,
						nr_sequencia_nf,
						cd_operacao_nf,
						cd_natureza_operacao,
						ie_tipo_nota,
						dt_emissao,
						dt_entrada_saida,
						ie_acao_nf,
						ie_emissao_nf,
						ie_tipo_frete,
						vl_mercadoria,
						vl_total_nota,
						qt_peso_bruto,
						qt_peso_liquido,
						dt_atualizacao,
						nm_usuario,
						nr_nota_fiscal,
						ie_situacao,
						ds_observacao,
						nr_seq_nf_ref_consumo,
						cd_condicao_pagamento,
						vl_despesa_doc,
						vl_frete,
						vl_descontos,
						dt_atualizacao_nrec,
						nm_usuario_nrec)
					SELECT	nr_seq_nf_atend_w,
						cd_estabelecimento,
						cd_cgc_emitente_w,
						cd_cgc_emitente,
						CASE WHEN cd_serie_nf_w='0' THEN  cd_serie_nf  ELSE cd_serie_nf_w END ,
						nr_sequencia_nf,
						coalesce(ie_operacao_nota_consumo_w, cd_operacao_nf),
						coalesce(ie_natureza_nota_consumo_w, cd_natureza_operacao),
						'SE',
						clock_timestamp(),
						clock_timestamp(),
						ie_acao_nf,
						ie_emissao_nf,
						ie_tipo_frete,
						vl_mercadoria,
						vl_total_nota,
						qt_peso_bruto,
						qt_peso_liquido,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_nf_atend_w,
						1,
						ds_obs_padrao_nf_dev_w,
						nr_seq_nota_entrada_w,
						cd_cond_pagto_consumo_w,
						0,0,0,
						clock_timestamp(),
						nm_usuario_p
					from	nota_fiscal
					where	nr_sequencia = nr_seq_nota_entrada_w;

					qt_nota_fiscal_atend_w := 1;

					/*Gera o Nrº Nota Fiscal conforme regra (Série da Nota Fiscal)*/

					/* Removido o procedimento abaixo, por que o mesmo é realizado dentro da procedure atualizar_nota_fiscal
					Duvidas conversar com analista.
					sup_gerar_nr_nota_fiscal(nr_seq_nf_atend_w, cd_serie_nf_w, cd_estabelecimento_p, nm_usuario_p);
					*/
					/* Pega  o número NR_NOTA_FISCAL que foi gerado, e mostra na tela */

					select	coalesce(nr_nota_fiscal, nr_seq_nf_atend_w) nr_nota_fiscal
					into STRICT	nr_nota_fiscal_atend_w
					from	nota_fiscal
					where	nr_sequencia = nr_seq_nf_atend_w;

					end;
				end if;

				/* Verfica se o material foi atendido  e se quantidade é igual */

				if (qt_item_nf_w = qt_unitaria_presc_w) then
					qt_existe_material_w 	:= 1;
					qt_item_nf_atend_w	:= qt_unitaria_presc_w;
					qt_item_estoque_ww	:= qt_item_estoque_w;
				else
					qt_existe_material_w 	:= 0;
					qt_item_nf_atend_w   	:= qt_unitaria_presc_w;
					qt_item_nf_nao_atend_w  := (qt_item_nf_w - qt_unitaria_presc_w);
					qt_item_estoque_ww	:= (dividir(qt_item_estoque_w, qt_item_nf_w) * qt_item_nf_atend_w);
				end if;

				/* Identifica validade do lote fornecedor  e descrição */

				begin
				select	dt_validade,
					ie_validade_indeterminada,
					ds_lote_fornec
				into STRICT	dt_validade_w,
					ie_validade_indeterminada_w,
					ds_lote_fornec_w
				from	material_lote_fornec
				where	nr_sequencia = nr_seq_lote_fornec_w;
				exception
				when others then
					dt_validade_w := null;
					ie_validade_indeterminada_w := 'N';
					ds_lote_fornec_w := '';
				end;

				select	coalesce(max(nr_item_nf),0) + 1
				into STRICT	nr_item_nf_ww
				from	nota_fiscal_item
				where	nr_sequencia = nr_seq_nf_atend_w;

				if (coalesce(qt_item_nf_atend_w,0) <> 0) then
					begin

					if (coalesce(cd_local_estoque_consumo_w,0) = 0) then

						select	cd_local_estoque
						into STRICT	cd_local_estoque_consumo_w
						from	nota_fiscal_item
						where	nr_sequencia = nr_seq_nota_entrada_w
						and	nr_item_nf = nr_item_nf_w;

					end if;

					select	coalesce(vl_unitario_item_nf,0),
						coalesce(vl_desconto,0)
					into STRICT	vl_unitario_item_nf_w,
						vl_desconto_w
					from	nota_fiscal_item
					where	nr_sequencia = nr_seq_nota_entrada_w
					and	nr_item_nf = nr_item_nf_w;

					vl_total_item_nf_w	:= qt_item_nf_atend_w * vl_unitario_item_nf_w;
					vl_liquido_w		:= vl_total_item_nf_w - vl_desconto_w;

					insert into nota_fiscal_item( nr_sequencia,
						cd_estabelecimento,
						cd_serie_nf,
						nr_sequencia_nf,
						nr_item_nf,
						cd_natureza_operacao,
						qt_item_nf,
						vl_unitario_item_nf,
						vl_total_item_nf,
						dt_atualizacao,
						nm_usuario,
						vl_frete,
						vl_desconto,
						vl_despesa_acessoria,
						cd_material,
						cd_conta_contabil,
						nr_seq_marca,
						cd_procedimento,
						cd_unidade_medida_compra,
						cd_unidade_medida_estoque,
						qt_item_estoque,
						vl_desconto_rateio,
						vl_seguro,
						vl_liquido,
						cd_local_estoque,
						nr_atendimento,
						cd_lote_fabricacao,
						dt_validade,
						ie_indeterminado,
						nr_prescricao)
					SELECT	nr_seq_nf_atend_w,
						cd_estabelecimento,
						CASE WHEN cd_serie_nf_w='0' THEN  cd_serie_nf  ELSE cd_serie_nf_w END ,
						1,
						nr_item_nf_ww,
						coalesce(ie_natureza_nota_consumo_w, cd_natureza_operacao),
						qt_item_nf_atend_w,
						vl_unitario_item_nf,
						vl_total_item_nf_w,
						clock_timestamp(),
						nm_usuario_p,
						vl_frete,
						vl_desconto,
						vl_despesa_acessoria,
						cd_material,
						substr(obter_conta_contabil_material(cd_estabelecimento_p,cd_material),1,255),
						(substr(obter_marca_material(cd_material,'C'),1,255))::numeric ,
						cd_procedimento,
						cd_unidade_medida_compra,
						cd_unidade_medida_estoque,
						qt_item_estoque_ww,
						vl_desconto_rateio,
						vl_seguro,
						vl_liquido_w,
						cd_local_estoque_consumo_w,
						nr_atendimento_w,
						ds_lote_fornec_w,
						dt_validade_w,
						ie_validade_indeterminada_w,
						nr_prescricao_w
					from	nota_fiscal_item
					where	nr_sequencia = nr_seq_nota_entrada_w
					and	nr_item_nf = nr_item_nf_w;

					cd_material_presc_ant_w := cd_material_item_nota_w;

					CALL atualiza_total_nota_fiscal(nr_seq_nf_atend_w, nm_usuario_p);
					end;
				end if;
				end;
			end if;
			end;
		end loop;
		close C01;

		end;
	end loop;
	close C02;

	open C01;
	loop
	fetch C01 into
		cd_material_item_nota_w,
		nr_item_nf_w,
		qt_item_nf_w,
		qt_item_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select max(coalesce(ie_atualiza_estoque,'N'))
		into STRICT   ie_atualiza_estoque_w
		from   operacao_estoque a,
		       operacao_nota b
		where  a.cd_operacao_estoque = b.cd_operacao_estoque
		and    b.cd_operacao_nf = ie_operacao_nota_devolucao_w;


		open C02;
		loop
		fetch C02 into
			cd_material_presc_w,
			qt_unitaria_presc_w,
			nr_seq_lote_fornec_w,
			nr_seq_ordem_compra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (cd_material_presc_w = cd_material_item_nota_w) then
				if (qt_item_nf_w = qt_unitaria_presc_w) then
					qt_existe_material_w 	:= 1;
					qt_item_nf_atend_w	:= qt_unitaria_presc_w;
					qt_item_estoque_ww	:= qt_item_estoque_w;
				else
					qt_existe_material_w 	:= 0;
					qt_item_nf_atend_w   	:= qt_unitaria_presc_w;
					qt_item_nf_nao_atend_w  := (qt_item_nf_w - qt_unitaria_presc_w);
					qt_item_estoque_ww	:= (dividir(qt_item_estoque_w, qt_item_nf_w) * qt_item_nf_atend_w);
				end if;
			end if;
			end;
		end loop;
		close C02;

		if (coalesce(ie_gerar_nf_cons_devol_p,'T') in ('T','D')) and (qt_existe_material_w = 0) then
			begin
			if (qt_nota_fiscal_nao_atend_w = 0) then
				begin

				begin

				select	max(obter_ordem_compra_presc(nr_prescricao,qt_material,nr_sequencia)) nr_seq_ordem_compra
				into STRICT	nr_seq_ordem_compra_w
				from	prescr_material a
				where	nr_prescricao = nr_prescricao_p
				and	nr_seq_nf_entrada = nr_seq_nota_entrada_w
				and	coalesce(ie_gerar_nf_cons_devol_p,'T') in ('T','D')
				and	ie_existe_nf_consumo_w = 'N'
				and	obter_saldo_disp_consig(cd_estabelecimento_p, cd_fornec_consignado, cd_material, coalesce(cd_local_estoque_consumo_w,cd_local_estoque)) >= qt_unitaria;

				exception
				when others then
				nr_seq_ordem_compra_w := null;
				end;

				select	substr(	replace_macro(
						replace_macro(
						replace_macro(
						replace_macro(
						replace_macro(ds_obs_padrao_nf_dev,
							'@nr_nota_fiscal', nr_nota_observacao_w),
							'@dt_emissao', coalesce(dt_emissao_w, trunc(clock_timestamp()))),
							'@dt_entrada_saida', coalesce(dt_entrada_saida_w, clock_timestamp())),
							'@ds_motivo_dev', WHEB_MENSAGEM_PCK.get_texto(281063)),
							'@nr_ordem_compra', nr_seq_ordem_compra_w),1,4000)
				into STRICT	ds_obs_padrao_nf_dev_w
				from	parametro_compras
				where	cd_estabelecimento = cd_estabelecimento_p;

				if (ds_obs_padrao_nf_dev_w IS NOT NULL AND ds_obs_padrao_nf_dev_w::text <> '') then
					ds_obs_padrao_nf_dev_w := ds_obs_padrao_nf_dev_w;
				else
					ds_obs_padrao_nf_dev_w := substr(WHEB_MENSAGEM_PCK.get_texto(281066) || nr_nota_observacao_w,1,4000);
				end if;

				select	nextval('nota_fiscal_seq')
				into STRICT	nr_seq_nf_nao_atend_w
				;

				/*Geração da nota de devolução*/

				insert into nota_fiscal(
					nr_sequencia,
					cd_estabelecimento,
					cd_cgc_emitente,
					cd_cgc,
					cd_serie_nf,
					nr_sequencia_nf,
					cd_operacao_nf,
					cd_natureza_operacao,
					ie_tipo_nota,
					dt_emissao,
					dt_entrada_saida,
					ie_acao_nf,
					ie_emissao_nf,
					ie_tipo_frete,
					vl_mercadoria,
					vl_total_nota,
					qt_peso_bruto,
					qt_peso_liquido,
					dt_atualizacao,
					nm_usuario,
					nr_nota_fiscal,
					ie_situacao,
					ds_observacao,
					cd_condicao_pagamento,
					vl_despesa_doc,
					vl_frete,
					vl_descontos,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				SELECT	nr_seq_nf_nao_atend_w,
					cd_estabelecimento,
					cd_cgc_emitente_w,
					cd_cgc_emitente,
					CASE WHEN cd_serie_nf_w='0' THEN  cd_serie_nf  ELSE cd_serie_nf_w END ,
					nr_sequencia_nf,
					coalesce(ie_operacao_nota_devolucao_w, cd_operacao_nf),
					coalesce(ie_natureza_nota_devolucao_w, cd_natureza_operacao),
					'SE',
					clock_timestamp(),
					clock_timestamp(),
					ie_acao_nf,
					ie_emissao_nf,
					ie_tipo_frete,
					vl_mercadoria,
					vl_total_nota,
					qt_peso_bruto,
					qt_peso_liquido,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_nf_nao_atend_w,
					1,
					ds_obs_padrao_nf_dev_w,
					cd_cond_pagto_consumo_w,
					0,0,0,
					clock_timestamp(),
					nm_usuario_p
				from	nota_fiscal
				where	nr_sequencia = nr_seq_nota_entrada_w;

				qt_nota_fiscal_nao_atend_w := 1;

				/*Gera o Nrº Nota Fiscal conforme regra (Série da Nota Fiscal)*/

				/* Removido o procedimento abaixo, por que o mesmo é realizado dentro da procedure atualizar_nota_fiscal
				Duvidas conversar com analista.
				sup_gerar_nr_nota_fiscal(nr_seq_nf_nao_atend_w, cd_serie_nf_w, cd_estabelecimento_p, nm_usuario_p);
				*/
				/* Pega  o número NR_NOTA_FISCAL que foi gerado, e mostra na tela */

				select	coalesce(nr_nota_fiscal, nr_seq_nf_nao_atend_w) nr_nota_fiscal
				into STRICT	nr_nota_fiscal_nao_atend_w
				from	nota_fiscal
				where	nr_sequencia = nr_seq_nf_nao_atend_w;

				end;
			end if;

			select	coalesce(max(nr_item_nf),0) + 1
			into STRICT	nr_item_nf_ww
			from	nota_fiscal_item
			where	nr_sequencia = nr_seq_nf_nao_atend_w;

			if (coalesce(cd_local_estoque_devol_w,0) = 0) then

				select	cd_local_estoque
				into STRICT	cd_local_estoque_devol_w
				from	nota_fiscal_item
				where	nr_sequencia = nr_seq_nota_entrada_w
				and	nr_item_nf = nr_item_nf_w;

			end if;

			select	coalesce(vl_unitario_item_nf,0),
				coalesce(vl_desconto,0),
				CASE WHEN qt_item_nf_nao_atend_w=0 THEN  qt_item_nf  ELSE qt_item_nf_nao_atend_w END ,
				CASE WHEN qt_item_nf_nao_atend_w=0 THEN  qt_item_estoque  ELSE dividir(qt_item_estoque, qt_item_nf) * qt_item_nf_nao_atend_w END
			into STRICT	vl_unitario_item_nf_w,
				vl_desconto_w,
				qt_item_nf_w,
				qt_item_estoque_w
			from	nota_fiscal_item
			where	nr_sequencia = nr_seq_nota_entrada_w
			and	nr_item_nf = nr_item_nf_w;

			vl_total_item_nf_w	:= qt_item_nf_w * vl_unitario_item_nf_w;
			vl_liquido_w		:= vl_total_item_nf_w - vl_desconto_w;

			insert into nota_fiscal_item(
				nr_sequencia,
				cd_estabelecimento,
				cd_serie_nf,
				nr_sequencia_nf,
				nr_item_nf,
				cd_natureza_operacao,
				qt_item_nf,
				vl_unitario_item_nf,
				vl_total_item_nf,
				dt_atualizacao,
				nm_usuario,
				vl_frete,
				vl_desconto,
				vl_despesa_acessoria,
				cd_material,
				cd_conta_contabil,
				nr_seq_marca,
				cd_procedimento,
				cd_unidade_medida_compra,
				cd_unidade_medida_estoque,
				qt_item_estoque,
				vl_desconto_rateio,
				vl_seguro,
				vl_liquido,
				cd_local_estoque,
				nr_atendimento,
				nr_prescricao)
			SELECT	nr_seq_nf_nao_atend_w,
				cd_estabelecimento,
				CASE WHEN cd_serie_nf_w='0' THEN  cd_serie_nf  ELSE cd_serie_nf_w END ,
				1,
				nr_item_nf_ww,
				coalesce(ie_natureza_nota_devolucao_w, cd_natureza_operacao),
				qt_item_nf_w,
				vl_unitario_item_nf,
				vl_total_item_nf_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_frete,
				vl_desconto,
				vl_despesa_acessoria,
				cd_material,
				substr(obter_conta_contabil_material(cd_estabelecimento_p,cd_material),1,255),
				(substr(obter_marca_material(cd_material,'C'),1,255))::numeric ,
				cd_procedimento,
				cd_unidade_medida_compra,
				cd_unidade_medida_estoque,
				qt_item_estoque_w,
				vl_desconto_rateio,
				vl_seguro,
				vl_liquido_w,
				cd_local_estoque_devol_w,
				nr_atendimento_w,
				nr_prescricao_w
			from	nota_fiscal_item
			where	nr_sequencia = nr_seq_nota_entrada_w
			and	nr_item_nf = nr_item_nf_w;

			CALL atualiza_total_nota_fiscal(nr_seq_nf_nao_atend_w,nm_usuario_p);

			end;
		end if;

		qt_item_nf_nao_atend_w 	:= 0;
		qt_existe_material_w 	:= 0;

		end;
	end loop;
	close C01;


	if (nr_nota_fiscal_atend_w <> '') then
		nr_nota_fiscal_atend_w	:= nr_nota_fiscal_atend_w || chr(13);
	end if;

	if (nr_nota_fiscal_atend_w	<> '') or (nr_nota_fiscal_nao_atend_w <> '') then
		begin

		if (ds_lista_nota_ger_w = '') then
			ds_lista_nota_ger_w	:= nr_nota_fiscal_atend_w || nr_nota_fiscal_nao_atend_w;
		else
			ds_lista_nota_ger_w	:= ds_lista_nota_ger_w || chr(13) || nr_nota_fiscal_atend_w || nr_nota_fiscal_nao_atend_w;
		end if;

		end;
	end if;

	end;
end loop;
close C00;

if (ds_lista_nota_ger_w <> '') then
	ds_mensagem_p := ds_lista_nota_ger_w;
else
	ds_mensagem_p := '';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_nf_prescricao ( nr_seq_nota_fiscal_p bigint, nr_prescricao_p bigint, ds_mensagem_p INOUT text, cd_estabelecimento_p bigint, ie_gerar_nf_cons_devol_p text, nm_usuario_p text) FROM PUBLIC;
