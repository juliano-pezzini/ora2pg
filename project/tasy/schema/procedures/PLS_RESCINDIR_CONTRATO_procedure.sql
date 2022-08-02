-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_rescindir_contrato ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_pagador_p bigint, nr_seq_subestipulante_p bigint, nr_seq_rescisao_contr_p bigint, dt_rescisao_p timestamp, dt_limite_utilizacao_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, ie_consistir_sib_p text, nm_usuario_p text, nr_certidao_obito_p text, dt_obito_p timestamp, ie_rescindir_contrato_p text, nr_seq_causa_rescisao_p bigint, ds_erro_p INOUT text, nr_seq_notific_pag_p bigint, ie_att_dt_rescisao_p text, ie_tipo_rescisao_p text default null, dt_fim_repasse_p timestamp default null) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
qt_benef_inativos_w		bigint;
qt_beneficiarios_w		bigint;
ie_inadimplencia_w		varchar(1);
nr_seq_trans_fin_inadi_w	bigint;
nr_seq_pagador_w		bigint;
ie_gerar_lead_pj_benef_w	varchar(1);
ie_gerar_lead_pf_benef_w	varchar(1);
ie_certidao_obito_w		varchar(1);
ie_tipo_contrato_w		varchar(2);
dt_rescisao_w			timestamp;
nr_contrato_w			bigint;
ds_perfil_w			varchar(300);
ds_erro_w			varchar(255);
qt_registros_w			bigint;
ie_regulamentacao_regra_w	varchar(2)	:= null;
nr_seq_regra_rescisao_w		bigint;
ie_obito_w			varchar(1);
nr_contrato_principal_w		bigint;
ie_gerar_lead_rescisao_w	varchar(2);
ie_atualiza_data_rescisao_w	varchar(10);
nr_seq_titular_ww		bigint;
nr_seq_motivo_conver_aux_w	bigint;
qt_beneficiarios_contrato_w	bigint;
ie_rescindir_subcontr_w		varchar(1);
cd_perfil_w			bigint;
qt_dt_adesao_superior_w		bigint;
ie_tipo_rescisao_w		varchar(1);
ie_dt_limite_menor_rescisao_w	varchar(1);
ds_regra_restricao_resc_w	varchar(1);
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
ie_dependente_rescisao_fut_w	varchar(1);
ie_gerar_devolucao_w		varchar(1);
ds_mensagem_rescisao_pag_w	varchar(4000);
ie_isentar_multa_w		pls_motivo_cancelamento.ie_isentar_multa%type;

ie_remido_ativo_w		varchar(1);
dt_resc_prog_remido_w		timestamp;
ie_titular_ativo_w		varchar(1);

--Percorre os beneficiarios titulares do contrato
C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado,
		b.nr_contrato,
		pls_obter_se_benef_remido(a.nr_sequencia, trunc(dt_rescisao_p+1,'dd')) ie_remido  --Verifica se benef eh remido no dia apos a rescisao. Neste caso precisa manter o contrato ativo
	from	pls_segurado	a,
		pls_contrato	b
	where	b.nr_sequencia		= a.nr_seq_contrato
	and	a.nr_seq_contrato	= nr_seq_contrato_p
	and	coalesce(a.dt_rescisao::text, '') = ''
	and	coalesce(a.nr_seq_titular::text, '') = ''
	
union

	SELECT	b.nr_sequencia nr_seq_segurado,
		a.nr_contrato,
		pls_obter_se_benef_remido(b.nr_sequencia, trunc(dt_rescisao_p+1,'dd')) ie_remido
	from	pls_segurado	b,
		pls_contrato	a
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	a.nr_contrato_principal	= nr_seq_contrato_p
	and	coalesce(b.dt_rescisao::text, '') = ''
	and (ie_rescindir_subcontr_w = 'S' or b.nr_seq_titular in (	select	nr_sequencia
									from	pls_segurado
									where	nr_seq_contrato	= nr_seq_contrato_p
									and	coalesce(dt_rescisao::text, '') = ''));

