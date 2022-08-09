-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_vl_seg_intercambio ( nr_seq_intercambio_p bigint, nr_seq_segurado_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_permite_tab_dif_p text, ie_consiste_tab_contr_p text, ie_gerar_cartao_p text, ie_commit_p text) AS $body$
DECLARE

 
/*	ie_opcao_p 
	C - Liberação de todos o benf. do contrato 
	L - Liberação beneficiário 
	T - Cálculo por alteração de titularidade 
	p - Alteração do produto 
	A - Alteração da tabela de preço 
*/
 
 
dt_contratacao_w		timestamp;
dt_liberacao_titular_w		timestamp;
dt_idade_w			timestamp;
dt_contrato_w			timestamp;
dt_validade_w			timestamp;
dt_liberacao_w			timestamp;
qt_idade_w			smallint;
nr_seq_segurado_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_preco_w			bigint;
nr_seq_pagador_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_titular_w		bigint;
nr_seq_carteira_w		bigint;
nr_seq_emissor_w		bigint;
nr_contrato_intercambio_w	bigint;
nr_seq_segurado_preco_w		bigint;
nr_seq_segurado_preco_ww	bigint	:= 0;
nr_seq_plano_tab_w		bigint;
qt_registros_w			bigint	:= 0;
vl_preco_ant_w			double precision	:= 0;
vl_preco_w			double precision;
vl_desconto_w			double precision;
ie_tabela_contrato_w		varchar(1);
ie_preco_w			varchar(2);
ie_tipo_contratacao_w		varchar(3);
cd_pessoa_fisica_w		varchar(10);
cd_usuario_plano_w		varchar(30);
nm_segurado_w			varchar(255);
nm_pessoa_fisica_w		varchar(255);
ds_observacao_w			varchar(255)	:= '';
nr_seq_parentesco_w		bigint;
vl_preco_nao_subsid_desc_w	double precision	:= 0;
dt_rescisao_w			timestamp;
ie_acao_contrato_w		varchar(2)	:= 'L';
qt_idade_ww			smallint;
ie_commit_w			varchar(1);
ie_importacao_base_w		varchar(1);
ie_grau_parentesco_w		varchar(2);
dt_validade_cart_param_int_w	varchar(1);
ie_gerar_validade_cartao_w	varchar(1);
cd_empresa_w			varchar(10);
cd_empresa_ww			bigint;
ie_tipo_estipulante_w		varchar(2);
ie_tipo_contrato_w		varchar(2);
cd_cartao_intercambio_w		varchar(30);
dt_inicio_vigencia_cart_w	timestamp;
nr_seq_rescisao_obito_w		bigint;
qt_dependete_w			bigint;
vl_minimo_mensalidade_w		double precision;
vl_adaptacao_w			double precision;
nr_seq_resc_prog_gerada_w	bigint;
nr_seq_inclusao_benef_w		bigint;
ie_pcmso_w			varchar(10);
ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
nr_seq_segurado_inter_w		pls_segurado.nr_sequencia%type;
ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;
qt_vidas_w			bigint	:= 0;

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_pessoa_fisica, 
		nr_seq_plano, 
		nr_seq_tabela, 
		dt_contratacao, 
		nr_seq_pagador, 
		nr_seq_titular, 
		nr_seq_intercambio, 
		substr(pls_obter_dados_segurado(nr_sequencia,'N'),1,255), 
		nr_seq_parentesco, 
		dt_rescisao, 
		ie_importacao_base, 
		cd_cartao_intercambio, 
		nr_seq_benef_inclusao 
	from	pls_segurado 
	where	((nr_seq_intercambio	= coalesce(nr_seq_intercambio_p,0)) 
	or (nr_sequencia		= coalesce(nr_seq_segurado_p,0)));

C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		coalesce(vl_preco_atual,0), 
		vl_preco_nao_subsid_atual, 
		coalesce(vl_minimo,0), 
		coalesce(vl_adaptacao,0) 
	from	pls_plano_preco 
	where	coalesce(qt_idade_ww,qt_idade_w)	>= qt_idade_inicial 
	and	coalesce(qt_idade_ww,qt_idade_w)	<= qt_idade_final 
	and	nr_seq_tabela	= nr_seq_tabela_w 
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w 
	order	by	coalesce(ie_grau_titularidade,' ');
	
