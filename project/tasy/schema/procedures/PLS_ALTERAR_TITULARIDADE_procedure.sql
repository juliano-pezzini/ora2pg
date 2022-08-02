-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_titularidade ( nr_seq_segurado_p bigint, nr_seq_titular_p bigint, nr_grau_parentesco_p bigint, ie_opcao_p bigint, nr_seq_mtvo_rescisao_p bigint, dt_rescisao_p timestamp, ds_observacao_p text, cd_estabelecimento_p bigint, dt_geracao_sib_p timestamp, nm_usuario_p text) AS $body$
DECLARE


/*	ie_opcao_p
	1 - Transformar dependente em 
	2 - Transformar titular em dependente
	3 - Alterar titular do dependente
*/
nr_seq_titular_w		bigint;
nm_titular_w			varchar(255);
nr_seq_contrato_w		bigint;
nr_seq_titular_ant_w		bigint;
ie_titular_pf_w			varchar(1);
ds_observacao_w			varchar(100);
ie_permite_tab_dif_w		varchar(1);
ie_consiste_tab_contr_w		varchar(1);
ie_geracao_valores_w		varchar(1);
ie_titular_familia_w		varchar(1);
ie_alterar_cart_benef_w		varchar(10);
cd_matricula_familia_w		bigint;
nm_pessoa_fisica_w		varchar(255);
nr_seq_seg_titular_w		bigint;
nm_titular_ant_w		varchar(255);
cd_cgc_estipulante_w		varchar(20);
ie_alterar_matricula_benef_w	varchar(10);
nr_seq_seg_dependente_w		bigint;
ie_dt_adesao_w			varchar(10);
dt_contratacao_titular_w	timestamp;
dt_contratacao_w		timestamp;
dt_rescisao_w			timestamp;
dt_rescisao_tit_w		timestamp;
ie_reativa_titular_w		varchar(1)	:= 'N';
ie_titularidade_w		pls_segurado.ie_titularidade%type;
ie_tipo_parentesco_w		grau_parentesco.ie_tipo_parentesco%type;
nr_seq_tabela_w			pls_tabela_preco.nr_sequencia%type;
ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_tabela_seg_w		pls_tabela_preco.nr_sequencia%type;
ie_calculo_vidas_tab_w		pls_tabela_preco.ie_calculo_vidas%type;
qt_vidas_w			pls_segurado_valor.qt_vidas%type	:= 0;
qt_registros_w			bigint;
qt_idade_w			bigint;
ie_estado_civil_w		pessoa_fisica.ie_estado_civil%type;
nm_beneficiario_w		varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_rescisao
	from	pls_segurado
	where	nr_seq_titular = nr_seq_titular_ant_w
	and	nr_seq_contrato	= nr_seq_contrato_w;
	
C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_segurado a,
		pls_tabela_preco b
	where	a.nr_seq_tabela = b.nr_sequencia
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	a.nr_seq_contrato = nr_seq_contrato_w;


