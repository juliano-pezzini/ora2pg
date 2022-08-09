-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_prod_benef_intercambio ( nr_seq_segurado_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, ie_tipo_alteracao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_motivo_alt_p bigint, ie_gerar_via_adic_p text, nr_seq_motivo_via_adic_p bigint) AS $body$
DECLARE


/*	ie_tipo_alteracao_p
	B - Alterar para o beneficiario selecionado
	D - Alterar para o beneficiario selecionado e seus dependentes
	T - Alterar para todos os beneficiarios do contrato
*/
ie_tipo_alteracao_w		varchar(1);
ie_tabela_base_w		varchar(1);
nr_seq_segurado_w		bigint;
nr_seq_tabela_ant_w		bigint;
nr_seq_plano_ant_w		bigint;
nm_tabela_ant_w			varchar(255);
ds_plano_ant_w			varchar(255);
qt_registros_w			bigint;
nr_seq_tabela_w			bigint	:= null;
nr_seq_titular_w		bigint;
nr_seq_plano_tit_w		bigint;
nr_seq_carteira_w		bigint;
nr_seq_intercambio_w		bigint;
ie_tipo_repasse_w		varchar(10);
nr_seq_alteracao_produto_w	pls_segurado_alt_plano.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_intercambio		= nr_seq_intercambio_w
	and	ie_tipo_alteracao_w	= 'T'
	and	coalesce(dt_rescisao::text, '') = ''
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	order by
		nr_seq_titular desc;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	((nr_sequencia	= nr_seq_segurado_p)
	or (nr_seq_titular	= nr_seq_segurado_p))
	and	coalesce(dt_rescisao::text, '') = ''
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	ie_tipo_alteracao_w	= 'D'
	order by
		nr_seq_titular desc;


BEGIN

ie_tipo_alteracao_w	:= coalesce(ie_tipo_alteracao_p,'X');

