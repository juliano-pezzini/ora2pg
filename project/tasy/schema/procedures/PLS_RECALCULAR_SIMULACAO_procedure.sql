-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recalcular_simulacao ( nr_seq_simulacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_contratacao_w		varchar(2);
nr_seq_tabela_w			bigint;
qt_idade_w			integer;
nr_seq_item_simul_w		bigint;
vl_preco_atual_w		double precision := 0;
vl_simulacao_w			double precision	:= 0;
cd_estabelecimento_w		smallint;
tx_desconto_w			double precision;
nr_seq_regra_desconto_w		bigint;
vl_mensal_sem_desc_w		double precision;
nr_seq_plano_w			bigint;
nr_seq_contrato_w		bigint;
tx_desconto_bonific_w		double precision := 0;
nr_seq_desconto_w		bigint;
vl_bonificacao_w		double precision;
tx_bonificacao_w		double precision;
ie_tipo_item_w			varchar(255);
vl_bonific_total_w		double precision := 0;
vl_contrato_w			double precision := 0;
vl_preco_cont_w			double precision;
tx_desc_w			double precision;
vl_minimo_w			double precision;
nr_seq_parentesco_w		bigint;
ie_alteracao_vinculacao_w	varchar(1);
ie_tipo_benef_w			varchar(1);
nr_seq_vinculo_bonificacao_w	bigint;
vl_preco_sca_w			double precision;
vl_total_bonificacao_w		double precision := 0;
vl_total_sca_w			double precision := 0;
vl_bonif_w			double precision := 0;
vl_bonificacao_vinc_w		double precision;
tx_bonificacao_vinc_w		double precision;
tx_bonif_desconto_w		double precision;
nr_seq_regra_w			bigint;
vl_via_carteira_ww		double precision;
tx_via_carteira_w		double precision;
vl_via_carteira_w		double precision;
qt_vidas_contrato_w		integer;
qt_vidas_simul_indiv_w		integer;
ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;
vl_preco_coletivo_atual_w	double precision := 0;
nr_seq_tabela_coletivo_w	bigint;
nr_seq_tabela_sca_col_w		bigint;
vl_preco_sca_coletivo_w		double precision := 0;
vl_preco_sca_tot_col_w		double precision := 0;
qt_idade_inicial_w		integer;
qt_idade_final_w		integer;
qt_beneficiario_w		integer;
vl_preco_tot_col_bonif_w	double precision := 0;
vl_preco_sem_dec_col_w		double precision := 0;
vl_inscricao_w			double precision := 0;
vl_sca_embutido_w		double precision := 0;
ie_valor_embutido_sca_w		varchar(10);
nr_seq_bonificacao_w		bigint;

--Simulação Indivdual
C00 CURSOR FOR
	SELECT	qt_idade,
		nr_seq_tabela,
		ie_tipo_benef,
		nr_seq_parentesco
	from	pls_simulpreco_individual
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

--Simulação Indivdual
C01 CURSOR FOR
	SELECT	nr_sequencia,
		qt_idade,
		nr_seq_tabela,
		nr_seq_parentesco,
		nr_seq_produto,
		ie_tipo_benef
	from	pls_simulpreco_individual
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

--Simulação Coletiva
C02 CURSOR FOR
	SELECT	nr_sequencia,
		qt_idade_inicial,
		qt_idade_final,
		qt_beneficiario,
		nr_seq_tabela
	from	pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

--Simulação Coletiva
C03 CURSOR FOR
	SELECT	c.ie_tipo_item,
		c.nr_seq_desconto,
		c.vl_bonificacao,
		c.tx_bonificacao
	from	pls_bonificacao_vinculo	a,
		pls_bonificacao		b,
		pls_bonificacao_regra	c
	where	a.nr_seq_contrato = nr_seq_contrato_w
	and	a.nr_seq_bonificacao = b.nr_sequencia
	and	c.nr_seq_bonificacao = b.nr_sequencia
	and	qt_idade_w between coalesce(c.qt_idade_inicial,qt_idade_w) and coalesce(c.qt_idade_final,qt_idade_w);

--Simulação Coletiva
C04 CURSOR FOR
	SELECT	coalesce(b.tx_bonificacao,0),
		coalesce(b.vl_bonificacao,0),
		c.ie_alteracao_vinculacao,
		a.nr_sequencia,
		b.ie_tipo_item,
		b.nr_seq_desconto
	from	pls_bonificacao_vinculo	a,
		pls_bonificacao_regra	b,
		pls_bonificacao		c
	where	a.nr_seq_simulacao = nr_seq_simulacao_p
	and	a.nr_seq_bonificacao = c.nr_sequencia
	and	b.nr_seq_bonificacao = c.nr_sequencia
	and	pls_obter_item_mens('1',b.ie_tipo_item) = 'S'
	and (coalesce(b.qt_idade_inicial,qt_idade_inicial_w) >=	qt_idade_inicial_w)
	and (coalesce(b.qt_idade_final,qt_idade_final_w) <=	qt_idade_final_w)
	and	ie_tipo_contratacao_w	<> 'I'
	
UNION ALL

	SELECT	null,
		null,
		b.ie_alteracao_vinculacao,
		a.nr_sequencia,
		'1',
		null
	from	pls_bonificacao_vinculo	a,
		pls_bonificacao		b
	where	a.nr_seq_simulacao = nr_seq_simulacao_p
	and	a.nr_seq_bonificacao = b.nr_sequencia
	and	not exists (	select	1
				from	pls_bonificacao_regra	x
				where	x.nr_seq_bonificacao 	= b.nr_sequencia)
	and	ie_tipo_contratacao_w	<> 'I';

--Simulação Coletiva
C05 CURSOR FOR
	SELECT	nr_seq_tabela
	from	pls_sca_vinculo
	where	nr_seq_simulacao	= nr_seq_simulacao_p
	and	ie_tipo_contratacao_w	<> 'I';

--Simulação Indivdual
C06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_bonificacao_vinculo
	where	nr_seq_segurado_simul	= nr_seq_item_simul_w
	
union all

	SELECT	nr_sequencia
	from	pls_bonificacao_vinculo
	where	nr_seq_simulacao	= nr_seq_simulacao_p;

--Simulação Indivdual
C07 CURSOR FOR
	SELECT	nr_seq_tabela
	from (SELECT	nr_seq_tabela
		from	pls_sca_vinculo
		where	nr_seq_segurado_simul	= nr_seq_item_simul_w
		and	(nr_seq_tabela IS NOT NULL AND nr_seq_tabela::text <> '')
		and	ie_tipo_contratacao_w	= 'I'
		
union all

		select	nr_seq_tabela
		from	pls_sca_vinculo
		where	nr_seq_simulacao	= nr_seq_simulacao_p
		and	(nr_seq_tabela IS NOT NULL AND nr_seq_tabela::text <> '')
		and	ie_tipo_contratacao_w	= 'I') alias2
	group by nr_seq_tabela;

--Preço
C08 CURSOR FOR
	SELECT	vl_preco_atual,
		vl_minimo
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_w
	and	qt_idade_w between qt_idade_inicial and qt_idade_final
	and 	((substr(ie_grau_titularidade,1,1) = ie_tipo_benef_w) or (coalesce(ie_grau_titularidade::text, '') = ''))
	and	((ie_preco_vidas_contrato_w = 'S' and
		  qt_vidas_simul_indiv_w between coalesce(qt_vidas_inicial,qt_vidas_simul_indiv_w) and coalesce(qt_vidas_final,qt_vidas_simul_indiv_w)) or (ie_preco_vidas_contrato_w = 'N'))
	order by coalesce(ie_grau_titularidade,' ');


BEGIN

select	ie_tipo_contratacao,
	cd_estabelecimento,
	nr_seq_contrato
into STRICT	ie_tipo_contratacao_w,
	cd_estabelecimento_w,
	nr_seq_contrato_w
from	pls_simulacao_preco
where	nr_sequencia	= nr_seq_simulacao_p;

ie_valor_embutido_sca_w := coalesce(obter_valor_param_usuario(1233, 8, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N');

open C00;
loop
fetch C00 into
	qt_idade_w,
	nr_seq_tabela_w,
	ie_tipo_benef_w,
	nr_seq_parentesco_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin

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

	open C08;
	loop
	fetch C08 into
		vl_preco_cont_w,
		vl_minimo_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
	end loop;
	close C08;

	vl_contrato_w := vl_contrato_w + coalesce(vl_preco_cont_w,0);
	end;
end loop;
close C00;

if (ie_tipo_contratacao_w	= 'I') then
	open C01;
	loop
	fetch C01 into
		nr_seq_item_simul_w,
		qt_idade_w,
		nr_seq_tabela_w,
		nr_seq_parentesco_w,
		nr_seq_plano_w,
		ie_tipo_benef_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		--Obter a taxa de desconto
		SELECT * FROM pls_obter_regra_desconto(nr_seq_item_simul_w, 3, cd_estabelecimento_w, tx_desconto_w, nr_seq_regra_desconto_w) INTO STRICT tx_desconto_w, nr_seq_regra_desconto_w;
		vl_total_bonificacao_w	:= 0;
		vl_mensal_sem_desc_w 	:= 0;

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

		open C08;
		loop
		fetch C08 into
			vl_preco_atual_w,
			vl_minimo_w;
		EXIT WHEN NOT FOUND; /* apply on C08 */
		end loop;
		close C08;

		if (coalesce(vl_preco_atual_w,0) > 0) then
			vl_mensal_sem_desc_w 	:= vl_preco_atual_w;
			vl_preco_atual_w	:= vl_preco_atual_w - dividir((vl_preco_atual_w * tx_desconto_w), 100);
		end if;

		update	pls_simulpreco_individual
		set	vl_mensal_sem_desc	= vl_mensal_sem_desc_w
		where	nr_sequencia		= nr_seq_item_simul_w;

		open C06;
		loop
		fetch C06 into
			nr_seq_bonificacao_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin
			vl_bonificacao_w := pls_gerar_resumo_itens_adic(nr_seq_item_simul_w, nr_seq_bonificacao_w, 'B', vl_bonificacao_w);
			vl_total_bonificacao_w	:= vl_total_bonificacao_w + vl_bonificacao_w;
			end;
		end loop;
		close C06;

		open C07;
		loop
		fetch C07 into
			nr_seq_tabela_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin

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

			open C08;
			loop
			fetch C08 into
				vl_preco_sca_w,
				vl_minimo_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
			end loop;
			close C08;

			vl_total_sca_w := vl_total_sca_w + coalesce(vl_preco_sca_w,0);
			end;
		end loop;
		close C07;

		/*aaschlote 06/05/2011 - OS - 317123 */

		CALL pls_gerar_valor_inscr_simul(nr_seq_item_simul_w,0,0);

		select	max(vl_inscricao)
		into STRICT	vl_inscricao_w
		from	pls_simulpreco_individual
		where	nr_sequencia	= nr_seq_item_simul_w;

		if (coalesce(vl_inscricao_w::text, '') = '') then
			vl_inscricao_w	:= 0;
		end if;

		/*aaschlote 24/10/2012 OS - 503533*/

		if (ie_valor_embutido_sca_w = 'S') then
			vl_sca_embutido_w	:= coalesce(pls_obter_vl_sca_embut_simul(nr_seq_item_simul_w),0);

			if (coalesce(vl_sca_embutido_w,0) > 0) then
				vl_preco_atual_w	:= vl_preco_atual_w + vl_sca_embutido_w;
			end if;
		end if;

		if (coalesce(vl_preco_atual_w,0) < coalesce(vl_minimo_w,0)) then
			vl_preco_atual_w := coalesce(vl_minimo_w,0);
		end if;

		SELECT * FROM pls_obter_regra_via_adic(nr_seq_contrato_w, null, nr_seq_plano_w, 1, 'N', nm_usuario_p, cd_estabelecimento_w, clock_timestamp(), nr_seq_regra_w, vl_via_carteira_ww, tx_via_carteira_w) INTO STRICT nr_seq_regra_w, vl_via_carteira_ww, tx_via_carteira_w;

		if (coalesce(tx_via_carteira_w,0) <> 0) then
			vl_via_carteira_w := dividir((vl_preco_atual_w * tx_via_carteira_w), 100);
		elsif (coalesce(vl_via_carteira_ww,0) <> 0) then
			vl_via_carteira_w := vl_via_carteira_ww;
		end if;

		update	pls_simulpreco_individual
		set	vl_mensalidade		= coalesce(vl_preco_atual_w,0) + vl_total_bonificacao_w + vl_total_sca_w + vl_inscricao_w + coalesce(vl_via_carteira_w,0),
			nr_seq_regra_desconto	= nr_seq_regra_desconto_w,
			tx_desconto		= tx_desconto_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_item_simul_w;

		vl_simulacao_w	:= vl_simulacao_w + coalesce(vl_preco_atual_w,0) + vl_total_bonificacao_w + vl_total_sca_w + vl_inscricao_w + coalesce(vl_via_carteira_w,0);

		vl_bonific_total_w 	:= 0;
		tx_desconto_bonific_w	:= 0;
		vl_total_bonificacao_w	:= 0;
		vl_total_sca_w		:= 0;
		vl_via_carteira_w	:= 0;
		end;
	end loop;
	close C01;
elsif (ie_tipo_contratacao_w	<> 'I') then
	SELECT * FROM pls_obter_regra_desconto(nr_seq_simulacao_p, 4, cd_estabelecimento_w, tx_desconto_w, nr_seq_regra_desconto_w) INTO STRICT tx_desconto_w, nr_seq_regra_desconto_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_item_simul_w,
		qt_idade_inicial_w,
		qt_idade_final_w,
		qt_beneficiario_w,
		nr_seq_tabela_coletivo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		begin
		select	coalesce(vl_preco_atual,0)
		into STRICT	vl_preco_coletivo_atual_w
		from	pls_plano_preco
		where	nr_seq_tabela		= nr_seq_tabela_coletivo_w
		and	qt_idade_inicial_w between qt_idade_inicial and qt_idade_final
		and	qt_idade_final_w <= qt_idade_final;
		exception
		when others then
			vl_preco_coletivo_atual_w	:= 0;
		end;

		vl_preco_coletivo_atual_w	:= vl_preco_coletivo_atual_w * qt_beneficiario_w;
		vl_preco_sem_dec_col_w		:= vl_preco_sem_dec_col_w + vl_preco_coletivo_atual_w;
		vl_preco_coletivo_atual_w	:= vl_preco_coletivo_atual_w - dividir((vl_preco_coletivo_atual_w * tx_desconto_w), 100);

		open C03;
		loop
		fetch C03 into
			ie_tipo_item_w,
			nr_seq_desconto_w,
			vl_bonificacao_w,
			tx_bonificacao_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			select	substr(pls_obter_qtd_vidas_contrato(nr_sequencia,'A'),1,10)
			into STRICT	qt_vidas_contrato_w
			from	pls_contrato
			where	nr_sequencia = nr_seq_contrato_w;

			if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then
				vl_bonific_total_w := vl_bonific_total_w + ((coalesce(tx_bonificacao_w,0)/100) * coalesce(vl_preco_coletivo_atual_w,0)) + coalesce(vl_bonificacao_w,0); /* Calcula as bonificações */
			elsif (nr_seq_desconto_w IS NOT NULL AND nr_seq_desconto_w::text <> '') then
				select	max(tx_desconto)
				into STRICT	tx_desc_w
				from	pls_preco_regra
				where	nr_seq_regra = nr_seq_desconto_w
				and	qt_vidas_contrato_w between qt_min_vidas and qt_max_vidas;

				tx_desconto_bonific_w := tx_desconto_bonific_w + coalesce(tx_desc_w,0);
			end if;

			end;
		end loop;
		close C03;

		vl_bonific_total_w := vl_bonific_total_w + ((tx_desconto_bonific_w/100) * vl_contrato_w); /* Calcula os desconto das bonificações */
		vl_preco_coletivo_atual_w := vl_preco_coletivo_atual_w - vl_bonific_total_w;

		open C04;
		loop
		fetch C04 into
			tx_bonificacao_w,
			vl_bonificacao_w,
			ie_alteracao_vinculacao_w,
			nr_seq_vinculo_bonificacao_w,
			ie_tipo_item_w,
			nr_seq_desconto_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then
				if (ie_alteracao_vinculacao_w = 'S') then
					select	coalesce(vl_bonificacao,vl_bonificacao_w),
						coalesce(tx_bonificacao,tx_bonificacao_w)
					into STRICT	vl_bonificacao_w,
						tx_bonificacao_w
					from	pls_bonificacao_vinculo	a,
						pls_bonificacao		b
					where	a.nr_seq_bonificacao		= b.nr_sequencia
					and	b.ie_alteracao_vinculacao	= 'S'
					and	a.nr_sequencia			= nr_seq_vinculo_bonificacao_w;
				end if;

				vl_preco_tot_col_bonif_w := vl_preco_tot_col_bonif_w - ((coalesce(tx_bonificacao_w,0)/100) * coalesce(vl_preco_coletivo_atual_w,0)) - coalesce(vl_bonificacao_w,0); /* Calcula as bonificações */
			elsif (nr_seq_desconto_w IS NOT NULL AND nr_seq_desconto_w::text <> '') then
				select	max(tx_desconto)
				into STRICT	tx_desconto_w
				from	pls_preco_regra
				where	nr_seq_regra = nr_seq_desconto_w
				and	qt_min_vidas >= qt_beneficiario_w
				and	qt_max_vidas <= qt_beneficiario_w;

				vl_preco_tot_col_bonif_w := vl_preco_tot_col_bonif_w - ((tx_desconto_w/100) * vl_preco_coletivo_atual_w); /* Calcula os desconto das bonificações */
			end if;
			end;
		end loop;
		close C04;

		open C05;
		loop
		fetch C05 into
			nr_seq_tabela_sca_col_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin

			select	max(vl_preco_atual)
			into STRICT	vl_preco_sca_coletivo_w
			from	pls_plano_preco
			where	nr_seq_tabela	= nr_seq_tabela_sca_col_w
			and	qt_idade_inicial_w between qt_idade_inicial and qt_idade_final
			and	qt_idade_final_w <= qt_idade_final;

			vl_preco_sca_tot_col_w := vl_preco_sca_tot_col_w + coalesce(vl_preco_sca_coletivo_w,0);
			vl_preco_sca_tot_col_w := vl_preco_sca_tot_col_w * qt_beneficiario_w;
			end;
		end loop;
		close C05;

		update	pls_simulpreco_coletivo
		set	vl_mensalidade		= coalesce(vl_preco_coletivo_atual_w,0) + coalesce(vl_preco_tot_col_bonif_w,0) + vl_preco_sca_tot_col_w,
			vl_preco_sem_desconto	= coalesce(vl_preco_sem_dec_col_w,0),
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia	= nr_seq_item_simul_w;

		if (qt_beneficiario_w > 0) then
			CALL pls_gerar_valor_inscr_simul(0, nr_seq_item_simul_w,0);

			select	max(vl_inscricao)
			into STRICT	vl_inscricao_w
			from	pls_simulpreco_coletivo
			where	nr_sequencia	= nr_seq_item_simul_w;

			vl_inscricao_w	:= coalesce(vl_inscricao_w,0) * qt_beneficiario_w;
		else
			update	pls_simulpreco_coletivo
			set	vl_inscricao	= 0
			where	nr_sequencia	= nr_seq_item_simul_w;

			vl_inscricao_w	:= 0;
		end if;

		vl_simulacao_w	:= vl_simulacao_w + coalesce(vl_preco_coletivo_atual_w,0) + coalesce(vl_preco_tot_col_bonif_w,0) + coalesce(vl_preco_sca_tot_col_w,0) + coalesce(vl_inscricao_w,0);

		vl_bonific_total_w		:= 0;
		tx_desconto_bonific_w 		:= 0;
		vl_preco_tot_col_bonif_w	:= 0;
		vl_preco_sca_tot_col_w		:= 0;
		vl_preco_coletivo_atual_w	:= 0;
		vl_preco_sem_dec_col_w		:= 0;

		end;
	end loop;
	close C02;
end if;

if (nr_seq_regra_desconto_w	> 0) and (ie_tipo_contratacao_w	= 'I') then
	nr_seq_regra_desconto_w	:= null;
	tx_desconto_w		:= null;
end if;

update	pls_simulacao_preco
set	vl_simulacao		= vl_simulacao_w,
	nr_seq_regra_desconto	= nr_seq_regra_desconto_w,
	tx_desconto		= tx_desconto_w,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_simulacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_simulacao ( nr_seq_simulacao_p bigint, nm_usuario_p text) FROM PUBLIC;
