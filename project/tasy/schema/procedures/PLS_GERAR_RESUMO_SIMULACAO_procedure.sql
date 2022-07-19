-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_resumo_simulacao ( nr_seq_simulacao_p bigint, nr_seq_item_p bigint, ie_tipo_operacao_p text, ie_tipo_entrada_p text, ie_tipo_simulacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
ie_tipo_operacao_p
I - Novo registro no resumo
E - Editar registro no resumo
D - Deletar no resumo
*/
/*
ie_tipo_entrada_p
BS - Beneficiário da simulação
BO - Bonificacao
SC - SCA
*/
/*ie_tipo_simulacao_p
I - Simulação individual
CA,CE - Simulação coletiva
*/
/* nr_seq_ordem
2 - Produto
3 - Bonificação
4 - SCA
5 - Taxa de inscrição
*/
C01 CURSOR FOR
	SELECT	nr_seq_plano
	from	pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

C03 CURSOR FOR
	SELECT	nr_sequencia,
		vl_mensalidade
	from	pls_simulpreco_individual
	where	nr_seq_simulacao	= nr_seq_simulacao_p
	and		((ie_tipo_operacao_p = 'I' and
			 nr_sequencia <> nr_seq_item_p) or
			 ie_tipo_operacao_p = 'D');

C04 CURSOR(	nr_seq_simul_ind_pc	pls_simulpreco_individual.nr_sequencia%type,
		nr_seq_simulacao_pc	pls_simulacao_preco.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_segurado_simul,
		coalesce(vl_mensalidade,0) vl_mensalidade
	from	pls_simulpreco_individual
	where	nr_sequencia = nr_seq_simul_ind_pc
	
union all

	SELECT	nr_sequencia nr_seq_segurado_simul,
		coalesce(vl_mensalidade,0) vl_mensalidade
	from	pls_simulpreco_individual
	where	nr_seq_simulacao = nr_seq_simulacao_pc;

nm_beneficiario_w		varchar(255);
qt_idade_w			smallint;
vl_simulacao_benef_w		double precision;
vl_simulacao_produto_w		double precision;
ie_tipo_benef_w			varchar(1);
nr_seq_produto_w		bigint;
nr_seq_tabela_w			bigint;
ds_tipo_benef_w			varchar(20);
ds_resumo_benef_w		varchar(255);
ds_resumo_produto_w		varchar(255);
qt_regitros_benef_2_w		bigint;
qt_regitros_benef_1_w		bigint;
qt_reg_benef_del_w		bigint;
qt_reg_benef_del_ww		bigint;
nm_bonificacao_w		varchar(150);
ds_resumo_bonificacao_w		varchar(255);
vl_bonificacao_w		double precision;
nr_seq_boni_segurado_w		bigint;
qt_reg_bonificacao_pf_w		bigint;
nm_sca_w			varchar(150);
ds_resumo_sca_w			varchar(255);
vl_sca_w			double precision;
nr_seq_sca_segurado_w		bigint;
qt_reg_sca_pf_1_w		bigint;
qt_reg_sca_pf_w			bigint;
qt_bonificacao_exist_w		bigint	:= 0;
qt_sca_existentes_w		bigint	:= 0;
tx_desconto_w			double precision;
nr_seq_regra_desconto_w		bigint;
ie_valor_embutido_sca_w		varchar(10);
vl_sca_embutido_w		double precision := 0;
------------------------------------------------------------
qt_produtos_principal_w		bigint;
qt_faixa_etaria_pj_w		bigint;
qt_plano_resumo_pj_w		bigint;
qt_faixas_deletadas_w		bigint;
vl_simul_produto_pj_w		double precision;
ds_resumo_plano_pj_w		varchar(250);
ds_res_faixa_etaria_w		varchar(250);
qt_produtos_w			bigint;
qt_beneficiario_w		bigint;
qt_idade_inicial_w		bigint;
qt_idade_final_w		bigint;
nr_seq_plano_pj_w		bigint;
nr_seq_tabela_pj_w		bigint;
vl_mensalidade_pj_w		double precision;
vl_preco_sem_desc_pj_w		double precision;
nr_seq_resumo_trocado_w		bigint;
nr_seq_plano_w			bigint;
ds_resumo_bonific_pj_w		varchar(250);
vl_resumo_bonificacao_w		double precision := 0;
qt_reg_bonificacao_pj_w		bigint;
qt_benef_simul_pj_w		bigint;
ds_resumo_sca_pj_w		varchar(250);
vl_resumo_sca_pj_w		double precision := 0;
qt_reg_sca_pj_w			bigint;
qt_bonific_exist_pj_w		bigint;
qt_sca_existentes_pj_w		bigint;
nr_seq_coletivo_w		bigint;
vl_simul_coletivo_pj_w		double precision := 0;
dt_simulacao_w			timestamp;
vl_inscricao_w			double precision;
qt_regitros_benef_5_w		bigint;
nr_seq_benef_simulacao_w	bigint;
nr_seq_resumo_ordem_1_w		bigint;
vl_mensalidade_beneficiario_w	double precision;
nr_seq_regra_w			bigint;
vl_via_carteira_ww		bigint;
vl_via_carteira_w		bigint;
tx_via_carteira_w		bigint;
nr_seq_contrato_w		bigint;
qt_vidas_simul_indiv_w		integer;
ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;

nr_seq_simulacao_w		pls_simulacao_preco.nr_sequencia%type;
BEGIN

select	dt_simulacao
into STRICT	dt_simulacao_w
from	pls_simulacao_preco
where	nr_sequencia	= nr_seq_simulacao_p;

ie_valor_embutido_sca_w := coalesce(obter_valor_param_usuario(1233, 8, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

if (ie_tipo_simulacao_p = 'I') then
	if (ie_tipo_entrada_p	= 'BS') then
		if (ie_tipo_operacao_p	in ('I','E')) then
			select	a.nm_beneficiario,
				a.qt_idade,
				coalesce(a.vl_mensalidade,0),
				coalesce(a.ie_tipo_benef,'T'),
				CASE WHEN a.ie_tipo_benef='T' THEN 'Titular'  ELSE 'Dependente' END ,
				a.nr_seq_produto,
				coalesce(a.nr_seq_tabela,0),
				coalesce(a.vl_inscricao,0),
				(	select 	max(x.nr_seq_contrato)
					from	pls_simulacao_preco	x
					where	x.nr_sequencia 	= a.nr_seq_simulacao)
			into STRICT	nm_beneficiario_w,
				qt_idade_w,
				vl_simulacao_benef_w,
				ie_tipo_benef_w,
				ds_tipo_benef_w,
				nr_seq_produto_w,
				nr_seq_tabela_w,
				vl_inscricao_w,
				nr_seq_contrato_w
			from	pls_simulpreco_individual	a
			where	a.nr_sequencia	= nr_seq_item_p;

			ds_resumo_benef_w	:= nm_beneficiario_w || ' - ' || qt_idade_w || ' anos - ' || ds_tipo_benef_w;
			ds_resumo_produto_w	:= '                Produto - ' || substr(pls_obter_dados_produto(nr_seq_produto_w,'N'),1,255);

			if (nr_seq_tabela_w <> 0) then

				begin
				select	coalesce(ie_preco_vidas_contrato,'N'),
					coalesce(ie_calculo_vidas,'A')
				into STRICT	ie_preco_vidas_contrato_w,
					ie_calculo_vidas_w
				from	pls_tabela_preco
				where	nr_sequencia = nr_seq_tabela_w;
				exception
				when others then
					ie_preco_vidas_contrato_w	:= 'N';
					ie_calculo_vidas_w		:= 'A';
				end;

				if (ie_preco_vidas_contrato_w = 'S') then
					qt_vidas_simul_indiv_w := 0;

					if (ie_calculo_vidas_w in ('A','F')) then
						select	count(1)
						into STRICT	qt_vidas_simul_indiv_w
						from	pls_simulpreco_individual
						where	nr_seq_simulacao = nr_seq_simulacao_p;
					elsif (ie_calculo_vidas_w = 'T') then
						select	count(1)
						into STRICT	qt_vidas_simul_indiv_w
						from	pls_simulpreco_individual
						where	nr_seq_simulacao = nr_seq_simulacao_p
						and	ie_tipo_benef = 'T';
					elsif (ie_calculo_vidas_w = 'D') then
						select	count(1)
						into STRICT	qt_vidas_simul_indiv_w
						from	pls_simulpreco_individual
						where	nr_seq_simulacao = nr_seq_simulacao_p
						and	ie_tipo_benef = 'D';
					elsif (ie_calculo_vidas_w = 'TD') then
						select	count(1)
						into STRICT	qt_vidas_simul_indiv_w
						from	pls_simulpreco_individual a
						where	nr_seq_simulacao = nr_seq_simulacao_p
						and	((ie_tipo_benef = 'T') or ((ie_tipo_benef = 'D') and ((	SELECT	count(1)
														from	grau_parentesco x
														where	x.nr_sequencia = a.nr_seq_parentesco
														and	x.ie_tipo_parentesco = '1') > 0)));
					end if;
				end if;

				select	max(vl_preco_atual)
				into STRICT	vl_simulacao_produto_w
				from	pls_plano_preco
				where	nr_seq_tabela	= nr_seq_tabela_w
				and	qt_idade_w between qt_idade_inicial and qt_idade_final
				and	((substr(ie_grau_titularidade,1,1) = ie_tipo_benef_w) or (coalesce(ie_grau_titularidade::text, '') = ''))
				and	((ie_preco_vidas_contrato_w = 'S' and
					  qt_vidas_simul_indiv_w between coalesce(qt_vidas_inicial,qt_vidas_simul_indiv_w) and coalesce(qt_vidas_final,qt_vidas_simul_indiv_w)) or (ie_preco_vidas_contrato_w = 'N'));

				SELECT * FROM pls_obter_regra_desconto(nr_seq_item_p, 3, cd_estabelecimento_p, tx_desconto_w, nr_seq_regra_desconto_w) INTO STRICT tx_desconto_w, nr_seq_regra_desconto_w;

				if (tx_desconto_w	<> 0) then
					vl_simulacao_produto_w	:= vl_simulacao_produto_w - dividir((vl_simulacao_produto_w * tx_desconto_w), 100);
				end if;
			else
				vl_simulacao_produto_w	:= 0;
			end if;

			SELECT * FROM pls_obter_regra_via_adic(nr_seq_contrato_w, null, nr_seq_produto_w, 1, 'N', wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_p, clock_timestamp(), nr_seq_regra_w, vl_via_carteira_ww, tx_via_carteira_w) INTO STRICT nr_seq_regra_w, vl_via_carteira_ww, tx_via_carteira_w;

			if (coalesce(tx_via_carteira_w,0) <> 0) then
				vl_via_carteira_w := dividir((vl_simulacao_produto_w * tx_via_carteira_w), 100);
			elsif (coalesce(vl_via_carteira_ww,0) <> 0) then
				vl_via_carteira_w := vl_via_carteira_ww;
			end if;

			if (ie_valor_embutido_sca_w = 'S') then
				vl_sca_embutido_w	:= coalesce(pls_obter_vl_sca_embut_simul(nr_seq_item_p),0);

				if (coalesce(vl_sca_embutido_w,0) > 0) then
					vl_simulacao_produto_w	:= vl_simulacao_produto_w + vl_sca_embutido_w;
				end if;
			end if;
		end if;

		--Inserir dados
		if (ie_tipo_operacao_p = 'I') then
			--Inserir o beneficiário
			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
					vl_resumo,ie_tipo_pessoa,vl_sca_embutido)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					cd_estabelecimento_p,nr_seq_simulacao_p,1,ds_resumo_benef_w,nr_seq_item_p,
					vl_simulacao_benef_w,'PF',vl_sca_embutido_w);
			--Inserir o produto do beneficiário
			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
					vl_resumo,ie_tipo_pessoa,ie_tipo_item,vl_sca_embutido)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					cd_estabelecimento_p,nr_seq_simulacao_p,2,ds_resumo_produto_w,nr_seq_item_p,
					vl_simulacao_produto_w,'PF','1',vl_sca_embutido_w);
			--Inserir o valor de inscrição do beneficiário
			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
					vl_resumo,ie_tipo_pessoa,ie_tipo_item)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					cd_estabelecimento_p,nr_seq_simulacao_p,5,'                Taxa de inscrição',nr_seq_item_p,
					vl_inscricao_w,'PF','2');
			--Inserir o valor da via carteira
			if (coalesce(vl_via_carteira_w, 0) > 0) then
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
						vl_resumo,ie_tipo_pessoa,ie_tipo_item)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,6,'                Via do cartão de identificação',nr_seq_item_p,
						vl_via_carteira_w,'PF','11');
			end if;

			--Verificar se já é existente vinculo com bonificação
			select	count(1)
			into STRICT	qt_bonificacao_exist_w
			from (SELECT	1
				from	pls_bonificacao_vinculo
				where	nr_seq_segurado_simul	= nr_seq_item_p
				
union all

				SELECT	1
				from	pls_bonificacao_vinculo
				where	nr_seq_simulacao	= nr_seq_simulacao_p) alias1;

			--Verificar se já é existente vinculo com o sca
			select	count(1)
			into STRICT	qt_sca_existentes_w
			from (SELECT	1
				from	pls_sca_vinculo
				where	nr_seq_segurado_simul	= nr_seq_item_p
				
union all

				SELECT	1
				from	pls_sca_vinculo
				where	nr_seq_simulacao	= nr_seq_simulacao_p) alias1;

		--Editar dados
		elsif (ie_tipo_operacao_p = 'E') then
			--Verificar se já é existente vinculo com bonificação
			select	count(1)
			into STRICT	qt_bonificacao_exist_w
			from (SELECT	1
				from	pls_bonificacao_vinculo
				where	nr_seq_segurado_simul	= nr_seq_item_p
				
union all

				SELECT	1
				from	pls_bonificacao_vinculo
				where	nr_seq_simulacao	= nr_seq_simulacao_p) alias2;

			--Verificar se já é existente vinculo com o sca
			select	count(1)
			into STRICT	qt_sca_existentes_w
			from (SELECT	1
				from	pls_sca_vinculo
				where	nr_seq_segurado_simul	= nr_seq_item_p
				
union all

				SELECT	1
				from	pls_sca_vinculo
				where	nr_seq_simulacao	= nr_seq_simulacao_p) alias1;

			select	count(1)
			into STRICT	qt_regitros_benef_1_w
			from	pls_simulacao_resumo
			where	nr_seq_segurado_simul	= nr_seq_item_p
			and	nr_seq_ordem		= 1
			and	ie_tipo_pessoa		= 'PF';

			if (qt_regitros_benef_1_w > 0) then
				update	pls_simulacao_resumo
				set	ds_item_resumo		= ds_resumo_benef_w,
					vl_resumo		= vl_simulacao_benef_w,
					vl_sca_embutido		= vl_sca_embutido_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 1
				and	nr_seq_segurado_simul	= nr_seq_item_p
				and	ie_tipo_pessoa		= 'PF';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
						vl_resumo,ie_tipo_pessoa,vl_sca_embutido)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,1,ds_resumo_benef_w,nr_seq_item_p,
						vl_simulacao_benef_w,'PF',vl_sca_embutido_w);
			end if;

			--Alterar informação do produto do beneficiário
			select	count(1)
			into STRICT	qt_regitros_benef_2_w
			from	pls_simulacao_resumo
			where	nr_seq_segurado_simul	= nr_seq_item_p
			and	nr_seq_ordem		= 2
			and	ie_tipo_pessoa		= 'PF';

			if (qt_regitros_benef_2_w > 0) then
				update	pls_simulacao_resumo
				set	ds_item_resumo		= ds_resumo_produto_w,
					vl_resumo		= vl_simulacao_produto_w,
					vl_sca_embutido		= vl_sca_embutido_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 2
				and	nr_seq_segurado_simul	= nr_seq_item_p
				and	ie_tipo_pessoa		= 'PF';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
						vl_resumo,ie_tipo_pessoa,ie_tipo_item,vl_sca_embutido)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,2,ds_resumo_produto_w,nr_seq_item_p,
						vl_simulacao_produto_w,'PF','1',vl_sca_embutido_w);
			end if;

			--Alterar nformação de inscrição do beneficiário
			select	count(1)
			into STRICT	qt_regitros_benef_5_w
			from	pls_simulacao_resumo
			where	nr_seq_segurado_simul	= nr_seq_item_p
			and	nr_seq_ordem		= 5
			and	ie_tipo_pessoa		= 'PF';

			if (qt_regitros_benef_5_w > 0) then
				update	pls_simulacao_resumo
				set	vl_resumo		= vl_inscricao_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 5
				and	nr_seq_segurado_simul	= nr_seq_item_p
				and	ie_tipo_pessoa		= 'PF';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,ds_item_resumo,nr_seq_segurado_simul,
						vl_resumo,ie_tipo_pessoa,ie_tipo_item)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,5,'                Taxa de inscrição',nr_seq_item_p,
						vl_inscricao_w,'PF','2');
			end if;
		end if;

		if (qt_sca_existentes_w > 0) then
			CALL pls_alt_resumo_simul_sca(nr_seq_simulacao_p,nr_seq_item_p,'I',cd_estabelecimento_p,nm_usuario_p);
		end if;

		if (qt_bonificacao_exist_w > 0) then
			CALL pls_alt_resumo_simul_bonific(nr_seq_simulacao_p,nr_seq_item_p,'I',cd_estabelecimento_p,nm_usuario_p);
		end if;

		--Deletar dados
		if (ie_tipo_operacao_p in ('D','I')) then
			open C03;
			loop
			fetch C03 into
				nr_seq_benef_simulacao_w,
				vl_mensalidade_beneficiario_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				CALL pls_alt_resumo_simul_bonific(nr_seq_simulacao_p,nr_seq_benef_simulacao_w,'I',cd_estabelecimento_p,nm_usuario_p);

				select	max(nr_sequencia)
				into STRICT	nr_seq_resumo_ordem_1_w
				from	pls_simulacao_resumo
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_segurado_simul	= nr_seq_benef_simulacao_w
				and	nr_seq_ordem	= 1;

				update	pls_simulacao_resumo
				set	vl_resumo	= vl_mensalidade_beneficiario_w
				where	nr_sequencia	= nr_seq_resumo_ordem_1_w;
				end;
			end loop;
			close C03;
		end if;

	elsif (ie_tipo_entrada_p	= 'BO') then
		select	a.nm_bonificacao,
			b.nr_seq_segurado_simul,
			b.nr_seq_simulacao
		into STRICT	nm_bonificacao_w,
			nr_seq_boni_segurado_w,
			nr_seq_simulacao_w
		from	pls_bonificacao_vinculo	b,
			pls_bonificacao		a
		where	b.nr_seq_bonificacao	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_item_p;

		for r_c04_w in C04(nr_seq_boni_segurado_w, nr_seq_simulacao_w) loop
			begin
			ds_resumo_bonificacao_w	:= '                Bonificação - ' || nm_bonificacao_w;
			vl_bonificacao_w := pls_gerar_resumo_itens_adic(r_c04_w.nr_seq_segurado_simul, nr_seq_item_p, 'B', vl_bonificacao_w);

			select	count(1)
			into STRICT	qt_regitros_benef_1_w
			from	pls_simulacao_resumo
			where	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
			and	nr_seq_ordem		= 1
			and	ie_tipo_pessoa		= 'PF';

			if (qt_regitros_benef_1_w > 0) and (ie_tipo_operacao_p in ('I','E')) then
				update	pls_simulacao_resumo
				set	vl_resumo		= r_c04_w.vl_mensalidade
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 1
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	ie_tipo_pessoa		= 'PF';
			elsif (qt_regitros_benef_1_w > 0) and (ie_tipo_operacao_p = 'D') then
				update	pls_simulacao_resumo
				set	vl_resumo		= r_c04_w.vl_mensalidade + vl_bonificacao_w *-1
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 1
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	ie_tipo_pessoa		= 'PF';
			end if;

			--Inserir dados
			if (ie_tipo_operacao_p = 'I') then
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_segurado_simul,nr_seq_vinc_bonificacao,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa,ie_tipo_item)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,3,r_c04_w.nr_seq_segurado_simul,nr_seq_item_p,
						ds_resumo_bonificacao_w,vl_bonificacao_w,'PF','14');
			--Editar dados
			elsif (ie_tipo_operacao_p = 'E') then
				select	count(1)
				into STRICT	qt_reg_bonificacao_pf_w
				from	pls_simulacao_resumo
				where	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	nr_seq_vinc_bonificacao	= nr_seq_item_p
				and	nr_seq_ordem		= 3
				and	ie_tipo_pessoa		= 'PF';

				if (qt_reg_bonificacao_pf_w > 0) then
					update	pls_simulacao_resumo
					set	ds_item_resumo		= ds_resumo_bonificacao_w,
						vl_resumo		= vl_bonificacao_w
					where	nr_seq_simulacao	= nr_seq_simulacao_p
					and	nr_seq_vinc_bonificacao	= nr_seq_item_p
					and	nr_seq_ordem		= 3
					and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
					and	ie_tipo_pessoa		= 'PF';
				else
					insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_segurado_simul,nr_seq_vinc_bonificacao,
							ds_item_resumo,vl_resumo,ie_tipo_pessoa,ie_tipo_item)
					values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
							cd_estabelecimento_p,nr_seq_simulacao_p,3,r_c04_w.nr_seq_segurado_simul,nr_seq_item_p,
							ds_resumo_bonificacao_w,vl_bonificacao_w,'PF','14');
				end if;
			--Deletar dados
			elsif (ie_tipo_operacao_p = 'D') then
				delete	FROM pls_simulacao_resumo
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 3
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	nr_seq_vinc_bonificacao	= nr_seq_item_p
				and	ie_tipo_pessoa		= 'PF';
			end if;
			end;
		end loop;--C04
	elsif (ie_tipo_entrada_p = 'SC') then
		select	a.ds_plano,
			b.nr_seq_segurado_simul,
			b.nr_seq_simulacao
		into STRICT	nm_sca_w,
			nr_seq_sca_segurado_w,
			nr_seq_simulacao_w
		from	pls_sca_vinculo	b,
			pls_plano		a
		where	b.nr_seq_plano		= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_item_p;

		for r_c04_w in C04(nr_seq_sca_segurado_w, nr_seq_simulacao_w) loop
			begin
			ds_resumo_sca_w	:= '                SCA - ' || nm_sca_w;
			vl_sca_w := pls_gerar_resumo_itens_adic(r_c04_w.nr_seq_segurado_simul, nr_seq_item_p, 'S', vl_sca_w);

			select	count(1)
			into STRICT	qt_reg_sca_pf_1_w
			from	pls_simulacao_resumo
			where	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
			and	nr_seq_ordem		= 1
			and	ie_tipo_pessoa		= 'PF';

			if (qt_reg_sca_pf_1_w > 0) and (ie_tipo_operacao_p in ('I','E')) then
				update	pls_simulacao_resumo
				set	vl_resumo		= r_c04_w.vl_mensalidade
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 1
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	ie_tipo_pessoa		= 'PF';
			elsif (qt_reg_sca_pf_1_w > 0) and (ie_tipo_operacao_p = 'D') then
				update	pls_simulacao_resumo
				set	vl_resumo		= r_c04_w.vl_mensalidade - vl_sca_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 1
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	ie_tipo_pessoa		= 'PF';
			end if;

			--Inserir dados
			if (ie_tipo_operacao_p = 'I') then
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_segurado_simul,nr_seq_vinc_sca,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa,ie_tipo_item)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,4,r_c04_w.nr_seq_segurado_simul,nr_seq_item_p,
						ds_resumo_sca_w,vl_sca_w,'PF','15');
			--Editar dados
			elsif (ie_tipo_operacao_p = 'E') then
				select	count(1)
				into STRICT	qt_reg_sca_pf_w
				from	pls_simulacao_resumo
				where	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	nr_seq_vinc_sca	= nr_seq_item_p
				and	nr_seq_ordem		= 4
				and	ie_tipo_pessoa		= 'PF';

				if (qt_reg_sca_pf_w > 0) then
					update	pls_simulacao_resumo
					set	ds_item_resumo		= ds_resumo_sca_w,
						vl_resumo		= vl_sca_w
					where	nr_seq_simulacao	= nr_seq_simulacao_p
					and	nr_seq_vinc_sca		= nr_seq_item_p
					and	nr_seq_ordem		= 4
					and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
					and	ie_tipo_pessoa		= 'PF';
				else
					insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_segurado_simul,nr_seq_vinc_sca,
							ds_item_resumo,vl_resumo,ie_tipo_pessoa,ie_tipo_item)
					values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
							cd_estabelecimento_p,nr_seq_simulacao_p,4,r_c04_w.nr_seq_segurado_simul,nr_seq_item_p,
							ds_resumo_sca_w,vl_sca_w,'PF','15');
				end if;
			--Deletar dados
			elsif (ie_tipo_operacao_p = 'D') then
				delete	FROM pls_simulacao_resumo
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_ordem		= 4
				and	nr_seq_segurado_simul	= r_c04_w.nr_seq_segurado_simul
				and	nr_seq_vinc_sca		= nr_seq_item_p
				and	ie_tipo_pessoa		= 'PF';
			end if;
			end;
		end loop; --C04
	end if;

	CALL pls_gerar_pro_rata_simulacao(nr_seq_simulacao_p,cd_estabelecimento_p,nm_usuario_p);
