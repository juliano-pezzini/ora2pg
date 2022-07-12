-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_lote_recalc ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	ctb_doc_w			ctb_documento%rowtype;
	ie_forma_contab_taxa_pgto_w	pls_parametro_contabil.ie_forma_contab_taxa_pgto%type;
	ie_lote_ajuste_prod_w		pls_parametro_contabil.ie_lote_ajuste_prod%type;
	ie_status_prov_pagto_w		pls_parametro_contabil.ie_status_prov_pagto%type;
	nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
	nr_seq_conta_w			pls_conta.nr_sequencia%type;
	nr_seq_prestador_exec_w		pls_conta.nr_seq_prestador_exec%type;
	ie_tipo_relacao_w		pls_prestador.ie_tipo_relacao%type;
	ie_regra_recalculo_w		varchar(1);
	ie_inseriu_w			varchar(1);



	c_contas CURSOR FOR
		SELECT	nr_seq_conta
		from	pls_conta_recalculo
		where	nr_seq_lote = nr_seq_lote_p;


	-- Obtem as informacoes para contabilizacao instantanea de provisao de producao medica.
	c_valores_prov_prod CURSOR FOR
		SELECT	d.nr_sequencia,
			pls_obter_valor_prov_resumo(d.nr_seq_conta, d.nr_sequencia, d.vl_apresentado, d.vl_calculado, d.vl_liberado, d.vl_taxa_adm, d.vl_taxa_adm_co, d.vl_taxa_adm_mat, ie_forma_contab_taxa_pgto_w,'P') vl_provisao,
			coalesce(d.vl_glosa,0) vl_glosa,
			pls_obter_valor_prov_resumo(d.nr_seq_conta, d.nr_sequencia, d.vl_apresentado, d.vl_calculado, d.vl_liberado, d.vl_taxa_adm, d.vl_taxa_adm_co, d.vl_taxa_adm_mat, ie_forma_contab_taxa_pgto_w, 'A') vl_ajuste,
			coalesce(d.vl_taxa_adm,0) + coalesce(d.vl_taxa_adm_co,0) + coalesce(d.vl_taxa_adm_mat,0) vl_taxa_adm,
			a.ie_tipo_protocolo,
			a.nr_sequencia 	nr_doc_analitico,
			b.nr_sequencia	nr_seq_doc_compl,
			c.nr_sequencia	nr_documento,
			e.nm_tabela,
			e.nm_atributo,
			e.cd_tipo_lote_contabil,
			e.nr_seq_info,
			count(case e.ie_situacao_ctb when 'P' then 1 end) qt_pendente
		from	ctb_documento 		e,
			pls_conta_medica_resumo	d,
			pls_conta_proc		c,
			pls_conta		b,
			pls_protocolo_conta	a
		where	c.nr_sequencia		= d.nr_seq_conta_proc
		and	b.nr_sequencia		= d.nr_seq_conta
		and	b.nr_sequencia		= c.nr_seq_conta
		and	a.nr_sequencia		= b.nr_seq_protocolo
		and	d.nr_seq_conta		= nr_seq_conta_w
		and	a.cd_estabelecimento	= cd_estabelecimento_p
		and	ie_status_prov_pagto_w 	= 'F'
		and	e.nm_tabela 		= 'PLS_CONTA_MEDICA_RESUMO'
		and	e.nm_atributo		in ('VL_LIBERADO', 'VL_GLOSA', 'VL_AJUSTADO', 'VL_TAXA_PAGAMENTO')
		and	e.nr_documento 		= a.nr_sequencia
		and	e.nr_seq_doc_compl 	= b.nr_sequencia
		and	e.nr_doc_analitico	= d.nr_sequencia
		and	e.cd_tipo_lote_contabil = 40
		and	e.nr_seq_info		in (36, 24)
		and	coalesce(e.ds_origem, 'X') 	<> 'ESTORNO'
		group by d.nr_sequencia,
			d.nr_seq_conta,
			d.vl_apresentado,
			d.vl_calculado,
			d.vl_liberado,
			d.vl_taxa_adm,
			d.vl_taxa_adm_co,
			d.vl_taxa_adm_mat,
			d.vl_glosa,
			a.ie_tipo_protocolo,
			a.nr_sequencia,
			b.nr_sequencia,
			c.nr_sequencia,
			e.nm_tabela,
			e.nm_atributo,
			e.cd_tipo_lote_contabil,
			e.nr_seq_info
		
