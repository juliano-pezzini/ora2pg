-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_nota_tit_faturamento (nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, -- NF
 ds_complemento_p text, ds_observacao_p text, ie_gera_titulo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_pls_fatura_w		bigint;
nr_seq_acao_w			bigint;
qt_impedimentos_w		bigint := 0;
ie_impedimento_cobranca_w	varchar(3);
ie_gerar_tit_ptu_w		varchar(3);
ie_manual_w			varchar(1) := 'N';
dt_emissao_w			timestamp;
nr_nota_fiscal_w		nota_fiscal.nr_nota_fiscal%type;
nr_nota_fiscal_ndc_w		nota_fiscal.nr_nota_fiscal%type;
nr_seq_lote_w			pls_lote_faturamento.nr_sequencia%type;
qt_fat_pode_ger_nota_w		integer;
qt_fat_notas_gerado_w		integer;
dt_emissao_fat_w		pls_fatura.dt_emissao%type;
qt_reg_ndc_w			integer := 1;
qt_reg_cta_w			integer := 0;
ie_atualizar_reg_nf_a500_w	pls_parametros.ie_atualizar_reg_nf_a500%type;
nr_seq_ptu_fatura_w		ptu_fatura.nr_sequencia%type;
nr_nota_fiscal_r506_w		ptu_nota_fiscal.nr_nota_fiscal%type;
nr_nota_fiscal_doc2_r506_w	ptu_nota_fiscal.nr_nota_fiscal_doc2%type;
ie_gerar_nf_reapresentacao_w	pls_parametro_faturamento.ie_gerar_nf_reapresentacao%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_impedimento_cobranca,
		coalesce(a.dt_emissao, coalesce(c.dt_emissao, clock_timestamp())),
		substr(pls_obter_dados_pls_fatura(a.nr_sequencia,'NF'),1,255) nr_nota_fiscal,
		substr(pls_obter_dados_pls_fatura(a.nr_sequencia,'NFN'),1,255) nr_nota_fiscal_ndc,
		c.nr_sequencia,
		a.dt_emissao,
		x.nr_sequencia nr_seq_ptu_fatura
	FROM pls_lote_faturamento c, pls_contrato_pagador b, pls_fatura a
LEFT OUTER JOIN ptu_fatura x ON (a.nr_sequencia = x.nr_seq_pls_fatura)
WHERE b.nr_sequencia	= a.nr_seq_pagador and c.nr_sequencia	= a.nr_seq_lote and c.nr_sequencia	= nr_seq_lote_p  and coalesce(a.ie_cancelamento::text, '') = ''
	
union all

	SELECT	a.nr_sequencia,
		a.ie_impedimento_cobranca,
		coalesce(a.dt_emissao, coalesce(c.dt_emissao, clock_timestamp())),
		substr(pls_obter_dados_pls_fatura(a.nr_sequencia,'NF'),1,255) nr_nota_fiscal,
		substr(pls_obter_dados_pls_fatura(a.nr_sequencia,'NFN'),1,255) nr_nota_fiscal_ndc,
		c.nr_sequencia,
		a.dt_emissao,
		x.nr_sequencia nr_seq_ptu_fatura
	FROM pls_lote_faturamento c, pls_contrato_pagador b, pls_fatura a
LEFT OUTER JOIN ptu_fatura x ON (a.nr_sequencia = x.nr_seq_pls_fatura)
WHERE b.nr_sequencia	= a.nr_seq_pagador and c.nr_sequencia	= a.nr_seq_lote and a.nr_sequencia	= nr_seq_fatura_p  and coalesce(a.ie_cancelamento::text, '') = '';


BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') or (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then	
	--Gerar os títulos a receber/faturas do lote
	if (ie_gera_titulo_p = 'S') then
		CALL pls_gerar_titulos_faturamento(nr_seq_lote_p , nr_seq_fatura_p, 'N', cd_estabelecimento_p, nm_usuario_p);
	else
		-- Somente recalcular tributos do lote de faturamento
		CALL pls_gerar_tributos_faturamento( nr_seq_lote_p, nr_seq_fatura_p, 'N', cd_estabelecimento_p, nm_usuario_p);
	end if;

	-- Informados apenas quando é gerado com parâmetros informados manualmente
	if (cd_operacao_nf_p IS NOT NULL AND cd_operacao_nf_p::text <> '') and (cd_serie_nf_p IS NOT NULL AND cd_serie_nf_p::text <> '') then
		ie_manual_w := 'S';
	else
		ie_manual_w := 'N';
	end if;

	--Verifica se a fatura possui impedimentos pendentes de definição da ação.
	if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
		select	count(1)
		into STRICT	qt_impedimentos_w
		from	pls_fatura 	a
		where	a.nr_seq_lote 	= nr_seq_lote_p
		and	a.ie_impedimento_cobranca = 'P';
	elsif (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then
		select	count(1)
		into STRICT	qt_impedimentos_w
		from	pls_fatura 	a
		where	a.nr_sequencia 	= nr_seq_fatura_p
		and	a.ie_impedimento_cobranca = 'P';
	end if;

	if (qt_impedimentos_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(172761);
	end if;
	
	select	coalesce(max(ie_atualizar_reg_nf_a500),'N')
	into STRICT	ie_atualizar_reg_nf_a500_w
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;
	
	select	coalesce(max(ie_gerar_nf_reapresentacao),'S')
	into STRICT	ie_gerar_nf_reapresentacao_w
	from	pls_parametro_faturamento
	where	cd_estabelecimento	= cd_estabelecimento_p;
		
	-- Gerar nota fiscal
	open C01;
	loop
	fetch C01 into
		nr_seq_pls_fatura_w,
		ie_impedimento_cobranca_w,
		dt_emissao_w,
		nr_nota_fiscal_w,
		nr_nota_fiscal_ndc_w,
		nr_seq_lote_w,
		dt_emissao_fat_w,
		nr_seq_ptu_fatura_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(dt_emissao_fat_w::text, '') = '') then
			update	pls_fatura
			set	dt_emissao = dt_emissao_w
			where	nr_sequencia = nr_seq_pls_fatura_w;
		end if;

		if (ie_gerar_nf_reapresentacao_w = 'N') then
			-- Verifica se o tipo de documento é NDC e não gera nfs
			select	sum(coalesce((select    1
					from	pls_conta_inf_ptu    i
					where	i.nr_seq_conta    = c.nr_sequencia),0)),
				count(1)
			into STRICT    qt_reg_ndc_w,
				qt_reg_cta_w
			from    pls_conta		c,
				pls_fatura_conta	fc,
				pls_fatura_evento	fe,
				pls_fatura		f,
				pls_lote_faturamento a
			where	f.nr_sequencia		= fe.nr_seq_fatura
			and	fe.nr_sequencia		= fc.nr_seq_fatura_evento
			and	c.nr_sequencia		= fc.nr_seq_conta
			and	a.nr_sequencia		= f.nr_seq_lote
			and	f.nr_sequencia		= nr_seq_pls_fatura_w;
		end if;
	
		if (qt_reg_ndc_w != qt_reg_cta_w) then
			ie_gerar_tit_ptu_w := 'S';
			if (coalesce(ie_impedimento_cobranca_w,'S') <> 'NF') then
				-- Geração Manual
				if (ie_manual_w = 'S') and (coalesce(nr_nota_fiscal_w::text, '') = '') then
					CALL pls_gerar_notas_tit_faturas(	nr_seq_lote_w, nr_seq_pls_fatura_w, null, cd_operacao_nf_p, cd_natureza_operacao_p,
									nr_seq_classif_fiscal_p, nr_seq_sit_trib_p, cd_serie_nf_p, coalesce(dt_emissao_p,dt_emissao_w), ds_complemento_p,
									ds_observacao_p, ie_gera_titulo_p, nm_usuario_p, cd_estabelecimento_p);

					ie_gerar_tit_ptu_w := 'N';
				end if;

				-- Geração por evento/ação
				if (ie_manual_w = 'N') then
					nr_seq_acao_w := pls_obter_acao_intercambio(	'15',  -- Geração da nota fiscal de faturamento
									'16',  -- Gerar nota fiscal
									null, nr_seq_pls_fatura_w, null, null, clock_timestamp(), null, 'N', nr_seq_acao_w);

					if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (coalesce(nr_nota_fiscal_w::text, '') = '') then
						CALL pls_gerar_notas_tit_faturas(	nr_seq_lote_w, nr_seq_pls_fatura_w, nr_seq_acao_w, cd_operacao_nf_p, cd_natureza_operacao_p,
										nr_seq_classif_fiscal_p, nr_seq_sit_trib_p, cd_serie_nf_p, coalesce(dt_emissao_p,dt_emissao_w), ds_complemento_p, 
										ds_observacao_p, ie_gera_titulo_p, nm_usuario_p, cd_estabelecimento_p);

						ie_gerar_tit_ptu_w := 'N';
					end if;

					-- GERAR NOTAS CONFORME O PTU
					if (ie_gerar_tit_ptu_w = 'S') then
						nr_seq_acao_w := pls_obter_acao_intercambio(	'15',  -- Geração da nota fiscal de faturamento
										'17',  -- Gerar nota fiscal (NDC)
										null, nr_seq_pls_fatura_w, null, null, clock_timestamp(), null, 'N', nr_seq_acao_w);

						if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (coalesce(nr_nota_fiscal_ndc_w::text, '') = '') then
							CALL pls_gerar_notas_tit_faturas(	nr_seq_lote_w, nr_seq_pls_fatura_w, nr_seq_acao_w, cd_operacao_nf_p, cd_natureza_operacao_p,
											nr_seq_classif_fiscal_p, nr_seq_sit_trib_p, cd_serie_nf_p, coalesce(dt_emissao_p,dt_emissao_w), ds_complemento_p, 
											ds_observacao_p, ie_gera_titulo_p, nm_usuario_p, cd_estabelecimento_p);
						end if;

						nr_seq_acao_w := pls_obter_acao_intercambio(	'15',  -- Geração da nota fiscal de faturamento
										'18',  -- Gerar nota fiscal (Fatura)
										null, nr_seq_pls_fatura_w, null, null, clock_timestamp(), null, 'N', nr_seq_acao_w);

						if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') and (coalesce(nr_nota_fiscal_w::text, '') = '') then
							CALL pls_gerar_notas_tit_faturas(	nr_seq_lote_w, nr_seq_pls_fatura_w, nr_seq_acao_w, cd_operacao_nf_p, cd_natureza_operacao_p,
											nr_seq_classif_fiscal_p, nr_seq_sit_trib_p, cd_serie_nf_p, coalesce(dt_emissao_p,dt_emissao_w), ds_complemento_p, 
											ds_observacao_p, ie_gera_titulo_p, nm_usuario_p, cd_estabelecimento_p);
						end if;
					end if;
				end if;

				-- Atualizar o R506 com os dados da nota fiscal
				if (ie_atualizar_reg_nf_a500_w = 'D') and (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then
					CALL pls_atualizar_infor_nf_ptu( nr_seq_ptu_fatura_w, nm_usuario_p, 'S');
					
					select	max(nr_nota_fiscal),
						max(nr_nota_fiscal_doc2)
					into STRICT	nr_nota_fiscal_r506_w,
						nr_nota_fiscal_doc2_r506_w
					from	ptu_nota_fiscal
					where	nr_seq_fatura = nr_seq_ptu_fatura_w;
						
					if (nr_nota_fiscal_r506_w IS NOT NULL AND nr_nota_fiscal_r506_w::text <> '') or (nr_nota_fiscal_doc2_r506_w IS NOT NULL AND nr_nota_fiscal_doc2_r506_w::text <> '') then
						update	ptu_fatura
						set	nr_fatura		= nr_nota_fiscal_r506_w,
							doc_fiscal_1		= nr_nota_fiscal_r506_w,
							nr_nota_credito_debito	= nr_nota_fiscal_doc2_r506_w,
							doc_fiscal_2		= nr_nota_fiscal_doc2_r506_w,
							tp_documento_1		= CASE WHEN nr_nota_fiscal_r506_w = NULL THEN tp_documento_1  ELSE 3 END ,
							tp_documento_2		= CASE WHEN nr_nota_fiscal_doc2_r506_w = NULL THEN tp_documento_2  ELSE 3 END
						where	nr_sequencia		= nr_seq_ptu_fatura_w;
					end if;
				end if;
			end if;		
		end if;
		end;
	end loop;
	close C01;

	-- Verifica quais as faturas que podem gerar notas
	select	count(1)
	into STRICT	qt_fat_pode_ger_nota_w
	from	pls_fatura 	b
	where	b.nr_seq_lote 	= coalesce(nr_seq_lote_p, nr_seq_lote_w)
	and	((coalesce(b.ie_impedimento_cobranca::text, '') = '') or (b.ie_impedimento_cobranca in ('L','P')))
	and	coalesce(b.ie_cancelamento,'X') not in ('C','E');

	-- Verifica quais as faturas que podem gerar notas e tem notas gerado
	select	count(1)
	into STRICT	qt_fat_notas_gerado_w
	from	pls_fatura 	b
	where	b.nr_seq_lote 	= coalesce(nr_seq_lote_p, nr_seq_lote_w)
	and	((coalesce(b.ie_impedimento_cobranca::text, '') = '') or (b.ie_impedimento_cobranca in ('L','P')))
	and	coalesce(b.ie_cancelamento,'X') not in ('C','E')
	and exists (	SELECT	1
			from	nota_fiscal	a
			where	a.nr_seq_fatura	= b.nr_sequencia);
	

	-- Verifica se todas as faturas que podem gerar notas tem notas gerados e atualiza data de geração dos notas no lote
	if (qt_fat_pode_ger_nota_w = qt_fat_notas_gerado_w) then
		update	pls_lote_faturamento	a
		set	dt_geracao_nf 		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia 		= nr_seq_lote_w;
	end if;	

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_nota_tit_faturamento (nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, nr_seq_classif_fiscal_p bigint, nr_seq_sit_trib_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, ds_complemento_p text, ds_observacao_p text, ie_gera_titulo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

