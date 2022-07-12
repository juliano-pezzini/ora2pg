-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desvinc_tit_fat ( nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	ie_lote_reembolso_fat_w		pls_parametro_contabil.ie_lote_reembolso_fat%type;
	ie_lote_dif_fat_w		pls_parametro_contabil.ie_lote_dif_fat%type;
	ie_lote_ajuste_fat_w		pls_parametro_contabil.ie_lote_ajuste_fat%type;
	ie_lote_taxa_fat_w		pls_parametro_contabil.ie_lote_taxa_fat%type;
	vl_contabil_w			ctb_documento.vl_movimento%type;
	nm_atributo_w			ctb_documento.nm_atributo%type;

	c_rec_fat CURSOR FOR
	SELECT	distinct coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_administracao,0) vl_contab_ndc,
		CASE WHEN s.ie_tipo_segurado='I' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='H' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='T' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric   ELSE 0 END  vl_contab_dif,
		e.vl_administracao vl_contab_taxa,
		coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_provisao,0) vl_contab_ajuste,
		coalesce(h.vl_taxa,0) vl_contab_taxa_adm,
		trunc(f.dt_mes_competencia,'month') dt_mes_competencia,
		g.nm_tabela,
		30 nr_seq_info_ctb,
		f.dt_emissao,
		r.dt_emissao dt_emissao_titulo,
		p.ie_tipo_cobranca,
		(SELECT	x.ie_status
		from	pls_conta_proc x
		where	a.nr_seq_conta_proc	= x.nr_sequencia) ie_status,
		f.nr_sequencia nr_seq_fatura,
		t.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		p.nr_sequencia nr_doc_analitico,
		g.nm_atributo,
		g.cd_tipo_lote_contabil,
		count(case g.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_conta t, pls_segurado s, pls_lote_faturamento l, ctb_documento g, pls_conta_pos_estab_contab e, pls_fatura_evento d, pls_fatura_conta c, pls_conta_pos_estabelecido a, pls_fatura f
LEFT OUTER JOIN titulo_receber r ON (f.nr_titulo = r.nr_titulo)
, pls_fatura_proc p
LEFT OUTER JOIN pls_conta_pos_taxa_contab h ON (p.nr_seq_pos_taxa_contab = h.nr_sequencia)
WHERE t.nr_sequencia 		= a.nr_seq_conta and a.nr_sequencia 		= e.nr_seq_conta_pos and s.nr_sequencia 		= t.nr_seq_segurado and a.nr_sequencia 		= p.nr_seq_conta_pos_estab and c.nr_sequencia 		= p.nr_seq_fatura_conta and d.nr_sequencia 		= c.nr_seq_fatura_evento and f.nr_sequencia 		= d.nr_seq_fatura and l.nr_sequencia 		= f.nr_seq_lote and g.nr_documento 		= t.nr_sequencia and g.nr_seq_doc_compl	= e.nr_sequencia and g.nr_doc_analitico	= p.nr_sequencia and g.nm_tabela 		= 'PLS_FATURA_PROC' and coalesce(g.ds_origem, 'X')	<> 'ESTORNO' and coalesce(f.ie_impedimento_cobranca,'X') not in ('NF','BP') and e.nr_sequencia		= p.nr_seq_conta_pos_contab   and coalesce(f.nr_seq_cancel_fat::text, '') = '' and coalesce(a.ie_status_faturamento, 'A') <> 'A' and (l.nr_sequencia = nr_seq_lote_p or coalesce(nr_seq_lote_p::text, '') = '') and (f.nr_sequencia = nr_seq_fatura_p or coalesce(nr_seq_fatura_p::text, '') = '') group by e.vl_custo_operacional,
		e.vl_administracao,
		s.ie_tipo_segurado,
		e.nr_sequencia,
		e.vl_provisao,
		h.vl_taxa,
		f.dt_mes_competencia,
		g.nm_tabela,
		f.dt_emissao,
		r.dt_emissao,
		p.ie_tipo_cobranca,
		a.nr_seq_conta_proc,
		f.nr_sequencia,
		t.nr_sequencia,
		e.nr_sequencia,
		p.nr_sequencia,
		g.nm_atributo,
		g.cd_tipo_lote_contabil
	
union all

	select	distinct coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_administracao,0) vl_contab_ndc,
		CASE WHEN s.ie_tipo_segurado='I' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='H' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='T' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric   ELSE 0 END  vl_contab_dif,
		e.vl_administracao vl_contab_taxa,
		coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_provisao,0) vl_contab_ajuste,
		coalesce(h.vl_taxa,0) vl_contab_taxa_adm,
		trunc(f.dt_mes_competencia,'month') dt_mes_competencia,
		g.nm_tabela,
		30 nr_seq_info_ctb,
		f.dt_emissao,
		r.dt_emissao dt_emissao_titulo,
		p.ie_tipo_cobranca,
		(select	x.ie_status
		from	pls_conta_proc x
		where	a.nr_seq_conta_proc	= x.nr_sequencia) ie_status,
		f.nr_sequencia nr_seq_fatura,
		t.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		p.nr_sequencia nr_doc_analitico,
		g.nm_atributo,
		g.cd_tipo_lote_contabil,
		count(case g.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_conta t, pls_segurado s, pls_lote_faturamento l, ctb_documento g, pls_conta_pos_estab_contab e, pls_fatura_evento d, pls_fatura_conta c, pls_conta_pos_estabelecido a, pls_fatura f
LEFT OUTER JOIN titulo_receber r ON (f.nr_titulo = r.nr_titulo)
, pls_fatura_proc p
LEFT OUTER JOIN pls_conta_pos_taxa_contab h ON (p.nr_seq_pos_taxa_contab = h.nr_sequencia)
WHERE t.nr_sequencia 		= a.nr_seq_conta and a.nr_sequencia 		= e.nr_seq_conta_pos and s.nr_sequencia 		= t.nr_seq_segurado and a.nr_sequencia 		= p.nr_seq_conta_pos_estab and c.nr_sequencia 		= p.nr_seq_fatura_conta and d.nr_sequencia 		= c.nr_seq_fatura_evento and f.nr_sequencia 		= d.nr_seq_fatura and l.nr_sequencia 		= f.nr_seq_lote   and g.nr_documento 		= t.nr_sequencia and g.nr_seq_doc_compl	= e.nr_sequencia and g.nr_doc_analitico	= p.nr_sequencia and coalesce(g.ds_origem, 'X')	<> 'ESTORNO' and g.nm_tabela		= 'PLS_FATURA_PROC' and coalesce(f.ie_impedimento_cobranca,'X') not in ('NF','BP') and coalesce(f.nr_seq_cancel_fat::text, '') = '' and not exists ( 	select 1
					from   pls_fatura_proc z
					where  a.nr_sequencia  = z.nr_seq_conta_pos_estab
					and    e.nr_sequencia  = z.nr_seq_conta_pos_contab) and (l.nr_sequencia = nr_seq_lote_p or coalesce(nr_seq_lote_p::text, '') = '') and (f.nr_sequencia = nr_seq_fatura_p or coalesce(nr_seq_fatura_p::text, '') = '') group by e.vl_custo_operacional,
		e.vl_administracao,
		s.ie_tipo_segurado,
		e.nr_sequencia,
		e.vl_provisao,
		h.vl_taxa,
		f.dt_mes_competencia,
		g.nm_tabela,
		f.dt_emissao,
		r.dt_emissao,
		p.ie_tipo_cobranca,
		a.nr_seq_conta_proc,
		f.nr_sequencia,
		t.nr_sequencia,
		e.nr_sequencia,
		p.nr_sequencia,
		g.nm_atributo,
		g.cd_tipo_lote_contabil
	
union all

	select	distinct coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_administracao,0) vl_contab_ndc,
		CASE WHEN s.ie_tipo_segurado='I' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='H' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='T' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric   ELSE 0 END  vl_contab_dif,
		e.vl_administracao vl_contab_taxa,
		coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_provisao,0) vl_contab_ajuste,
		coalesce(h.vl_taxa,0) vl_contab_taxa_adm,
		trunc(f.dt_mes_competencia,'month') dt_mes_competencia,
		g.nm_tabela,
		30 nr_seq_info_ctb,
		f.dt_emissao,
		r.dt_emissao dt_emissao_titulo,
		m.ie_tipo_cobranca,
		(select	x.ie_status
		from	pls_conta_mat x
		where	a.nr_seq_conta_mat	= x.nr_sequencia) ie_status,
		f.nr_sequencia nr_seq_fatura,
		t.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		m.nr_sequencia nr_doc_analitico,
		g.nm_atributo,
		g.cd_tipo_lote_contabil,
		count(case g.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_conta t, pls_segurado s, pls_lote_faturamento l, ctb_documento g, pls_conta_pos_estab_contab e, pls_fatura_evento d, pls_fatura_conta c, pls_conta_pos_estabelecido a, pls_fatura f
LEFT OUTER JOIN titulo_receber r ON (f.nr_titulo = r.nr_titulo)
, pls_fatura_mat m
LEFT OUTER JOIN pls_conta_pos_taxa_contab h ON (m.nr_seq_pos_taxa_contab = h.nr_sequencia)
WHERE t.nr_sequencia 		= a.nr_seq_conta and a.nr_sequencia 		= e.nr_seq_conta_pos and s.nr_sequencia 		= t.nr_seq_segurado and a.nr_sequencia 		= m.nr_seq_conta_pos_estab and c.nr_sequencia 		= m.nr_seq_fatura_conta and d.nr_sequencia 		= c.nr_seq_fatura_evento and f.nr_sequencia 		= d.nr_seq_fatura and l.nr_sequencia 		= f.nr_seq_lote and coalesce(f.ie_impedimento_cobranca,'X') not in ('NF','BP') and e.nr_sequencia		= m.nr_seq_conta_pos_contab   and g.nr_documento 		= t.nr_sequencia and g.nr_seq_doc_compl	= e.nr_sequencia and g.nr_doc_analitico	= m.nr_sequencia and g.nm_tabela		= 'PLS_FATURA_MAT' and coalesce(g.ds_origem, 'X')	<> 'ESTORNO' and coalesce(f.nr_seq_cancel_fat::text, '') = '' and coalesce(a.ie_status_faturamento, 'A') <> 'A' and (l.nr_sequencia = nr_seq_lote_p or coalesce(nr_seq_lote_p::text, '') = '') and (f.nr_sequencia = nr_seq_fatura_p or coalesce(nr_seq_fatura_p::text, '') = '') group by e.vl_custo_operacional,
		e.vl_administracao,
		s.ie_tipo_segurado,
		e.nr_sequencia,
		e.vl_provisao,
		h.vl_taxa,
		f.dt_mes_competencia,
		g.nm_tabela,
		f.dt_emissao,
		r.dt_emissao,
		m.ie_tipo_cobranca,
		a.nr_seq_conta_mat,
		f.nr_sequencia,
		t.nr_sequencia,
		e.nr_sequencia,
		m.nr_sequencia,
		g.nm_atributo,
		g.cd_tipo_lote_contabil
	
union all

	select	distinct coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_administracao,0) vl_contab_ndc,
		CASE WHEN s.ie_tipo_segurado='I' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='H' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric  WHEN s.ie_tipo_segurado='T' THEN (pls_obter_vl_pag_fat_pos(e.nr_sequencia,'T'))::numeric   ELSE 0 END  vl_contab_dif,
		e.vl_administracao vl_contab_taxa,
		coalesce(e.vl_custo_operacional,0) - coalesce(e.vl_provisao,0) vl_contab_ajuste,
		coalesce(h.vl_taxa,0) vl_contab_taxa_adm,
		trunc(f.dt_mes_competencia,'month') dt_mes_competencia,
		g.nm_tabela,
		30 nr_seq_info_ctb,
		f.dt_emissao,
		r.dt_emissao dt_emissao_titulo,
		m.ie_tipo_cobranca,
		(select	x.ie_status
		from	pls_conta_mat x
		where	a.nr_seq_conta_mat	= x.nr_sequencia) ie_status,
		f.nr_sequencia nr_seq_fatura,
		t.nr_sequencia nr_documento,
		e.nr_sequencia nr_seq_doc_compl,
		m.nr_sequencia nr_doc_analitico,
		g.nm_atributo,
		g.cd_tipo_lote_contabil,
		count(case g.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	FROM pls_conta t, pls_segurado s, pls_lote_faturamento l, ctb_documento g, pls_conta_pos_estab_contab e, pls_fatura_evento d, pls_fatura_conta c, pls_conta_pos_estabelecido a, pls_fatura f
LEFT OUTER JOIN titulo_receber r ON (f.nr_titulo = r.nr_titulo)
, pls_fatura_mat m
LEFT OUTER JOIN pls_conta_pos_taxa_contab h ON (m.nr_seq_pos_taxa_contab = h.nr_sequencia)
WHERE t.nr_sequencia 		= a.nr_seq_conta and a.nr_sequencia 		= e.nr_seq_conta_pos and s.nr_sequencia 		= t.nr_seq_segurado and a.nr_sequencia 		= m.nr_seq_conta_pos_estab and c.nr_sequencia 		= m.nr_seq_fatura_conta and d.nr_sequencia 		= c.nr_seq_fatura_evento and f.nr_sequencia 		= d.nr_seq_fatura and l.nr_sequencia 		= f.nr_seq_lote and g.nr_documento 		= t.nr_sequencia and g.nr_seq_doc_compl	= e.nr_sequencia and g.nr_doc_analitico	= m.nr_sequencia and coalesce(g.ds_origem, 'X')	<> 'ESTORNO' and g.nm_tabela		= 'PLS_FATURA_MAT' and coalesce(f.ie_impedimento_cobranca,'X') not in ('NF','BP')   and coalesce(f.nr_seq_cancel_fat::text, '') = '' and not exists ( 	select 1
					from   pls_fatura_mat z
					where  a.nr_sequencia  = z.nr_seq_conta_pos_estab
					and    e.nr_sequencia  = z.nr_seq_conta_pos_contab) and (l.nr_sequencia = nr_seq_lote_p or coalesce(nr_seq_lote_p::text, '') = '') and (f.nr_sequencia = nr_seq_fatura_p or coalesce(nr_seq_fatura_p::text, '') = '') group by e.vl_custo_operacional,
		e.vl_administracao,
		s.ie_tipo_segurado,
		e.nr_sequencia,
		e.vl_administracao,
		e.vl_provisao,
		h.vl_taxa,
		f.dt_mes_competencia,
		g.nm_tabela,
		f.dt_emissao,
		r.dt_emissao ,
		m.ie_tipo_cobranca,
		a.nr_seq_conta_mat,
		f.nr_sequencia,
		t.nr_sequencia,
		e.nr_sequencia,
		m.nr_sequencia,
		g.nm_atributo,
		g.cd_tipo_lote_contabil;

	vet_rec_fat c_rec_fat%rowtype;

	
BEGIN
	select	max(coalesce(a.ie_lote_ajuste_fat,'R')),
		max(coalesce(a.ie_lote_reembolso_fat,'R')),
		max(coalesce(a.ie_lote_taxa_fat,'R')),
		max(ie_lote_dif_fat)
	into STRICT	ie_lote_ajuste_fat_w,
		ie_lote_reembolso_fat_w,
		ie_lote_taxa_fat_w,
		ie_lote_dif_fat_w
	from	pls_parametro_contabil	a
	where	a.cd_estabelecimento	= cd_estabelecimento_p;

	open c_rec_fat;
	loop
	fetch c_rec_fat into
		vet_rec_fat;
	EXIT WHEN NOT FOUND; /* apply on c_rec_fat */
		begin
		vl_contabil_w	:= 0;
		if (vet_rec_fat.nm_atributo = 'VL_FATURADO_NDC'
			and 	ie_lote_reembolso_fat_w in ('R','A')
			and 	vet_rec_fat.ie_tipo_cobranca not in ('3','4')) then

			vl_contabil_w		:= vet_rec_fat.vl_contab_ndc;

		elsif	(vet_rec_fat.nm_atributo = 'VL_FATURADO_DIF'
			and 	((ie_lote_dif_fat_w = 'R'
			or (coalesce(ie_lote_dif_fat_w,'X') = 'X'
			and	ie_lote_ajuste_fat_w	= 'R'))
			and 	vet_rec_fat.ie_tipo_cobranca not in ('3','4')
			and	coalesce(vet_rec_fat.ie_status,'X') <> 'M')) then

			vl_contabil_w		:= vet_rec_fat.vl_contab_dif;

		elsif (vet_rec_fat.nm_atributo = 'VL_TAXA'
			and	ie_lote_taxa_fat_w in ('R','A')
			and 	vet_rec_fat.ie_tipo_cobranca not in ('3','4')) then

			vl_contabil_w		:= vet_rec_fat.vl_contab_taxa;

		elsif (vet_rec_fat.nm_atributo = 'VL_AJUSTE'
			and	vet_rec_fat.vl_contab_ajuste <> 0
			and	ie_lote_ajuste_fat_w = 'R'
			and 	vet_rec_fat.ie_tipo_cobranca not in ('3','4')) then

			vl_contabil_w		:= vet_rec_fat.vl_contab_ajuste;

		elsif (vet_rec_fat.nm_atributo = 'VL_TAXA_ADM'
			and	vet_rec_fat.ie_tipo_cobranca in ('3','4')) then

			vl_contabil_w		:= vet_rec_fat.vl_contab_taxa_adm;

		end if;

		if (coalesce(vl_contabil_w, 0) <> 0) then

			if (vet_rec_fat.qt_pendente > 0) then
				delete 	FROM ctb_documento
				where	nr_documento			= vet_rec_fat.nr_documento
				and	nr_seq_doc_compl 		= vet_rec_fat.nr_seq_doc_compl
				and	nr_doc_analitico 		= vet_rec_fat.nr_doc_analitico
				and 	nm_tabela 			= vet_rec_fat.nm_tabela
				and	nm_atributo 			= vet_rec_fat.nm_atributo
				and	cd_tipo_lote_contabil 		= vet_rec_fat.cd_tipo_lote_contabil
				and	nr_seq_info 			= vet_rec_fat.nr_seq_info_ctb
				and	ie_situacao_ctb 		= 'P'
				and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
			else
				CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
										pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
										44,
										null,
										vet_rec_fat.nr_seq_info_ctb,
										vet_rec_fat.nr_documento,
										vet_rec_fat.nr_seq_doc_compl,
										vet_rec_fat.nr_doc_analitico,
										vl_contabil_w * -1, -- Inverte o valor pois e estorno
										vet_rec_fat.nm_tabela,
										vet_rec_fat.nm_atributo,
										nm_usuario_p,
										'P',
										'ESTORNO');
			end if;

		end if;
		end;
	end loop;
	close c_rec_fat;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desvinc_tit_fat ( nr_seq_lote_p bigint, nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