if (coalesce(nr_seq_motivo_alt_p,0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(177806);
end if;

if (coalesce(nr_seq_plano_p::text, '') = '') or (coalesce(nr_seq_plano_p,0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(177807);
end if;

select	nr_seq_intercambio,
	ie_tipo_repasse
into STRICT	nr_seq_intercambio_w,
	ie_tipo_repasse_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

if (ie_tipo_repasse_w = 'P') then
	if (coalesce(nr_seq_tabela_p::text, '') = '') or (coalesce(nr_seq_tabela_p,0) = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177810);
	end if;
	
	nr_seq_tabela_w	:= nr_seq_tabela_p;
	
	select	count(*)
	into STRICT	qt_registros_w
	from	pls_tabela_preco
	where	nr_seq_plano	= nr_seq_plano_p
	and	nr_sequencia	= nr_seq_tabela_p;
	
	if (qt_registros_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177811);
	end if;

	select	ie_tabela_base
	into STRICT	ie_tabela_base_w
	from	pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_p;

	if (ie_tabela_base_w = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177812);
	end if;
end if;

if (ie_tipo_alteracao_w	= 'T') and (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	open c01;
	loop
	fetch c01 into	
		nr_seq_segurado_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	nr_seq_tabela,
			nr_seq_plano,
			substr(obter_descricao_padrao('PLS_TABELA_PRECO','NM_TABELA',nr_seq_tabela),1,255),
			substr(pls_obter_dados_produto(nr_seq_plano,'N'),1,255)
		into STRICT	nr_seq_tabela_ant_w,
			nr_seq_plano_ant_w,
			nm_tabela_ant_w,
			ds_plano_ant_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;

		if (nr_seq_plano_ant_w = nr_seq_plano_p) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1109071,'DS_PRODUTO='||nr_seq_plano_ant_w||'-'||substr(pls_obter_dados_produto(nr_seq_plano_ant_w, 'N'),1,255)||
									';NM_BENEFICIARIO='||pls_obter_dados_produto(nr_seq_segurado_w, 'N'));
		end if;
		
		update	pls_segurado
		set	nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			nr_seq_plano	= nr_seq_plano_p,
			nr_seq_tabela	= nr_seq_tabela_w
		where	nr_sequencia	= nr_seq_segurado_w;

		CALL pls_gerar_vl_seg_intercambio(null, nr_seq_segurado_w, 'P',
			cd_estabelecimento_p, nm_usuario_p,  'S',
			'S','N', 'N');

		select	nextval('pls_segurado_alt_plano_seq')
		into STRICT	nr_seq_alteracao_produto_w
		;
			
		insert into pls_segurado_alt_plano(nr_sequencia, nm_usuario, dt_atualizacao,
			nr_seq_segurado, nr_seq_plano_ant, nr_seq_plano_atual,
			nr_seq_tabela_ant, nr_seq_tabela_atual, dt_alteracao,
			nr_seq_motivo_alt, ds_observacao, ie_situacao)
		values (nr_seq_alteracao_produto_w, nm_usuario_p, clock_timestamp(),
			nr_seq_segurado_w, nr_seq_plano_ant_w, nr_seq_plano_p,
			nr_seq_tabela_ant_w, nr_seq_tabela_w, clock_timestamp(),
			nr_seq_motivo_alt_p, wheb_mensagem_pck.get_texto(1105643), 'A');
		
		CALL pls_inativar_alteracao_produto(nr_seq_segurado_w, nr_seq_alteracao_produto_w, clock_timestamp(), 'N', nm_usuario_p);
		
		CALL pls_gerar_segurado_historico(nr_seq_segurado_w, '4', clock_timestamp(),
					wheb_mensagem_pck.get_texto(1108462),
					wheb_mensagem_pck.get_texto(1108497, 'NR_SEQ_PLANO_ANT='||nr_seq_plano_ant_w||';'||'NR_SEQ_PLANO='||nr_seq_plano_p),
					null, null, null,
					null, clock_timestamp(), null,
					null, null, null,
					null, null, nm_usuario_p, 'N');
			
		select	max(nr_sequencia)
		into STRICT	nr_seq_carteira_w
		from	pls_segurado_carteira
		where	nr_seq_segurado	= nr_seq_segurado_w;

		if (ie_gerar_via_adic_p = 'S') then
			CALL pls_gerar_via_carteira(nr_seq_carteira_w,nr_seq_motivo_via_adic_p,nm_usuario_p,1202,'M','N');
		end if;
					
		end;
	end loop;
	close c01;

elsif (ie_tipo_alteracao_w	= 'D') and (coalesce(nr_seq_segurado_p,0) <> 0) and (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	open c02;
	loop
	fetch c02 into	
		nr_seq_segurado_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		select	nr_seq_tabela,
			nr_seq_plano,
			substr(obter_descricao_padrao('PLS_TABELA_PRECO','NM_TABELA',nr_seq_tabela),1,255),
			substr(pls_obter_dados_produto(nr_seq_plano,'N'),1,255)
		into STRICT	nr_seq_tabela_ant_w,
			nr_seq_plano_ant_w,
			nm_tabela_ant_w,
			ds_plano_ant_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;

		if (nr_seq_plano_ant_w = nr_seq_plano_p) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1109071,'DS_PRODUTO='||nr_seq_plano_ant_w||'-'||substr(pls_obter_dados_produto(nr_seq_plano_ant_w, 'N'),1,255)||
									';NM_BENEFICIARIO='||pls_obter_dados_produto(nr_seq_segurado_w, 'N'));
		end if;
		
		update	pls_segurado
		set	nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			nr_seq_plano	= nr_seq_plano_p,
			nr_seq_tabela	= nr_seq_tabela_w
		where	nr_sequencia	= nr_seq_segurado_w;

		CALL pls_gerar_vl_seg_intercambio(null, nr_seq_segurado_w, 'P',
			cd_estabelecimento_p, nm_usuario_p,  'S',
			'S','N', 'N');

		select	nextval('pls_segurado_alt_plano_seq')
		into STRICT	nr_seq_alteracao_produto_w
		;
			
		insert into pls_segurado_alt_plano(nr_sequencia, nm_usuario, dt_atualizacao,
			nr_seq_segurado, nr_seq_plano_ant, nr_seq_plano_atual,
			nr_seq_tabela_ant, nr_seq_tabela_atual, dt_alteracao,
			nr_seq_motivo_alt, ds_observacao, ie_situacao)
		values (nr_seq_alteracao_produto_w, nm_usuario_p, clock_timestamp(),
			nr_seq_segurado_w, nr_seq_plano_ant_w, nr_seq_plano_p,
			nr_seq_tabela_ant_w, nr_seq_tabela_w, clock_timestamp(),
			nr_seq_motivo_alt_p, wheb_mensagem_pck.get_texto(1105644), 'A');
			
		CALL pls_inativar_alteracao_produto(nr_seq_segurado_w, nr_seq_alteracao_produto_w, clock_timestamp(), 'N', nm_usuario_p);
			
		CALL pls_gerar_segurado_historico(nr_seq_segurado_w, '4', clock_timestamp(),
					wheb_mensagem_pck.get_texto(1108496),
					wheb_mensagem_pck.get_texto(1108497, 'NR_SEQ_PLANO_ANT='||nr_seq_plano_ant_w||';'||'NR_SEQ_PLANO='||nr_seq_plano_p),
					null, null, null,
					null, clock_timestamp(), null,
					null, null, null,
					null, null, nm_usuario_p, 'N');
					
		select	max(nr_sequencia)
		into STRICT	nr_seq_carteira_w
		from	pls_segurado_carteira
		where	nr_seq_segurado	= nr_seq_segurado_w;

		if (ie_gerar_via_adic_p = 'S') then
			CALL pls_gerar_via_carteira(nr_seq_carteira_w,nr_seq_motivo_via_adic_p,nm_usuario_p,1202,'M','N');
		end if;
		
		end;
	end loop;
	close c02;

elsif (ie_tipo_alteracao_w	= 'B') and (coalesce(nr_seq_segurado_p,0) <> 0) and (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	
	select	nr_seq_tabela,
		nr_seq_plano,
		substr(obter_descricao_padrao('PLS_TABELA_PRECO','NM_TABELA',nr_seq_tabela),1,255),
		substr(pls_obter_dados_produto(nr_seq_plano,'N'),1,255)
	into STRICT	nr_seq_tabela_ant_w,
		nr_seq_plano_ant_w,
		nm_tabela_ant_w,
		ds_plano_ant_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;

	if (nr_seq_plano_ant_w = nr_seq_plano_p) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1109071,'DS_PRODUTO='||nr_seq_plano_ant_w||'-'||substr(pls_obter_dados_produto(nr_seq_plano_ant_w, 'N'),1,255)||
								';NM_BENEFICIARIO='||pls_obter_dados_produto(nr_seq_segurado_p, 'N'));
	end if;
	
	update	pls_segurado
	set	nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		nr_seq_plano	= nr_seq_plano_p,
		nr_seq_tabela	= nr_seq_tabela_w
	where	nr_sequencia	= nr_seq_segurado_p;

	CALL pls_gerar_vl_seg_intercambio(null, nr_seq_segurado_p, 'P',
			cd_estabelecimento_p, nm_usuario_p,  'S',
			'S','N', 'N');

	select	nextval('pls_segurado_alt_plano_seq')
	into STRICT	nr_seq_alteracao_produto_w
	;
			
	insert into pls_segurado_alt_plano(nr_sequencia, nm_usuario, dt_atualizacao,
		nr_seq_segurado, nr_seq_plano_ant, nr_seq_plano_atual,
		nr_seq_tabela_ant, nr_seq_tabela_atual, dt_alteracao,
		nr_seq_motivo_alt, ds_observacao, ie_situacao)
	values (nr_seq_alteracao_produto_w, nm_usuario_p, clock_timestamp(),
		nr_seq_segurado_p, nr_seq_plano_ant_w, nr_seq_plano_p,
		nr_seq_tabela_ant_w, nr_seq_tabela_w, clock_timestamp(),
		nr_seq_motivo_alt_p, wheb_mensagem_pck.get_texto(1105647), 'A');
		
	CALL pls_inativar_alteracao_produto(nr_seq_segurado_p, nr_seq_alteracao_produto_w, clock_timestamp(), 'N', nm_usuario_p);
		
	CALL pls_gerar_segurado_historico(nr_seq_segurado_p, '4', clock_timestamp(),
					wheb_mensagem_pck.get_texto(1108499),
					wheb_mensagem_pck.get_texto(1108497, 'NR_SEQ_PLANO_ANT='||nr_seq_plano_ant_w||';'||'NR_SEQ_PLANO='||nr_seq_plano_p),
					null, null, null,
					null, clock_timestamp(), null,
					null, null, null,
					null, null, nm_usuario_p, 'N');
					
	select	max(nr_sequencia)
	into STRICT	nr_seq_carteira_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_p;

	if (ie_gerar_via_adic_p = 'S') then
		CALL pls_gerar_via_carteira(nr_seq_carteira_w,nr_seq_motivo_via_adic_p,nm_usuario_p,1202,'M','N');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_prod_benef_intercambio ( nr_seq_segurado_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, ie_tipo_alteracao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_motivo_alt_p bigint, ie_gerar_via_adic_p text, nr_seq_motivo_via_adic_p bigint) FROM PUBLIC;
