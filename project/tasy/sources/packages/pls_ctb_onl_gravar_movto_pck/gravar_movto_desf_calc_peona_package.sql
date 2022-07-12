-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_calc_peona ( nr_seq_peona_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	ctb_doc_w ctb_documento%rowtype;

	c_peona CURSOR FOR
	SELECT	b.vl_peona vl_contabil,
		a.nr_sequencia nr_seq_peona,
		b.nr_sequencia nr_seq_peona_conta_contab,
		a.dt_competencia,
		c.nm_tabela,
		c.nm_atributo,
		c.cd_tipo_lote_contabil,
		c.nr_seq_info,
		count(case c.ie_situacao_ctb when 'P' then 1 end) qt_pendente
	from	pls_peona_conta_contab	b,
		pls_peona		a,
		ctb_documento		c
	where	a.nr_sequencia		= b.nr_seq_peona
	and	a.nr_sequencia		= nr_seq_peona_p
	and	c.nr_seq_doc_compl	= a.nr_sequencia
	and	c.nr_doc_analitico	= b.nr_sequencia
	and	c.cd_tipo_lote_contabil = 35
	and	coalesce(c.ds_origem, 'X')   <> 'ESTORNO'
	and	c.nm_tabela 		= 'PLS_PEONA_CONTA_CONTAB'
	and	c.nm_atributo		= 'VL_PEONA'
	group by b.vl_peona,
		a.nr_sequencia,
		b.nr_sequencia,
		a.dt_competencia,
		c.nm_tabela,
		c.nm_atributo,
		c.cd_tipo_lote_contabil,
		c.nr_seq_info;
	
	vet_peona c_peona%rowtype;

	
BEGIN
	open c_peona;
	loop
	fetch c_peona into
		vet_peona;
	EXIT WHEN NOT FOUND; /* apply on c_peona */
		begin
		if (vet_peona.qt_pendente > 0) then
			delete 	FROM ctb_documento
			where	nr_seq_doc_compl 		= vet_peona.nr_seq_peona
			and	nr_doc_analitico 		= vet_peona.nr_seq_peona_conta_contab
			and 	nm_tabela 			= vet_peona.nm_tabela
			and	nm_atributo 			= vet_peona.nm_atributo
			and	cd_tipo_lote_contabil 		= vet_peona.cd_tipo_lote_contabil
			and	ie_situacao_ctb 		= 'P'
			and	coalesce(ds_origem, 'X')		<> 'ESTORNO';
		else
			CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_p,
									pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
									35,
									null,
									null,
									null,
									vet_peona.nr_seq_peona,
									vet_peona.nr_seq_peona_conta_contab,
									vet_peona.vl_contabil * -1, -- Inverte o valor pois e estorno
									'PLS_PEONA_CONTA_CONTAB',
									'VL_PEONA',
									nm_usuario_p,
									'P',
									'ESTORNO');

			select 	*
			into STRICT	ctb_doc_w
			from (SELECT *
				from   	ctb_documento a
				where 	a.nr_seq_doc_compl	= vet_peona.nr_seq_peona
				and	a.nr_doc_analitico	= vet_peona.nr_seq_peona_conta_contab
				and	a.cd_tipo_lote_contabil = vet_peona.cd_tipo_lote_contabil
				order by nr_sequencia desc) alias0 LIMIT 1;

			CALL pls_contab_onl_lote_fin_pck.contabiliza_documento(ctb_doc_w, nm_usuario_p);
			
		end if;
		end;
	end loop;
	close c_peona;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_calc_peona ( nr_seq_peona_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;