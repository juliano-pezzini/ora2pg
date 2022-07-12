-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desv_canc_tit_pp ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_cancelamento_p timestamp) AS $body$
DECLARE


	dt_cancelamento_w			timestamp;

	c_evento CURSOR FOR
	SELECT	coalesce(i.vl_item,0) vl_item,  /*Contabilizar os valores dos itens, conforme o lancamento no pagamento de producao medica*/
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		i.nr_sequencia nr_seq_item_pp,
		l.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		i.nr_sequencia nr_doc_analitico,
		count(case f.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_prestador p, pls_pp_lote l, ctb_documento f, pls_evento e, pls_pp_item_lote i
LEFT OUTER JOIN pls_pp_lanc_programado z ON (i.nr_seq_lanc_prog = z.nr_sequencia)
WHERE l.nr_sequencia		= i.nr_seq_lote and p.nr_sequencia		= i.nr_seq_prestador and e.nr_sequencia		= i.nr_seq_evento  and e.ie_tipo_evento	= 'F' and l.ie_status		= 'D' and f.nr_documento		= l.nr_sequencia and f.nr_seq_doc_compl	= e.nr_sequencia and f.nr_doc_analitico	= i.nr_sequencia and f.cd_tipo_lote_contabil = 41 and f.nm_tabela		= 'PLS_PP_ITEM_LOTE' and f.nm_atributo		= 'VL_ITEM' and coalesce(f.ds_origem, 'X')	<> 'ESTORNO' and exists (SELECT 1
				from 	pls_pp_prestador x
				where	x.nr_seq_lote = nr_seq_lote_p
				and	x.nr_seq_prestador = p.nr_sequencia
				and	coalesce(x.nr_titulo_pagar, 0) <> 0) and l.nr_sequencia		= nr_seq_lote_p group by i.vl_item,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		i.nr_sequencia,
		l.nr_sequencia,
		e.nr_sequencia,
		i.nr_sequencia
	
union

	select	coalesce(i.vl_acao_negativo,0) * -1 vl_item, /*Contabilizar as apropriacoes para o proximo pagamento*/
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		i.nr_sequencia nr_seq_item_pp,
		l.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		i.nr_sequencia nr_doc_analitico,
		count(case f.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_prestador p, pls_pp_lote l, ctb_documento f, pls_evento e, pls_pp_item_lote i
LEFT OUTER JOIN pls_pp_lanc_programado z ON (i.nr_seq_lanc_prog = z.nr_sequencia)
WHERE l.nr_sequencia		= i.nr_seq_lote and p.nr_sequencia		= i.nr_seq_prestador and e.nr_sequencia		= i.nr_seq_evento  and e.ie_tipo_evento	= 'F' and coalesce(i.vl_acao_negativo,0) <> 0 and l.ie_status		= 'D' and f.nr_documento		= l.nr_sequencia and f.nr_seq_doc_compl	= e.nr_sequencia and f.nr_doc_analitico	= i.nr_sequencia and f.cd_tipo_lote_contabil = 41 and f.nm_tabela		= 'PLS_PP_ITEM_LOTE' and f.nm_atributo		= 'VL_ITEM' and coalesce(f.ds_origem, 'X')	<> 'ESTORNO' and exists (select 1
				from 	pls_pp_prestador x
				where	x.nr_seq_lote = nr_seq_lote_p
				and	x.nr_seq_prestador = p.nr_sequencia
				and	coalesce(x.nr_titulo_pagar, 0) <> 0) and l.nr_sequencia		= nr_seq_lote_p group by i.vl_acao_negativo,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		i.nr_sequencia,
		l.nr_sequencia,
		e.nr_sequencia,
		i.nr_sequencia;

	vet_evento c_evento%rowtype;

	c_pagamento CURSOR FOR
	SELECT	'P' ie_proc_mat, /*Procedimento*/
		coalesce(d.vl_liberado,0) vl_contabil,
		coalesce(d.vl_glosa,0) vl_glosa,
		d.vl_liberado - CASE WHEN coalesce(d.vl_apresentado,0)=0 THEN coalesce(d.vl_calculado,0)  ELSE coalesce(d.vl_apresentado,0) END  vl_ajuste,
		b.nr_seq_protocolo nr_documento,
		b.nr_sequencia nr_seq_doc_compl,
		d.nr_sequencia nr_doc_analitico,
		c.nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		b.nr_sequencia nr_seq_conta,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		count(case f.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_pp_item_lote i, ctb_documento f, pls_conta_proc c, pls_conta b, pls_pp_lote a, pls_conta_medica_resumo d
LEFT OUTER JOIN pls_prestador p ON (d.nr_seq_prestador_pgto = p.nr_sequencia)
WHERE c.nr_sequencia		= d.nr_seq_conta_proc and b.nr_sequencia		= c.nr_seq_conta and b.nr_sequencia		= d.nr_seq_conta and d.nr_sequencia		= i.nr_seq_resumo and b.nr_sequencia		= i.nr_seq_conta and a.nr_sequencia		= i.nr_seq_lote  and ((d.ie_situacao = 'A') or (coalesce(d.ie_situacao::text, '') = '')) and a.ie_status		= 'D' and f.nr_documento		= b.nr_seq_protocolo and f.nr_seq_doc_compl	= b.nr_sequencia and f.nr_doc_analitico	= d.nr_sequencia and f.cd_tipo_lote_contabil = 41 and f.nm_tabela		= 'PLS_CONTA_MEDICA_RESUMO' and f.nm_atributo		in ('VL_LIBERADO', 'VL_GLOSA', 'VL_AJUSTE') and coalesce(f.ds_origem, 'X')	<> 'ESTORNO' and exists (SELECT 1
				from 	pls_pp_prestador x
				where	x.nr_seq_lote = nr_seq_lote_p
				and	x.nr_seq_prestador = p.nr_sequencia
				and	coalesce(x.nr_titulo_pagar, 0) <> 0) and a.nr_sequencia		= nr_seq_lote_p group by d.vl_liberado,
		d.vl_glosa,
		d.vl_apresentado,
		d.vl_calculado,
		b.nr_seq_protocolo,
		b.nr_sequencia,
		d.nr_sequencia,
		c.nr_sequencia,
		b.nr_sequencia,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info
	
union all

	select	'M' ie_proc_mat, /*Material*/
		coalesce(d.vl_liberado,0) vl_contabil,
		coalesce(d.vl_glosa,0) vl_glosa,
		d.vl_liberado - CASE WHEN coalesce(d.vl_apresentado,0)=0 THEN coalesce(d.vl_calculado,0)  ELSE coalesce(d.vl_apresentado,0) END  vl_ajuste,
		b.nr_seq_protocolo nr_documento,
		b.nr_sequencia nr_seq_doc_compl,
		d.nr_sequencia nr_doc_analitico,
		null nr_seq_conta_proc,
		c.nr_sequencia nr_seq_conta_mat,
		b.nr_sequencia nr_seq_conta,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		count(case f.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_pp_item_lote i, ctb_documento f, pls_conta_mat c, pls_conta b, pls_pp_lote a, pls_conta_medica_resumo d
LEFT OUTER JOIN pls_prestador p ON (d.nr_seq_prestador_pgto = p.nr_sequencia)
WHERE c.nr_sequencia		= d.nr_seq_conta_mat and b.nr_sequencia		= c.nr_seq_conta and b.nr_sequencia		= d.nr_seq_conta and d.nr_sequencia		= i.nr_seq_resumo and b.nr_sequencia		= i.nr_seq_conta and a.nr_sequencia		= i.nr_seq_lote  and ((d.ie_situacao = 'A') or (coalesce(d.ie_situacao::text, '') = '')) and a.ie_status		= 'D' and f.nr_documento		= b.nr_seq_protocolo and f.nr_seq_doc_compl	= b.nr_sequencia and f.nr_doc_analitico	= d.nr_sequencia and f.cd_tipo_lote_contabil = 41 and f.nm_tabela		= 'PLS_CONTA_MEDICA_RESUMO' and f.nm_atributo		in ('VL_LIBERADO', 'VL_GLOSA', 'VL_AJUSTE') and coalesce(f.ds_origem, 'X')	<> 'ESTORNO' and exists (select 1
				from 	pls_pp_prestador x
				where	x.nr_seq_lote = nr_seq_lote_p
				and	x.nr_seq_prestador = p.nr_sequencia
				and	coalesce(x.nr_titulo_pagar, 0) <> 0) and a.nr_sequencia = nr_seq_lote_p group by d.vl_liberado,
		d.vl_glosa,
		d.vl_apresentado,
		d.vl_calculado,
		b.nr_seq_protocolo,
		b.nr_sequencia,
		d.nr_sequencia,
		c.nr_sequencia,
		b.nr_sequencia,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info;

	vet_pagamento	c_pagamento%rowtype;

	c_tributo CURSOR FOR
	SELECT r.vl_tributo vl_contabil,
		r.nr_sequencia	nr_seq_trib_pp,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		l.nr_sequencia nr_documento,
		i.nr_sequencia nr_seq_doc_compl,
		r.nr_sequencia nr_doc_analitico,
		count(case f.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	pls_pp_base_atual_trib		r,
		pls_pp_valor_trib_pessoa 	b,
		pls_pp_item_lote		i,
		pls_pp_lote			l,
		pls_pp_prestador		t,
		pls_prestador			p,
		ctb_documento 			f
	where	b.nr_sequencia		= r.nr_seq_trib_pessoa
	and	l.nr_sequencia		= r.nr_seq_lote
	and	i.nr_sequencia		= r.nr_seq_item_lote
	and	p.nr_sequencia		= b.nr_seq_prestador
	and	p.nr_sequencia		= t.nr_seq_prestador
	and	l.nr_sequencia		= t.nr_seq_lote
	and	l.ie_status		= 'D'
	and	f.nr_documento		= l.nr_sequencia
	and	f.nr_seq_doc_compl	= i.nr_sequencia
	and	f.nr_doc_analitico	= r.nr_sequencia
	and	f.cd_tipo_lote_contabil = 41
	and	f.nm_tabela		= 'PLS_PP_BASE_ATUAL_TRIB'
	and	f.nm_atributo		= 'VL_TRIBUTO'
	and	coalesce(f.ds_origem, 'X')	<> 'ESTORNO'
	and	coalesce(t.nr_titulo_pagar, 0) <> 0
	and	l.nr_sequencia		= nr_seq_lote_p
	group by r.vl_tributo,
		r.nr_sequencia,
		f.nm_tabela,
		f.nm_atributo,
		f.cd_tipo_lote_contabil,
		f.nr_seq_info,
		l.nr_sequencia,
		i.nr_sequencia,
		r.nr_sequencia;

	vet_tributo c_tributo%rowtype;

	
BEGIN
	
	if (dt_cancelamento_p IS NOT NULL AND dt_cancelamento_p::text <> '') then
		dt_cancelamento_w := dt_cancelamento_p;
	else
		dt_cancelamento_w := clock_timestamp();
	end if;

	open c_evento;
	loop
	fetch c_evento into	
		vet_evento;
	EXIT WHEN NOT FOUND; /* apply on c_evento */
		begin
		if (vet_evento.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_documento 			= vet_evento.nr_documento
			and	nr_seq_doc_compl 		= vet_evento.nr_seq_doc_compl
			and	nr_doc_analitico 		= vet_evento.nr_doc_analitico
			and 	nm_tabela 			= vet_evento.nm_tabela
			and	nm_atributo 			= vet_evento.nm_atributo
			and	cd_tipo_lote_contabil 		= vet_evento.cd_tipo_lote_contabil
			and	nr_seq_info 			= vet_evento.nr_seq_info
			and	ie_situacao_ctb 		= 'P'
			and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
		else
			if (coalesce(vet_evento.vl_item, 0) <> 0) then
				CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
										pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
										41,             
										null,		
										39,
										vet_evento.nr_documento,
										vet_evento.nr_seq_doc_compl,
										vet_evento.nr_doc_analitico,
										vet_evento.vl_item * -1, -- Inverte o valor pois e estorno
										vet_evento.nm_tabela,
										vet_evento.nm_atributo,
										nm_usuario_p,
										'P',
										'ESTORNO');
			end if;
		end if;
		end;
	end loop;
	close c_evento;

	open c_pagamento;
	loop
	fetch c_pagamento into
		vet_pagamento;
	EXIT WHEN NOT FOUND; /* apply on c_pagamento */
		begin
		if (vet_pagamento.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_documento 			= vet_pagamento.nr_documento
			and	nr_seq_doc_compl 		= vet_pagamento.nr_seq_doc_compl
			and	nr_doc_analitico 		= vet_pagamento.nr_doc_analitico
			and 	nm_tabela 			= vet_pagamento.nm_tabela
			and	nm_atributo 			= vet_pagamento.nm_atributo
			and	cd_tipo_lote_contabil 		= vet_pagamento.cd_tipo_lote_contabil
			and	nr_seq_info 			= vet_pagamento.nr_seq_info
			and	ie_situacao_ctb 		= 'P'
			and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
		else
			if (coalesce(vet_pagamento.nm_atributo, 'X') = 'VL_LIBERADO') then /* Conta */
				if (coalesce(vet_pagamento.vl_contabil, 0) <> 0) then
					CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
											pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
											41,
											null,		
											36,
											vet_pagamento.nr_documento,
											vet_pagamento.nr_seq_doc_compl,
											vet_pagamento.nr_doc_analitico,
											vet_pagamento.vl_contabil * -1, -- Inverte o valor pois e estorno
											vet_pagamento.nm_tabela,
											vet_pagamento.nm_atributo,
											nm_usuario_p,
											'P',
											'ESTORNO');
				end if;
			elsif (coalesce(vet_pagamento.nm_atributo, 'X') = 'VL_GLOSA') then /* Glosa */
				if (coalesce(vet_pagamento.vl_glosa, 0) <> 0) then
					CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
											pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
											41,
											null,		
											24,
											vet_pagamento.nr_documento,
											vet_pagamento.nr_seq_doc_compl,
											vet_pagamento.nr_doc_analitico,
											vet_pagamento.vl_glosa * -1, -- Inverte o valor pois e estorno
											vet_pagamento.nm_tabela,
											vet_pagamento.nm_atributo,
											nm_usuario_p,
											'P',
											'ESTORNO');
				end if;
			elsif (coalesce(vet_pagamento.nm_atributo, 'X') = 'VL_AJUSTE') then /* Valor de ajuste */
				if (coalesce(vet_pagamento.vl_ajuste, 0) <> 0) then
					CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
											pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
											41,
											null,		
											36,
											vet_pagamento.nr_documento,
											vet_pagamento.nr_seq_doc_compl,
											vet_pagamento.nr_doc_analitico,
											vet_pagamento.vl_ajuste * -1, -- Inverte o valor pois e estorno
											vet_pagamento.nm_tabela,
											vet_pagamento.nm_atributo,
											nm_usuario_p,
											'P',
											'ESTORNO');
				end if;
			end if;
		end if;
		end;
	end loop;
	close c_pagamento;

	open c_tributo;
	loop
	fetch c_tributo into
		vet_tributo;
	EXIT WHEN NOT FOUND; /* apply on c_tributo */
		begin
		if (vet_tributo.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_documento 			= vet_tributo.nr_documento
			and	nr_seq_doc_compl 		= vet_tributo.nr_seq_doc_compl
			and	nr_doc_analitico 		= vet_tributo.nr_doc_analitico
			and 	nm_tabela 			= vet_tributo.nm_tabela
			and	nm_atributo 			= vet_tributo.nm_atributo
			and	cd_tipo_lote_contabil 		= vet_tributo.cd_tipo_lote_contabil
			and	nr_seq_info 			= vet_tributo.nr_seq_info
			and	ie_situacao_ctb 		= 'P'
			and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
		else
			if (coalesce(vet_tributo.vl_contabil, 0) <> 0) then
				CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
										pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
										41,
										null,		
										40,
										vet_tributo.nr_documento,
										vet_tributo.nr_seq_doc_compl,
										vet_tributo.nr_doc_analitico,
										vet_tributo.vl_contabil * -1, -- Inverte o valor pois e estorno
										vet_tributo.nm_tabela,
										vet_tributo.nm_atributo,
										nm_usuario_p,
										'P',
										'ESTORNO');
			end if;
		end if;
		end;
	end loop;
	close c_tributo;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desv_canc_tit_pp ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_cancelamento_p timestamp) FROM PUBLIC;
