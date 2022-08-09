-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_a550 ( nr_seq_camara_contest_p ptu_camara_contestacao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_remove_ndc_p text default 'N') AS $body$
DECLARE


qt_registro_w			integer;
nr_titulo_w			titulo_receber.nr_titulo%type;
ie_status_imp_w			ptu_camara_contestacao.ie_status_imp%type;
ie_remove_ndc_w			varchar(1) := ie_remove_ndc_p;
nr_seq_lote_contest_w		ptu_camara_contestacao.nr_seq_lote_contest%type;


BEGIN
if (nr_seq_camara_contest_p IS NOT NULL AND nr_seq_camara_contest_p::text <> '') then

	-- Busca o STATUS da camara contestacao
	select	max(ie_status_imp),
		max(nr_seq_lote_contest)
	into STRICT	ie_status_imp_w,
		nr_seq_lote_contest_w
	from	ptu_camara_contestacao
	where	nr_sequencia = nr_seq_camara_contest_p;
	
	-- Gerar LOG
	pls_gerar_contest_log(	nr_seq_lote_contest_w, null, null, null, null, null, 'DLA550', 'N', nm_usuario_p);	
	
	if (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
		-- Verificar se tem lote de discussao
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_lote_discussao
		where	nr_seq_lote_contest = nr_seq_lote_contest_w;
		
		if (qt_registro_w > 0) and (ie_status_imp_w <> 'IN') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(883294);
		end if;
		
		-- Verificar se tem A560
		select	count(1)
		into STRICT	qt_registro_w
		from	ptu_nota_debito		nb,
			ptu_nota_deb_conclusao	dc
		where	nb.nr_sequencia		 = dc.nr_seq_nota_debito
		and	nb.nr_seq_camara_contest = nr_seq_camara_contest_p
		and	coalesce(nb.ie_cancelamento::text, '') = ''
		and	exists (SELECT	1
				from	titulo_receber	tr
				where	tr.nr_seq_nota_deb_conclusao	= dc.nr_sequencia
				
union

				SELECT	1
				from	titulo_pagar	tp
				where	tp.nr_seq_nota_deb_conclusao	= dc.nr_sequencia);
		
		if (qt_registro_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(883295);
		end if;
		
		-- Limpar os titulos a receber de A560
		update	titulo_receber
		set	nr_seq_nota_deb_conclusao  = NULL
		where	ie_situacao	= '3' -- Somente cancelada
		and	nr_seq_nota_deb_conclusao in (SELECT	dc.nr_sequencia
							from	ptu_nota_deb_conclusao	dc,
								ptu_nota_debito		d
							where	d.nr_sequencia	= dc.nr_seq_nota_debito
							and	d.nr_seq_camara_contest = nr_seq_camara_contest_p);
		
		-- Limpar os titulos a pagar de A560
		update	titulo_pagar
		set	nr_seq_nota_deb_conclusao  = NULL
		where	ie_situacao	= 'C' -- Somente cancelada
		and	nr_seq_nota_deb_conclusao in (SELECT	dc.nr_sequencia
							from	ptu_nota_deb_conclusao	dc,
								ptu_nota_debito		d
							where	d.nr_sequencia	= dc.nr_seq_nota_debito
							and	d.nr_seq_camara_contest = nr_seq_camara_contest_p);
		

		update 	pls_recebimento_ptu pr
		set	pr.nr_seq_nota_debito  = NULL,
			pr.ie_status = 'P' -- Pendente
		where	pr.nr_seq_nota_debito in (	SELECT	d.nr_sequencia
								from	ptu_nota_debito	d
								where	d.nr_seq_camara_contest = nr_seq_camara_contest_p);

		-- Excluir A560
		delete	FROM ptu_nota_debito
		where	nr_sequencia in (SELECT	d.nr_sequencia
					from	ptu_nota_debito	d
					where	d.nr_seq_camara_contest = nr_seq_camara_contest_p);

	end if;
	
	-- Se o STATUS da camara contestacao for INCONSISTENTE desfaz o nota de credito
	if (ie_status_imp_w = 'IN') then
		ie_remove_ndc_w := 'S';
	end if;
	
	delete	FROM ptu_processo_camara_cont
	where	nr_seq_camara_contest	= nr_seq_camara_contest_p;
	
	delete	FROM ptu_questionamento_codigo
	where	nr_seq_registro in (	SELECT	nr_sequencia
					from	ptu_questionamento
					where	nr_seq_contestacao = nr_seq_camara_contest_p);
					
	delete	FROM ptu_questionamento_codigo
	where	nr_seq_registro_rrs in (	SELECT	nr_sequencia
						from	ptu_questionamento_rrs
						where	nr_seq_contestacao = nr_seq_camara_contest_p);
						
	delete	FROM ptu_questionamento_codigo
	where	nr_seq_contestacao = nr_seq_camara_contest_p;
	
	delete	FROM ptu_quest_serv_rrs
	where	nr_seq_quest_rrs in (	SELECT	nr_sequencia
					from	ptu_questionamento_rrs
					where	nr_seq_contestacao = nr_seq_camara_contest_p);
	
	delete	FROM ptu_questionamento_rrs
	where	nr_seq_contestacao = nr_seq_camara_contest_p;
	
	delete	FROM ptu_questionamento_item	a
	where exists (	SELECT	1
			from	ptu_questionamento	b
			where	b.nr_seq_conta_proc	= a.nr_seq_conta_proc
			and	b.nr_seq_contestacao	= nr_seq_camara_contest_p
			
union all

			SELECT	1
			from	ptu_questionamento	b
			where	b.nr_seq_conta_mat	= a.nr_seq_conta_mat
			and	b.nr_seq_contestacao	= nr_seq_camara_contest_p);
			
	delete	FROM ptu_questionamento
	where	nr_seq_contestacao = nr_seq_camara_contest_p;
	
	if (ie_remove_ndc_w = 'S') then
		select	count(1)
		into STRICT	qt_registro_w
		from (SELECT	1
			from	ptu_nota_debito
			where	nr_seq_camara_contest = nr_seq_camara_contest_p
			and	ie_cancelamento = 'S'
			
union all

			SELECT	count(1)
			
			where	ie_status_imp_w = 'IN') alias3;
			
		-- Exclui a NDC (A560) caso esteja cancelada ou a camara contestacao for INCONSISTENTE
		if (qt_registro_w > 0) then
			-- EXCLUIR OS DADOS DO A560
			delete	FROM ptu_nota_deb_fat_ndr
			where	nr_seq_nota_debito	in (	SELECT	nr_sequencia
								from	ptu_nota_debito
								where	nr_seq_camara_contest	= nr_seq_camara_contest_p);
								
			delete	FROM ptu_nota_deb_dados
			where	nr_seq_nota_debito	in (	SELECT	nr_sequencia
								from	ptu_nota_debito
								where	nr_seq_camara_contest	= nr_seq_camara_contest_p);
								
			delete	FROM ptu_nota_deb_credor_deved
			where	nr_seq_nota_debito	in (	SELECT	nr_sequencia
								from	ptu_nota_debito
								where	nr_seq_camara_contest	= nr_seq_camara_contest_p);
								
			delete	FROM ptu_nota_deb_bol_inst
			where	nr_seq_nota_deb_bol	in (	SELECT	nr_sequencia
								from	ptu_nota_deb_bol
								where	nr_seq_nota_debito	in (	select	nr_sequencia
													from	ptu_nota_debito
													where	nr_seq_camara_contest	= nr_seq_camara_contest_p));
													
			delete	FROM ptu_nota_deb_bol_obs
			where	nr_seq_nota_deb_bol	in (	SELECT	nr_sequencia
								from	ptu_nota_deb_bol
								where	nr_seq_nota_debito	in (	select	nr_sequencia
													from	ptu_nota_debito
													where	nr_seq_camara_contest	= nr_seq_camara_contest_p));
													
			delete	FROM ptu_nota_deb_bol_ld
			where	nr_seq_nota_deb_bol	in (	SELECT	nr_sequencia
								from	ptu_nota_deb_bol
								where	nr_seq_nota_debito	in (	select	nr_sequencia
													from	ptu_nota_debito
													where	nr_seq_camara_contest	= nr_seq_camara_contest_p));
													
			delete	FROM ptu_nota_deb_bol
			where	nr_seq_nota_debito	in (	SELECT	nr_sequencia
								from	ptu_nota_debito
								where	nr_seq_camara_contest	= nr_seq_camara_contest_p);
								
			-- EXCLUIR  OS DADOS DE TITULO A RECEBER CANCELADO
			delete	FROM alteracao_vencimento
			where	nr_titulo	in (	SELECT	nr_titulo
							from	titulo_receber
							where	nr_seq_nota_deb_conclusao	in (	select	nr_sequencia
													from	ptu_nota_deb_conclusao
													where	nr_seq_nota_debito	in (	select	nr_sequencia
																		from	ptu_nota_debito
																		where	nr_seq_camara_contest	= nr_seq_camara_contest_p)));
																		
			delete	FROM alteracao_valor
			where	nr_titulo	in (	SELECT	nr_titulo
							from	titulo_receber
							where	nr_seq_nota_deb_conclusao	in (	select	nr_sequencia
													from	ptu_nota_deb_conclusao
													where	nr_seq_nota_debito	in (	select	nr_sequencia
																		from	ptu_nota_debito
																		where	nr_seq_camara_contest	= nr_seq_camara_contest_p)));
																		
			delete	FROM lote_encontro_contas_hist
			where	nr_titulo_receber	in (	SELECT	nr_titulo
								from	titulo_receber
								where	nr_seq_nota_deb_conclusao	in (	select	nr_sequencia
														from	ptu_nota_deb_conclusao
														where	nr_seq_nota_debito	in (	select	nr_sequencia
																			from	ptu_nota_debito
																			where	nr_seq_camara_contest	= nr_seq_camara_contest_p)));
																			
			delete	FROM titulo_receber
			where	nr_seq_nota_deb_conclusao	in (	SELECT	nr_sequencia
									from	ptu_nota_deb_conclusao
									where	nr_seq_nota_debito	in (	select	nr_sequencia
														from	ptu_nota_debito
														where	nr_seq_camara_contest	= nr_seq_camara_contest_p));
			-- EXCLUIR OS DADOS DO A560
			delete	FROM ptu_nota_deb_conclusao
			where	nr_seq_nota_debito	in (	SELECT	nr_sequencia
								from	ptu_nota_debito
								where	nr_seq_camara_contest	= nr_seq_camara_contest_p);
								
			update 	pls_recebimento_ptu pr
			set	pr.nr_seq_nota_debito  = NULL,
				pr.ie_status = 'P' -- Pendente
			where	pr.nr_seq_nota_debito in (	SELECT	pnd.nr_sequencia
								from	ptu_nota_debito pnd
								where	pnd.nr_seq_camara_contest	= nr_seq_camara_contest_p);

			delete	FROM ptu_nota_debito
			where	nr_seq_camara_contest	= nr_seq_camara_contest_p;
		end if;
	end if;
	
	
	update 	pls_recebimento_ptu pr
	set	pr.nr_seq_contestacao  = NULL,
		pr.ie_status = 'P' -- Pendente
	where	pr.nr_seq_contestacao = nr_seq_camara_contest_p;
	
	
	-- EXCLUIR O A550
	delete	FROM ptu_camara_contestacao
	where	nr_sequencia = nr_seq_camara_contest_p;
		
	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_a550 ( nr_seq_camara_contest_p ptu_camara_contestacao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_remove_ndc_p text default 'N') FROM PUBLIC;
