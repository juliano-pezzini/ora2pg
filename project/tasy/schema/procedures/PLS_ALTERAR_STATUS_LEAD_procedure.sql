-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_status_lead ( nr_seq_solicitacao_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, ie_acao_p text, nr_seq_motivo_p text, ds_lista_atividade_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

/*
ie_acao_p
	'A' = Aprovar lead
	'R' = Reprovar lead
	'T' = Reativar lead
*/
nr_seq_canal_venda_w		bigint;
nr_seq_cliente_w		bigint;
nr_seq_canal_ativo_w		bigint;
ie_tipo_vendedor_w		varchar(2);
qt_dias_efetivacao_w		integer;
nr_seq_com_empresa_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_segurado_indic_w		bigint;
ds_historico_w			varchar(400)	:= '';
nm_completo_usuario_w		varchar(100);
ie_tipo_atividade_w		bigint;
cd_pf_vinculado_w		varchar(10);
cd_cnpj_vinculado_w		varchar(14);
qt_registros_w			bigint;
nr_seq_classificacao_w		bigint;
dt_atividade_canal_w		timestamp;
qt_dias_atividade_canal_w	bigint;
qt_vidas_w			bigint;
dt_aprovacao_w			timestamp;
cd_pessoa_indicacao_w		varchar(255);
nr_seq_tipo_logradouro_w	bigint;
nr_seq_vendedor_aux_w		bigint;
ie_origem_solicitacao_w		varchar(2);
nm_contato_w			varchar(120);
nr_contrato_existente_w		bigint;
nr_seq_contrato_existente_w	bigint;
nr_seq_agente_motivador_w	bigint;
nr_seq_origem_agente_w		bigint;
qt_prospect_lead_w		integer;
ie_tipo_contratacao_w		pls_plano.ie_tipo_contratacao%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_solicitacao_vendedor
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p
	and	coalesce(dt_fim_vigencia::text, '') = '';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_comercial_empresa
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p;

C03 CURSOR FOR
	SELECT	max(coalesce(qt_dias_efetivacao,0))
	from	pls_solicitacao_regra_vend
	where	ie_tipo_canal_venda	= ie_tipo_vendedor_w
	and	((coalesce(nr_seq_classificacao,nr_seq_classificacao_w) = nr_seq_classificacao_w and (nr_seq_classificacao IS NOT NULL AND nr_seq_classificacao::text <> '')) or coalesce(nr_seq_classificacao::text, '') = '')
	and	((coalesce(ie_tipo_contratacao,ie_tipo_contratacao_w) = ie_tipo_contratacao_w and (ie_tipo_contratacao IS NOT NULL AND ie_tipo_contratacao::text <> '')) or coalesce(ie_tipo_contratacao::text, '') = '')
	and (ie_aplicacao_regra = 'P' or ie_aplicacao_regra = 'A')
	and	ie_situacao		= 'A'
	and	((qt_vidas_w between coalesce(qt_vidas,0) and coalesce(qt_vidas_final,qt_vidas_w) and (qt_vidas_w IS NOT NULL AND qt_vidas_w::text <> '')) or (coalesce(qt_vidas_w::text, '') = ''))
	order by ie_tipo_contratacao,coalesce(qt_vidas,0);

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_solic_vendedor_compl
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p;

C05 CURSOR FOR
	SELECT	qt_dias_ativ_canal_com
	from	(SELECT	qt_dias_ativ_canal_com,
			ie_origem_solicitacao,
			ie_tipo_contratacao
		from	pls_comercial_regra_acao
		where	nr_seq_solicitacao	= nr_seq_solicitacao_p
		and	ie_situacao		= 'A'
		
union all

		select	qt_dias_ativ_canal_com,
			ie_origem_solicitacao,
			ie_tipo_contratacao
		from	pls_comercial_regra_acao
		where	coalesce(nr_seq_solicitacao::text, '') = ''
		and	coalesce(nr_seq_cliente::text, '') = ''
		and	not exists (	select	1
					from	pls_comercial_regra_acao
					where	nr_seq_solicitacao	= nr_seq_solicitacao_p
					and	ie_situacao		= 'A')
		and	((ie_aplicacao_comercial = 'P') or (ie_aplicacao_comercial = 'T'))
		and	ie_situacao		= 'A'
		and	((ie_origem_solicitacao = ie_origem_solicitacao_w) or (coalesce(ie_origem_solicitacao::text, '') = ''))
		and	((ie_tipo_contratacao = ie_tipo_contratacao_w) or (coalesce(ie_tipo_contratacao::text, '') = ''))) alias14
	order by coalesce(ie_origem_solicitacao,' '),
		coalesce(ie_tipo_contratacao, ' ');


BEGIN

select	coalesce(ie_origem_solicitacao,'E'),
	coalesce(ie_tipo_contratacao,'I')
into STRICT	ie_origem_solicitacao_w,
	ie_tipo_contratacao_w
from	pls_solicitacao_comercial
where	nr_sequencia = nr_seq_solicitacao_p;

open C05;
loop
fetch C05 into
	qt_dias_atividade_canal_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
end loop;
close C05;

if (qt_dias_atividade_canal_w IS NOT NULL AND qt_dias_atividade_canal_w::text <> '') then
	dt_atividade_canal_w	:= clock_timestamp()  + qt_dias_atividade_canal_w;
else
	dt_atividade_canal_w	:= null;
end if;

select	substr(Obter_Nome_Usuario(nm_usuario_p),1,255)
into STRICT	nm_completo_usuario_w
;

select	max(nr_sequencia) cd
into STRICT	ie_tipo_atividade_w
from	pls_tipo_atividade
where	ie_situacao		= 'A'
and	ie_status		= 'S'
and	cd_estabelecimento	= cd_estabelecimento_p;

if (coalesce(ie_tipo_atividade_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 184077, null);
end if;

if (ie_acao_p	= 'A') then
	select	nr_seq_segurado,
		nr_seq_contrato,
		nr_seq_segurado_indic,
		cd_pf_vinculado,
		cd_cnpj_vinculado,
		nr_seq_classificacao,
		cd_pessoa_indicacao,
		nr_seq_tipo_logradouro,
		nm_contato,
		nr_contrato_existente,
		nr_seq_contrato_existente,
		nr_seq_agente_motivador,
		nr_seq_origem_agente
	into STRICT	nr_seq_segurado_w,
		nr_seq_contrato_w,
		nr_seq_segurado_indic_w,
		cd_pf_vinculado_w,
		cd_cnpj_vinculado_w,
		nr_seq_classificacao_w,
		cd_pessoa_indicacao_w,
		nr_seq_tipo_logradouro_w,
		nm_contato_w,
		nr_contrato_existente_w,
		nr_seq_contrato_existente_w,
		nr_seq_agente_motivador_w,
		nr_seq_origem_agente_w
	from	pls_solicitacao_comercial
	where	nr_sequencia	= nr_seq_solicitacao_p;

	if (coalesce(cd_pf_vinculado_w,'0') <> '0') then
		select	count(*)
		into STRICT	qt_registros_w
		from	pls_comercial_cliente
		where (cd_pessoa_fisica	= cd_pf_vinculado_w and coalesce(cd_pf_vinculado_w,'0') <> '0')
		and	ie_status	not in ('C','N');
	elsif (coalesce(cd_cnpj_vinculado_w,'0') <> '0') then
		select	count(*)
		into STRICT	qt_registros_w
		from	pls_comercial_cliente
		where (cd_cgc	= cd_cnpj_vinculado_w and coalesce(cd_cnpj_vinculado_w,'0') <> '0')
		and	ie_status	not in ('C','N');
	end if;

	if (qt_registros_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 184080, null);
		/* Existe prospecção em aberto para está pessoa. Verifique. */

	end if;

	--aaschlote 07/04/2011 - Parâmetro[36] - Tipo de consistência ao aprovar solicitação de lead/prospect sem simulação de preço vinculada
	CALL pls_consistir_simul_comercial(nr_seq_solicitacao_p,'S',cd_estabelecimento_p,nm_usuario_p);

	update	pls_solicitacao_comercial
	set	ie_status	= 'A',
		dt_aprovacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_solicitacao_p;

	ds_historico_w := 'Solicitação de lead aprovada pelo usuário '||nm_completo_usuario_w||' no dia '||clock_timestamp()||'.';

	select	nextval('pls_comercial_cliente_seq')
	into STRICT	nr_seq_cliente_w
	;

	insert	into	pls_comercial_cliente(	nr_sequencia,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			cd_cgc,
			ie_classificacao,
			nr_seq_solicitacao,
			dt_aprovacao,
			ie_fase_venda,
			ie_status,
			ie_origem_cliente,
			nr_seq_segurado,
			nr_seq_contrato,
			nr_seq_segurado_indic,
			nr_seq_classificacao,
			dt_atividade_canal,
			cd_pessoa_indicacao,
			nr_seq_tipo_logradouro,
			nm_contato,
			nr_contrato_existente,
			nr_seq_contrato_existente,
			nr_seq_agente_motivador,
			nr_seq_origem_agente)
		values (	nr_seq_cliente_w,
			cd_estabelecimento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_p,
			cd_cgc_p,
			'L',
			nr_seq_solicitacao_p,
			clock_timestamp(),
			'A',
			'A',
			'S',
			nr_seq_segurado_w,
			nr_seq_contrato_w,
			nr_seq_segurado_indic_w,
			nr_seq_classificacao_w,
			dt_atividade_canal_w,
			cd_pessoa_indicacao_w,
			nr_seq_tipo_logradouro_w,
			nm_contato_w,
			nr_contrato_existente_w,
			nr_seq_contrato_existente_w,
			nr_seq_agente_motivador_w,
			nr_seq_origem_agente_w);

	select	max(nr_sequencia)
	into STRICT	nr_seq_canal_ativo_w
	from	pls_solicitacao_vendedor
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p
	and	coalesce(dt_fim_vigencia::text, '') = '';

	select	max(coalesce(a.qt_funcionarios, 0))
	into STRICT	qt_vidas_w
	from	pls_solicitacao_vendedor	c,
		pls_comercial_cliente		b,
		pls_solicitacao_comercial	a
	where	b.nr_seq_solicitacao = a.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_cliente
	and	a.nr_sequencia = nr_seq_solicitacao_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_canal_venda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_seq_canal_venda_w = nr_seq_canal_ativo_w) then
			select	CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END
			into STRICT	ie_tipo_vendedor_w
			from	pls_vendedor a,
				pls_solicitacao_vendedor b
			where	a.nr_sequencia	= b.nr_seq_vendedor_canal
			and	b.nr_sequencia	= nr_seq_canal_venda_w;

			open C03;
			loop
			fetch C03 into
				qt_dias_efetivacao_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				qt_dias_efetivacao_w	:= qt_dias_efetivacao_w;
				end;
			end loop;
			close C03;

			if (qt_dias_efetivacao_w <> 0) then
				select	max(a.dt_aprovacao)
				into STRICT	dt_aprovacao_w
				from	pls_solicitacao_vendedor	c,
					pls_comercial_cliente		b,
					pls_solicitacao_comercial	a
				where	b.nr_seq_solicitacao = a.nr_sequencia
				and	b.nr_sequencia = c.nr_seq_cliente
				and	a.nr_sequencia	= nr_seq_solicitacao_p;

				if (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') then
					update	pls_solicitacao_vendedor
					set	dt_inicio_vigencia = dt_aprovacao_w
					where	nr_seq_solicitacao	= nr_seq_solicitacao_p;
				else
					update	pls_solicitacao_vendedor
					set	dt_inicio_vigencia = clock_timestamp()
					where	nr_seq_solicitacao	= nr_seq_solicitacao_p;

					dt_aprovacao_w := clock_timestamp();
				end if;
			end if;
		else
			qt_dias_efetivacao_w := null;
		end if;

		insert	into	pls_solicitacao_vendedor(	nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_vendedor_canal,
				nr_seq_vendedor_vinculado,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				nr_seq_cliente,
				qt_dias_efetivacao)
			(SELECT	nextval('pls_solicitacao_vendedor_seq'),
				cd_estabelecimento_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_vendedor_canal,
				nr_seq_vendedor_vinculado,
				dt_aprovacao_w,
				dt_fim_vigencia,
				nr_seq_cliente_w,
				qt_dias_efetivacao_w
			from	pls_solicitacao_vendedor
			where	nr_sequencia	= nr_seq_canal_venda_w);
		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_com_empresa_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert	into	pls_comercial_empresa(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cliente,
				cd_empresa_ref,
				nr_seq_empresa_serv,
				ds_observacao)
			(SELECT	nextval('pls_comercial_empresa_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cliente_w,
				cd_empresa_ref,
				nr_seq_empresa_serv,
				ds_observacao
			from	pls_comercial_empresa
			where	nr_sequencia	= nr_seq_com_empresa_w);
		end;
	end loop;
	close C02;

	open C04;
	loop
	fetch C04 into
		nr_seq_vendedor_aux_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		insert	into	pls_solic_vendedor_compl(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cliente,
				nr_seq_vendedor_canal,
				nr_seq_vendedor_vinculado,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				cd_estabelecimento)
			(SELECT	nextval('pls_solic_vendedor_compl_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_cliente_w,
				nr_seq_vendedor_canal,
				nr_seq_vendedor_vinculado,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				cd_estabelecimento
			from	pls_solic_vendedor_compl
			where	nr_sequencia	= nr_seq_vendedor_aux_w);
		end;
	end loop;
	close C04;
elsif (ie_acao_p	= 'R') then
	select	count(1)
	into STRICT	qt_prospect_lead_w
	from	pls_comercial_cliente
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p;

	if (qt_prospect_lead_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 284283, null ); /* Não é possível reprovar o lead selecionado, pois já existe prospecção gerada para o mesmo. */
	end if;

	update	pls_solicitacao_comercial
	set	ie_status	= 'R',
		nr_seq_motivo_reprovacao = nr_seq_motivo_p,
		dt_reprovacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_solicitacao_p;

	ds_historico_w := 'Solicitação de lead reprovada pelo usuário '||nm_completo_usuario_w||' no dia '||clock_timestamp()||'.';

elsif (ie_acao_p	= 'T') then
	update	pls_solicitacao_comercial
	set	ie_status	= 'PE',
		nr_seq_motivo_reprovacao  = NULL,
		dt_reprovacao	 = NULL,
		ie_etapa_solicitacao	= 'C'
	where	nr_sequencia	= nr_seq_solicitacao_p;

	ds_historico_w := 'Solicitação de lead reativada pelo usuário '||nm_completo_usuario_w||' no dia '||clock_timestamp()||'.';
end if;

if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then

	insert	into	pls_solicitacao_historico(	nr_sequencia, nr_seq_solicitacao, ie_tipo_atividade,
			dt_historico, nm_usuario_historico, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ds_historico, dt_liberacao, nm_usuario_liberacao)
	values (	nextval('pls_solicitacao_historico_seq'), nr_seq_solicitacao_p, ie_tipo_atividade_w,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			ds_historico_w, clock_timestamp(), nm_usuario_p);
end if;

CALL pls_atualiza_etapa_solicitacao(nr_seq_solicitacao_p, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_status_lead ( nr_seq_solicitacao_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, ie_acao_p text, nr_seq_motivo_p text, ds_lista_atividade_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