elsif (ie_tipo_simulacao_p in ('CA','CE')) then
	select	coalesce(sum(qt_beneficiario),0)
	into STRICT	qt_benef_simul_pj_w
	from	pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;
	if (ie_tipo_entrada_p	= 'BS') then
		if (ie_tipo_operacao_p	in ('I','E')) then
			select	coalesce(qt_beneficiario,0),
				qt_idade_inicial,
				qt_idade_final,
				nr_seq_plano,
				nr_seq_tabela,
				coalesce(vl_mensalidade,0),
				coalesce(vl_preco_sem_desconto,0)
			into STRICT	qt_beneficiario_w,
				qt_idade_inicial_w,
				qt_idade_final_w,
				nr_seq_plano_pj_w,
				nr_seq_tabela_pj_w,
				vl_mensalidade_pj_w,
				vl_preco_sem_desc_pj_w
			from	pls_simulpreco_coletivo
			where	nr_sequencia	= nr_seq_item_p;

			ds_res_faixa_etaria_w	:= '                Faixa etária ' || qt_idade_inicial_w || ' á ' || qt_idade_final_w || ' - Quantidade = ' || qt_beneficiario_w;

			if (coalesce(nr_seq_plano_pj_w,0) <> 0) and (coalesce(nr_seq_tabela_pj_w,0) <> 0) then
				ds_resumo_plano_pj_w	:= 'Produto - ' || substr(pls_obter_dados_produto(nr_seq_plano_pj_w,'N'),1,255);

				begin
				select	coalesce(vl_resumo,0)
				into STRICT	vl_simul_produto_pj_w
				from	pls_simulacao_resumo
				where	nr_seq_ordem		= 1
				and	nr_seq_plano		= nr_seq_plano_pj_w
				and	nr_seq_simulacao	= nr_seq_simulacao_p;
				exception
				when others then
					vl_simul_produto_pj_w	:= 0;
				end;

				SELECT * FROM pls_obter_regra_desconto(nr_seq_simulacao_p, 4, cd_estabelecimento_p, tx_desconto_w, nr_seq_regra_desconto_w) INTO STRICT tx_desconto_w, nr_seq_regra_desconto_w;

				if (tx_desconto_w	<> 0) then
					vl_simul_produto_pj_w	:= vl_simul_produto_pj_w + dividir((vl_simul_produto_pj_w * tx_desconto_w),100);
				else
					vl_simul_produto_pj_w	:= vl_simul_produto_pj_w + vl_mensalidade_pj_w;
				end if;
			end if;
		end if;

		--Inserir dados
		if (ie_tipo_operacao_p	= 'I') and (coalesce(nr_seq_plano_pj_w,0) <> 0) then
			select	count(1)
			into STRICT	qt_produtos_principal_w
			from	pls_simulacao_resumo
			where	nr_seq_ordem		= 1
			and	nr_seq_plano		= nr_seq_plano_pj_w
			and	nr_seq_simulacao	= nr_seq_simulacao_p
			and	ie_tipo_pessoa		= 'PJ';

			select	count(1)
			into STRICT	qt_sca_existentes_pj_w
			from	pls_sca_vinculo
			where	nr_seq_simulacao	= nr_seq_simulacao_p;

			if (qt_produtos_principal_w = 0) then
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,1,nr_seq_plano_pj_w,
						ds_resumo_plano_pj_w,vl_simul_produto_pj_w,'PJ');
			elsif (qt_produtos_principal_w > 0) then
				update	pls_simulacao_resumo
				set	vl_resumo		= vl_simul_produto_pj_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_plano		= nr_seq_plano_pj_w
				and	nr_seq_ordem		= 1
				and	ie_tipo_pessoa		= 'PJ';
			end if;

			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_simul_coletivo,
						nr_seq_plano,ds_item_resumo,vl_resumo,ie_tipo_pessoa)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,2,nr_seq_item_p,
						nr_seq_plano_pj_w,ds_res_faixa_etaria_w,vl_mensalidade_pj_w,'PJ');

			if (qt_sca_existentes_pj_w > 0) then
				CALL pls_alt_resumo_simul_sca(nr_seq_simulacao_p,null,'C',cd_estabelecimento_p,nm_usuario_p);
			end if;
		--Editar dados
		elsif (ie_tipo_operacao_p	= 'E') and (coalesce(nr_seq_plano_pj_w,0) <> 0) then
			select	count(1)
			into STRICT	qt_plano_resumo_pj_w
			from	pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	ie_tipo_pessoa		= 'PJ'
			and	nr_seq_plano		<> nr_seq_plano_pj_w
			and	nr_seq_ordem		= 2;

			select	count(1)
			into STRICT	qt_bonific_exist_pj_w
			from	pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_ordem		= 3
			and	ie_tipo_pessoa		= 'PJ'
			and	(nr_seq_vinc_bonificacao IS NOT NULL AND nr_seq_vinc_bonificacao::text <> '');

			select	count(1)
			into STRICT	qt_sca_existentes_pj_w
			from	pls_sca_vinculo
			where	nr_seq_simulacao	= nr_seq_simulacao_p;

			if (qt_plano_resumo_pj_w = 1) then
				select	nr_sequencia
				into STRICT	nr_seq_resumo_trocado_w
				from	pls_simulacao_resumo
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	ie_tipo_pessoa		= 'PJ'
				and	nr_seq_plano		<> nr_seq_plano_pj_w
				and	nr_seq_ordem		= 1;
				delete	FROM pls_simulacao_resumo
				where	nr_sequencia	= nr_seq_resumo_trocado_w;
			end if;

			select	count(1)
			into STRICT	qt_produtos_principal_w
			from	pls_simulacao_resumo
			where	nr_seq_ordem		= 1
			and	nr_seq_plano		= nr_seq_plano_pj_w
			and	nr_seq_simulacao	= nr_seq_simulacao_p
			and	ie_tipo_pessoa		= 'PJ';

			if (qt_produtos_principal_w = 0) then
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,1,nr_seq_plano_pj_w,
						ds_resumo_plano_pj_w,vl_simul_produto_pj_w,'PJ');
			elsif (qt_produtos_principal_w > 0) then
				update	pls_simulacao_resumo
				set	vl_resumo		= vl_simul_produto_pj_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_plano		= nr_seq_plano_pj_w
				and	nr_seq_ordem		= 1
				and	ie_tipo_pessoa		= 'PJ';
			end if;

			select	count(1)
			into STRICT	qt_faixa_etaria_pj_w
			from	pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_simul_coletivo	= nr_seq_item_p
			and	nr_seq_ordem		= 2
			and	ie_tipo_pessoa		= 'PJ';

			if (qt_faixa_etaria_pj_w > 0) then
				update	pls_simulacao_resumo
				set	vl_resumo		= vl_mensalidade_pj_w,
					ds_item_resumo		= ds_res_faixa_etaria_w,
					nr_seq_plano		= nr_seq_plano_pj_w
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_simul_coletivo	= nr_seq_item_p
				and	nr_seq_ordem		= 2
				and	ie_tipo_pessoa		= 'PJ';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_simul_coletivo,
						nr_seq_plano,ds_item_resumo,vl_resumo,ie_tipo_pessoa)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,2,nr_seq_item_p,
						nr_seq_plano_pj_w,ds_res_faixa_etaria_w,vl_mensalidade_pj_w,'PJ');
			end if;

			if (qt_bonific_exist_pj_w > 0) then
				CALL pls_alt_resumo_simul_bonific(nr_seq_simulacao_p,null,'C',cd_estabelecimento_p,nm_usuario_p);
			end if;

			if (qt_sca_existentes_pj_w > 0) then
				CALL pls_alt_resumo_simul_sca(nr_seq_simulacao_p,null,'C',cd_estabelecimento_p,nm_usuario_p);
			end if;
		--Deletar dados
		elsif (ie_tipo_operacao_p	= 'D') then
			delete	FROM pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_simul_coletivo	= nr_seq_item_p
			and	nr_seq_ordem		= 2;

			begin
			select	nr_seq_plano
			into STRICT	nr_seq_plano_pj_w
			from	pls_simulpreco_coletivo
			where	nr_sequencia	= nr_seq_item_p;
			exception
			when others then
				nr_seq_plano_pj_w	:= 0;
			end;

			if (coalesce(nr_seq_plano_pj_w,0) <> 0) then
				select	count(1)
				into STRICT	qt_faixas_deletadas_w
				from	pls_simulacao_resumo
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_plano		= nr_seq_plano_pj_w
				and	nr_seq_ordem		= 2;

				if (qt_faixas_deletadas_w	= 0) then
					delete	FROM pls_simulacao_resumo
					where	nr_seq_simulacao	= nr_seq_simulacao_p
					and	nr_seq_plano		= nr_seq_plano_pj_w
					and	nr_seq_ordem		= 1;
				end if;
			end if;
		end if;
	elsif (ie_tipo_entrada_p	= 'BO') then
		select	a.nm_bonificacao
		into STRICT	nm_bonificacao_w
		from	pls_bonificacao_vinculo	b,
			pls_bonificacao		a
		where	b.nr_seq_bonificacao	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_item_p;

		ds_resumo_bonific_pj_w	:= 'Bonificação - ' || nm_bonificacao_w || ' - Qt. = ' || qt_benef_simul_pj_w;
		vl_resumo_bonificacao_w	:= coalesce(pls_obter_valores_simul_pj(nr_seq_simulacao_p,null,nr_seq_item_p,'B'),0);

		--Inserir dados
		if (ie_tipo_operacao_p = 'I') then
			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,nr_seq_vinc_bonificacao,
					ds_item_resumo,vl_resumo,ie_tipo_pessoa)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					cd_estabelecimento_p,nr_seq_simulacao_p,3,0,nr_seq_item_p,
					ds_resumo_bonific_pj_w,vl_resumo_bonificacao_w,'PJ');
		--Editar dados
		elsif (ie_tipo_operacao_p = 'E') then
			select	count(1)
			into STRICT	qt_reg_bonificacao_pj_w
			from	pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_vinc_bonificacao	= nr_seq_item_p
			and	nr_seq_ordem		= 3
			and	ie_tipo_pessoa		= 'PJ';

			if (qt_reg_bonificacao_pj_w > 0) then
				update	pls_simulacao_resumo
				set	ds_item_resumo		= ds_resumo_bonific_pj_w,
					vl_resumo		= vl_resumo_bonificacao_w,
					nr_seq_plano		= 0
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_vinc_bonificacao	= nr_seq_item_p
				and	nr_seq_ordem		= 3
				and	ie_tipo_pessoa		= 'PJ';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,nr_seq_vinc_bonificacao,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,3,0,nr_seq_item_p,
						ds_resumo_bonific_pj_w,vl_resumo_bonificacao_w,'PJ');
			end if;
		--Deletar dados
		elsif (ie_tipo_operacao_p = 'D') then
			delete	FROM pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_ordem		= 3
			and	nr_seq_vinc_bonificacao	= nr_seq_item_p
			and	ie_tipo_pessoa		= 'PJ';
		end if;
	elsif (ie_tipo_entrada_p = 'SC') then
		select	a.ds_plano
		into STRICT	nm_sca_w
		from	pls_sca_vinculo	b,
			pls_plano		a
		where	b.nr_seq_plano		= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_item_p;

		ds_resumo_sca_pj_w	:= 'SCA - ' || nm_sca_w || ' - Qt. = ' || qt_benef_simul_pj_w;
		vl_resumo_sca_pj_w	:= coalesce(pls_obter_valores_simul_pj(nr_seq_simulacao_p,null,nr_seq_item_p,'S'),0);

		--Inserir dados
		if (ie_tipo_operacao_p = 'I') then
			insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,nr_seq_vinc_sca,
					ds_item_resumo,vl_resumo,ie_tipo_pessoa)
			values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					cd_estabelecimento_p,nr_seq_simulacao_p,4,0,nr_seq_item_p,
					ds_resumo_sca_pj_w,vl_resumo_sca_pj_w,'PJ');
		--Editar dados
		elsif (ie_tipo_operacao_p = 'E') then
			select	count(1)
			into STRICT	qt_reg_sca_pj_w
			from	pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_vinc_sca	= nr_seq_item_p
			and	nr_seq_ordem		= 4
			and	ie_tipo_pessoa		= 'PJ';

			if (qt_reg_sca_pj_w > 0) then
				update	pls_simulacao_resumo
				set	ds_item_resumo		= ds_resumo_sca_pj_w,
					vl_resumo		= vl_resumo_sca_pj_w,
					nr_seq_plano		= 0
				where	nr_seq_simulacao	= nr_seq_simulacao_p
				and	nr_seq_vinc_sca	= nr_seq_item_p
				and	nr_seq_ordem		= 4
				and	ie_tipo_pessoa		= 'PJ';
			else
				insert into	pls_simulacao_resumo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						cd_estabelecimento,nr_seq_simulacao,nr_seq_ordem,nr_seq_plano,nr_seq_vinc_sca,
						ds_item_resumo,vl_resumo,ie_tipo_pessoa)
				values (	nextval('pls_simulacao_resumo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						cd_estabelecimento_p,nr_seq_simulacao_p,4,0,nr_seq_item_p,
						ds_resumo_sca_pj_w,vl_resumo_sca_pj_w,'PJ');
			end if;
		--Deletar dados
		elsif (ie_tipo_operacao_p = 'D') then
			delete	FROM pls_simulacao_resumo
			where	nr_seq_simulacao	= nr_seq_simulacao_p
			and	nr_seq_ordem		= 4
			and	nr_seq_vinc_sca		= nr_seq_item_p
			and	ie_tipo_pessoa		= 'PJ';
		end if;
	end if;
	open C01;
	loop
	fetch C01 into
		nr_seq_plano_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	coalesce(sum(vl_preco_sem_desconto),0)
		into STRICT	vl_simul_produto_pj_w
		from	pls_simulpreco_coletivo
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	nr_seq_plano		= nr_seq_plano_w;

		update	pls_simulacao_resumo
		set	vl_resumo		= vl_simul_produto_pj_w
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	nr_seq_plano		= nr_seq_plano_w
		and	nr_seq_ordem		= 1
		and	ie_tipo_pessoa		= 'PJ';

		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_coletivo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	coalesce(sum(vl_preco_sem_desconto),2)
		into STRICT	vl_simul_coletivo_pj_w
		from	pls_simulpreco_coletivo
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	nr_sequencia		= nr_seq_coletivo_w;

		update	pls_simulacao_resumo
		set	vl_resumo		= vl_simul_coletivo_pj_w
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	nr_seq_simul_coletivo	= nr_seq_coletivo_w
		and	nr_seq_ordem		= 2
		and	ie_tipo_pessoa		= 'PJ';

		end;
	end loop;
	close C02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_resumo_simulacao ( nr_seq_simulacao_p bigint, nr_seq_item_p bigint, ie_tipo_operacao_p text, ie_tipo_entrada_p text, ie_tipo_simulacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

