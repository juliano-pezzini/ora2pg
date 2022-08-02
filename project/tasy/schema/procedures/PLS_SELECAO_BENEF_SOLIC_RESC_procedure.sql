-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_selecao_benef_solic_resc ( nr_seq_solicitacao_p bigint, ie_opcao_p text, nr_seq_segurado_p bigint, nr_seq_causa_rescisao_p bigint, nr_seq_motivo_rescisao_p bigint, nr_certidao_obito_p text, dt_obito_p timestamp, qt_meses_contribuicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*	ie_opcao_p
	1	Carregar os beneficiarios do contrato para selecao
	2	Atualizar selecao beneficiario
	3	Inserir os beneficiarios selecionados na solicitacao de rescisao
	4	Excluir beneficiario do lote
	5	Marcar / Desmarcar todos
*/
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;
dt_solicitacao_w	pls_solicitacao_rescisao.dt_solicitacao%type;
ie_tipo_contratacao_w	pls_solicitacao_rescisao.ie_tipo_contratacao%type;
qt_registro_w		integer;
ie_selecao_w		w_pls_selecao_benef_resc.ie_selecao%type;
ie_selecao_titular_w	w_pls_selecao_benef_resc.ie_selecao%type;
nr_seq_titular_w	pls_segurado.nr_seq_titular%type;
nr_seq_motivo_w		pls_motivo_cancelamento.nr_sequencia%type;
nr_seq_atendimento_w	pls_atendimento.nr_sequencia%type;
dt_obito_w		pls_solic_rescisao_benef.dt_obito%type;
nr_certidao_obito_w	pls_solic_rescisao_benef.nr_certidao_obito%type;
ie_titular_selecionado_w varchar(1);
ie_status_w		pls_solicitacao_rescisao.ie_status%type;
ie_impede_transf_tit_w	pls_restricao_solic_resc.ie_impede_transf_tit%type;
ie_impede_resc_dep_w	pls_restricao_solic_resc.ie_impede_resc_dep%type;
dt_rescisao_w		pls_segurado.dt_rescisao%type;
nr_seq_intercambio_w	pls_solicitacao_rescisao.nr_seq_intercambio%type;

C01 CURSOR(	nr_seq_contrato_pc	pls_contrato.nr_sequencia%type,
		nr_seq_titular_pc	pls_segurado.nr_sequencia%type,
		dt_solicitacao_pc	pls_solicitacao_rescisao.dt_solicitacao%type,
		nr_seq_intercambio_pc	pls_solicitacao_rescisao.nr_seq_intercambio%type) FOR
	SELECT	a.nr_sequencia nr_seq_segurado
	from	pls_segurado a
	where	a.nr_seq_contrato	= nr_seq_contrato_pc
	and (coalesce(nr_seq_titular_pc::text, '') = '' or a.nr_sequencia = nr_seq_titular_pc or a.nr_seq_titular = nr_seq_titular_pc)
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > dt_solicitacao_pc)
	and	pls_obter_se_benef_remido(a.nr_sequencia,dt_solicitacao_pc) = 'N'
	and     not exists ( 	SELECT 1
				from    pls_solic_rescisao_benef x,
					pls_solicitacao_rescisao  z
				where   x.nr_seq_solicitacao = z.nr_sequencia
				and     z.ie_status in ( 1 ,2)
				and     x.nr_seq_segurado = a.nr_sequencia )
	
union all
				
	select	a.nr_sequencia nr_seq_segurado
	from	pls_segurado a
	where	a.nr_seq_intercambio = nr_seq_intercambio_pc
	and (coalesce(nr_seq_titular_pc::text, '') = '' or a.nr_sequencia = nr_seq_titular_pc or a.nr_seq_titular = nr_seq_titular_pc)
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > dt_solicitacao_pc)
	and	pls_obter_se_benef_remido(a.nr_sequencia,dt_solicitacao_pc) = 'N'
	and     not exists ( 	select 1
				from    pls_solic_rescisao_benef x,
					pls_solicitacao_rescisao  z
				where   x.nr_seq_solicitacao = z.nr_sequencia
				and     z.ie_status in ( 1 ,2)
				and     x.nr_seq_segurado = a.nr_sequencia );