union all

		SELECT	d.nr_sequencia,
			pls_obter_valor_prov_resumo(d.nr_seq_conta, d.nr_sequencia, d.vl_apresentado, d.vl_calculado, d.vl_liberado, d.vl_taxa_adm, d.vl_taxa_adm_co, d.vl_taxa_adm_mat, ie_forma_contab_taxa_pgto_w,'P') vl_provisao,
			coalesce(d.vl_glosa,0) vl_glosa,
			pls_obter_valor_prov_resumo(d.nr_seq_conta, d.nr_sequencia, d.vl_apresentado, d.vl_calculado, d.vl_liberado, d.vl_taxa_adm, d.vl_taxa_adm_co, d.vl_taxa_adm_mat, ie_forma_contab_taxa_pgto_w, 'A') vl_ajuste,
			coalesce(d.vl_taxa_adm,0) + coalesce(d.vl_taxa_adm_co,0) + coalesce(d.vl_taxa_adm_mat,0) vl_taxa_adm,
			a.ie_tipo_protocolo,
			a.nr_sequencia 	nr_doc_analitico,
			b.nr_sequencia	nr_seq_doc_compl,
			c.nr_sequencia	nr_documento,
			e.nm_tabela,
			e.nm_atributo,
			e.cd_tipo_lote_contabil,
			e.nr_seq_info,
			count(case e.ie_situacao_ctb when 'P' then 1 end) qt_pendente
		from	ctb_documento 		e,
			pls_conta_medica_resumo	d,
			pls_conta_mat		c,
			pls_conta		b,
			pls_protocolo_conta	a
		where	c.nr_sequencia		= d.nr_seq_conta_mat
		and	b.nr_sequencia		= d.nr_seq_conta
		and	b.nr_sequencia		= c.nr_seq_conta
		and	a.nr_sequencia		= b.nr_seq_protocolo
		and	d.nr_seq_conta		= nr_seq_conta_w
		and	a.cd_estabelecimento	= cd_estabelecimento_p
		and	ie_status_prov_pagto_w 	= 'F'
		and	e.nm_tabela 		= 'PLS_CONTA_MEDICA_RESUMO'
		and	e.nm_atributo		in ('VL_LIBERADO', 'VL_GLOSA', 'VL_AJUSTADO', 'VL_TAXA_PAGAMENTO') 
		and	e.nr_documento 		= a.nr_sequencia
		and	e.nr_seq_doc_compl 	= b.nr_sequencia
		and	e.nr_doc_analitico	= d.nr_sequencia
		and	e.cd_tipo_lote_contabil = 40
		and	e.nr_seq_info		in (36, 24)
		and	coalesce(e.ds_origem, 'X') 	<> 'ESTORNO'
		group by d.nr_sequencia,
			d.nr_seq_conta,
			d.vl_apresentado,
			d.vl_calculado,
			d.vl_liberado,
			d.vl_taxa_adm,
			d.vl_taxa_adm_co,
			d.vl_taxa_adm_mat,
			d.vl_glosa,
			a.ie_tipo_protocolo,
			a.nr_sequencia,
			b.nr_sequencia,
			c.nr_sequencia,
			e.nm_tabela,
			e.nm_atributo,
			e.cd_tipo_lote_contabil,
			e.nr_seq_info;
		
	vet_valores_prov_prod		c_valores_prov_prod%rowtype;

