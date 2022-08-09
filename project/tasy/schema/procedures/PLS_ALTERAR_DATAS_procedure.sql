-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_datas ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_sca_p bigint, dt_data_alteracao_p timestamp, ie_tipo_data_p text, cd_estabelecimento_p bigint, nr_seq_motivo_p bigint, ie_alterar_datas_sca_p text, ie_alterar_data_benef_p text, ie_alt_data_vice_versa_p text, ie_tipo_alteracao_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


/* IE_TIPO_DATA_P - dom 1899
	13 - Alteracao da data do contrato
	14 - Alteracao da data de adesao
	15 - Alteracao da data de limite de utilizacao
	16 - Alteracao da data de inclusao da operadora
	19 - Alteracao da data de rescisao do beneficiario
	27 - Alteracao da data do reajuste
	44 - Alteracao da data do reajuste do SCA
	97 - Alteracao da data de reativacao
	
ie_tipo_alteracao_p
	0 - Somenente beneficiario
	1 - Beneficiario mais os depedentes
	2 - Todos beneficiarios do contrato
*/
ds_valor_dominio_w		varchar(255);
dt_data_antiga_w		timestamp;
dt_contrato_w			timestamp;
nr_seq_tabela_w			bigint;
ie_tabela_ok_w			varchar(1)	:= 'S';
nr_seq_plano_w			bigint	:= 0;
ie_preco_w			varchar(2)	:= '1';
ie_situacao_atend_w		varchar(1);
ie_pasta_reajuste_w		bigint	:= 0;
ds_observacao_historico_w	varchar(255);
ds_motivo_alteracao_w		varchar(255);
ie_dt_adesao_w			varchar(10);
dt_contratacao_titular_w	timestamp;
nr_seq_titular_w		bigint;
dt_validade_cart_parmetros_w	varchar(10);
nr_seq_contrato_w		bigint;
nr_seq_seg_preco_w		bigint;
nr_seq_pagador_w		bigint;
cd_pagador_w			varchar(10);
cd_beneficiario_w		varchar(10);
qt_pagadores_benef_w		bigint;
nr_seq_segurado_ant_w		bigint;
dt_inclusao_operadora_w		timestamp;
qt_benef_fora_familia_w		bigint;
nr_seq_contrato_plano_w		bigint;
dt_inativacao_w			timestamp;
dt_inicio_plano_w		timestamp;
dt_contratacao_w		timestamp;
ie_dt_limite_menor_rescisao_w	varchar(1);
dt_rescisao_w			timestamp;
dt_limite_utilizacao_w		timestamp;
qt_registro_w			integer;
ie_reajuste_w			pls_contrato.ie_reajuste%type;
dt_reajuste_w			pls_segurado.dt_reajuste%type;
nr_mes_reajuste_w		pls_segurado.nr_mes_reajuste%type;
nr_seq_grupo_reajuste_w		pls_contrato.nr_seq_grupo_reajuste%type;
dt_reajuste_contrato_w		pls_contrato.dt_reajuste%type;
dt_reativacao_w			pls_segurado.dt_reativacao%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_inicio_vigencia,
		coalesce(nr_seq_tabela,0) nr_seq_tabela
	from	pls_contrato_plano
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	coalesce(dt_inativacao::text, '') = '';

C02 CURSOR FOR
	SELECT	nr_sequencia nr_seq_vinculo_sca
	from	pls_sca_vinculo
	where	nr_seq_segurado	= nr_seq_segurado_p
	and	coalesce(dt_fim_vigencia::text, '') = ''
	and	ie_tipo_data_p <> 19
	
union all

	SELECT	nr_sequencia nr_seq_vinculo_sca
	from	pls_sca_vinculo
	where	nr_seq_segurado	= nr_seq_segurado_p
	and	ie_tipo_data_p	= 19
	and	trunc(dt_fim_vigencia,'dd') = trunc(dt_data_antiga_w,'dd');

C03 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	nr_seq_contrato		= nr_seq_contrato_p
	and	ie_acao_contrato	= 'A';