C02 CURSOR FOR
	SELECT	a.nr_seq_segurado,
		b.nr_seq_titular
	from	w_pls_selecao_benef_resc a,
		pls_segurado b
	where	b.nr_sequencia		= a.nr_seq_segurado
	and	a.nr_seq_solicitacao	= nr_seq_solicitacao_p
	and	a.nm_usuario		= nm_usuario_p
	and	a.ie_selecao		= 'S'
	order by coalesce(b.nr_seq_titular,b.nr_sequencia),
		coalesce(b.nr_seq_titular,0);

C03 CURSOR FOR
	SELECT	coalesce(ie_impede_transf_tit,'N'),
		coalesce(ie_impede_resc_dep,'N')
	from	pls_restricao_solic_resc
	where (ie_tipo_contratacao = ie_tipo_contratacao_w or coalesce(ie_tipo_contratacao::text, '') = '')
	order by coalesce(ie_tipo_contratacao,' ');

BEGIN
select	nr_seq_contrato,
	dt_solicitacao,
	ie_tipo_contratacao,
	nr_seq_atendimento,
	ie_status,
	nr_seq_intercambio
into STRICT	nr_seq_contrato_w,
	dt_solicitacao_w,
	ie_tipo_contratacao_w,
	nr_seq_atendimento_w,
	ie_status_w,
	nr_seq_intercambio_w
from	pls_solicitacao_rescisao
where	nr_sequencia	= nr_seq_solicitacao_p;

if (ie_opcao_p = '1') then --Carregar os beneficiarios do contrato para selecao
	delete	from	w_pls_selecao_benef_resc
	where	nr_seq_solicitacao	= nr_seq_solicitacao_p
	and	nm_usuario		= nm_usuario_p;
	
	delete	from	w_pls_selecao_benef_resc
	where	dt_atualizacao < clock_timestamp() - interval '1 days';
	
	begin
	select	coalesce(b.nr_seq_titular,b.nr_sequencia)
	into STRICT	nr_seq_titular_w
	from	pls_atendimento	a,
		pls_segurado	b
	where	b.nr_sequencia	= a.nr_seq_segurado
	and	a.nr_sequencia	= nr_seq_atendimento_w;
	exception
	when others then
		nr_seq_titular_w	:= null;
	end;
	
	for r_c01_w in C01(nr_seq_contrato_w,nr_seq_titular_w,fim_dia(dt_solicitacao_w),nr_seq_intercambio_w) loop
		begin
		insert	into	w_pls_selecao_benef_resc(	nr_seq_segurado, nr_seq_solicitacao,
				nm_usuario, dt_atualizacao, ie_selecao)
			values (	r_c01_w.nr_seq_segurado, nr_seq_solicitacao_p,
				nm_usuario_p, clock_timestamp(), 'N');
		end;
	end loop;