BEGIN
ie_permite_tab_dif_w		:= obter_valor_param_usuario(1202,9,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_consiste_tab_contr_w		:= obter_valor_param_usuario(1202,10,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_titular_familia_w		:= coalesce(obter_valor_param_usuario(1202,82,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'N');
ie_dt_adesao_w			:= coalesce(obter_valor_param_usuario(1202, 88, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'S');
ie_alterar_cart_benef_w		:= coalesce(obter_valor_param_usuario(1202, 99, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_titular_pf_w			:= coalesce(obter_valor_param_usuario(1202, 48, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');

if (coalesce(ie_opcao_p,0) <> 0) then
	select 	max(nr_seq_contrato),
		max(nr_seq_tabela)
	into STRICT	nr_seq_contrato_w,
		nr_seq_tabela_w
	from	pls_segurado
	where 	nr_sequencia = nr_seq_segurado_p;
	
	if (nr_seq_tabela_w IS NOT NULL AND nr_seq_tabela_w::text <> '') then
		select	coalesce(ie_preco_vidas_contrato,'N')
		into STRICT	ie_preco_vidas_contrato_w
		from	pls_tabela_preco
		where	nr_sequencia = nr_seq_tabela_w;
	else
		ie_preco_vidas_contrato_w	:= 'N';
	end if;
	
	begin
	select	ie_geracao_valores,
		cd_cgc_estipulante
	into STRICT	ie_geracao_valores_w,
		cd_cgc_estipulante_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;
	exception
	when others then
		ie_geracao_valores_w	:= 'B';
		cd_cgc_estipulante_w	:= '';
	end;

	if (ie_titular_pf_w = 'S') and (coalesce(cd_cgc_estipulante_w::text, '') = '') then
		ie_alterar_matricula_benef_w	:= 'N';
	else
		ie_alterar_matricula_benef_w	:= 'S';
	end if;
	
	if (coalesce(ie_opcao_p,0) = 1) then
		select	nr_seq_titular,
			substr(pls_obter_dados_segurado(nr_seq_titular,'N'),1,255),
			dt_rescisao,
			ie_titularidade
		into STRICT	nr_seq_titular_ant_w,
			nm_titular_ant_w,
			dt_rescisao_w,
			ie_titularidade_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;
		
		update	pls_segurado
		set	nr_seq_titular		 = NULL,
			ie_tipo_parentesco	= '',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nr_seq_parentesco	 = NULL,
			cd_matricula_familia	= CASE WHEN ie_alterar_matricula_benef_w='S' THEN null  ELSE cd_matricula_familia END
		where	nr_sequencia	= nr_seq_segurado_p;
		
		CALL pls_gerar_regra_titularidade(nr_seq_segurado_p,cd_estabelecimento_p,nm_usuario_p);

		if (ie_alterar_matricula_benef_w = 'S') then
			CALL pls_atualizar_familia_pf(nr_seq_segurado_p,cd_estabelecimento_p,nm_usuario_p);
					
			CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1109908),
							wheb_mensagem_pck.get_texto(1109909), null, null, null,
							null, clock_timestamp(), null, null,
							null, null, null, null,
							nm_usuario_p, 'N');					
		end if;
		
		select 	max(cd_matricula_familia)
		into STRICT	cd_matricula_familia_w
		from	pls_segurado
		where 	nr_sequencia = nr_seq_segurado_p;
		
		--Consistir o parametro [82] - Permite apenas 1 titular por familia no contrato
		if (coalesce(ie_titular_familia_w,'N') = 'S') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_seg_titular_w
			from	pls_segurado
			where	nr_seq_contrato		= nr_seq_contrato_w
			and	cd_matricula_familia	= cd_matricula_familia_w
			and	nr_sequencia	<> nr_seq_segurado_p
			and	coalesce(nr_seq_titular::text, '') = ''
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_rescisao::text, '') = '';
			
			if (nr_seq_seg_titular_w IS NOT NULL AND nr_seq_seg_titular_w::text <> '') then
				select	max(b.nm_pessoa_fisica)
				into STRICT	nm_pessoa_fisica_w
				from	pls_segurado	a,
					pessoa_fisica	b
				where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
				and	a.nr_sequencia		= nr_seq_seg_titular_w;
				
				if (nm_pessoa_fisica_w IS NOT NULL AND nm_pessoa_fisica_w::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(193607,'NM_TITULAR='||nm_pessoa_fisica_w);
				end if;
			end if;
		end if;
		
		--Gerar o valor para o beneficiario, caso o mesmo
		if (coalesce(ie_geracao_valores_w,'B') <> 'B') then
			CALL pls_gerar_valor_segurado(
					null, nr_seq_segurado_p, 'T',
					cd_estabelecimento_p, nm_usuario_p, 'S',
					clock_timestamp(), ie_permite_tab_dif_w, ie_consiste_tab_contr_w,
					'N', 'N');
		end if;
		
		--Caso o dependente esteja rescindido, entao deve ser reativado
		if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
			ie_reativa_titular_w	:= 'S';
			CALL pls_reativar_segurado(	nr_seq_segurado_p,clock_timestamp(), wheb_mensagem_pck.get_texto(1109913),
						'S', nm_usuario_p);
		end if;
		
		if (ie_titular_pf_w = 'S') and (coalesce(cd_cgc_estipulante_w::text, '') = '') then
			open C01;
			loop
			fetch C01 into
				nr_seq_seg_dependente_w,
				dt_rescisao_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				
				update	pls_segurado
				set	nr_seq_titular	= nr_seq_segurado_p
				where	nr_sequencia	= nr_seq_seg_dependente_w;
				
				--Caso o dependente esteja rescindido, entao deve ser reativado
				if	(dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '' AND ie_reativa_titular_w = 'S') then
					CALL pls_reativar_segurado(	nr_seq_seg_dependente_w,clock_timestamp(), wheb_mensagem_pck.get_texto(1109914),
								'S', nm_usuario_p);
				end if;
				
				CALL pls_gerar_segurado_historico(
					nr_seq_seg_dependente_w, '12', clock_timestamp(),
					wheb_mensagem_pck.get_texto(1109915,'NM_TITULAR_ANT='|| nm_titular_ant_w), ds_observacao_p, null,
					null, null, null,
					dt_geracao_sib_p, null, null,
					null, null, null,
					null, nm_usuario_p, 'N');
				
				if (ie_alterar_matricula_benef_w = 'S') then
					--Atualizar a familia do beneficiario
					CALL pls_atualizar_familia_pf(nr_seq_seg_dependente_w,cd_estabelecimento_p,nm_usuario_p);				
						
					CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1109908),
									wheb_mensagem_pck.get_texto(1109909), null, null, null,
									null, clock_timestamp(), null, null,
									null, null, null, null,
									nm_usuario_p, 'N');							
				end if;
				
				end;
			end loop;
			close C01;
			
			select	max(dt_rescisao)
			into STRICT	dt_rescisao_tit_w
			from	pls_segurado
			where	nr_sequencia	= nr_seq_titular_ant_w;
			
			--Apenas pode rescindir o titular caso o mesmo nao esteja rescindido
			if (coalesce(dt_rescisao_tit_w::text, '') = '') then
				if (coalesce(nr_seq_mtvo_rescisao_p,0) <> 0) then
					CALL pls_rescindir_segurado(nr_seq_titular_ant_w, dt_rescisao_p, dt_rescisao_p, nr_seq_mtvo_rescisao_p, wheb_mensagem_pck.get_texto(1109924), cd_estabelecimento_p, nm_usuario_p, 'B', 'N',null, null);
				else
					update	pls_segurado
					set	dt_rescisao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						ie_situacao_atend	= 'I',
						ie_tipo_rescisao	= 'B'
					where	nr_sequencia		= nr_seq_titular_ant_w;
					
					--Rescindir a carteirinha
					update	pls_segurado_carteira
					set	dt_validade_carteira	= clock_timestamp(),
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp()
					where	nr_seq_segurado		= nr_seq_titular_ant_w
					and	coalesce(dt_validade_carteira::text, '') = '';
					
					ds_observacao_w	:= wheb_mensagem_pck.get_texto(1109924);
					
					CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1109911),
									ds_observacao_w, null, null, null,
									null, clock_timestamp(), null, null,
									null, null, null, null,
									nm_usuario_p, 'N');							
				end if;
			end if;
		end if;
		
		CALL pls_gerar_segurado_historico(
			nr_seq_segurado_p, '12', clock_timestamp(),
			wheb_mensagem_pck.get_texto(1109916,'NM_TITULAR_ANT='|| nm_titular_ant_w), ds_observacao_p, null,
			null, null, null,
			clock_timestamp(), null, null,
			nr_seq_titular_ant_w, null, null,
			null, nm_usuario_p, 'N');
	elsif (coalesce(ie_opcao_p,0) = 2) then
		CALL pls_consiste_data_sib(dt_geracao_sib_p, nm_usuario_p, cd_estabelecimento_p);
		select	CASE WHEN coalesce(max(a.ie_titularidade)::text, '') = '' THEN 'T'  ELSE 'D' END ,
			max(b.nm_pessoa_fisica),
			max(b.ie_estado_civil)
		into STRICT	ie_titularidade_w,
			nm_beneficiario_w,
			ie_estado_civil_w
		from	pls_segurado a,
			pessoa_fisica b
		where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	a.nr_sequencia = nr_seq_segurado_p;	
		
		select	max(ie_tipo_parentesco)
		into STRICT	ie_tipo_parentesco_w
		from	grau_parentesco
		where	nr_sequencia	= nr_grau_parentesco_p;

		qt_idade_w := pls_obter_idade_segurado(nr_seq_segurado_p,dt_geracao_sib_p,'A');

		select	count(1)
		into STRICT	qt_registros_w
		from	pls_restricao_inclusao_seg
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	dt_geracao_sib_p between trunc(coalesce(dt_inicio_vigencia,dt_geracao_sib_p),'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_geracao_sib_p))
		and     ie_titularidade in ('D','A')
		and (qt_idade_w  between coalesce(qt_idade_inicial,qt_idade_w) and coalesce(qt_idade_final,qt_idade_w))
		and (nr_seq_parentesco = nr_grau_parentesco_p or coalesce(nr_seq_parentesco::text, '') = '')
		and (ie_estado_civil = ie_estado_civil_w or coalesce(ie_estado_civil::text, '') = '');

		if (qt_registros_w	> 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1109938, 'NM_BENEFICIARIO=' || nm_beneficiario_w || ';DS_PARENTESCO='|| substr(Obter_desc_parentesco(nr_grau_parentesco_p),1,50));
			--Mensagem: Nao e permitido alterar o beneficiario #@NM_BENEFICIARIO#@ para dependente, com o grau de parentesco #@DS_PARENTESCO#@.Favor Verificar as regras de restricao de inclusao do contrato.
		end if;		
		
		update	pls_segurado
		set	nr_seq_titular		= nr_seq_titular_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nr_seq_parentesco	= nr_grau_parentesco_p,
			ie_tipo_parentesco	= ie_tipo_parentesco_w
		where	nr_sequencia		= nr_seq_segurado_p;
		
		
		CALL pls_gerar_regra_titularidade(nr_seq_segurado_p,cd_estabelecimento_p,nm_usuario_p);
		
		--Gerar o valor para o beneficiario, caso o mesmo
		if (coalesce(ie_geracao_valores_w,'B') <> 'B') then
			CALL pls_gerar_valor_segurado(
					null, nr_seq_segurado_p, 'T',
					cd_estabelecimento_p, nm_usuario_p, 'S',
					clock_timestamp(), ie_permite_tab_dif_w, ie_consiste_tab_contr_w,
					'N', 'N');
		end if;
		
		CALL pls_gerar_segurado_historico(
			nr_seq_segurado_p, '12', clock_timestamp(),
			wheb_mensagem_pck.get_texto(1109917), ds_observacao_p, null,
			null, null, null,
			dt_geracao_sib_p, null, null,
			null, null, null,
			null, nm_usuario_p, 'N');
		
		--Atualizar a familia do beneficiario
		if (ie_alterar_matricula_benef_w = 'S') then
			CALL pls_atualizar_familia_pf(nr_seq_segurado_p,cd_estabelecimento_p,nm_usuario_p);	

			CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1109908),
							 wheb_mensagem_pck.get_texto(1109909), null, null, null,
							null, clock_timestamp(), null, null,
							null, null, null, null,
							nm_usuario_p, 'N');
		end if;
	elsif (coalesce(ie_opcao_p,0) = 3) then
		CALL pls_consiste_data_sib(dt_geracao_sib_p, nm_usuario_p, cd_estabelecimento_p);
		
		select	a.nr_seq_titular,
			substr(pls_obter_dados_segurado(a.nr_seq_titular,'N'),1,255),
			CASE coalesce(WHEN(a.ie_titularidade)::text, '') = '' THEN 'T'  ELSE 'D' END ,
			b.nm_pessoa_fisica,
			b.ie_estado_civil
		into STRICT	nr_seq_titular_w,
			nm_titular_w,
			ie_titularidade_w,
			nm_beneficiario_w,
			ie_estado_civil_w
		from	pls_segurado a,
			pessoa_fisica b
		where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	nr_sequencia	= nr_seq_segurado_p;

		qt_idade_w := pls_obter_idade_segurado(nr_seq_segurado_p,dt_geracao_sib_p,'A');

		select	count(1)
		into STRICT	qt_registros_w
		from	pls_restricao_inclusao_seg
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	dt_geracao_sib_p between trunc(coalesce(dt_inicio_vigencia,dt_geracao_sib_p),'dd') and fim_dia(coalesce(dt_fim_vigencia,dt_geracao_sib_p))
		and    	ie_titularidade in ('D','A')
		and (qt_idade_w  between coalesce(qt_idade_inicial,qt_idade_w) and coalesce(qt_idade_final,qt_idade_w))
		and (nr_seq_parentesco = nr_grau_parentesco_p or coalesce(nr_seq_parentesco::text, '') = '')
		and (ie_estado_civil = ie_estado_civil_w or coalesce(ie_estado_civil::text, '') = '');

		if (qt_registros_w	> 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1109939, 'NM_BENEFICIARIO=' || nm_beneficiario_w || ';DS_PARENTESCO='|| substr(Obter_desc_parentesco(nr_grau_parentesco_p),1,50));
			--Mensagem: Nao e permitido alterar o titular do beneficiario #@NM_BENEFICIARIO#@, com o grau de parentesco #@DS_PARENTESCO#@.Favor Verificar as regras de restricao de inclusao do contrato..
		end if;		
		
		if (nr_seq_titular_w <> nr_seq_titular_p) then
			update	pls_segurado
			set	nr_seq_titular		= nr_seq_titular_p,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p,
				nr_seq_parentesco	= CASE WHEN nr_grau_parentesco_p=0 THEN nr_seq_parentesco  ELSE nr_grau_parentesco_p END
			where	nr_sequencia		= nr_seq_segurado_p;
			
			--Gerar historico
			CALL pls_gerar_segurado_historico(
				nr_seq_segurado_p, '12', clock_timestamp(),
				wheb_mensagem_pck.get_texto(1109915,'NM_TITULAR_ANT='|| nm_titular_w), ds_observacao_p, null,
				null, null, null,
				dt_geracao_sib_p, null, null,
				nr_seq_titular_w, null, null,
				null, nm_usuario_p, 'S');

			CALL pls_atualizar_familia_pf(nr_seq_segurado_p,cd_estabelecimento_p,nm_usuario_p);			

			CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1109908),
							wheb_mensagem_pck.get_texto(1109909), null, null, null,
							null, clock_timestamp(), null, null,
							null, null, null, null,
							nm_usuario_p, 'N');					
		end if;
	end if;
	
	CALL pls_preco_beneficiario_pck.atualizar_desconto_benef(nr_seq_contrato_w, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
	
	select	nr_seq_titular
	into STRICT	nr_seq_titular_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	CALL pls_att_classif_dependencia(coalesce(nr_seq_titular_w,nr_seq_segurado_p),nm_usuario_p,'N');
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_segurado_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL pls_preco_beneficiario_pck.gravar_preco_benef(nr_seq_segurado_w, 'Q', 'S', clock_timestamp(), 'N', null, nm_usuario_p, cd_estabelecimento_p);
		end;
	end loop;
	close C02;
end if;

CALL pls_gerar_valor_sca_segurado(nr_seq_segurado_p, 'T', clock_timestamp(), nm_usuario_p, cd_estabelecimento_p);

if	(((ie_alterar_cart_benef_w = 'S') or (ie_alterar_cart_benef_w = 'PF') and (coalesce(cd_cgc_estipulante_w::text, '') = '')) or (ie_alterar_cart_benef_w = 'PJ') and (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '')) then
	CALL pls_alterar_cartao_ident_benef(nr_seq_segurado_p,dt_geracao_sib_p,cd_estabelecimento_p,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_titularidade ( nr_seq_segurado_p bigint, nr_seq_titular_p bigint, nr_grau_parentesco_p bigint, ie_opcao_p bigint, nr_seq_mtvo_rescisao_p bigint, dt_rescisao_p timestamp, ds_observacao_p text, cd_estabelecimento_p bigint, dt_geracao_sib_p timestamp, nm_usuario_p text) FROM PUBLIC;

