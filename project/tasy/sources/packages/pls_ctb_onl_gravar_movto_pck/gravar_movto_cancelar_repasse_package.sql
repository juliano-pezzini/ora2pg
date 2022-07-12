-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_cancelar_repasse ( nr_seq_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	c_repasse CURSOR FOR
	SELECT	a.nr_seq_vendedor nr_documento,
		a.nr_sequencia nr_seq_doc_compl,
		b.nr_sequencia nr_doc_analitico,
		b.vl_repasse vl_contabil,
		trunc(a.dt_referencia,'dd') dt_movimento,
		c.nm_tabela,
		c.nm_atributo,
		26 nr_seq_info_ctb,
		c.cd_tipo_lote_contabil,
		c.nr_seq_info,
		count(case c.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	pls_repasse_mens	b,
		pls_repasse_vend	a,
		ctb_documento		c
	where	b.nr_seq_repasse	= a.nr_sequencia
	and	a.nr_sequencia		= nr_seq_repasse_p
	and	a.ie_status 		= 'F'
	and	c.nr_seq_doc_compl	= a.nr_sequencia
	and	c.nr_doc_analitico  	= b.nr_sequencia
	and	c.nm_tabela 		= 'PLS_REPASSE_MENS'
	and	c.nm_atributo		= 'VL_REPASSE'
	and	c.nr_seq_info		= 26
	and	coalesce(c.ds_origem, 'X') 	<> 'ESTORNO'
	group by a.nr_seq_vendedor,
		a.nr_sequencia,
		b.nr_sequencia,
		b.vl_repasse,
		a.dt_referencia,
		c.nm_tabela,
		c.nm_atributo,
		c.cd_tipo_lote_contabil,
		c.nr_seq_info
	
union all

	SELECT	f.nr_sequencia nr_documento,
		a.nr_sequencia nr_seq_doc_compl,
		c.nr_sequencia nr_doc_analitico,
		c.vl_lancamento vl_contabil,
		trunc(a.dt_referencia,'dd') dt_movimento,
		d.nm_tabela,
		d.nm_atributo,
		26 nr_seq_info_ctb,
		d.cd_tipo_lote_contabil,
		d.nr_seq_info,
		count(case d.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	pls_repasse_vend		a,
		pls_vendedor			f,
		pls_repasse_lanc		c,
		ctb_documento			d
	where	f.nr_sequencia		= a.nr_seq_vendedor
	and	a.nr_sequencia		= c.nr_seq_repasse
	and	a.nr_sequencia		= nr_seq_repasse_p
	and	a.ie_status 		= 'F'
	and	d.nr_seq_doc_compl	= a.nr_sequencia
	and	d.nr_doc_analitico  	= c.nr_sequencia
	and	d.nm_tabela 		= 'PLS_REPASSE_LANC'
	and	d.nm_atributo		= 'VL_LANCAMENTO'
	and	d.nr_seq_info		= 26
	and	coalesce(d.ds_origem, 'X') 	<> 'ESTORNO'
	group by f.nr_sequencia,
		a.nr_sequencia,
		c.nr_sequencia,
		c.vl_lancamento,
		a.dt_referencia,
		d.nm_tabela,
		d.nm_atributo,
		d.cd_tipo_lote_contabil,
		d.nr_seq_info;

	vet_repasse c_repasse%rowtype;
	
BEGIN

	open c_repasse;
	loop
	fetch c_repasse into
		vet_repasse;
	EXIT WHEN NOT FOUND; /* apply on c_repasse */
		begin
		if (vet_repasse.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_documento			= vet_repasse.nr_documento
			and	nr_seq_doc_compl 		= vet_repasse.nr_seq_doc_compl
			and	nr_doc_analitico 		= vet_repasse.nr_doc_analitico
			and 	nm_tabela 			= vet_repasse.nm_tabela
			and	nm_atributo 			= vet_repasse.nm_atributo
			and	cd_tipo_lote_contabil 		= vet_repasse.cd_tipo_lote_contabil
			and	nr_seq_info 			= vet_repasse.nr_seq_info
			and	ie_situacao_ctb 		= 'P'
			and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
		else
			CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
									pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
									24,
									null,
									vet_repasse.nr_seq_info_ctb,
									vet_repasse.nr_documento,
									vet_repasse.nr_seq_doc_compl,
									vet_repasse.nr_doc_analitico,
									vet_repasse.vl_contabil * -1, --Inverte o valor pois e estorno
									vet_repasse.nm_tabela,
									vet_repasse.nm_atributo,
									nm_usuario_p,
									'P',
									'ESTORNO');
		end if;	

		end;
	end loop;
	close c_repasse;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_cancelar_repasse ( nr_seq_repasse_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