C02 CURSOR( nr_seq_segurado_pc	pls_segurado.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_dependente,
		b.nr_contrato,
		pls_obter_se_benef_remido(a.nr_sequencia, dt_rescisao_p) ie_remido
	from	pls_segurado	a,
		pls_contrato	b
	where	b.nr_sequencia		= a.nr_seq_contrato
	and	a.nr_seq_titular	= nr_seq_segurado_pc
	and	((coalesce(a.dt_rescisao::text, '') = '') or (ie_dependente_rescisao_fut_w = 'S' and a.dt_rescisao > dt_rescisao_p));

C04 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado,
		b.ie_regulamentacao ie_regulamentacao_plano
	from	pls_plano b,
		pls_segurado a
	where	a.nr_seq_plano		= b.nr_sequencia
	and	a.nr_seq_pagador	= nr_seq_pagador_p
	and	((coalesce(a.dt_rescisao::text, '') = '' and coalesce(nr_seq_notific_pag_p::text, '') = '') or
		((coalesce(a.dt_rescisao, clock_timestamp()) >= clock_timestamp()) and (nr_seq_notific_pag_p IS NOT NULL AND nr_seq_notific_pag_p::text <> '')));

C05 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	nr_seq_subestipulante	= nr_seq_subestipulante_p
	and	coalesce(dt_rescisao::text, '') = '';

C07 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_segurado_contr_vinc
	from	pls_segurado	b,
		pls_contrato	a
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	a.nr_contrato_principal	= nr_seq_contrato_w
	and	coalesce(dt_rescisao::text, '') = '';

C08 CURSOR FOR
	SELECT	nr_sequencia nr_seq_contr_vinculado,
		nr_contrato nr_contrato_vinculado
	from	pls_contrato
	where	nr_contrato_principal	= nr_seq_contrato_w
	and	coalesce(dt_rescisao_contrato::text, '') = '';

C09 CURSOR FOR
	SELECT	nr_sequencia nr_seq_pagador
	from	pls_contrato_pagador
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	coalesce(dt_rescisao::text, '') = ''; --Pagadores ja rescididos so podem ter a data de rescisao alterada caso o parametro ie_atualiza_data_rescisao_w permitir
C10 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado_sca
	from	pls_segurado
	where	nr_seq_contrato	= nr_seq_contrato_w
	and	nr_sequencia <> nr_seq_segurado_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

C11 CURSOR(	nr_seq_segurado_sca_pc	pls_segurado.nr_sequencia%type ) FOR
	SELECT	a.nr_sequencia nr_seq_vinculo_sca
	from	pls_sca_vinculo a,
		pls_tabela_preco b
	where	a.nr_seq_tabela = b.nr_sequencia
	and	coalesce(b.ie_preco_vidas_contrato,'N') = 'S'
	and	a.nr_seq_segurado = nr_seq_segurado_sca_pc;

C12 CURSOR FOR
	SELECT	nr_sequencia nr_seq_pagador
	from	pls_contrato_pagador
	where	nr_seq_contrato	= nr_seq_contrato_p;

C13 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado,
		b.nr_contrato,
		pls_obter_se_benef_remido(a.nr_sequencia, trunc(dt_rescisao_p+1,'dd')) ie_remido  --Verifica se benef eh remido no dia apos a rescisao. Neste caso precisa manter o contrato ativo
	from	pls_segurado	a,
		pls_contrato	b
	where	b.nr_sequencia		= a.nr_seq_contrato
	and	a.nr_seq_contrato	= nr_seq_contrato_p
	and	(a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '')
	and	coalesce(a.nr_seq_titular::text, '') = '';

BEGIN

ie_gerar_devolucao_w	:= 'N';

select	max(nr_sequencia)
into STRICT	nr_contrato_principal_w
from	pls_contrato
where	nr_contrato_principal	= nr_seq_contrato_p;

if (ie_consistir_sib_p = 'S') then
	
	if (coalesce(nr_seq_contrato_p, 0) <> 0) then
		select	count(1)
		into STRICT	qt_registros_w
		from	table(pls_sib_validacao_pck.validar_sib_contrato(nr_seq_contrato_p,null,null,null));
	elsif (coalesce(nr_seq_segurado_p, 0) <> 0) then
		select	count(1)
		into STRICT	qt_registros_w
		from	table(pls_sib_validacao_pck.validar_sib_contrato(null,nr_seq_segurado_p,null,null));
	end if;
	
	if (qt_registros_w > 0) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(281112);
	end if;
end if;

if (coalesce(ds_erro_w::text, '') = '') then
	cd_perfil_w	:= Obter_Perfil_Ativo;
	ie_gerar_lead_pj_benef_w	:= coalesce(obter_valor_param_usuario(1237, 16, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'N');
	ie_gerar_lead_pf_benef_w	:= coalesce(obter_valor_param_usuario(1237, 54, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'N');
	ie_certidao_obito_w		:= coalesce(obter_valor_param_usuario(1202, 109, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'N');
	ie_rescindir_subcontr_w		:= coalesce(obter_valor_param_usuario(1202, 131, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'S');
	ie_dt_limite_menor_rescisao_w	:= coalesce(obter_valor_param_usuario(1202, 151, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'S');
	ie_dependente_rescisao_fut_w	:= coalesce(obter_valor_param_usuario(1202, 155, cd_perfil_w, nm_usuario_p, cd_estabelecimento_p), 'S');
	ie_atualiza_data_rescisao_w	:= coalesce(ie_att_dt_rescisao_p,'N');
	
	if (ie_dt_limite_menor_rescisao_w = 'N') and (trunc(dt_limite_utilizacao_p,'dd') < trunc(dt_rescisao_p,'dd') ) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(448199);
	end if;
	
	select	coalesce(ie_inadimplencia,'N'),
		coalesce(ie_obito,'N'),
		coalesce(ie_gerar_lead_rescisao,'S'),
		coalesce(ie_isentar_multa,'N')
	into STRICT	ie_inadimplencia_w,
		ie_obito_w,
		ie_gerar_lead_rescisao_w,
		ie_isentar_multa_w
	from	pls_motivo_cancelamento
	where	nr_sequencia = nr_seq_motivo_p;
	
	if (ie_inadimplencia_w = 'S') then
		select	nr_seq_trans_fin_inadi
		into STRICT	nr_seq_trans_fin_inadi_w
		from	pls_parametros
		where	cd_estabelecimento = cd_estabelecimento_p;
	end if;
	
	begin
	select	ds_perfil
	into STRICT	ds_perfil_w
	from	perfil
	where	cd_perfil	= cd_perfil_w;
	exception
	when others then
		ds_perfil_w	:= ' ';
	end;
	
	if (coalesce(nr_seq_contrato_p,0) <> 0) then
		select	pls_obter_restr_resc_contrato(nr_seq_contrato_p,cd_perfil_w,nm_usuario_p, 'C')
		into STRICT	ds_regra_restricao_resc_w
		;
		
		if (ds_regra_restricao_resc_w = 'S') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(450518, null);
		end if;
		
		--Verifica se existe beneficiario com a data de adesao superior e a data de de rescisao e que nao esteja cancelado
		select	count(1)
		into STRICT	qt_dt_adesao_superior_w
		from	pls_segurado a
		where	a.nr_seq_contrato = nr_seq_contrato_p
		and	trunc(a.dt_contratacao,'dd') > trunc(dt_rescisao_p,'dd')
		and	coalesce(a.dt_cancelamento::text, '') = '';
		
		if (qt_dt_adesao_superior_w > 0 ) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(355086, null);
		end if;
		
		if (ie_atualiza_data_rescisao_w = 'S') then
			CALL pls_alt_data_resc_benef_inatvo(	nr_seq_contrato_p,
							dt_rescisao_p,
							dt_limite_utilizacao_p,
							cd_estabelecimento_p,
							nm_usuario_p);
		end if;
		
		select	count(1)
		into STRICT	qt_beneficiarios_contrato_w
		from	pls_segurado
		where	nr_seq_contrato = nr_seq_contrato_p
		and	coalesce(dt_rescisao::text, '') = ''
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
		
		if (ie_obito_w = 'S') and (qt_beneficiarios_contrato_w = 1) and (dt_obito_p IS NOT NULL AND dt_obito_p::text <> '') then
			select	cd_pessoa_fisica
			into STRICT	cd_pessoa_fisica_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_p
			and	coalesce(dt_rescisao::text, '') = ''
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			
			CALL pls_inserir_obito_pf(	cd_pessoa_fisica_w,
						dt_obito_p,
						nr_certidao_obito_p,
						nm_usuario_p,
						ie_certidao_obito_w);
		end if;
		
		CALL pls_gerar_multa_contratual(nr_seq_contrato_p,null,dt_rescisao_p,null,cd_estabelecimento_p,nm_usuario_p,ie_isentar_multa_w); --Calcular a multa antes de rescindir os beneficiarios
		
		ie_titular_ativo_w	:= 'N';
		ie_remido_ativo_w	:= 'N';
		dt_resc_prog_remido_w	:= null;
		for r_c01_w in C01 loop
			begin
			ie_titular_ativo_w	:= 'S';
			for r_c02_w in C02(r_c01_w.nr_seq_segurado) loop
				begin
				nr_seq_motivo_conver_aux_w := pls_converter_motivo_can_tit(	nr_seq_motivo_p, nr_seq_motivo_conver_aux_w, nm_usuario_p);
				
				if (coalesce(nr_seq_motivo_conver_aux_w::text, '') = '') then
					nr_seq_motivo_conver_aux_w	:= nr_seq_motivo_p;
				end if;
				
				if (r_c02_w.ie_remido = 'S') then
					ie_remido_ativo_w	:= 'S';
				else
					--Realiza a rescisao dos dependentes
					CALL pls_rescindir_segurado(	r_c02_w.nr_seq_dependente,
								dt_rescisao_p,
								dt_limite_utilizacao_p,
								nr_seq_motivo_conver_aux_w,
								ds_observacao_p,
								cd_estabelecimento_p,
								nm_usuario_p,
								coalesce(ie_tipo_rescisao_p, 'C'),
								'N',
								nr_seq_causa_rescisao_p,
								dt_fim_repasse_p);
				end if;
				end;
			end loop; --C02
			
			if (r_c01_w.ie_remido = 'S') then
				ie_remido_ativo_w	:= 'S';
			else
				CALL pls_rescindir_segurado(	r_c01_w.nr_seq_segurado,
							dt_rescisao_p,
							dt_limite_utilizacao_p,
							nr_seq_motivo_p,
							ds_observacao_p,
							cd_estabelecimento_p,
							nm_usuario_p,
							coalesce(ie_tipo_rescisao_p, 'C'),
							'N',
							nr_seq_causa_rescisao_p,
							dt_fim_repasse_p);
			end if;
			end;
		end loop; --C01
		
		if (ie_titular_ativo_w = 'N') then
			for r_c13_w in C13 loop --Listar todos titulares inativos, para buscar por dependentes que estejam ativos
				begin
				
				for r_c02_w in C02(r_c13_w.nr_seq_segurado) loop
					begin
					nr_seq_motivo_conver_aux_w := pls_converter_motivo_can_tit(	nr_seq_motivo_p, nr_seq_motivo_conver_aux_w, nm_usuario_p);
					
					if (coalesce(nr_seq_motivo_conver_aux_w::text, '') = '') then
						nr_seq_motivo_conver_aux_w	:= nr_seq_motivo_p;
					end if;
					
					if (r_c02_w.ie_remido = 'S') then
						ie_remido_ativo_w	:= 'S';
					else
						--Realiza a rescisao dos dependentes
						CALL pls_rescindir_segurado(	r_c02_w.nr_seq_dependente,
									dt_rescisao_p,
									dt_limite_utilizacao_p,
									nr_seq_motivo_conver_aux_w,
									ds_observacao_p,
									cd_estabelecimento_p,
									nm_usuario_p,
									coalesce(ie_tipo_rescisao_p, 'C'),
									'N',
									nr_seq_causa_rescisao_p,
									dt_fim_repasse_p);
					end if;
					end;
				end loop; --C02
				
				end;
			end loop;
		end if;
		
		if (ie_remido_ativo_w = 'N') then --Verifica se tem algum beneficiario remido com rescisao futura efetivada
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_remido_ativo_w
			from	pls_segurado
			where	nr_seq_contrato	= nr_seq_contrato_p
			and	dt_rescisao	> fim_dia(dt_rescisao_p)
			and	pls_obter_se_benef_remido(nr_sequencia, trunc(dt_rescisao_p+1,'dd')) = 'S';
		end if;
		
		if (ie_remido_ativo_w = 'S') then
			select	max(coalesce(a.dt_rescisao,b.dt_rescisao)) --Busca a maior data de rescisao de remido, para gerar a rescisao programada do contrato
			into STRICT	dt_resc_prog_remido_w
			FROM pls_segurado a
LEFT OUTER JOIN pls_rescisao_contrato b ON (a.nr_sequencia = b.nr_seq_segurado)
WHERE pls_obter_se_benef_remido(a.nr_sequencia, dt_rescisao_p) = 'S' and a.nr_seq_contrato	= nr_seq_contrato_p and coalesce(b.ie_situacao,'A')	= 'A';
			
			if (coalesce(dt_resc_prog_remido_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1105648); --Existe(m) beneficiario(s) remido(s) sem data de rescisao ou rescisao programada. Favor verifique!
			end if;
			
			update	pls_contrato
			set	ie_exclusivo_benef_remido	= 'S',
				nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp()
			where	nr_sequencia			= nr_seq_contrato_p;
			
			insert	into	pls_rescisao_contrato(	nr_sequencia, nr_seq_contrato, ie_situacao,
					dt_solicitacao, nm_usuario_solicitacao, dt_atualizacao,
					nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
					dt_rescisao, nr_seq_motivo_rescisao, nr_seq_causa_rescisao,
					dt_limite_utilizacao, ie_processo, ie_tipo_solicitante,
					ds_observacao )
				values (nextval('pls_rescisao_contrato_seq'), nr_seq_contrato_p, 'A',
					clock_timestamp(), nm_usuario_p, clock_timestamp(),
					nm_usuario_p, clock_timestamp(), nm_usuario_p,
					dt_resc_prog_remido_w, nr_seq_motivo_p, nr_seq_causa_rescisao_p,
					dt_resc_prog_remido_w, 'M', 'T',
					wheb_mensagem_pck.get_texto(1105406,'DT_RESC_PROGRAMADA='||to_char(dt_resc_prog_remido_w,'dd/mm/rrrr'))); --Rescisao de contrato programada para #@DT_RESC_PROGRAMADA#@, devido a existencia de beneficiario remido ativo
			
			insert into pls_contrato_historico(nr_sequencia,
				cd_estabelecimento,
				nr_seq_contrato,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_historico,
				dt_atualizacao_nrec,
				ie_tipo_historico,
				ds_historico,
				ds_observacao)
			values (nextval('pls_contrato_historico_seq'),
				cd_estabelecimento_p,
				nr_seq_contrato_p,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				clock_timestamp(),
				'1',
				wheb_mensagem_pck.get_texto(1105406,'DT_RESC_PROGRAMADA='||to_char(dt_resc_prog_remido_w,'dd/mm/rrrr')), --Rescisao de contrato programada para #@DT_RESC_PROGRAMADA#@, devido a existencia de beneficiario remido ativo
				ds_observacao_p);
		else
			update	pls_contrato
			set	dt_rescisao_contrato		= dt_rescisao_p,
				ie_situacao			= '3',
				ie_exclusivo_benef_remido	= 'N',
				nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp(),
				nr_seq_motivo_rescisao		= nr_seq_motivo_p,
				dt_limite_utilizacao		= dt_limite_utilizacao_p,
				nr_seq_causa_rescisao		= nr_seq_causa_rescisao_p
			where	nr_sequencia			= nr_seq_contrato_p;
		
			for r_c09_w in C09 loop
				begin
				update	pls_contrato_pagador
				set	dt_rescisao			= dt_rescisao_p,
					nm_usuario			= nm_usuario_p,
					dt_atualizacao			= clock_timestamp(),
					nr_seq_motivo_cancelamento	= nr_seq_motivo_p
				where	nr_sequencia			= r_c09_w.nr_seq_pagador;
				
				CALL pls_liquidar_titulos_rescisao(	r_c09_w.nr_seq_pagador,
								dt_rescisao_p,
								cd_estabelecimento_p,
								nm_usuario_p);
				
				ie_gerar_devolucao_w	:= 'S';
				end;
			end loop; --C09
			
			select	max(nr_contrato)
			into STRICT	nr_contrato_w
			from	pls_contrato
			where	nr_sequencia	= nr_seq_contrato_p;
			
			insert into pls_contrato_historico(nr_sequencia,
				cd_estabelecimento,
				nr_seq_contrato,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_historico,
				dt_atualizacao_nrec,
				ie_tipo_historico,
				ds_historico,
				ds_observacao)
			values (nextval('pls_contrato_historico_seq'),
				cd_estabelecimento_p,
				nr_seq_contrato_p,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				clock_timestamp(),
				'1',
				wheb_mensagem_pck.get_texto(1191986, 'NR_CONTRATO_P=' || nr_contrato_w ||
								';DS_PERFIL_P=' || ds_perfil_w ||
								';DATA_P=' || to_char(clock_timestamp(),'dd/mm/rrrr')||
								';DT_LIMITE_UTILIZACAO='||to_char(dt_limite_utilizacao_p,'dd/mm/rrrr')),
				ds_observacao_p);
		end if;
		
		if (nr_contrato_principal_w IS NOT NULL AND nr_contrato_principal_w::text <> '') and (ie_rescindir_subcontr_w = 'S') then
			nr_seq_contrato_w := nr_seq_contrato_p;
			
			for r_c08_w in C08 loop
				begin
				update	pls_contrato
				set	dt_rescisao_contrato	= dt_rescisao_p,
					ie_situacao		= '3',
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					nr_seq_motivo_rescisao	= nr_seq_motivo_p,
					dt_limite_utilizacao	= dt_limite_utilizacao_p,
					nr_seq_causa_rescisao	= nr_seq_causa_rescisao_p
				where	nr_sequencia		= r_c08_w.nr_seq_contr_vinculado;
				
				update	pls_contrato_pagador
				set	dt_rescisao			= dt_rescisao_p,
					nm_usuario			= nm_usuario_p,
					dt_atualizacao			= clock_timestamp(),
					nr_seq_motivo_cancelamento	= nr_seq_motivo_p
				where	nr_seq_contrato			= r_c08_w.nr_seq_contr_vinculado
				and	coalesce(dt_rescisao::text, '') = '';
				
				insert into pls_contrato_historico(nr_sequencia,
					cd_estabelecimento,
					nr_seq_contrato,
					nm_usuario,
					nm_usuario_nrec,
					dt_atualizacao,
					dt_historico,
					dt_atualizacao_nrec,
					ie_tipo_historico,
					ds_historico,
					ds_observacao)
				values (nextval('pls_contrato_historico_seq'),
					cd_estabelecimento_p,
					r_c08_w.nr_seq_contr_vinculado,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					clock_timestamp(),
					'1',
					wheb_mensagem_pck.get_texto(1191989, 'NR_CONTRATO_P=' || r_c08_w.nr_contrato_vinculado ||
									';DS_PERFIL_P=' || ds_perfil_w ||
									';DATA_P=' || to_char(clock_timestamp(),'dd/mm/rrrr') ||
									';NR_CONTRATO2_P=' || nr_contrato_w||
									';DT_LIMITE_UTILIZACAO='||to_char(dt_limite_utilizacao_p,'dd/mm/rrrr')),
					ds_observacao_p );
				end;
			end loop; --C08
			
		end if;
	elsif (coalesce(nr_seq_segurado_p,0) <> 0) then
		
		select 	nr_seq_contrato,
			nr_seq_pagador,
			nr_seq_titular,
			cd_pessoa_fisica
		into STRICT	nr_seq_contrato_w,
			nr_seq_pagador_w,
			nr_seq_titular_ww,
			cd_pessoa_fisica_w
		from 	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;
		
		select	pls_obter_restr_resc_contrato(nr_seq_contrato_w,cd_perfil_w,nm_usuario_p, 'B')
		into STRICT	ds_regra_restricao_resc_w
		;
		
		if (ds_regra_restricao_resc_w = 'S') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(450507, null);
		end if;
		
		if (coalesce(nr_seq_titular_ww::text, '') = '') then
			ie_tipo_rescisao_w	:= 'T';
		else
			ie_tipo_rescisao_w	:= 'B';
		end if;
		
		
		for r_c02_w in C02(nr_seq_segurado_p) loop
			begin
			nr_seq_motivo_conver_aux_w := pls_converter_motivo_can_tit(	nr_seq_motivo_p, nr_seq_motivo_conver_aux_w, nm_usuario_p);
			
			if (coalesce(nr_seq_motivo_conver_aux_w::text, '') = '') then
				nr_seq_motivo_conver_aux_w	:= nr_seq_motivo_p;
			end if;
			
			CALL pls_rescindir_segurado(	r_c02_w.nr_seq_dependente,
						dt_rescisao_p,
						dt_limite_utilizacao_p,
						nr_seq_motivo_conver_aux_w,
						ds_observacao_p,
						cd_estabelecimento_p,
						nm_usuario_p,
						coalesce(ie_tipo_rescisao_p, 'B'),
						'N',
						nr_seq_causa_rescisao_p,
						dt_fim_repasse_p);
			
			select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END
			into STRICT	ie_tipo_contrato_w
			from	pls_contrato	b,
				pls_segurado	a
			where	a.nr_sequencia	= r_c02_w.nr_seq_dependente
			and	a.nr_seq_contrato	= b.nr_sequencia;
			
			--Verificar se o motivo da rescisao permite gerar leads
			if (ie_gerar_lead_rescisao_w = 'S') then
				--Verificar se o parametro gera o lead automatico
				if	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'S') or
					(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'S')) then
					CALL pls_gerar_solicitacao_lead(	null,
									null,
									'T',
									'R',
									nm_usuario_p,
									cd_estabelecimento_p,
									r_c02_w.nr_seq_dependente);
				--Verificar se o parametro gera o lead conforme regra
				elsif	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'D') or
					(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'D')) then
					CALL pls_definir_geracao_lead_resc(	null,
									null,
									r_c02_w.nr_seq_dependente,
									ie_tipo_rescisao_w,
									ie_tipo_contrato_w,
									nr_seq_motivo_p,
									cd_perfil_w,
									cd_estabelecimento_p,
									nm_usuario_p);
				end if;
			end if;
			end;
		end loop; --C02
		
		if (ie_obito_w = 'S') then
			CALL pls_inserir_obito_pf(	cd_pessoa_fisica_w,
						dt_obito_p,
						nr_certidao_obito_p,
						nm_usuario_p,
						ie_certidao_obito_w);
		end if;
		
		CALL pls_rescindir_segurado(	nr_seq_segurado_p,
					dt_rescisao_p,
					dt_limite_utilizacao_p,
					nr_seq_motivo_p,
					ds_observacao_p,
					cd_estabelecimento_p,
					nm_usuario_p,
					coalesce(ie_tipo_rescisao_p, 'B'),
					ie_obito_w,
					nr_seq_causa_rescisao_p,
					dt_fim_repasse_p);
		
		select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_contrato_w
		from	pls_contrato	b,
			pls_segurado	a
		where	a.nr_sequencia	= nr_seq_segurado_p
		and	b.nr_sequencia	= a.nr_seq_contrato;
		
		--Verificar se o motivo da rescisao permite gerar leads
		if (ie_gerar_lead_rescisao_w = 'S') then
			--Verificar se o parametro gera o lead automatico
			if	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'S') or
				(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'S')) then
				CALL pls_gerar_solicitacao_lead(	null,
								null,
								'T',
								'R',
								nm_usuario_p,
								cd_estabelecimento_p,
								nr_seq_segurado_p);
			--Verificar se o parametro gera o lead conforme regra
			elsif	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'D') or
				(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'D')) then
				
				CALL pls_definir_geracao_lead_resc(	null,
								null,
								nr_seq_segurado_p,
								ie_tipo_rescisao_w,
								ie_tipo_contrato_w,
								nr_seq_motivo_p,
								cd_perfil_w,
								cd_estabelecimento_p,
								nm_usuario_p);
			end if;
		end if;
		
		--Gerar o seguro de obito para os dependentes
		if (ie_obito_w = 'S') then
			CALL pls_gerar_seg_beneficio_obito(	nr_seq_segurado_p,
							dt_rescisao_p,
							cd_estabelecimento_p,
							nm_usuario_p);
		end if;
		
		--Rescindir o pagador caso todos os beneficiarios do mesmo estao rescindidos
		select	count(*)
		into STRICT	qt_beneficiarios_w
		from	pls_segurado
		where	nr_seq_pagador	= nr_seq_pagador_w;
		
		select	count(*)
		into STRICT	qt_benef_inativos_w
		from	pls_segurado
		where	nr_seq_pagador	= nr_seq_pagador_w
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	(dt_rescisao IS NOT NULL AND dt_rescisao::text <> '');
		
		if (qt_beneficiarios_w > 0) and (qt_benef_inativos_w = qt_beneficiarios_w) then
			
			update	pls_contrato_pagador
			set	dt_rescisao			= dt_rescisao_p,
				nm_usuario			= nm_usuario_p,
				dt_atualizacao			= clock_timestamp(),
				nr_seq_motivo_cancelamento	= nr_seq_motivo_p
			where	nr_sequencia			= nr_seq_pagador_w;
			
			CALL pls_liquidar_titulos_rescisao(	nr_seq_pagador_w,
							dt_rescisao_p,
							cd_estabelecimento_p,
							nm_usuario_p);
		end if;
		
		--Recalcula o preco do SCA dos beneficiarios do contrato pela quantidade de vidas
		for r_c10_w in c10 loop
			begin
			for r_c11_w in C11(r_c10_w.nr_seq_segurado_sca) loop
				begin
				CALL pls_recalcular_preco_sca(r_c10_w.nr_seq_segurado_sca, 'C', cd_estabelecimento_p, clock_timestamp(), r_c11_w.nr_seq_vinculo_sca, nm_usuario_p);
				end;
			end loop; --C11
			end;
		end loop; --C10
		
		CALL pls_preco_beneficiario_pck.atualizar_preco_beneficiarios(nr_seq_segurado_p, null, null, null, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
	elsif (coalesce(nr_seq_pagador_p,0) <> 0) then
		select	max(a.nr_seq_regra_rescisao)
		into STRICT	nr_seq_regra_rescisao_w
		from	pls_notificacao_pagador a
		where	a.nr_sequencia	= nr_seq_notific_pag_p;
		
		if (nr_seq_regra_rescisao_w IS NOT NULL AND nr_seq_regra_rescisao_w::text <> '') then
			select	a.ie_regulamentacao_plano
			into STRICT	ie_regulamentacao_regra_w
			from	pls_regra_rescisao a
			where	a.nr_sequencia	= nr_seq_regra_rescisao_w;
		end if;
		
		for r_c04_w in C04 loop
			begin
			if (coalesce(ie_regulamentacao_regra_w::text, '') = '') or (ie_regulamentacao_regra_w = r_c04_w.ie_regulamentacao_plano) then
				CALL pls_rescindir_segurado(	r_c04_w.nr_seq_segurado,
							dt_rescisao_p,
							dt_limite_utilizacao_p,
							nr_seq_motivo_p,
							ds_observacao_p,
							cd_estabelecimento_p,
							nm_usuario_p,
							coalesce(ie_tipo_rescisao_p, 'P'),
							'N',
							nr_seq_causa_rescisao_p,
							dt_fim_repasse_p);
				
				update	pls_segurado
				set	nr_seq_notific_pagador	= nr_seq_notific_pag_p,
					dt_limite_utilizacao	= coalesce(dt_limite_utilizacao_p, dt_limite_utilizacao)
				where	nr_sequencia		= r_c04_w.nr_seq_segurado
				and	(dt_rescisao IS NOT NULL AND dt_rescisao::text <> '')
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			else
				update	pls_segurado
				set	dt_limite_utilizacao	= coalesce(dt_limite_utilizacao_p, dt_limite_utilizacao)
				where	nr_sequencia		= r_c04_w.nr_seq_segurado
				and	(dt_rescisao IS NOT NULL AND dt_rescisao::text <> '')
				and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			end if;
			end;
		end loop;
		
		update	pls_contrato_pagador a
		set	dt_rescisao			= dt_rescisao_p,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp(),
			nr_seq_motivo_cancelamento	= nr_seq_motivo_p
		where	nr_sequencia			= nr_seq_pagador_p
		and	not exists (SELECT	1
					from	pls_segurado x
					where	x.nr_seq_pagador	= a.nr_sequencia
					and	coalesce(x.dt_rescisao::text, '') = ''
					and	(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> ''));
		
		CALL pls_liquidar_titulos_rescisao(	nr_seq_pagador_p,
						dt_rescisao_p,
						cd_estabelecimento_p,
						nm_usuario_p);
		
		select 	nr_seq_contrato,
			cd_pessoa_fisica
		into STRICT	nr_seq_contrato_w,
			cd_pessoa_fisica_w
		from 	pls_contrato_pagador
		where	nr_sequencia	= nr_seq_pagador_p;
		
		CALL pls_gerar_devolucao_mens(null, nr_seq_pagador_p, 'P', nr_seq_motivo_p, 'N', nm_usuario_p, cd_estabelecimento_p);
		
		if (ie_obito_w = 'S') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
			CALL pls_inserir_obito_pf(	cd_pessoa_fisica_w,
						dt_obito_p,
						nr_certidao_obito_p,
						nm_usuario_p,
						ie_certidao_obito_w);
		end if;
		
		CALL pls_preco_beneficiario_pck.atualizar_preco_beneficiarios(null, nr_seq_contrato_w, null, nr_seq_pagador_p, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
		
		ds_mensagem_rescisao_pag_w :=	substr(	wheb_mensagem_pck.get_texto(1039983) || ' ' || wheb_mensagem_pck.get_texto(1039984, 'DS_MSG='||nr_seq_pagador_p) || chr(13) ||
							wheb_mensagem_pck.get_texto(1039986) || ': '|| wheb_mensagem_pck.get_texto(1039984, 'DS_MSG='||dt_rescisao_p) || chr(13) ||
							wheb_mensagem_pck.get_texto(1039987) || ': '|| wheb_mensagem_pck.get_texto(1039984, 'DS_MSG='||pls_obter_desc_causa_rescisao(nr_seq_causa_rescisao_p)) || chr(13) ||
							wheb_mensagem_pck.get_texto(1039991, 'DS_MOTIVO='||pls_obter_desc_motivo_padrao(nr_seq_motivo_p)) || chr(13) ||
							wheb_mensagem_pck.get_texto(1039992, 'DS_OBSERVACAO='||ds_observacao_p), 1, 4000);
		
		insert into pls_pagador_historico(	nr_sequencia,nr_seq_pagador,cd_estabelecimento,dt_atualizacao,nm_usuario,
				dt_atualizacao_nrec,nm_usuario_nrec,ds_historico,dt_historico,nm_usuario_historico,
				ds_titulo,ie_origem,ie_tipo_historico)
		values (	nextval('pls_pagador_historico_seq'),nr_seq_pagador_p,cd_estabelecimento_p,clock_timestamp(),nm_usuario_p,
				clock_timestamp(),nm_usuario_p,ds_mensagem_rescisao_pag_w,clock_timestamp(),nm_usuario_p,
				wheb_mensagem_pck.get_texto(296441),'GC','S');
	elsif (coalesce(nr_seq_subestipulante_p,0) <> 0) then
		for r_c05_w in C05 loop
			begin
			CALL pls_rescindir_segurado(	r_c05_w.nr_seq_segurado,
						dt_rescisao_p,
						dt_limite_utilizacao_p,
						nr_seq_motivo_p,
						ds_observacao_p,
						cd_estabelecimento_p,
						nm_usuario_p,
						coalesce(ie_tipo_rescisao_p, 'S'),
						'N',
						nr_seq_causa_rescisao_p,
						dt_fim_repasse_p);
			end;
		end loop; --C05
		
		update	pls_sub_estipulante
		set	dt_rescisao			= dt_rescisao_p,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp(),
			nr_seq_motivo_cancelamento	= nr_seq_motivo_p,
			dt_limite_utilizacao		= dt_limite_utilizacao_p
		where	nr_sequencia			= nr_seq_subestipulante_p;
		
		--Obter o contrato do pagador
		select	nr_seq_contrato
		into STRICT	nr_seq_contrato_w
		from	pls_sub_estipulante
		where	nr_sequencia	= nr_seq_subestipulante_p;
		
		CALL pls_preco_beneficiario_pck.atualizar_preco_beneficiarios(null, nr_seq_contrato_w, nr_seq_subestipulante_p, null, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
	end if;
	
	--Verificar se apos rescindir os beneficiarios vai ser rescindido o contrato tambem
	if (coalesce(nr_seq_contrato_w,0) > 0) then
		CALL pls_preco_beneficiario_pck.atualizar_desconto_benef(nr_seq_contrato_w, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
		
		select	count(*)
		into STRICT	qt_beneficiarios_w
		from	pls_segurado
		where	nr_seq_contrato	= nr_seq_contrato_w;
		
		select	count(*)
		into STRICT	qt_benef_inativos_w
		from	pls_segurado
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	(dt_rescisao IS NOT NULL AND dt_rescisao::text <> '');
		
		if (ie_rescindir_contrato_p = 'S') and (qt_beneficiarios_w > 0) and (qt_benef_inativos_w = qt_beneficiarios_w) then
			update	pls_contrato
			set	dt_rescisao_contrato	= dt_rescisao_p,
				ie_situacao		= '3',
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nr_seq_motivo_rescisao	= nr_seq_motivo_p,
				dt_limite_utilizacao	= dt_limite_utilizacao_p,
				nr_seq_causa_rescisao	= nr_seq_causa_rescisao_p
			where	nr_sequencia		= nr_seq_contrato_w;
			
			insert into pls_contrato_historico(nr_sequencia,
				cd_estabelecimento,
				nr_seq_contrato,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_historico,
				dt_atualizacao_nrec,
				ie_tipo_historico,
				ds_historico,
				ds_observacao)
			values (nextval('pls_contrato_historico_seq'),
				cd_estabelecimento_p,
				nr_seq_contrato_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				clock_timestamp(),
				'1',
				wheb_mensagem_pck.get_texto(1105347), --Contrato rescindido ao rescindir todos os beneficiarios ativos do contrato
				ds_observacao_p);
			
			select	count(*)
			into STRICT	qt_registros_w
			from	pls_contrato
			where	nr_contrato_principal	= nr_seq_contrato_w
			and	coalesce(dt_rescisao_contrato::text, '') = '';
			
			if (qt_registros_w > 0) and (ie_rescindir_subcontr_w = 'S') then
				for r_c07_w in C07 loop
					begin
					CALL pls_rescindir_segurado(	r_c07_w.nr_seq_segurado_contr_vinc,
								dt_rescisao_p,
								dt_limite_utilizacao_p,
								nr_seq_motivo_p,
								ds_observacao_p,
								cd_estabelecimento_p,
								nm_usuario_p,
								coalesce(ie_tipo_rescisao_p, 'C'),
								'N',
								nr_seq_causa_rescisao_p,
								dt_fim_repasse_p);
					end;
				end loop; --C07
				
				for r_c08_w in C08 loop
					begin
					update	pls_contrato
					set	dt_rescisao_contrato	= dt_rescisao_p,
						ie_situacao		= '3',
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						nr_seq_motivo_rescisao	= nr_seq_motivo_p,
						dt_limite_utilizacao	= dt_limite_utilizacao_p,
						nr_seq_causa_rescisao	= nr_seq_causa_rescisao_p
					where	nr_sequencia		= r_c08_w.nr_seq_contr_vinculado;
					
					update	pls_contrato_pagador
					set	dt_rescisao			= dt_rescisao_p,
						nm_usuario			= nm_usuario_p,
						dt_atualizacao			= clock_timestamp(),
						nr_seq_motivo_cancelamento	= nr_seq_motivo_p
					where	nr_seq_contrato			= r_c08_w.nr_seq_contr_vinculado;
					
					insert into pls_contrato_historico(nr_sequencia,
						cd_estabelecimento,
						nr_seq_contrato,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_historico,
						dt_atualizacao_nrec,
						ie_tipo_historico,
						ds_historico,
						ds_observacao)
					values (nextval('pls_contrato_historico_seq'),
						cd_estabelecimento_p,
						r_c08_w.nr_seq_contr_vinculado,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						clock_timestamp(),
						'1',
						wheb_mensagem_pck.get_texto(281115, 'DS_PERFIL_P=' || ds_perfil_w ||
										';DATA_P=' || to_char(clock_timestamp(),'dd/mm/rrrr')), -- Contrato rescindido com o perfil #@DS_PERFIL_P#@ em #@DATA_P#@, a partir do contrato principal
						ds_observacao_p);
					end;
				end loop; --C08
				
			end if;
		end if;
	end if;
	
	if (coalesce(nr_seq_contrato_w,coalesce(nr_seq_contrato_p,0)) > 0) then
		select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
			dt_rescisao_contrato
		into STRICT	ie_tipo_contrato_w,
			dt_rescisao_w
		from	pls_contrato
		where	nr_sequencia	= coalesce(nr_seq_contrato_w,nr_seq_contrato_p);
		
		--Verificar se o motivo da rescisao permite gerar leads
		if (ie_gerar_lead_rescisao_w = 'S') then
			--Verificar se o parametro gera o lead automatico
			if	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'S') or
				(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'S')) and (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
				CALL pls_gerar_solicitacao_lead(	coalesce(nr_seq_contrato_w,nr_seq_contrato_p),
								null,
								'T',
								'R',
								nm_usuario_p,
								cd_estabelecimento_p,
								null);
			--Verificar se o parametro gera o lead conforme regra
			elsif	((ie_tipo_contrato_w = 'PJ' AND ie_gerar_lead_pj_benef_w = 'D') or
				(ie_tipo_contrato_w = 'PF' AND ie_gerar_lead_pf_benef_w = 'D')) and (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
				CALL pls_definir_geracao_lead_resc(	nr_seq_contrato_p,
								null,
								null,
								'C',
								ie_tipo_contrato_w,
								nr_seq_motivo_p,
								cd_perfil_w,
								cd_estabelecimento_p,
								nm_usuario_p);
			end if;
		end if;
	end if;
	
	if (ie_gerar_devolucao_w = 'S') then
		for r_c12_w in c12 loop
			begin
			CALL pls_gerar_devolucao_mens(null, r_c12_w.nr_seq_pagador, 'C', nr_seq_motivo_p, 'N', nm_usuario_p, cd_estabelecimento_p);
			end;
		end loop;
	end if;
	
	if (nr_seq_rescisao_contr_p IS NOT NULL AND nr_seq_rescisao_contr_p::text <> '') then
		update	pls_rescisao_contrato
		set	ie_situacao 	= 'I',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_rescisao_contr_p;
	end if;
else
	ds_erro_p	:= ds_erro_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rescindir_contrato ( nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_pagador_p bigint, nr_seq_subestipulante_p bigint, nr_seq_rescisao_contr_p bigint, dt_rescisao_p timestamp, dt_limite_utilizacao_p timestamp, nr_seq_motivo_p bigint, ds_observacao_p text, cd_estabelecimento_p bigint, ie_consistir_sib_p text, nm_usuario_p text, nr_certidao_obito_p text, dt_obito_p timestamp, ie_rescindir_contrato_p text, nr_seq_causa_rescisao_p bigint, ds_erro_p INOUT text, nr_seq_notific_pag_p bigint, ie_att_dt_rescisao_p text, ie_tipo_rescisao_p text default null, dt_fim_repasse_p timestamp default null) FROM PUBLIC;