C04 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	nr_seq_titular	= nr_seq_segurado_p;

C05 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	nr_seq_contrato	= nr_seq_contrato_p;

BEGIN
ds_valor_dominio_w	:= obter_valor_dominio(1899, ie_tipo_data_p);
ie_dt_adesao_w		:= coalesce(obter_valor_param_usuario(1202, 88, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'S');
ie_dt_limite_menor_rescisao_w	:= coalesce(obter_valor_param_usuario(1202, 151, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'S');

select	coalesce(dt_base_validade_carteira,'B')
into STRICT	dt_validade_cart_parmetros_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_tipo_data_p in (15,19,97)) then
	select	nr_seq_pagador,
		cd_pessoa_fisica,
		dt_rescisao,
		dt_limite_utilizacao,
		dt_reativacao
	into STRICT	nr_seq_pagador_w,
		cd_beneficiario_w,
		dt_rescisao_w,
		dt_limite_utilizacao_w,
		dt_reativacao_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pagador_w
		from	pls_contrato_pagador
		where	nr_sequencia	= nr_seq_pagador_w;
	end if;
	
	select	count(1)
	into STRICT	qt_pagadores_benef_w
	from	pls_segurado
	where	nr_seq_pagador	= nr_seq_pagador_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	dt_rescisao > clock_timestamp();
	
	select	count(1)
	into STRICT	qt_benef_fora_familia_w
	from	pls_segurado
	where	nr_seq_pagador	= nr_seq_pagador_w
	and	nr_sequencia	<> nr_seq_segurado_p
	and	nr_seq_titular	<> nr_seq_segurado_p;
end if;

if (ie_tipo_data_p	= 13) then
	--Consistir a nova data em relacao so SIB
	CALL pls_consiste_data_sib(dt_data_alteracao_p, nm_usuario_p, cd_estabelecimento_p);
	
	select	count(1)
	into STRICT	qt_registro_w
	from	pls_segurado
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	dt_contratacao	< dt_data_alteracao_p
	and	((ie_alterar_data_benef_p = 'N') or (ie_alterar_data_benef_p = 'S' and ie_acao_contrato <> 'A'));
	
	if (qt_registro_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(570236, null);
	end if;
	
	select	coalesce(dt_contrato,''),
		nr_seq_grupo_reajuste,
		dt_reajuste,
		ie_reajuste
	into STRICT	dt_data_antiga_w,
		nr_seq_grupo_reajuste_w,
		dt_reajuste_contrato_w,
		ie_reajuste_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_p;
	
	--Verificar a nova data de adesao em relacao a data de vigencia da tabela de preco do beneficiario
	for c01_w in C01 loop
		begin
		
		select	max('S')
		into STRICT	ie_tabela_ok_w
		from	pls_tabela_preco
		where	nr_sequencia	= c01_w.nr_seq_tabela
		and	dt_data_alteracao_p between trunc(dt_inicio_vigencia) and coalesce(dt_fim_vigencia, pls_util_pck.obter_dt_vigencia_default('F'));
		
		if (nr_seq_tabela_w > 0) and (coalesce(ie_tabela_ok_w,'N')	= 'N') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(185413,'NR_SEQ_TABELA='||c01_w.nr_seq_tabela);
		end if;
		
		if (trunc(dt_data_antiga_w,'dd') = trunc(c01_w.dt_inicio_vigencia,'dd')) then
			update	pls_contrato_plano
			set	dt_inicio_vigencia = dt_data_alteracao_p
			where	nr_sequencia	= c01_w.nr_sequencia;
		end if;
		
		end;
	end loop; --C01
	
	update	pls_contrato
	set	dt_contrato	= dt_data_alteracao_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_contrato_p;
	
	if (ie_alterar_data_benef_p = 'S') then
		for c03_w in C03 loop
			begin
			CALL pls_alterar_datas(null,c03_w.nr_seq_segurado,null,dt_data_alteracao_p,14,cd_estabelecimento_p,nr_seq_motivo_p,ie_alterar_datas_sca_p,'N','N','0','N',nm_usuario_p);
			end;
		end loop; --C03
	end if;
	
	if	((coalesce(nr_seq_grupo_reajuste_w::text, '') = '') and (coalesce(dt_reajuste_contrato_w::text, '') = '')) then
		CALL pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contrato(nr_seq_contrato_p, ie_reajuste_w, (to_char(dt_data_alteracao_p,'mm'))::numeric , 'N', nm_usuario_p, cd_estabelecimento_p);
	end if;
elsif (ie_tipo_data_p	= 14) then
	--Consistir a nova data em relacao so SIB
	CALL pls_consiste_data_sib(dt_data_alteracao_p, nm_usuario_p, cd_estabelecimento_p);
	
	select	coalesce(a.dt_contratacao,''),
		coalesce(b.dt_contrato,''),
		a.nr_seq_tabela,
		coalesce(nr_seq_plano,0),
		nr_seq_contrato,
		coalesce(a.ie_situacao_atend,'A'),
		a.dt_inclusao_operadora,
		a.nr_seq_pagador,
		b.ie_reajuste,
		a.dt_reajuste,
		a.nr_mes_reajuste
	into STRICT	dt_data_antiga_w,
		dt_contrato_w,
		nr_seq_tabela_w,
		nr_seq_plano_w,
		nr_seq_contrato_w,
		ie_situacao_atend_w,
		dt_inclusao_operadora_w,
		nr_seq_pagador_w,
		ie_reajuste_w,
		dt_reajuste_w,
		nr_mes_reajuste_w
	from	pls_contrato	b,
		pls_segurado	a
	where	a.nr_sequencia		= nr_seq_segurado_p
	and	a.nr_seq_contrato	= b.nr_sequencia;
	
	if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_contrato_plano_w
		from	pls_contrato_plano
		where	nr_seq_contrato				= nr_seq_contrato_w
		and	nr_seq_plano				= nr_seq_plano_w
		and	coalesce(nr_seq_tabela,nr_seq_tabela_w)	= nr_seq_tabela_w;
		
		if (nr_seq_contrato_plano_w IS NOT NULL AND nr_seq_contrato_plano_w::text <> '') then
			select	dt_inativacao,
				trunc(dt_inicio_vigencia, 'dd')
			into STRICT	dt_inativacao_w,
				dt_inicio_plano_w
			from	pls_contrato_plano
			where	nr_sequencia	= nr_seq_contrato_plano_w;
			
			if (dt_data_alteracao_p > coalesce(dt_inativacao_w,dt_data_alteracao_p)) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(342140, null);
			elsif (dt_inicio_plano_w > trunc(dt_data_alteracao_p, 'dd')) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(328371, null);
			end if;
		end if;
	end if;
	
	select	coalesce(max(ie_preco),'1')
	into STRICT	ie_preco_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;
	
	--Verificar a nova data de adesao em relacao a data de vigencia da tabela de preco do beneficiario
	select	coalesce(max('S'),'N')
	into STRICT	ie_tabela_ok_w
	from	pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_w
	and	dt_data_alteracao_p between trunc(dt_inicio_vigencia) and coalesce(dt_fim_vigencia, pls_util_pck.obter_dt_vigencia_default('F') );
	
	if (ie_preco_w	= '1') and (ie_tabela_ok_w	= 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185413,'NR_SEQ_TABELA='||nr_seq_tabela_w);
	end if;
	
	--Nao pode ser menor do que a data do contrato
	if (ie_preco_w	= '1') and (trunc(dt_data_alteracao_p,'dd')	< trunc(dt_contrato_w,'dd')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185415,'DT_ALTERADA='||dt_data_alteracao_p||';'||'DT_CONTRATO='||dt_contrato_w);
	end if;
	
	--Nao pode ser menor do que a data do inclusao da operadora
	if (trunc(dt_data_alteracao_p,'dd') < trunc(dt_inclusao_operadora_w,'dd')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(199834,'NM_BENEFICIRIARIO='||substr(pls_obter_dados_segurado(nr_seq_segurado_p,'N'),1,255));
	end if;
	
	select	max(nr_seq_titular)
	into STRICT	nr_seq_titular_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	--Consistir o parametro [88] ; aaschlote - 16/09/2011
	if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') and (ie_dt_adesao_w	= 'N') then
		select	dt_contratacao
		into STRICT	dt_contratacao_titular_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_titular_w;
		
		if (dt_contratacao_titular_w > dt_data_alteracao_p) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(185417);
		end if;
	end if;
	
	--aaschlote 20/09/2011 OS - 362840
	if (ie_alterar_datas_sca_p = 'S') then
		for c02_w in C02 loop
			begin
			CALL pls_alterar_vigencia_sca(c02_w.nr_seq_vinculo_sca,dt_data_alteracao_p,'N',nm_usuario_p);
			end;
		end loop; --C02
	end if;
	
	if (trunc(dt_data_alteracao_p,'month') < trunc(dt_data_antiga_w,'month')) then
		CALL pls_gerar_valor_sca_segurado(nr_seq_segurado_p, 'R', null, nm_usuario_p, cd_estabelecimento_p);
	end if;
	
	--aaaschlote 13/06/2012 OS - 457710
	if (trunc(dt_data_alteracao_p,'dd') > trunc(clock_timestamp(),'dd')) and (ie_situacao_atend_w <> 'F') then
		ie_situacao_atend_w	:= 'F';
	elsif (trunc(dt_data_alteracao_p,'dd') <= trunc(clock_timestamp(),'dd')) and (ie_situacao_atend_w = 'F') then
		ie_situacao_atend_w	:= 'A';
	end if;
	
	update	pls_segurado
	set	dt_contratacao		= dt_data_alteracao_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		ie_situacao_atend	= ie_situacao_atend_w
	where	nr_sequencia		= nr_seq_segurado_p;
	
	update	pls_carencia
	set	dt_inicio_vigencia	= dt_data_alteracao_p,
		dt_fim_vigencia		= dt_data_alteracao_p + qt_dias,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_segurado		= nr_seq_segurado_p
	and	trunc(dt_inicio_vigencia,'month') = trunc(dt_data_antiga_w,'month');
	
	if	((ie_reajuste_w = 'A') and (coalesce(dt_reajuste_w::text, '') = '')) then
		CALL pls_atualizar_mes_reaj_pck.alterar_dt_contratacao_benef(nr_seq_segurado_p, dt_data_alteracao_p, coalesce(nr_mes_reajuste_w, 0), nm_usuario_p, cd_estabelecimento_p);
	end if;
	
	update	pls_segurado_pagador
	set	dt_inicio_vigencia	= trunc(dt_data_alteracao_p,'month')
	where	nr_seq_segurado		= nr_seq_segurado_p
	and	nr_seq_pagador		= nr_seq_pagador_w
	and	trunc(dt_inicio_vigencia,'month') = trunc(dt_data_antiga_w,'month');
	
	select	coalesce(dt_base_validade_carteira,dt_validade_cart_parmetros_w)
	into STRICT	dt_validade_cart_parmetros_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;
	
	dt_validade_cart_parmetros_w	:= coalesce(dt_validade_cart_parmetros_w,'B');
	
	select	min(nr_sequencia)
	into STRICT	nr_seq_seg_preco_w
	from	pls_segurado_preco
	where	nr_seq_segurado		= nr_seq_segurado_p
	and	cd_motivo_reajuste	= 'C';
	
	if (nr_seq_seg_preco_w IS NOT NULL AND nr_seq_seg_preco_w::text <> '') then
		update	pls_segurado_preco
		set	dt_reajuste	= dt_data_alteracao_p
		where	nr_sequencia	= nr_seq_seg_preco_w;
	end if;
	
	update	pls_segurado_carteira
	set	dt_inicio_vigencia	= dt_data_alteracao_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_segurado		= nr_seq_segurado_p;
elsif (ie_tipo_data_p	= 15) then
	if (ie_dt_limite_menor_rescisao_w = 'N') and (trunc(dt_data_alteracao_p,'dd') < trunc(dt_rescisao_w,'dd')) and (ie_alt_data_vice_versa_p = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(448199);
	end if;
	
	--Nao ha consistencias a fazer
	
	select	coalesce(dt_limite_utilizacao,'')
	into STRICT	dt_data_antiga_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	--aaschlote - 20/04/2011 - Caso a data limiote de utilizacao foi maior que a data atual, entao o sistema deve deixar a situacao de atendimento apta
	if (dt_data_alteracao_p > clock_timestamp()) then
		ie_situacao_atend_w	:= 'A';
	elsif (dt_data_alteracao_p <= clock_timestamp()) then
		ie_situacao_atend_w	:= 'I';
	end if;
	
	update	pls_segurado
	set	dt_limite_utilizacao	= fim_dia(dt_data_alteracao_p),
		dt_rescisao		= CASE WHEN ie_alt_data_vice_versa_p='S' THEN dt_data_alteracao_p WHEN ie_alt_data_vice_versa_p='N' THEN dt_rescisao END ,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		ie_situacao_atend	= ie_situacao_atend_w
	where	nr_sequencia		= nr_seq_segurado_p;
	
	select	max(nr_seq_titular)
	into STRICT	nr_seq_titular_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	--aaschlote OS 387858 02/12/2012
	if	((ie_tipo_alteracao_p = 0 and qt_pagadores_benef_w = 1) or (ie_tipo_alteracao_p = 1 and coalesce(nr_seq_titular_w::text, '') = '')) and (qt_benef_fora_familia_w = 0) and (cd_beneficiario_w = cd_pagador_w) then
		update	pls_contrato_pagador
		set	dt_rescisao	= dt_data_alteracao_p
		where	nr_sequencia	= nr_seq_pagador_w;
	end if;
elsif (ie_tipo_data_p	= 16) then
	select	coalesce(dt_inclusao_operadora,''),
		nr_seq_segurado_ant
	into STRICT	dt_data_antiga_w,
		nr_seq_segurado_ant_w
	from	pls_segurado
	where	nr_sequencia		= nr_seq_segurado_p;
	
	update	pls_segurado
	set	dt_inclusao_operadora	= dt_data_alteracao_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_segurado_p;
	
	CALL pls_preco_beneficiario_pck.gravar_preco_benef(nr_seq_segurado_p, 'R', 'S', clock_timestamp(), 'N', null, nm_usuario_p, cd_estabelecimento_p);

	--aaschlote 29/05/2012 - 448017
	if (ie_alterar_datas_sca_p = 'S') then
		for c02_w in C02 loop
			begin
			if (coalesce(nr_seq_segurado_ant_w::text, '') = '') then
				update	pls_sca_vinculo
				set	dt_inclusao_benef	= dt_data_alteracao_p,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia		= c02_w.nr_seq_vinculo_sca;
			end if;
			end;
		end loop; --C02
	end if;
elsif (ie_tipo_data_p	= 19) then
	if (ie_dt_limite_menor_rescisao_w = 'N') and (trunc(dt_limite_utilizacao_w,'dd') < trunc(dt_data_alteracao_p,'dd')) and (ie_alt_data_vice_versa_p = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(448194);
	end if;
	
	--Consistir a nova data em relacao so SIB
	CALL pls_consiste_data_sib(dt_data_alteracao_p, nm_usuario_p, cd_estabelecimento_p);
	
	select	dt_rescisao,
		dt_contratacao
	into STRICT	dt_data_antiga_w,
		dt_contratacao_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	update	pls_segurado_repasse
	set	dt_fim_repasse			=	fim_dia(dt_data_alteracao_p)
	where	nr_seq_segurado			=	nr_seq_segurado_p
	and	trunc(dt_fim_repasse, 'dd')	=	trunc(dt_data_antiga_w, 'dd');
	
	if (dt_data_antiga_w IS NOT NULL AND dt_data_antiga_w::text <> '') then
		if (dt_data_alteracao_p < trunc(dt_contratacao_w,'dd')) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(355532);
		end if;
		
		if (ie_alt_data_vice_versa_p = 'S') then
			if (dt_data_alteracao_p > clock_timestamp()) then
				ie_situacao_atend_w	:= 'A';
			elsif (dt_data_alteracao_p <= clock_timestamp()) then
				ie_situacao_atend_w	:= 'I';
			end if;
		end if;
		
		update	pls_segurado
		set	dt_rescisao		= fim_dia(dt_data_alteracao_p),
			dt_limite_utilizacao	= CASE WHEN ie_alt_data_vice_versa_p='S' THEN dt_data_alteracao_p WHEN ie_alt_data_vice_versa_p='N' THEN dt_limite_utilizacao END ,
			ie_situacao_atend	= CASE WHEN ie_alt_data_vice_versa_p='S' THEN ie_situacao_atend_w WHEN ie_alt_data_vice_versa_p='N' THEN ie_situacao_atend END ,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_segurado_p;
		
		select	max(nr_seq_titular)
		into STRICT	nr_seq_titular_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;
		
		--Se estiver alterando a data apenas do beneficiario, so pode existir ele para o pagador, se for titular + dependentes, deve estar no titular
		if	((ie_tipo_alteracao_p = 0 and qt_pagadores_benef_w = 1) or (ie_tipo_alteracao_p = 1 and coalesce(nr_seq_titular_w::text, '') = '')) and (qt_benef_fora_familia_w = 0) and (cd_beneficiario_w = cd_pagador_w) then
			update	pls_contrato_pagador
			set	dt_rescisao	= dt_data_alteracao_p
			where	nr_sequencia	= nr_seq_pagador_w;
		end if;
		
		if (ie_alterar_datas_sca_p = 'S') then
			for c02_w in C02 loop
				begin
				CALL pls_alterar_fim_vigencia_sca(c02_w.nr_seq_vinculo_sca,dt_data_alteracao_p,'N',nm_usuario_p);
				end;
			end loop; --C02
		end if;
	end if;
elsif (ie_tipo_data_p = 27) then
	if (coalesce(nr_seq_segurado_p::text, '') = '') then
		begin
		ie_pasta_reajuste_w	:= 1;
		
		select	coalesce(dt_reajuste,''),
			nr_seq_grupo_reajuste,
			ie_reajuste
		into STRICT	dt_data_antiga_w,
			nr_seq_grupo_reajuste_w,
			ie_reajuste_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_p;
		
		update	pls_contrato
		set	dt_reajuste	= dt_data_alteracao_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_contrato_p;
		end;
		
		if (coalesce(nr_seq_grupo_reajuste_w::text, '') = '') then
			CALL pls_atualizar_mes_reaj_pck.alterar_mes_reaj_contrato(nr_seq_contrato_p, ie_reajuste_w, (to_char(dt_data_alteracao_p, 'mm'))::numeric , 'N', nm_usuario_p, cd_estabelecimento_p);
		end if;
	else
		begin
		ie_pasta_reajuste_w	:= 2;
		
		select	coalesce(a.dt_reajuste,''),
			a.nr_mes_reajuste,
			b.ie_reajuste
		into STRICT	dt_data_antiga_w,
			nr_mes_reajuste_w,
			ie_reajuste_w
		from	pls_segurado a,
			pls_contrato b
		where	b.nr_sequencia	= a.nr_seq_contrato
		and	a.nr_sequencia	= nr_seq_segurado_p;
		
		update	pls_segurado
		set	dt_reajuste	= dt_data_alteracao_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_segurado_p;
		
		if (ie_reajuste_w = 'A') then
			CALL pls_atualizar_mes_reaj_pck.alterar_dt_reajuste_benef(nr_seq_segurado_p, dt_data_alteracao_p, coalesce(nr_mes_reajuste_w, 0), nm_usuario_p, cd_estabelecimento_p);
		end if;
		end;
	end if;
elsif (ie_tipo_data_p = 44) then
	select	coalesce(b.dt_reajuste,''),
		coalesce(b.nr_mes_reajuste, 0)
	into STRICT	dt_data_antiga_w,
		nr_mes_reajuste_w
	from	pls_sca_vinculo	b,
		pls_segurado	a
	where	a.nr_sequencia		= b.nr_seq_segurado
	and	a.nr_sequencia		= nr_seq_segurado_p
	and	b.nr_sequencia		= nr_seq_sca_p;
	
	update	pls_sca_vinculo
	set	dt_reajuste		= dt_data_alteracao_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_sca_p;

	CALL pls_atualizar_mes_reaj_pck.alterar_mes_reaj_sca(nr_seq_sca_p, (to_char(dt_data_alteracao_p, 'mm'))::numeric , nm_usuario_p, cd_estabelecimento_p);
elsif (ie_tipo_data_p = 97) then
	if (dt_reativacao_w IS NOT NULL AND dt_reativacao_w::text <> '') then
		dt_data_antiga_w	:= dt_reativacao_w;
	
		update	pls_segurado
		set	dt_reativacao	= dt_data_alteracao_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_segurado_p;
	end if;
end if;

if (ie_tipo_data_p in (14,15,16,19)) then
	if (ie_tipo_alteracao_p = '1') and (coalesce(nr_seq_titular_w::text, '') = '') then
		for c04_w in C04 loop
			begin
			CALL pls_alterar_datas(null,c04_w.nr_seq_segurado,null,dt_data_alteracao_p,ie_tipo_data_p,cd_estabelecimento_p,nr_seq_motivo_p,ie_alterar_datas_sca_p,
					'N',ie_alt_data_vice_versa_p,0,'N',nm_usuario_p);
			end;
		end loop; --C04
	elsif (ie_tipo_alteracao_p = 2) then
		for c05_w in C05 loop
			begin
			CALL pls_alterar_datas(null,c05_w.nr_seq_segurado,null,dt_data_alteracao_p,ie_tipo_data_p,cd_estabelecimento_p,nr_seq_motivo_p,ie_alterar_datas_sca_p,
					'N',ie_alt_data_vice_versa_p,0,'N',nm_usuario_p);
			end;
		end loop; --C05
	end if;
end if;

if (coalesce(nr_seq_motivo_p, 0) = 0) then
	ds_observacao_historico_w := 'pls_alterar_datas';
else
	begin
	select	ds_motivo
	into STRICT	ds_motivo_alteracao_w
	from	pls_motivo_alteracao_plano
	where	nr_sequencia = nr_seq_motivo_p;
	
	ds_observacao_historico_w := 'Motivo: '||ds_motivo_alteracao_w;
	end;
end if;

if (ie_tipo_data_p	in (13)) or (ie_tipo_data_p in (27) and ie_pasta_reajuste_w = 1) then
	insert	into	pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, ie_tipo_historico,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico)
		values ( nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, clock_timestamp(), ie_tipo_data_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'De: ' || dt_data_antiga_w || '. Para: ' || dt_data_alteracao_p);
elsif (ie_tipo_data_p	in (14,15,16,19,44,97)) or (ie_tipo_data_p in (27) and ie_pasta_reajuste_w = 2) then
	CALL pls_gerar_segurado_historico(
		nr_seq_segurado_p, ie_tipo_data_p, clock_timestamp(),
		'De: ' || dt_data_antiga_w || '. Para: ' || dt_data_alteracao_p, ds_observacao_historico_w, null,
		null, null, null,
		clock_timestamp(), null, null,
		null, null, null,
		null, nm_usuario_p, 'N');
end if;

if (ie_commit_p	= 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_datas ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_sca_p bigint, dt_data_alteracao_p timestamp, ie_tipo_data_p text, cd_estabelecimento_p bigint, nr_seq_motivo_p bigint, ie_alterar_datas_sca_p text, ie_alterar_data_benef_p text, ie_alt_data_vice_versa_p text, ie_tipo_alteracao_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