elsif (ie_opcao_p in ('2','4')) then --2-Atualizar selecao beneficiario e 4-Excluir beneficiario do lote
	ie_impede_transf_tit_w	:= 'N';
	ie_impede_resc_dep_w	:= 'N';
	open C03;
	loop
	fetch C03 into
		ie_impede_transf_tit_w,
		ie_impede_resc_dep_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
	end loop;
	close C03;
	
	if (ie_opcao_p = '2') then --Atualizar selecao beneficiario
		select	CASE WHEN a.ie_selecao='N' THEN 'S'  ELSE 'N' END ,
			b.nr_seq_titular
		into STRICT	ie_selecao_w,
			nr_seq_titular_w
		from	w_pls_selecao_benef_resc a,
			pls_segurado b
		where	b.nr_sequencia	= a.nr_seq_segurado
		and	a.nr_seq_solicitacao = nr_seq_solicitacao_p
		and	a.nr_seq_segurado	= nr_seq_segurado_p
		and	a.nm_usuario	= nm_usuario_p;
		
		update	w_pls_selecao_benef_resc
		set	ie_selecao	= ie_selecao_w
		where	nr_seq_solicitacao = nr_seq_solicitacao_p
		and	nr_seq_segurado	= nr_seq_segurado_p
		and	nm_usuario	= nm_usuario_p;
		
		if (coalesce(nr_seq_titular_w::text, '') = '') then
			update	w_pls_selecao_benef_resc a
			set	a.ie_selecao	= ie_selecao_w
			where	nr_seq_solicitacao = nr_seq_solicitacao_p
			and	nm_usuario	= nm_usuario_p
			and	exists (	SELECT	1
					from	pls_segurado x
					where	x.nr_sequencia = a.nr_seq_segurado
					and	x.nr_seq_titular = nr_seq_segurado_p);
		else
			select	max(ie_selecao)
			into STRICT	ie_selecao_titular_w
			from	w_pls_selecao_benef_resc
			where	nr_seq_solicitacao = nr_seq_solicitacao_p
			and	nr_seq_segurado = nr_seq_titular_w
			and	nm_usuario = nm_usuario_p;
			
			if (ie_selecao_w = 'N') then --Demarcando um dependente
				if (ie_selecao_titular_w = 'S') and (ie_impede_transf_tit_w = 'S') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(763938,'nm_beneficiario='||pls_obter_dados_segurado(nr_seq_titular_w,'N')); --E necessario desmarcar o titular #@NM_BENEFICIARIO#@!
				end if;
			elsif (ie_selecao_w = 'S') then --Selecionando um dependente
				if (ie_selecao_titular_w = 'N') and (ie_impede_resc_dep_w = 'S') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(784613,'nm_beneficiario='||pls_obter_dados_segurado(nr_seq_titular_w,'N')); --Nao e possivel rescindir somente o dependente. Sera necessario rescindir o titular #@NM_BENEFICIARIO#@!
				end if;
			end if;
		end if;
	elsif (ie_opcao_p = '4') then --Excluir beneficiario do lote
		select	max(b.nr_seq_titular),
			max(b.dt_rescisao)
		into STRICT	nr_seq_titular_w,
			dt_rescisao_w
		from	pls_solic_rescisao_benef a,
			pls_segurado b
		where	b.nr_sequencia	= a.nr_seq_segurado
		and	a.nr_seq_solicitacao	= nr_seq_solicitacao_p
		and	a.nr_seq_segurado	= nr_seq_segurado_p;
		if (coalesce(dt_rescisao_w::text, '') = '') then
			if (coalesce(nr_seq_titular_w::text, '') = '') then --Exclusao de titular
				if (ie_impede_resc_dep_w = 'S') then
					select	count(1)
					into STRICT	qt_registro_w
					from	pls_solic_rescisao_benef a,
						pls_segurado b
					where	b.nr_sequencia		= a.nr_seq_segurado
					and	b.nr_seq_titular	= nr_seq_segurado_p
					and	a.nr_seq_solicitacao	= nr_seq_solicitacao_p;
				
					if (qt_registro_w > 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(784699); --E necessario excluir os dependentes para realizar a exclusao do titular
					end if;
				end if;
			else --Exclusao de dependente
				if (ie_impede_transf_tit_w = 'S') then
					select	count(1)
					into STRICT	qt_registro_w
					from	pls_solic_rescisao_benef
					where	nr_seq_segurado	= nr_seq_titular_w
					and	nr_seq_solicitacao = nr_seq_solicitacao_p;
				
					if (qt_registro_w > 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(763941,'nm_beneficiario='||pls_obter_dados_segurado(nr_seq_titular_w,'N')); --E necessario excluir o titular #@NM_BENEFICIARIO#@!
					end if;
				end if;
			end if;
		end if;

		delete	from	pls_solic_rescisao_benef
		where	nr_seq_solicitacao	= nr_seq_solicitacao_p
		and	nr_seq_segurado		= nr_seq_segurado_p;
		
		if (ie_status_w = '2') then --Se a solicitacao da rescisao estiver liberada e o beneficiario for excluido deve gerar log
			insert	into	pls_solicitacao_resc_hist(	nr_sequencia, nr_seq_solicitacao, dt_liberacao,
					nm_usuario, nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
					ds_titulo, ds_historico)
				values (	nextval('pls_solicitacao_resc_hist_seq'), nr_seq_solicitacao_p, clock_timestamp(),
					nm_usuario_p, nm_usuario_p, clock_timestamp(), clock_timestamp(),
					wheb_mensagem_pck.get_texto(1121850), wheb_mensagem_pck.get_texto(1121849) || ': ' || nr_seq_segurado_p || ' - '|| pls_obter_dados_segurado(nr_seq_segurado_p, 'N'));
		end if;
	end if;
elsif (ie_opcao_p = '3') then --Inserir os beneficiarios selecionados na solicitacao de rescisao
	for r_c02_w in C02 loop
		begin
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_solic_rescisao_benef
		where	nr_seq_solicitacao	= nr_seq_solicitacao_p
		and	nr_seq_segurado		= r_c02_w.nr_seq_segurado;
		
		if (qt_registro_w = 0) then
			dt_obito_w		:= null;
			nr_certidao_obito_w	:= null;
			nr_seq_motivo_w		:= null;
			if (r_c02_w.nr_seq_titular IS NOT NULL AND r_c02_w.nr_seq_titular::text <> '') then
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_titular_selecionado_w
				from	w_pls_selecao_benef_resc a
				where	a.nr_seq_segurado	= r_c02_w.nr_seq_titular
				and	a.nr_seq_solicitacao	= nr_seq_solicitacao_p
				and	a.nm_usuario		= nm_usuario_p
				and	a.ie_selecao		= 'S';
				
				if (ie_titular_selecionado_w = 'S') then
					nr_seq_motivo_w := pls_converter_motivo_can_tit(nr_seq_motivo_rescisao_p, nr_seq_motivo_w, nm_usuario_p);
				end if;
			end if;
			nr_seq_motivo_w	:= coalesce(nr_seq_motivo_w,nr_seq_motivo_rescisao_p);
			
			if (pls_obter_motivo_obito(nr_seq_motivo_w) = 'S') then
				dt_obito_w		:= dt_obito_p;
				nr_certidao_obito_w	:= nr_certidao_obito_p;
			end if;
			
			--Se o beneficiario esiver selecionado como novo titular, deve limpar pois sera rescindido entao nao pode ser o novo titular
			update	pls_solic_rescisao_benef
			set	nr_seq_novo_titular	 = NULL
			where	nr_seq_novo_titular	= r_c02_w.nr_seq_segurado
			and	nr_seq_solicitacao	= nr_seq_solicitacao_p;
			
			insert	into	pls_solic_rescisao_benef(	nr_sequencia, nr_seq_solicitacao, nr_seq_segurado,
					dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
					nr_seq_causa_rescisao, nr_seq_motivo_rescisao, ie_titularidade,
					dt_obito, nr_certidao_obito, qt_meses_contribuicao)
				values (	nextval('pls_solic_rescisao_benef_seq'), nr_seq_solicitacao_p, r_c02_w.nr_seq_segurado,
					clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
					nr_seq_causa_rescisao_p, nr_seq_motivo_w, CASE WHEN coalesce(r_c02_w.nr_seq_titular::text, '') = '' THEN 'T'  ELSE 'D' END ,
					dt_obito_w, nr_certidao_obito_w, qt_meses_contribuicao_p);
		end if;
		end;
	end loop;
elsif (ie_opcao_p = '5') then --Marcar / Desmarcar todos
	select	CASE WHEN max(ie_selecao)='N' THEN 'S'  ELSE 'N' END
	into STRICT	ie_selecao_w
	from	w_pls_selecao_benef_resc
	where	nr_seq_solicitacao = nr_seq_solicitacao_p
	and	nm_usuario	= nm_usuario_p;
	
	update	w_pls_selecao_benef_resc
	set	ie_selecao	= ie_selecao_w
	where	nr_seq_solicitacao = nr_seq_solicitacao_p
	and	nm_usuario	= nm_usuario_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_selecao_benef_solic_resc ( nr_seq_solicitacao_p bigint, ie_opcao_p text, nr_seq_segurado_p bigint, nr_seq_causa_rescisao_p bigint, nr_seq_motivo_rescisao_p bigint, nr_certidao_obito_p text, dt_obito_p timestamp, qt_meses_contribuicao_p bigint, nm_usuario_p text) FROM PUBLIC;

