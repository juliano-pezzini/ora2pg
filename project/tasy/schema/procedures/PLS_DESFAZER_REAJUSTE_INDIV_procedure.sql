-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_reajuste_indiv ( nr_seq_reajuste_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_tabela_w			bigint;
nr_seq_plano_w			bigint;
dt_contrato_w			timestamp;
nr_seq_contrato_ww		bigint;
dt_reajuste_w			timestamp;
nr_seq_preco_w			bigint;
nr_seq_reajuste_tabela_w	bigint;
vl_base_w			double precision;
vl_reajustado_w			double precision;
vl_preco_nao_subsid_base_w	double precision;
vl_preco_nao_subsidiado_w	double precision;
vl_reajuste_w			double precision;
pr_reajuste_w			double precision;
nr_seq_reajuste_preco_atual_w	bigint;
qt_reajuste_w			bigint;
vl_adaptacao_base_w		double precision;
vl_adaptacao_w			double precision;
cd_cgc_estipulante_w		varchar(14);
nr_seq_reajuste_desfazer_w	bigint;
------------------------------------------------------------------------------------
nr_seq_lote_reaj_copart_w	bigint;
tx_reajuste_copartic_w		double precision;
tx_reajuste_copartic_max_w	double precision;
qt_regra_copartic_w		bigint;
ie_vinculo_coparticipacao_w	varchar(10);
ie_reajustar_copartic_w		varchar(10);
------------------------------------------------------------------------------------
nr_seq_lote_reaj_inscricao_w	bigint;
tx_reajuste_inscricao_w		double precision;
qt_regra_inscricao_w		bigint;
ie_reajustar_inscricao_w	varchar(10);
ie_aplicar_definitivo_w		varchar(10);
qt_registros_w			bigint;
qt_tabela_inserida_w		bigint;

nr_seq_regra_gerada_w		pls_reajuste_copartic.nr_seq_regra_gerada%type;
tx_reajuste_w 			pls_lote_reaj_copartic.tx_reajuste%type;
tx_reajuste_vl_maximo_w 	pls_lote_reaj_copartic.tx_reajuste_vl_maximo%type;

vl_maximo_w			pls_regra_coparticipacao.vl_maximo%type;
vl_coparticipacao_w		pls_regra_coparticipacao.vl_coparticipacao%type;

nr_seq_copartic_reajustada_w	pls_reajuste_copartic.nr_seq_copartic_reajustada%type;
nr_seq_regra_atual_w		pls_reajuste_copartic.nr_seq_regra_atual%type;
vl_apropriacao_w		pls_regra_copartic_aprop.vl_apropriacao%type;
tx_apropriacao_w		pls_regra_copartic_aprop.tx_apropriacao%type;
nr_seq_copartic_ant_w		pls_reajuste_copartic.nr_seq_copartic_ant%type;
vl_reajuste_atual_w		double precision;
vl_maximo_atual_w		pls_regra_coparticipacao.vl_maximo%type;
vl_minimo_w			pls_reajuste_preco.vl_minimo%type;
vl_minimo_base_w		pls_reajuste_preco.vl_minimo_base%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_tabela,
		a.nr_seq_plano,
		b.dt_contrato,
		b.nr_sequencia
	from	pls_contrato_plano	a,
		pls_contrato		b
	where	a.nr_seq_contrato	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_contrato_w
	and	(a.nr_seq_tabela IS NOT NULL AND a.nr_seq_tabela::text <> '')
	
union all

	SELECT	a.nr_seq_tabela,
		a.nr_seq_plano,
		b.dt_contrato,
		b.nr_sequencia
	from	pls_segurado	a,
		pls_contrato	b
	where	a.nr_seq_contrato	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_segurado_w
	and	(a.nr_seq_tabela IS NOT NULL AND a.nr_seq_tabela::text <> '')
	
union all

	select	a.nr_seq_tabela,
		a.nr_seq_plano,
		c.dt_contrato,
		c.nr_sequencia
	from	pls_sca_vinculo	a,
		pls_segurado	b,
		pls_contrato	c
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_contrato	= c.nr_sequencia
	and	((b.nr_sequencia = nr_seq_segurado_w) or (coalesce(nr_seq_segurado_w::text, '') = ''))
	and	((c.nr_sequencia = nr_seq_contrato_w) or (coalesce(nr_seq_contrato_w::text, '') = ''))
	and	coalesce(nr_seq_reajuste_desfazer_w::text, '') = ''
	and	(a.nr_seq_tabela IS NOT NULL AND a.nr_seq_tabela::text <> '')
	
union all

	select	a.nr_seq_tabela,
		a.nr_seq_plano,
		a.dt_contrato,
		a.nr_seq_contrato
	from	pls_reajuste_tabela	a
	where	a.nr_seq_reajuste	= nr_seq_reajuste_desfazer_w
	and (a.nr_seq_contrato = nr_seq_contrato_w or coalesce(nr_seq_contrato_w::text, '') = '');

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_w;

c03 CURSOR FOR
	SELECT	tx_reajuste,
		tx_reajuste_vl_maximo,
		ie_vinculo_coparticipacao,
		nr_seq_contrato,
		nr_sequencia
	from	pls_lote_reaj_copartic a
	where	nr_seq_reajuste = nr_seq_reajuste_desfazer_w
	and (nr_seq_contrato = nr_seq_contrato_w or coalesce(nr_seq_contrato_w::text, '') = '');

c04 CURSOR FOR
	SELECT	nr_seq_contrato,
		tx_reajuste
	from	pls_lote_reaj_inscricao
	where	nr_seq_reajuste = nr_seq_reajuste_desfazer_w;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_reaj_copartic
	where	nr_seq_reajuste = nr_seq_reajuste_p;

C06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_lote_reaj_inscricao
	where	nr_seq_reajuste = nr_seq_reajuste_p;


BEGIN

if (ie_acao_p	= 'A') then
	begin
	select	nr_seq_contrato,
		nr_seq_segurado,
		dt_reajuste,
		nr_seq_reajuste_desfazer
	into STRICT	nr_seq_contrato_w,
		nr_seq_segurado_w,
		dt_reajuste_w,
		nr_seq_reajuste_desfazer_w
	from	pls_reajuste
	where	nr_sequencia	= nr_seq_reajuste_p;
	exception
	when others then
		nr_seq_contrato_w	:= null;
		nr_seq_segurado_w	:= null;
	end;
	
	if (coalesce(nr_seq_contrato_w::text, '') = '') and (coalesce(nr_seq_segurado_w::text, '') = '') and (coalesce(nr_seq_reajuste_desfazer_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 192349, null);
		/* Favor informar o contrato ou beneficiario para desfazer o ultimo reajuste aplicado! */

	elsif (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
		select	max(cd_cgc_estipulante)
		into STRICT	cd_cgc_estipulante_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_w;
		
		if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort( 194710, null );
			/* Para o contrato coletivo deve ser aplicado o deflator. Favor verifique. */

		end if;
	end if;
	
	open C01;
	loop
	fetch C01 into
		nr_seq_tabela_w,
		nr_seq_plano_w,
		dt_contrato_w,
		nr_seq_contrato_ww;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	count(1)
		into STRICT	qt_tabela_inserida_w
		from	pls_reajuste_tabela
		where	nr_seq_reajuste	= nr_seq_reajuste_p
		and	nr_seq_tabela	= nr_seq_tabela_w;
		
		if (qt_tabela_inserida_w = 0) then
			qt_reajuste_w	:= 0;
			
			select	nextval('pls_reajuste_tabela_seq')
			into STRICT	nr_seq_reajuste_tabela_w
			;
			
			insert	into	pls_reajuste_tabela(	nr_sequencia, nr_seq_reajuste, nr_seq_tabela,
					dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
					nm_usuario_nrec, nr_seq_plano, dt_contrato,
					nr_seq_contrato, ie_origem_tabela, dt_inicio_vigencia)
				values (	nr_seq_reajuste_tabela_w, nr_seq_reajuste_p, nr_seq_tabela_w,
					clock_timestamp(), nm_usuario_p, clock_timestamp(),
					nm_usuario_p, nr_seq_plano_w, dt_contrato_w,
					nr_seq_contrato_ww, 'B', dt_reajuste_w);
			
			open C02;
			loop
			fetch C02 into
				nr_seq_preco_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				select	max(nr_sequencia)
				into STRICT	nr_seq_reajuste_preco_atual_w
				from	pls_reajuste_preco
				where	nr_seq_preco	= nr_seq_preco_w;
				
				if (nr_seq_reajuste_preco_atual_w IS NOT NULL AND nr_seq_reajuste_preco_atual_w::text <> '') then
					select	vl_base,
						vl_reajustado,
						vl_preco_nao_subsid_base,
						vl_preco_nao_subsidiado,
						vl_adaptacao_base,
						vl_adaptacao,
						vl_minimo,
						vl_minimo_base
					into STRICT	vl_base_w,
						vl_reajustado_w,
						vl_preco_nao_subsid_base_w,
						vl_preco_nao_subsidiado_w,
						vl_adaptacao_base_w,
						vl_adaptacao_w,
						vl_minimo_w,
						vl_minimo_base_w
					from	pls_reajuste_preco
					where	nr_sequencia	= nr_seq_reajuste_preco_atual_w;
					
					vl_reajuste_w	:= vl_reajustado_w - vl_base_w;
					if (coalesce(vl_base_w,0) <> 0) then						
						pr_reajuste_w	:= ((vl_reajuste_w * 100) / vl_reajustado_w) * -1;
					else
						pr_reajuste_w	:= 0;
					end if;
					
					insert	into	pls_reajuste_preco(	nr_sequencia, nr_seq_reajuste, dt_reajuste,
							pr_reajustado, vl_base, vl_reajustado,
							nr_seq_preco, nr_seq_tabela, dt_periodo_inicial,
							dt_periodo_final, dt_atualizacao, nm_usuario,
							dt_atualizacao_nrec, nm_usuario_nrec, vl_preco_nao_subsidiado,
							vl_preco_nao_subsid_base, vl_adaptacao_base, vl_adaptacao,
							vl_minimo, vl_minimo_base)
						values (	nextval('pls_reajuste_preco_seq'), nr_seq_reajuste_p, dt_reajuste_w,
							coalesce(pr_reajuste_w,0), vl_reajustado_w, vl_base_w,
							nr_seq_preco_w, nr_seq_reajuste_tabela_w, dt_reajuste_w,
							dt_reajuste_w, clock_timestamp(), nm_usuario_p,
							clock_timestamp(), nm_usuario_p, vl_preco_nao_subsid_base_w,
							vl_preco_nao_subsidiado_w, vl_adaptacao_w, vl_adaptacao_base_w,
							vl_minimo_base_w, vl_minimo_w);
					qt_reajuste_w	:= coalesce(qt_reajuste_w,0) + 1;
				end if;
				end;
			end loop;
			close C02;
			
			if (qt_reajuste_w = 0) then			
				delete	from	pls_reajuste_tabela
				where	nr_sequencia	= nr_seq_reajuste_tabela_w;
			end if;
		end if;
		end;
	end loop;
	close C01;
	
	ie_reajustar_copartic_w	:= 'N';
	
	open C03;
	loop
	fetch C03 into
		tx_reajuste_copartic_w,
		tx_reajuste_copartic_max_w,
		ie_vinculo_coparticipacao_w,
		nr_seq_contrato_ww,
		nr_seq_lote_reaj_copart_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		vl_maximo_w := null;		
		vl_reajuste_w := null;
		
		select	max(nr_seq_regra_gerada),
			max(nr_seq_copartic_reajustada)			
		into STRICT	nr_seq_regra_gerada_w,
			nr_seq_copartic_reajustada_w
		from	pls_reajuste_copartic
		where	nr_seq_lote = nr_seq_lote_reaj_copart_w;
		
		
		if (nr_seq_regra_gerada_w IS NOT NULL AND nr_seq_regra_gerada_w::text <> '') then
			select	nr_seq_regra_gerada,
				nr_seq_regra_atual
			into STRICT	nr_seq_regra_gerada_w,
				nr_seq_regra_atual_w
			from	pls_reajuste_copartic
			where	nr_seq_lote = nr_seq_lote_reaj_copart_w
			and	(nr_seq_regra_gerada IS NOT NULL AND nr_seq_regra_gerada::text <> '')  LIMIT 1;
			
			select	max(vl_maximo),
				max(vl_coparticipacao)
			into STRICT	vl_maximo_w,
				vl_reajuste_w
			from	pls_regra_coparticipacao
			where	nr_sequencia = nr_seq_regra_gerada_w;
			
			select	max(vl_maximo),
				max(vl_coparticipacao)
			into STRICT	vl_maximo_atual_w,
				vl_reajuste_atual_w
			from	pls_regra_coparticipacao
			where	nr_sequencia = nr_seq_regra_atual_w;

			if (vl_reajuste_w <> 0) then
				tx_reajuste_copartic_w		:= (((vl_reajuste_w - vl_reajuste_atual_w) * 100) / vl_reajuste_w) * - 1;
			else
				tx_reajuste_copartic_w		:= 0;
			end if;
			
			if (vl_maximo_w IS NOT NULL AND vl_maximo_w::text <> '') then
				if (vl_maximo_w <> 0) then
					tx_reajuste_copartic_max_w 	:= (((vl_maximo_w - vl_maximo_atual_w) * 100) / vl_maximo_w) * -1;
				else
					tx_reajuste_copartic_max_w	:= 0;
				end if;
			else
				tx_reajuste_copartic_max_w := tx_reajuste_copartic_w;
			end if;
		elsif (nr_seq_copartic_reajustada_w IS NOT NULL AND nr_seq_copartic_reajustada_w::text <> '') then		
			select	nr_seq_copartic_reajustada,
				nr_seq_copartic_ant
			into STRICT	nr_seq_copartic_reajustada_w,
				nr_seq_copartic_ant_w
			from	pls_reajuste_copartic
			where	nr_seq_lote = nr_seq_lote_reaj_copart_w
			and	(nr_seq_copartic_reajustada IS NOT NULL AND nr_seq_copartic_reajustada::text <> '')  LIMIT 1;
		
			select	max(a.vl_apropriacao),
				max(b.vl_maximo_copartic)
			into STRICT	vl_reajuste_w,
				vl_maximo_w
			from	pls_regra_copartic_aprop a,
				pls_regra_copartic 	 b
			where	b.nr_sequencia = a.nr_seq_regra
			and	b.nr_sequencia = nr_seq_copartic_reajustada_w;
			
			select	max(a.vl_apropriacao),
				max(b.vl_maximo_copartic)
			into STRICT	vl_reajuste_atual_w,
				vl_maximo_atual_w
			from	pls_regra_copartic_aprop a,
				pls_regra_copartic 	 b
			where	b.nr_sequencia = a.nr_seq_regra
			and	b.nr_sequencia = nr_seq_copartic_ant_w;
			
			if (vl_reajuste_w <> 0) then
				tx_reajuste_copartic_w		:= (((vl_reajuste_w - vl_reajuste_atual_w) * 100) / vl_reajuste_w) * -1;
			else
				tx_reajuste_copartic_w		:= 0;
			end if;
			
			if (vl_maximo_w IS NOT NULL AND vl_maximo_w::text <> '') then
				if (vl_maximo_w <> 0) then
					tx_reajuste_copartic_max_w 	:= (((vl_maximo_w - vl_maximo_atual_w) * 100) / vl_maximo_w) * -1;
				else
					tx_reajuste_copartic_max_w	:= 0;
				end if;
			else
				tx_reajuste_copartic_max_w := tx_reajuste_copartic_w;
			end if;
		end if;
		
		if (coalesce(vl_reajuste_w::text, '') = '') then
		
			select	max(pr_reajustado)
			into STRICT	tx_reajuste_copartic_w
			from	pls_reajuste_tabela	e,
				pls_tabela_preco	c,
				pls_reajuste		b,	
				pls_plano_preco		f,
				pls_reajuste_preco	g
			where	e.nr_seq_tabela		= c.nr_sequencia
			and	e.nr_seq_reajuste	= b.nr_sequencia
			and	f.nr_seq_tabela 	= c.nr_sequencia
			and	g.nr_seq_tabela		= e.nr_sequencia
			and	g.nr_seq_preco		= f.nr_sequencia
			and	c.nr_contrato 		= nr_seq_contrato_ww
			and	b.nr_sequencia		= nr_seq_reajuste_p;
			
			tx_reajuste_copartic_max_w := tx_reajuste_copartic_w;
		end if;
		
		select	nextval('pls_lote_reaj_copartic_seq')
		into STRICT	nr_seq_lote_reaj_copart_w
		;
		
		insert	into	pls_lote_reaj_copartic(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			cd_estabelecimento, nr_seq_contrato, dt_referencia,  tx_reajuste, tx_reajuste_vl_maximo,
			nr_seq_reajuste, ie_vinculo_coparticipacao)
		values (	nr_seq_lote_reaj_copart_w, clock_timestamp(), nm_usuario_p,clock_timestamp(), nm_usuario_p,
			cd_estabelecimento_p, nr_seq_contrato_ww,dt_reajuste_w, tx_reajuste_copartic_w,tx_reajuste_copartic_max_w,
			nr_seq_reajuste_p, ie_vinculo_coparticipacao_w);
				
		CALL pls_incluir_copartic_lote_reaj(nr_seq_lote_reaj_copart_w, cd_estabelecimento_p, 'N', nm_usuario_p);
				
		select	count(1)
		into STRICT	qt_regra_copartic_w
		from	pls_reajuste_copartic
		where	nr_seq_lote	= nr_seq_lote_reaj_copart_w;
		
		if (qt_regra_copartic_w = 0) then
			delete	FROM pls_lote_reaj_copartic
			where	nr_sequencia	= nr_seq_lote_reaj_copart_w;		
		end if;
		
		ie_reajustar_copartic_w	:= 'S';
		end;
	end loop;
	close C03;
	
	ie_reajustar_inscricao_w	:= 'N';
	
	open C04;
	loop
	fetch C04 into
		nr_seq_contrato_ww,
		tx_reajuste_inscricao_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		if (coalesce(tx_reajuste_inscricao_w,0) <> 0) then
			tx_reajuste_inscricao_w	:= tx_reajuste_inscricao_w * -1;
		end if;
		
		select	nextval('pls_lote_reaj_inscricao_seq')
		into STRICT	nr_seq_lote_reaj_inscricao_w
		;
			
		insert	into	pls_lote_reaj_inscricao(	nr_sequencia, dt_atualizacao, nm_usuario,dt_atualizacao_nrec, nm_usuario_nrec,
				cd_estabelecimento,nr_seq_contrato, dt_referencia,  tx_reajuste, nr_seq_reajuste)
		values (	nr_seq_lote_reaj_inscricao_w, clock_timestamp(), nm_usuario_p,clock_timestamp(), nm_usuario_p,
				cd_estabelecimento_p, nr_seq_contrato_ww, dt_reajuste_w,  tx_reajuste_inscricao_w,nr_seq_reajuste_p);
		
		CALL pls_incluir_inscricao_reaj(nr_seq_lote_reaj_inscricao_w, cd_estabelecimento_p, nm_usuario_p);
		
		select	count(1)
		into STRICT	qt_regra_inscricao_w
		from	pls_reajuste_inscricao
		where	nr_seq_lote	= nr_seq_lote_reaj_inscricao_w;
		
		if (qt_regra_inscricao_w = 0) then
			delete	FROM pls_lote_reaj_inscricao
			where	nr_sequencia	= nr_seq_lote_reaj_inscricao_w;
		end if;
		
		ie_reajustar_inscricao_w	:= 'S';
		
		end;
	end loop;
	close C04;
	
	update	pls_reajuste
	set	ie_status		= '3',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		ie_reajustar_inscricao	= ie_reajustar_inscricao_w,
		ie_reajustar_copartic	= ie_reajustar_copartic_w
	where	nr_sequencia	= nr_seq_reajuste_p;
	
	ie_aplicar_definitivo_w	:= 'N';
	
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p  LIMIT 1;
	
	if (qt_registros_w = 0) then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_lote_reaj_copartic
		where	nr_seq_reajuste	= nr_seq_reajuste_p  LIMIT 1;
		
		if (qt_registros_w = 0) then
			select	count(1)
			into STRICT	qt_registros_w
			from	pls_lote_reaj_inscricao
			where	nr_seq_reajuste	= nr_seq_reajuste_p  LIMIT 1;
		end if;
		
		if (qt_registros_w > 0) then
			ie_aplicar_definitivo_w	:= 'S';
		end if;
		
		if (ie_aplicar_definitivo_w = 'S') then
			CALL pls_aplicar_reajuste(nr_seq_reajuste_p,'N',null,'N',nm_usuario_p,cd_estabelecimento_p);
		end if;	
	end if;
	
elsif (ie_acao_p	= 'D') then
	delete	from	pls_reajuste_preco
	where	nr_seq_reajuste	= nr_seq_reajuste_p;
	
	delete	from	pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p;
	
	/*Deletar os reajustes de coparticipacoes*/

	open C05;
	loop
	fetch C05 into
		nr_seq_lote_reaj_copart_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		delete	FROM pls_reajuste_copartic
		where	nr_seq_lote	= nr_seq_lote_reaj_copart_w;
		
		delete	FROM pls_lote_reaj_copartic
		where	nr_sequencia	= nr_seq_lote_reaj_copart_w;
		end;
	end loop;
	close C05;
	
	/*Deletar os reajustes de inscricao*/

	open C06;
	loop
	fetch C06 into
		nr_seq_lote_reaj_inscricao_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		delete	FROM pls_reajuste_inscricao
		where	nr_seq_lote	= nr_seq_lote_reaj_inscricao_w;
		
		delete	FROM pls_lote_reaj_inscricao
		where	nr_sequencia	= nr_seq_lote_reaj_inscricao_w;
		end;
	end loop;
	close C06;
	
	update	pls_reajuste
	set	ie_status	= '1',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_reajuste_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_reajuste_indiv ( nr_seq_reajuste_p bigint, ie_acao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