C03 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_segurado 
	where	nr_seq_intercambio = nr_seq_intercambio_w 
	and	nr_sequencia <> nr_seq_segurado_p 
	and	ie_calculo_vidas_w <> 'F' 
	
union
 
	SELECT	nr_sequencia 
	from	pls_segurado 
	where	nr_seq_intercambio = nr_seq_intercambio_w 
	and	nr_sequencia <> nr_seq_segurado_p 
	and	nr_seq_titular	= nr_seq_segurado_p 
	and	ie_calculo_vidas_w = 'F' 
	
union
 
	select	nr_sequencia 
	from	pls_segurado 
	where	nr_seq_intercambio = nr_seq_intercambio_w 
	and	nr_sequencia	<> nr_seq_segurado_p 
	and	nr_sequencia	= nr_seq_titular_w 
	and	ie_calculo_vidas_w = 'F' 
	
union
 
	select	nr_sequencia 
	from	pls_segurado 
	where	nr_seq_intercambio = nr_seq_intercambio_w 
	and	nr_sequencia	<> nr_seq_segurado_p 
	and	nr_seq_titular	= nr_seq_titular_w 
	and	ie_calculo_vidas_w = 'F';
	
C04 CURSOR FOR 
	SELECT	nr_sequencia, 
		coalesce(vl_preco_atual,0), 
		vl_preco_nao_subsid_atual, 
		coalesce(vl_minimo,0), 
		coalesce(vl_adaptacao,0) 
	from	pls_plano_preco 
	where	qt_idade_w	>= qt_idade_inicial 
	and	qt_idade_w	<= qt_idade_final 
	and	nr_seq_tabela	= nr_seq_tabela_w 
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w 
	and	qt_vidas_w between coalesce(qt_vidas_inicial,qt_vidas_w) and coalesce(qt_vidas_final,qt_vidas_w) 
	order	by	coalesce(ie_grau_titularidade,' ');	
 

BEGIN 
select	coalesce(dt_base_validade_cart_inter,'B'), 
	coalesce(ie_gerar_validade_cartao,'S'), 
	nr_seq_motivo_rescisao_obito 
into STRICT	dt_validade_cart_param_int_w, 
	ie_gerar_validade_cartao_w, 
	nr_seq_rescisao_obito_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
ie_commit_w		:= ie_commit_p;
 