BEGIN
	select	coalesce(max(ie_forma_contab_taxa_pgto),'N'),
		coalesce(max(ie_status_prov_pagto),'NC'),
		max(coalesce(ie_lote_ajuste_prod,'R'))
	into STRICT	ie_forma_contab_taxa_pgto_w,
		ie_status_prov_pagto_w,
		ie_lote_ajuste_prod_w
	from	pls_parametro_contabil
	where	cd_estabelecimento	= cd_estabelecimento_p;

	open c_contas;
	loop
	fetch c_contas into	
		nr_seq_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas */
		begin
		select	max(nr_seq_protocolo)
		into STRICT	nr_seq_protocolo_w
		from	pls_conta
		where	nr_sequencia	= nr_seq_conta_w;

		select	nr_seq_prestador_exec
		into STRICT	nr_seq_prestador_exec_w
		from	pls_conta
		where	nr_sequencia = nr_seq_conta_w;

		select 	coalesce(max(ie_tipo_relacao), 'X')
		into STRICT 	ie_tipo_relacao_w
		from 	pls_prestador
		where 	nr_sequencia = nr_seq_prestador_exec_w;

		select	coalesce(max('S'), 'N')
		into STRICT	ie_regra_recalculo_w
		from	pls_regra_lote_recalculo
		where	cd_estabelecimento = cd_estabelecimento_p
		and	ie_tipo_regra = 1
		and	ie_situacao = 'A';

		open c_valores_prov_prod;
			loop
			fetch c_valores_prov_prod into	
				vet_valores_prov_prod;
			EXIT WHEN NOT FOUND; /* apply on c_valores_prov_prod */
				begin
				-- Se o movimento original ainda nao foi contabilizado, deleta ele ao inves de gerar um movimento de estorno 
				if (vet_valores_prov_prod.qt_pendente > 0) then
					delete 	FROM ctb_documento
					where	nr_documento 			= nr_seq_protocolo_w
					and	nr_seq_doc_compl 		= nr_seq_conta_w
					and	nr_doc_analitico 		= vet_valores_prov_prod.nr_sequencia
					and 	nm_tabela 			= vet_valores_prov_prod.nm_tabela
					and	nm_atributo 			= vet_valores_prov_prod.nm_atributo
					and	cd_tipo_lote_contabil		= vet_valores_prov_prod.cd_tipo_lote_contabil
					and	nr_seq_info 			= vet_valores_prov_prod.nr_seq_info
					and	ie_situacao_ctb 		= 'P'
					and	coalesce(ds_origem, 'X') 		<> 'ESTORNO';
				else
					if (vet_valores_prov_prod.nm_atributo = 'VL_LIBERADO' and vet_valores_prov_prod.vl_provisao <> 0) then
						ie_inseriu_w := 'S';

						CALL ctb_concil_financeira_pck.ctb_gravar_documento(cd_estabelecimento_p,
												pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
												40,
												null,
												36,
												nr_seq_protocolo_w,
												nr_seq_conta_w,
												vet_valores_prov_prod.nr_sequencia,
												vet_valores_prov_prod.vl_provisao * -1, --Inverte o valor pois e um estorno
												'PLS_CONTA_MEDICA_RESUMO',
												vet_valores_prov_prod.nm_atributo,
												nm_usuario_p,
												'P',
												'ESTORNO');

					elsif (vet_valores_prov_prod.nm_atributo = 'VL_GLOSA' and vet_valores_prov_prod.vl_glosa <> 0) then
						ie_inseriu_w := 'S';

						CALL ctb_concil_financeira_pck.ctb_gravar_documento(cd_estabelecimento_p,
												pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
												40,
												null,
												24,
												nr_seq_protocolo_w,
												nr_seq_conta_w,
												vet_valores_prov_prod.nr_sequencia,
												vet_valores_prov_prod.vl_glosa * -1, --Inverte o valor pois e um estorno
												'PLS_CONTA_MEDICA_RESUMO',
												vet_valores_prov_prod.nm_atributo,
												nm_usuario_p,
												'P',
												'ESTORNO');

					elsif (vet_valores_prov_prod.nm_atributo = 'VL_AJUSTADO' and vet_valores_prov_prod.vl_ajuste <> 0
						and	ie_lote_ajuste_prod_w 	= 'P'
						and	vet_valores_prov_prod.ie_tipo_protocolo <> 'F') then
						ie_inseriu_w := 'S';

						CALL ctb_concil_financeira_pck.ctb_gravar_documento(cd_estabelecimento_p,
												pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
												40,
												null,
												36,
												nr_seq_protocolo_w,
												nr_seq_conta_w,
												vet_valores_prov_prod.nr_sequencia,
												vet_valores_prov_prod.vl_ajuste * -1, --Inverte o valor pois e um estorno
												'PLS_CONTA_MEDICA_RESUMO',
												vet_valores_prov_prod.nm_atributo,
												nm_usuario_p,
												'P',
												'ESTORNO');

					elsif (vet_valores_prov_prod.nm_atributo = 'VL_TAXA_PAGAMENTO' and vet_valores_prov_prod.vl_taxa_adm <> 0
						and coalesce(ie_forma_contab_taxa_pgto_w,'N') <> 'N') then
						ie_inseriu_w := 'S';

						CALL ctb_concil_financeira_pck.ctb_gravar_documento(cd_estabelecimento_p,
												pkg_date_utils.start_of(clock_timestamp(), 'DAY'),
												40,
												null,
												36,
												nr_seq_protocolo_w,
												nr_seq_conta_w,
												vet_valores_prov_prod.nr_sequencia,
												vet_valores_prov_prod.vl_taxa_adm * -1, --Invter o valor pois e um estorno
												'PLS_CONTA_MEDICA_RESUMO',
												vet_valores_prov_prod.nm_atributo,
												nm_usuario_p,
												'P',
												'ESTORNO');
					end if;
					if (coalesce(ie_inseriu_w, 'N') = 'S') then
						select 	*
						into STRICT 	ctb_doc_w
						from (SELECT 	*
							from   	ctb_documento a
							where 	a.nr_documento 		= nr_seq_protocolo_w
							and	a.nr_seq_doc_compl	= nr_seq_conta_w
							and	a.nr_doc_analitico	= vet_valores_prov_prod.nr_sequencia
							and	a.cd_tipo_lote_contabil = 40
							and	a.ie_situacao_ctb 	= 'P'
							order by nr_sequencia desc) alias2 LIMIT 1;

						CALL pls_contab_onl_lote_fin_pck.contabiliza_documento(ctb_doc_w, nm_usuario_p);
						ie_inseriu_w := 'N';
					end if;
				end if;
				end;
			end loop;
			close c_valores_prov_prod;
		end;
	end loop;
	close c_contas;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ctb_onl_gravar_movto_pck.gravar_movto_desf_lote_recalc ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
