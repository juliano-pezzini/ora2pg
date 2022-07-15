-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_gerar_movto_estoque_prod ( nr_seq_ordem_prod_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
cd_operacao_estoque_w		smallint;
cd_local_estoque_w		smallint;
cd_centro_custo_w		integer;
cd_centro_w			integer;
cd_material_w			integer;
ie_material_estoque_w		varchar(1);
ie_material_estoque_gen_w	varchar(1);
cd_oper_producao_w		smallint;
dt_mes_referencia_w		timestamp;
qt_refeicao_w			bigint;
cd_unidade_medida_consumo_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
qt_conv_estoque_consumo_w	double precision;
nr_movimento_estoque_w		bigint;
ie_origem_documento_w		varchar(3) := '20';
nr_seq_cardapio_w		bigint;
nr_seq_receita_w		bigint;
cd_material_genero_w		integer;
qt_componente_w			double precision;
qt_conversao_w			double precision;
cd_unid_med_cons_w		varchar(30);
cd_unid_med_etq_w		varchar(30);
cd_conta_contabil_w		varchar(20)	:= null;
vl_custo_w			double precision;

C01 CURSOR FOR
	SELECT	nr_seq_cardapio,
		qt_refeicao,
		cd_material,
		vl_custo
	from	nut_ordem_prod_card
	where	nr_seq_ordem = nr_seq_ordem_prod_p
	order by 1;

C02 CURSOR FOR
	SELECT	b.nr_sequencia
	from	nut_cardapio a,
		nut_receita_real b
	where	b.nr_seq_cardapio	= a.nr_sequencia
	and	a.nr_seq_card_dia	= nr_seq_cardapio_w;

C03 CURSOR FOR
	SELECT	b.cd_material,
		b.qt_conversao,
		coalesce(a.qt_componente_real,a.qt_componente),
		substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
		substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque
	from	material c,
		nut_genero_alim b,
		nut_rec_real_comp a
	where	coalesce(a.nr_seq_gen_alim_sub,a.nr_seq_gen_alim)	= b.nr_sequencia
	and	b.cd_material					= c.cd_material
	and	a.nr_seq_rec_real				= nr_seq_receita_w;


BEGIN

if (nr_seq_ordem_prod_p IS NOT NULL AND nr_seq_ordem_prod_p::text <> '') then
	begin

	select	cd_estabelecimento,
		cd_operacao_estoque,
		cd_local_estoque,
		cd_centro_custo,
		trunc(dt_ordem,'mm')
	into STRICT	cd_estabelecimento_w,
		cd_operacao_estoque_w,
		cd_local_estoque_w,
		cd_centro_custo_w,
		dt_mes_referencia_w
	from	nut_ordem_prod
	where	nr_sequencia = nr_seq_ordem_prod_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_cardapio_w,
		qt_refeicao_w,
		cd_material_w,
		vl_custo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		/* Geracao da Entrada da Producao se for material de estoque */

		ie_material_estoque_w := substr(obter_se_material_estoque(cd_estabelecimento_w, 0, cd_material_w),1,1);

		if (ie_material_estoque_w = 'S') then
			begin
			select	coalesce(max(cd_oper_producao),0)
			into STRICT	cd_oper_producao_w
			from	parametro_estoque
			where	cd_estabelecimento	= cd_estabelecimento_w;

			if (cd_oper_producao_w = 0) then
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(204700);
				--Falta informar a operação de estoque (Produção) nos parâmetros de estoque!
			end if;

			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo,
				substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_consumo,
				qt_conv_estoque_consumo
			into STRICT	cd_unidade_medida_consumo_w,
				cd_unidade_medida_estoque_w,
				qt_conv_estoque_consumo_w
			from	material
			where	cd_material = cd_material_w;

			SELECT * FROM Define_Conta_Material(	cd_estabelecimento_w, cd_material_w, 2, null, wheb_usuario_pck.get_cd_setor_atendimento, null, null, null, null, null, cd_local_estoque_w, cd_oper_producao_w, clock_timestamp(), cd_conta_contabil_w, cd_centro_w, null, null) INTO STRICT cd_conta_contabil_w, cd_centro_w;

			select	nextval('movimento_estoque_seq')
			into STRICT	nr_movimento_estoque_w
			;

			insert into movimento_estoque(
				nr_movimento_estoque,
				cd_estabelecimento,
				cd_local_estoque,
				dt_movimento_estoque,
				cd_operacao_estoque,
				cd_acao,
				cd_material,
				dt_mesano_referencia,
				qt_movimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_documento,
				nr_documento,
				nr_sequencia_item_docto,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_sequencia_documento,
				vl_movimento,
				cd_unidade_medida_estoque,
				cd_procedimento,
				cd_setor_atendimento,
				cd_conta,
				dt_contabil,
				cd_lote_fabricacao,
				dt_validade,
				qt_estoque,
				dt_processo,
				cd_local_estoque_destino,
				cd_centro_custo,
				cd_unidade_med_mov,
				nr_movimento_estoque_corresp,
				cd_conta_contabil,
				cd_material_estoque,
				ie_origem_proced,
				cd_fornecedor,
				nr_lote_contabil,
				ds_observacao,
				nr_seq_lote_fornec)
			values (	nr_movimento_estoque_w,
				cd_estabelecimento_w,
				cd_local_estoque_w,
				clock_timestamp(),
				cd_oper_producao_w,
				'1',
				cd_material_w,
				dt_mes_referencia_w,
				(qt_refeicao_w * qt_conv_estoque_consumo_w),
				clock_timestamp(),
				nm_usuario_p,
				ie_origem_documento_w,
				nr_seq_ordem_prod_p,
				null,
				null,
				null,
				null,
				vl_custo_w,
				cd_unidade_medida_estoque_w,
				null,
				null,
				null,
				null,
				nr_seq_ordem_prod_p,
				null,
				qt_refeicao_w,
				null,
				null,
				null,
				cd_unidade_medida_consumo_w,
				null,
				cd_conta_contabil_w,
				null,
				null,
				null,
				null,
				'nut_gerar_movto_estoque_prod - ' || wheb_mensagem_pck.get_texto(797919, 'NR_SEQ_ORDEM_PROD='||nr_seq_ordem_prod_p),
				null);

			if (vl_custo_w <> 0) then
				insert into movimento_estoque_valor(
					nr_movimento_estoque,
					cd_tipo_valor,
					vl_movimento,
					dt_atualizacao,
					nm_usuario)
				values (nr_movimento_estoque_w,
					7,
					vl_custo_w,
					clock_timestamp(),
					nm_usuario_p);
			end if;
			end;
		end if;

		/* Geracao das Saidas para a Producao */

		open C02;
		loop
		fetch C02 into
			nr_seq_receita_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			open C03;
			loop
			fetch C03 into
				cd_material_genero_w,
				qt_conversao_w,
				qt_componente_w,
				cd_unid_med_cons_w,
				cd_unid_med_etq_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				ie_material_estoque_gen_w := substr(obter_se_material_estoque(cd_estabelecimento_w, 0, cd_material_genero_w),1,1);

				if (ie_material_estoque_gen_w = 'S') then
					begin

					qt_componente_w	:= dividir(qt_componente_w,qt_conversao_w);

					SELECT * FROM Define_Conta_Material(	cd_estabelecimento_w, cd_material_genero_w, 2, null, wheb_usuario_pck.get_cd_setor_atendimento, null, null, null, null, null, cd_local_estoque_w, cd_operacao_estoque_w, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;

					select	nextval('movimento_estoque_seq')
					into STRICT	nr_movimento_estoque_w
					;

					insert into movimento_estoque(
						nr_movimento_estoque,
						cd_estabelecimento,
						cd_local_estoque,
						dt_movimento_estoque,
						cd_operacao_estoque,
						cd_acao,
						cd_material,
						dt_mesano_referencia,
						qt_movimento,
						dt_atualizacao,
						nm_usuario,
						ie_origem_documento,
						nr_documento,
						cd_unidade_med_mov,
						cd_unidade_medida_estoque,
						cd_lote_fabricacao,
						dt_validade,
						qt_estoque,
						dt_processo,
						cd_centro_custo,
						nr_seq_lote_fornec,
						cd_conta_contabil,
						ds_observacao)
					values (	nr_movimento_estoque_w,
						cd_estabelecimento_w,
						cd_local_estoque_w,
						clock_timestamp(),
						cd_operacao_estoque_w,
						'1',
						cd_material_genero_w,
						dt_mes_referencia_w,
						qt_componente_w,
						clock_timestamp(),
						nm_usuario_p,
						ie_origem_documento_w,
						nr_seq_ordem_prod_p,
						cd_unid_med_cons_w,
						cd_unid_med_cons_w,
						nr_seq_ordem_prod_p,
						null,
						qt_componente_w,
						null,
						CASE WHEN cd_centro_custo_w=0 THEN  null  ELSE cd_centro_custo_w END ,
						null,
						cd_conta_contabil_w,
						'nut_gerar_movto_estoque_prod - ' || wheb_mensagem_pck.get_texto(797920,
									'NR_SEQ_ORDEM_PROD='||nr_seq_ordem_prod_p||
									';NR_SEQ_RECEITA='||nr_seq_receita_w));
					end;
				end if;

				end;
			end loop;
			close C03;

			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_gerar_movto_estoque_prod ( nr_seq_ordem_prod_p bigint, nm_usuario_p text) FROM PUBLIC;

