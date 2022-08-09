-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_camara_contest (nr_seq_camara_contest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


nr_fatura_w			ptu_fatura.nr_fatura%type;
nr_seq_ptu_fatura_w		bigint;
nr_seq_pls_fatura_w		bigint;
nr_seq_lote_contest_w		bigint;
nr_seq_camara_contest_w		bigint;
nr_seq_lote_disc_w		bigint;
qt_registro_w			bigint := 0;
cd_unimed_w			varchar(10);
cd_unimed_operadora_w		varchar(10);
ie_operacao_w			varchar(1) := 'E';
nr_nota_credito_debito_a500_w	varchar(30);
nr_nota_cred_deb_number_w	numeric(30);
ie_tipo_arquivo_w		ptu_camara_contestacao.ie_tipo_arquivo%type;
ie_novo_imp_a550_w		pls_visible_false.ie_novo_imp_a550%type;
ds_erro_w			ptu_processo_camara_cont.ds_erro%type;
nr_seq_log_w			ptu_processo_camara_cont.nr_sequencia%type;
ie_status_processo_w		ptu_processo_camara_cont.ie_status_processo%type := 'FI'; -- Finalizada importação (sem erros)
					

BEGIN
select	coalesce(max(ie_novo_imp_a550),'N')
into STRICT	ie_novo_imp_a550_w
from	pls_visible_false
where	cd_estabelecimento = cd_estabelecimento_p;

select	max(a.nr_fatura),
	max(a.cd_unimed_destino),
	max(a.nr_nota_credito_debito_a500),
	max((	select	max(x.nr_sequencia)
		from	ptu_processo_camara_cont x
		where	x.nr_seq_camara_contest = a.nr_sequencia
		and	x.ie_tipo_processo	= 'IA')) nr_seq_log
into STRICT	nr_fatura_w,
	cd_unimed_w,
	nr_nota_credito_debito_a500_w,
	nr_seq_log_w
from	ptu_camara_contestacao a
where	a.nr_sequencia	= nr_seq_camara_contest_p;

if (nr_seq_log_w IS NOT NULL AND nr_seq_log_w::text <> '') then
	select	coalesce(max(ie_status_processo),'FI')
	into STRICT	ie_status_processo_w
	from	ptu_processo_camara_cont
	where	nr_sequencia	= nr_seq_log_w;
end if;

if (ie_status_processo_w = 'FI') then -- Se a importação do arquivo foi finalizada (sem erros)
	nr_nota_cred_deb_number_w := somente_numero(nr_nota_credito_debito_a500_w);
	cd_unimed_operadora_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);

	if (lpad(cd_unimed_operadora_w,4,'0') = lpad(cd_unimed_w,4,'0')) then
		ie_operacao_w := 'R'; -- Faturamento
	else
		ie_operacao_w := 'E'; -- Pagamento
	end if;

	-- OBTER CONTESTAÇÃO DE PAGAMENTO
	if (coalesce(nr_fatura_w,'0') <> '0') and (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso) e Fatura
		select	max(nr_seq_lote_contest),
			max(nr_sequencia),
			max(ie_tipo_arquivo)
		into STRICT	nr_seq_lote_contest_w,
			nr_seq_camara_contest_w,
			ie_tipo_arquivo_w
		from	ptu_camara_contestacao
		where	nr_fatura			= nr_fatura_w
		and	nr_nota_credito_debito_a500	= nr_nota_credito_debito_a500_w
		and	nr_sequencia			= nr_seq_camara_contest_p
		and	ie_operacao			= ie_operacao_w
		and	(nr_seq_lote_contest IS NOT NULL AND nr_seq_lote_contest::text <> '');
		
	elsif (coalesce(nr_fatura_w,'0') <> '0') then -- Fatura
		select	max(nr_seq_lote_contest),
			max(nr_sequencia),
			max(ie_tipo_arquivo)
		into STRICT	nr_seq_lote_contest_w,
			nr_seq_camara_contest_w,
			ie_tipo_arquivo_w
		from	ptu_camara_contestacao
		where	nr_fatura			= nr_fatura_w
		and	nr_sequencia			= nr_seq_camara_contest_p
		and	ie_operacao			= ie_operacao_w
		and	(nr_seq_lote_contest IS NOT NULL AND nr_seq_lote_contest::text <> '');

	elsif (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso)
		select	max(nr_seq_lote_contest),
			max(nr_sequencia),
			max(ie_tipo_arquivo)
		into STRICT	nr_seq_lote_contest_w,
			nr_seq_camara_contest_w,
			ie_tipo_arquivo_w
		from	ptu_camara_contestacao
		where	nr_nota_credito_debito_a500	= nr_nota_credito_debito_a500_w
		and	nr_sequencia			= nr_seq_camara_contest_p
		and	ie_operacao			= ie_operacao_w
		and	(nr_seq_lote_contest IS NOT NULL AND nr_seq_lote_contest::text <> '');
	end if;

	-- FATURA DE PAGAMENTO
	if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') and (ie_operacao_w = 'E') then
		if (coalesce(nr_fatura_w,'0') <> '0') and (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso) e Fatura
			select	max(nr_sequencia)
			into STRICT	nr_seq_ptu_fatura_w
			from	ptu_fatura
			where	nr_fatura	 		= nr_fatura_w
			and	nr_nota_credito_debito		= nr_nota_credito_debito_a500_w
			and	(cd_unimed_origem)::numeric  	= cd_unimed_w;
			
		elsif (coalesce(nr_fatura_w,'0') <> '0') then -- Fatura
			select	max(nr_sequencia)
			into STRICT	nr_seq_ptu_fatura_w
			from	ptu_fatura
			where	nr_fatura	 		= nr_fatura_w
			and	(cd_unimed_origem)::numeric  	= cd_unimed_w;
			
		elsif (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso)
			select	max(nr_sequencia)
			into STRICT	nr_seq_ptu_fatura_w
			from	ptu_fatura
			where	nr_nota_credito_debito		= nr_nota_credito_debito_a500_w
			and	(cd_unimed_origem)::numeric  	= cd_unimed_w;
		end if;
		
		if (coalesce(nr_seq_ptu_fatura_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(717837); -- Fatura originada da função OPS - Contas de Intercâmbio (A500) não localizada.
		end if;
	end if;

	ds_erro_w := null;
	if (nr_fatura_w IS NOT NULL AND nr_fatura_w::text <> '') or (coalesce(nr_nota_cred_deb_number_w,0) > 0) then
		
		if (ie_novo_imp_a550_w = 'S') then -- Incio da geração do lote de discussão
			pls_gerar_log_imp_a550( nr_seq_camara_contest_p, 'GD', 'PR', nm_usuario_p, clock_timestamp(), null, ds_erro_w, ie_tipo_arquivo_w, 'S');
		end if;
		
		-- PAGAMENTO
		if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then	
			begin
			-- Gerar lote de discussão
			nr_seq_lote_disc_w := pls_gerar_lote_discussao_a550(nr_seq_lote_contest_w, nr_seq_camara_contest_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_lote_disc_w);
			exception
			when others then
				ds_erro_w := substr(sqlerrm || pls_util_pck.enter_w || 'Error Back Trace: ' || dbms_utility.format_error_backtrace, 1, 4000);
			end;
			
			if (coalesce(ds_erro_w::text, '') = '') then
				begin
				-- Gerar nota débito/crédito A560
				CALL pls_gerar_nota_debito_a560( nr_seq_lote_disc_w, nr_seq_camara_contest_p, cd_estabelecimento_p, nm_usuario_p);
				exception
				when others then
					ds_erro_w := substr(sqlerrm || pls_util_pck.enter_w || 'Error Back Trace: ' || dbms_utility.format_error_backtrace, 1, 4000);
				end;
			end if;
			
		-- FATURAMENTO
		else		
			if (coalesce(nr_fatura_w,'0') <> '0') and (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso) e Fatura
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_pls_fatura_w
				from	pls_fatura	a,
					ptu_fatura	b
				where	a.nr_sequencia		= b.nr_seq_pls_fatura
				and	b.nr_fatura		= nr_fatura_w
				and	b.nr_nota_credito_debito= nr_nota_credito_debito_a500_w;
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_lote_contest_w
				from	pls_lote_contestacao a
				where	nr_seq_pls_fatura = nr_seq_pls_fatura_w;
				
			elsif (coalesce(nr_fatura_w,'0') <> '0') then -- Fatura
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_pls_fatura_w
				from	pls_fatura	a,
					ptu_fatura	b
				where	a.nr_sequencia	= b.nr_seq_pls_fatura
				and	b.nr_fatura	= nr_fatura_w;
				
				if (coalesce(nr_seq_pls_fatura_w::text, '') = '') then
					select	max(a.nr_sequencia)
					into STRICT	nr_seq_pls_fatura_w
					from	pls_fatura		a,
						ptu_fatura		b
					where	a.nr_sequencia		= b.nr_seq_pls_fatura
					and	a.nr_titulo		= nr_fatura_w
					and	b.tp_documento_1	= 3;
				end if;
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_lote_contest_w
				from	pls_lote_contestacao
				where	nr_seq_pls_fatura = nr_seq_pls_fatura_w;
			
			elsif (coalesce(nr_nota_cred_deb_number_w,0) > 0) then -- NDR A500 (Reembolso)
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_pls_fatura_w
				from	pls_fatura	a,
					ptu_fatura	b
				where	a.nr_sequencia		= b.nr_seq_pls_fatura
				and	b.nr_nota_credito_debito= nr_nota_credito_debito_a500_w;
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_lote_contest_w
				from	pls_lote_contestacao
				where	nr_seq_pls_fatura = nr_seq_pls_fatura_w;
			end if;			
			
			if (coalesce(nr_seq_pls_fatura_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(717839); -- Fatura originada da função OPS - Faturamento não localizada.
			end if;
			
			if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
				select	count(1)
				into STRICT	qt_registro_w
				from	pls_contestacao
				where	nr_seq_lote = nr_seq_lote_contest_w;
				
				if (qt_registro_w = 0) then
					begin
					CALL pls_gerar_lote_contest_a550( nr_seq_lote_contest_w, nr_seq_camara_contest_p, nr_seq_camara_contest_w, nr_seq_pls_fatura_w, cd_estabelecimento_p, nm_usuario_p);
					exception
					when others then
						ds_erro_w := substr(sqlerrm || pls_util_pck.enter_w || 'Error Back Trace: ' || dbms_utility.format_error_backtrace, 1, 4000);
					end;
				else
					begin
					-- Gerar lote de discussão para este lote de contestação
					nr_seq_lote_disc_w := pls_gerar_lote_disc_a550_fat(	nr_seq_lote_contest_w, nr_seq_camara_contest_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_lote_disc_w);
					exception
					when others then
						ds_erro_w := substr(sqlerrm || pls_util_pck.enter_w || 'Error Back Trace: ' || dbms_utility.format_error_backtrace, 1, 4000);
					end;
				end if;
			end if;	
			
			if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') and (coalesce(nr_seq_lote_contest_w::text, '') = '') and (coalesce(ds_erro_w::text, '') = '') then
				begin
				-- Gerar lote de contestação
				CALL pls_gerar_lote_contest_a550( null, nr_seq_camara_contest_p, nr_seq_camara_contest_w, nr_seq_pls_fatura_w, cd_estabelecimento_p, nm_usuario_p);
				exception
				when others then
					ds_erro_w := substr(sqlerrm || pls_util_pck.enter_w || 'Error Back Trace: ' || dbms_utility.format_error_backtrace, 1, 4000);
				end;
			end if;
		end if;
		
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			rollback;
		end if;
		
		if (ie_novo_imp_a550_w = 'S') then -- Final da geração do lote de discussão
			pls_gerar_log_imp_a550( nr_seq_camara_contest_p, 'GD', 'FI', nm_usuario_p, null, clock_timestamp(), ds_erro_w, ie_tipo_arquivo_w, 'S');
		
		elsif (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			-- Caso tenha problema, barra processo
			CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
		end if;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(216466);
	end if;

	-- Importação concluida com sucesso
	CALL ptu_atualizar_status_imp_a550( nr_seq_camara_contest_p, 'IM', 'N');

	if (coalesce(ie_commit_p,'N') = 'S') then
		commit;
	end if;
end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_camara_contest (nr_seq_camara_contest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