open c01;
loop 
fetch c01 into	 
	nr_seq_segurado_w, 
	cd_pessoa_fisica_w, 
	nr_seq_plano_w, 
	nr_seq_tabela_w, 
	dt_contratacao_w, 
	nr_seq_pagador_w, 
	nr_seq_titular_w, 
	nr_seq_intercambio_w, 
	nm_segurado_w, 
	nr_seq_parentesco_w, 
	dt_rescisao_w, 
	ie_importacao_base_w, 
	cd_cartao_intercambio_w, 
	nr_seq_inclusao_benef_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	if (coalesce(nr_seq_pagador_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177839,'NM_SEGURADO='||nm_segurado_w||';'||'NR_SEQ_INTERCAMBIO='||nr_seq_intercambio_w);
	elsif (coalesce(nr_seq_plano_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177841,'NM_SEGURADO='||nm_segurado_w||';'||'NR_SEQ_INTERCAMBIO='||nr_seq_intercambio_w);
	elsif (coalesce(nr_seq_intercambio_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177842);
	end if;
	 
	if 	((nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') and (coalesce(nr_seq_parentesco_w::text, '') = '')) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177843,'NM_SEGURADO='||nm_segurado_w||';'||'NR_SEQ_INTERCAMBIO='||nr_seq_intercambio_w);
	end if;
	 
	select	coalesce(dt_inclusao,clock_timestamp()), 
		cd_operadora_empresa, 
		CASE WHEN cd_pessoa_fisica='' THEN 'PJ'  ELSE 'PF' END , 
		ie_tipo_contrato, 
		coalesce(dt_base_validade_carteira,dt_validade_cart_param_int_w) 
	into STRICT	dt_contrato_w, 
		cd_empresa_w, 
		ie_tipo_estipulante_w, 
		ie_tipo_contrato_w, 
		dt_validade_cart_param_int_w 
	from	pls_intercambio 
	where	nr_sequencia	= nr_seq_intercambio_w;
	 
	if (coalesce(cd_cartao_intercambio_w::text, '') = '') and (ie_tipo_contrato_w = 'S') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177944,'NM_SEGURADO='||nm_segurado_w||';'||'NR_SEQ_INTERCAMBIO='||nr_seq_intercambio_w);
	end if;
	 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	pls_intercambio_plano a 
	where	a.nr_seq_intercambio	= nr_seq_intercambio_w 
	and	a.nr_seq_plano		= nr_seq_plano_w;
 
	if (qt_registros_w = 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177946,'NR_SEQ_SEGURADO='||nr_seq_segurado_w||';'||'NM_SEGURADO='||nm_segurado_w);
	end if;
 
	select	ie_tipo_contratacao, 
		ie_preco, 
		coalesce(ie_pcmso,'N') 
	into STRICT	ie_tipo_contratacao_w, 
		ie_preco_w, 
		ie_pcmso_w 
	from	pls_plano 
	where	nr_sequencia	= nr_seq_plano_w;
 
	if (ie_preco_w = '1') then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_segurado_w 
		and	coalesce(nr_seq_tabela::text, '') = '';
		if (qt_registros_w > 0) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177947);
		end if;
	end if;
 
	if (ie_importacao_base_w = 'S') then 
		dt_idade_w	:= trunc(clock_timestamp(),'dd');
	else 
		if (ie_opcao_p	in ('L','C')) then /* Paulo - OS 125685 */
 
			dt_idade_w	:= trunc(dt_contratacao_w,'dd');
		elsif (dt_contratacao_w > clock_timestamp()) then 
			dt_idade_w	:= trunc(dt_contratacao_w,'dd');
		else 
			dt_idade_w	:= trunc(clock_timestamp(),'dd');
		end if;
	end if;
	 
	select	coalesce(somente_numero(substr(obter_idade(dt_nascimento,dt_idade_w,'A'),1,3)),999), 
		substr(nm_pessoa_fisica,1,255) 
	into STRICT	qt_idade_w, 
		nm_pessoa_fisica_w 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
	 
	if (qt_idade_w >= 999) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177948||'NM_BENEFICIARIO='||nm_pessoa_fisica_w);
	end if;
	 
	/*aaschlote 18/01/2011 - Consistir o parãmetro[2]*/
 
	CALL pls_consistir_tit_benef_interc(nr_seq_intercambio_w,nm_usuario_p);
	 
	/*OS - 352136 aaschlote 12/09/2011 - Verificar as regras de parentesco do plano*/
 
	select	count(*) 
	into STRICT	qt_dependete_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_segurado_w 
	and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '');
	 
	if (qt_dependete_w > 0) then 
		CALL pls_consistir_parenteco_plano(nr_seq_plano_w,nr_seq_segurado_w,'C',nm_usuario_p);
	end if;	
	 
	/*aaschlote 18/08/2011 - 352617*/
 
	if (ie_opcao_p	in ('L','C')) then 
		CALL pls_liberar_vinculo_sca(null, nr_seq_segurado_w, null, 'L', 'N', 'N', nm_usuario_p, cd_estabelecimento_p);
	 
		CALL pls_gerar_grupos_intercambio(nr_seq_segurado_w,cd_estabelecimento_p,nm_usuario_p);
	end if;
	 
	if (coalesce(nr_seq_tabela_w,0) <> 0) then 
		select	count(*) 
		into STRICT	qt_registros_w 
		from	pls_intercambio_plano a 
		where	a.nr_seq_intercambio	= nr_seq_intercambio_w 
		and	a.nr_seq_tabela		= nr_seq_tabela_w;
		 
		if (qt_registros_w = 0) and (coalesce(ie_permite_tab_dif_p,'N') = 'N') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177950,'NR_SEQ_SEGURADO='||nr_seq_segurado_w||';'||'NM_BENEFICIARIO'||nm_segurado_w);
		end if;
		 
		select	coalesce(nr_seq_contrato_inter,0), 
			dt_liberacao, 
			nr_seq_plano, 
			coalesce(ie_calculo_vidas,'A'), 
			coalesce(ie_preco_vidas_contrato,'N') 
		into STRICT	nr_contrato_intercambio_w, 
			dt_liberacao_w, 
			nr_seq_plano_tab_w, 
			ie_calculo_vidas_w, 
			ie_preco_vidas_contrato_w 
		from	pls_tabela_preco 
		where	nr_sequencia	= nr_seq_tabela_w;
		 
		if (coalesce(dt_liberacao_w::text, '') = '') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177952,'NM_SEGURADO='||nm_segurado_w);
		end if;
		 
		if (coalesce(ie_consiste_tab_contr_p,'S') = 'S') and (nr_seq_intercambio_w <> nr_contrato_intercambio_w) and (ie_tipo_contratacao_w <> 'I') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177954,'NM_SEGURADO='||nm_segurado_w);
		end if;
		 
		ie_grau_parentesco_w	:= coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_segurado_w,'C'),1,2),'X');
		 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_segurado_preco_w 
		from	pls_segurado_preco 
		where	nr_seq_segurado	= nr_seq_segurado_w 
		and	dt_reajuste	= 
					(SELECT	max(dt_reajuste) 
					from	pls_segurado_preco 
					where	nr_seq_segurado	= nr_seq_segurado_w);
		 
		if (coalesce(nr_seq_segurado_preco_w,0) > 0) then 
			select (coalesce(vl_preco_atual,0) - coalesce(vl_desconto_w,0)), 
				qt_idade 
			into STRICT	vl_preco_ant_w, 
				qt_idade_ww 
			from	pls_segurado_preco 
			where	nr_sequencia	= nr_seq_segurado_preco_w;
		end if;
		 
		if (ie_preco_vidas_contrato_w = 'S') then 
			if (coalesce(ie_calculo_vidas_w,'A') = 'A') then 
				select	count(*) 
				into STRICT	qt_vidas_w 
				from	pls_segurado 
				where	nr_seq_intercambio = nr_seq_intercambio_w 
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
				and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > trunc(clock_timestamp(),'mm')));
			elsif (ie_calculo_vidas_w = 'T') then 
				select	count(*) 
				into STRICT	qt_vidas_w 
				from	pls_segurado 
				where	nr_seq_intercambio = nr_seq_intercambio_w 
				and	coalesce(nr_seq_titular::text, '') = '' 
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
				and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > trunc(dt_rescisao,'mm')));
			elsif (ie_calculo_vidas_w = 'D') then 
				select	count(*) 
				into STRICT	qt_vidas_w 
				from	pls_segurado 
				where	nr_seq_intercambio = nr_seq_intercambio_w 
				and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') 
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
				and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > trunc(dt_rescisao,'mm')));
			elsif (ie_calculo_vidas_w = 'TD') then 
				select	count(*) 
				into STRICT	qt_vidas_w 
				from	pls_segurado a 
				where	a.nr_seq_intercambio = nr_seq_intercambio_w 
				and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
				and	((coalesce(a.dt_rescisao::text, '') = '') or (trunc(a.dt_rescisao,'mm') > trunc(dt_rescisao,'mm'))) 
				and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(*) 
													from	grau_parentesco x 
													where	x.nr_sequencia = a.nr_seq_parentesco 
													and	x.ie_tipo_parentesco = '1') > 0)));
			elsif (ie_calculo_vidas_w = 'F') then 
				qt_vidas_w	:= coalesce(pls_obter_qt_vida_benef(nr_seq_segurado_p,nr_seq_titular_w,clock_timestamp()),0);
			end if;
		else 
			qt_vidas_w	:= 1;
		end if;
		 
		if (ie_preco_vidas_contrato_w = 'S') then 
			open C04;
			loop 
			fetch C04 into	 
				nr_seq_preco_w, 
				vl_preco_w, 
				vl_preco_nao_subsid_desc_w, 
				vl_minimo_mensalidade_w, 
				vl_adaptacao_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
			end loop;
			close C04;
		else 
			open C02;
			loop 
			fetch C02 into	 
				nr_seq_preco_w, 
				vl_preco_w, 
				vl_preco_nao_subsid_desc_w, 
				vl_minimo_mensalidade_w, 
				vl_adaptacao_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;
		end if;
		 
		if (coalesce(nr_seq_preco_w,0) = 0) then			 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177955); /*Existem tabelas sem preço por faixa etária ou com faixa etária inválida para idade do beneficiário. Verifique! */
		end if;
		 
		if (nr_seq_plano_w	<> nr_seq_plano_tab_w) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177956,'NR_SEQ_TABELA='||nr_seq_tabela_w||';'||'NR_SEQ_PLANO='||nr_seq_plano_w);
		end if;
		 
		select	nextval('pls_segurado_preco_seq') 
		into STRICT	nr_seq_segurado_preco_ww 
		;		
		 
		insert into pls_segurado_preco(nr_sequencia, dt_atualizacao, nm_usuario, 
			dt_reajuste, nr_seq_segurado, vl_preco_atual, 
			vl_preco_ant, qt_idade, cd_motivo_reajuste, 
			ds_observacao, vl_desconto,dt_liberacao, 
			nm_usuario_liberacao, vl_preco_nao_subsid_desc, 
			nr_seq_tabela, nr_seq_preco, vl_minimo_mensalidade, 
			vl_adaptacao,ie_situacao) 
		values (nr_seq_segurado_preco_ww, clock_timestamp(), nm_usuario_p, 
			CASE WHEN ie_opcao_p='L' THEN dt_contratacao_w WHEN ie_opcao_p='C' THEN dt_contrato_w  ELSE trunc(clock_timestamp(),'dd') END , nr_seq_segurado_w, vl_preco_w, 
			CASE WHEN vl_preco_ant_w=0 THEN  vl_preco_w  ELSE vl_preco_ant_w END , qt_idade_w, CASE WHEN ie_opcao_p='L' THEN 'C' WHEN ie_opcao_p='C' THEN 'C' WHEN ie_opcao_p='P' THEN 'P' WHEN ie_opcao_p='A' THEN 'A' WHEN ie_opcao_p='T' THEN 'T' END , 
			ds_observacao_w, 0,clock_timestamp(), 
			nm_usuario_p, vl_preco_nao_subsid_desc_w, 
			nr_seq_tabela_w, nr_seq_preco_w, vl_minimo_mensalidade_w, 
			vl_adaptacao_w,'A');			
		 
	end if;
 
	if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then 
		select	dt_liberacao 
		into STRICT	dt_liberacao_titular_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_titular_w;
 
		if (coalesce(dt_liberacao_titular_w::text, '') = '') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(177959);
		end if;
	end if;
 
	 
	begin 
	cd_empresa_ww	:= (cd_empresa_w)::numeric;
	exception 
	when others then 
	cd_empresa_ww	:= null;
	end;
	 
	select	max(cd_usuario_plano) 
	into STRICT	cd_usuario_plano_w 
	from	pls_segurado_carteira 
	where	nr_seq_segurado	= nr_seq_segurado_w 
	and	coalesce(dt_validade_carteira,clock_timestamp()) >= clock_timestamp();
 
	if (coalesce(ie_gerar_cartao_p,'S') = 'N') and (coalesce(cd_usuario_plano_w,'0') = '0') and (coalesce(dt_rescisao_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(177960,'NR_SEQ_SEGURADO='||nr_seq_segurado_w||';'||'NM_SEGURADO='||nm_segurado_w);
	end if;
	 
	update	pls_segurado 
	set	cd_operadora_empresa	= CASE WHEN ie_opcao_p='L' THEN cd_empresa_w WHEN ie_opcao_p='C' THEN cd_empresa_w  ELSE cd_operadora_empresa END , 
		ie_pcmso		= ie_pcmso_w 
	where	nr_sequencia		= nr_seq_segurado_w;
	 
	if (ie_opcao_p	= 'C') then 
		ie_acao_contrato_w	:= 'A';
	elsif (ie_opcao_p	= 'L') then 
		ie_acao_contrato_w	:= 'L';
	end if;
	 
	if (ie_opcao_p in ('L','C')) then 
	 
		CALL pls_atualizar_familia_pf(nr_seq_segurado_w,cd_estabelecimento_p,nm_usuario_p);
			 
		CALL pls_gerar_regra_titularidade(nr_seq_segurado_w,cd_estabelecimento_p,nm_usuario_p);
		 
		CALL pls_gerar_ops_congenere_benef(nr_seq_segurado_w, null, cd_estabelecimento_p, nm_usuario_p, 'N');
	 
		if (coalesce(ie_gerar_cartao_p,'S') = 'S') then 
			dt_validade_w		:= null;
			if (ie_gerar_validade_cartao_w = 'S') then 
				if (dt_validade_cart_param_int_w = 'B') then 
					dt_validade_w		:= dt_contratacao_w;
				elsif (dt_validade_cart_param_int_w = 'C') then 
					/*aaschlote 20/07/2012 OS - 473527 - Quando a base da validade for o contrato, então coloca o mês e o dia do contrato e o ano será a data de adesão do beneficiário*/
 
					begin 
					dt_validade_w		:= to_date(to_char(dt_contrato_w,'dd/mm/') || to_char(dt_contratacao_w,'yyyy'));
					exception 
					when others then 
						if (to_char(dt_contrato_w,'mm') = '02') then 
							dt_validade_w		:= to_date('28/02/' || to_char(dt_contratacao_w,'yyyy'));
						end if;
					end;
				end if;
			end if;
			 
			CALL pls_gerar_carteira_usuario(nr_seq_segurado_w, nr_seq_titular_w, dt_contratacao_w, dt_validade_w, 'P', 'N',null, nm_usuario_p);
			 
			/*Gerar renovação das carteiras, de acordo com a regra*/
 
			CALL pls_gerar_renovacao_cart_inter(nr_seq_intercambio_w,nr_seq_segurado_w,ie_acao_contrato_w,nm_usuario_p);
		end if;
		 
		CALL pls_liberar_segurado(nr_seq_segurado_w, ie_opcao_p, nm_usuario_p, 'N');
		 
		/*aaschlote 07/12/2011 OS - 387277*/
 
		CALL pls_isentar_caren_benef_inter(nr_seq_segurado_w,cd_estabelecimento_p,nm_usuario_p);
		 
		/*aaschlote OS 265605 09/12/2010 - Se o tipo de contrato de intercâmbio for Seguro óbito, então a data de rescisão será daqui há 5 anos*/
 
		if (ie_tipo_contrato_w = 'S') and (ie_tipo_estipulante_w	= 'PJ') then 
			/*aaschlote OS 281611 - O sistema irá gerar uma rescisão programa invés de rescindir o segurado*/
 
			nr_seq_resc_prog_gerada_w := pls_gerar_rescisao_programada(null, null, nr_seq_segurado_w, nr_seq_rescisao_obito_w, 5, dt_contratacao_w, ie_tipo_estipulante_w, 'N', '', nm_usuario_p, null, null, 0, null, 'S', nr_seq_resc_prog_gerada_w, null);
		end if;	
		 
		if (nr_seq_inclusao_benef_w IS NOT NULL AND nr_seq_inclusao_benef_w::text <> '') then 
			update	pls_inclusao_beneficiario 
			set	ie_status_intercambio	= 'C' 
			where	nr_sequencia		= nr_seq_inclusao_benef_w;
		end if;
	end if;
	end;
end loop;
close c01;
 
if (ie_preco_vidas_contrato_w = 'S') then 
	 
	if (ie_opcao_p = 'L') then 
		open C03;
		loop 
		fetch C03 into	 
			nr_seq_segurado_inter_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			CALL pls_recalc_preco_benef_inter(nr_seq_segurado_inter_w, 'Q', 'S', dt_contratacao_w,'N', nm_usuario_p, cd_estabelecimento_p);
			end;
		end loop;
		close C03;
	 
	 
	end if;
end if;
 
if (coalesce(ie_commit_p,'N') = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_vl_seg_intercambio ( nr_seq_intercambio_p bigint, nr_seq_segurado_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_permite_tab_dif_p text, ie_consiste_tab_contr_p text, ie_gerar_cartao_p text, ie_commit_p text) FROM PUBLIC;
