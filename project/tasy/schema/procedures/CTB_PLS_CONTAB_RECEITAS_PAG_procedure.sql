-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_contab_receitas_pag ( nr_lote_contabil_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w			timestamp;
cd_estabelecimento_w		smallint;
nr_lote_contabil_w		bigint;
nr_seq_mensalidade_w		bigint;
dt_referencia_mens_w		timestamp;
nr_seq_nota_fiscal_w		bigint;
nr_seq_pagador_w		bigint;
ie_cancelamento_w		varchar(2);
nr_lote_contab_antecip_w	bigint;
nr_titulo_w			bigint;
ie_tipo_pagador_w		varchar(2);
cd_cgc_pagador_w		varchar(14);
cd_pf_pagador_w			varchar(10);
vl_imposto_w			double precision;
cd_conta_imposto_cred_w		varchar(20);
cd_historico_imposto_cred_w	bigint;
ds_compl_hist_imposto_cred_ww	varchar(255);
ds_compl_hist_imposto_cred_w	varchar(255);
nr_seq_w_movto_cont_w		bigint;
cd_conta_imposto_deb_w		varchar(20);
cd_historico_imposto_deb_w	bigint;
ds_conteudo_w			varchar(255)	:= '';
ds_compl_hist_imposto_deb_ww	varchar(255);
ds_compl_hist_imposto_deb_w	varchar(255);
nr_nota_fiscal_w		varchar(255);
nm_pagador_w			varchar(255);
cd_conta_estorno_cred_w		varchar(20);
cd_conta_estorno_deb_w		varchar(20);
nr_seq_lote_mens_w		bigint;
qt_compl_hist_cred_w		bigint;
qt_compl_hist_deb_w		bigint;
dt_antecipacao_w		timestamp;
dt_mesano_referencia_w		timestamp;
dt_referencia_mov_w		timestamp;
nm_agrupador_w			varchar(255);
nr_seq_agrupamento_w		bigint;
dt_ref_inicial_w		timestamp;
dt_ref_final_w			timestamp;
nr_seq_info_ctb_w		informacao_contabil.nr_sequencia%type;
nm_tabela_w			w_movimento_contabil.nm_tabela%type;
nm_atributo_w			w_movimento_contabil.nm_atributo%type;
nr_seq_tab_orig_w		w_movimento_contabil.nr_seq_tab_orig%type;
nr_seq_tab_compl_w		w_movimento_contabil.nr_seq_tab_compl%type;


c_item CURSOR FOR
	SELECT	b.nr_sequencia,
		b.dt_referencia,
		d.nr_sequencia,
		b.nr_seq_pagador,
		b.ie_cancelamento,
		a.nr_lote_contab_antecip,
		c.nr_titulo,
		a.nr_sequencia,
		a.dt_contabilizacao,
		a.dt_mesano_referencia
	FROM nota_fiscal d, pls_lote_mensalidade a, pls_mensalidade b
LEFT OUTER JOIN titulo_receber c ON (b.nr_sequencia = c.nr_seq_mensalidade)
WHERE a.nr_sequencia			= b.nr_seq_lote  and d.nr_seq_mensalidade		= b.nr_sequencia and a.nr_lote_contabil		= nr_lote_contabil_p
	
union

	SELECT	b.nr_sequencia,
		b.dt_referencia,
		d.nr_sequencia,
		b.nr_seq_pagador,
		b.ie_cancelamento,
		a.nr_lote_contab_antecip,
		c.nr_titulo,
		a.nr_sequencia,
		a.dt_contabilizacao,
		a.dt_mesano_referencia
	FROM nota_fiscal d, pls_lote_mensalidade a, pls_mensalidade b
LEFT OUTER JOIN titulo_receber c ON (b.nr_sequencia = c.nr_seq_mensalidade)
WHERE a.nr_sequencia			= b.nr_seq_lote  and d.nr_seq_mensalidade		= b.nr_sequencia and a.nr_lote_contab_antecip	= nr_lote_contabil_p and coalesce(b.ie_cancelamento::text, '') = '';

nr_vetor_w			bigint	:= 0;
type registro is table of w_movimento_contabil%RowType index by integer;
w_movto_contabil_w		registro;


BEGIN
nr_seq_w_movto_cont_w	:= 0;

select	dt_referencia,
	cd_estabelecimento,
	nr_lote_contabil
into STRICT 	dt_referencia_w,
	cd_estabelecimento_w,
	nr_lote_contabil_w
from 	lote_contabil
where 	nr_lote_contabil 	= nr_lote_contabil_p;

dt_ref_inicial_w	:= trunc(dt_referencia_w,'dd');
dt_ref_final_w		:= fim_dia(fim_mes(dt_referencia_w));

/*update	pls_lote_mensalidade
set	nr_lote_contabil	= nr_lote_contabil_p
where	nvl(nr_lote_contabil,0)	= 0
and	ie_status		= 2
and	cd_estabelecimento	= cd_estabelecimento_w
and	dt_mesano_referencia between dt_ref_inicial_w and dt_ref_final_w;
--and	trunc(dt_mesano_referencia,'month') = trunc(dt_referencia_w, 'month')
update	pls_lote_mensalidade
set	nr_lote_contab_antecip	= nr_lote_contabil_p
where	nvl(nr_lote_contab_antecip,0)	= 0
and	ie_status			= 2
and	cd_estabelecimento		= cd_estabelecimento_w
and	dt_contabilizacao between dt_ref_inicial_w and dt_ref_final_w;
--and	trunc(dt_contabilizacao,'month') = trunc(dt_referencia_w, 'month');*/
nm_agrupador_w		:= trim(obter_agrupador_contabil(21));
nr_seq_info_ctb_w	:= 55;
nm_tabela_w		:= 'NOTA_FISCAL';
nm_atributo_w		:= 'VL_TRIBUTO';

open c_item;
loop
fetch c_item into
	nr_seq_mensalidade_w,
	dt_referencia_mens_w,
	nr_seq_nota_fiscal_w,
	nr_seq_pagador_w,
	ie_cancelamento_w,
	nr_lote_contab_antecip_w,
	nr_titulo_w,
	nr_seq_lote_mens_w,
	dt_antecipacao_w,
	dt_mesano_referencia_w;
exit when c_item%notfound;
	begin
	/* Obter o valor total dos impostos */

	select	coalesce(sum(vl_tributo),0)
	into STRICT	vl_imposto_w
	from	nota_fiscal_trib
	where	nr_sequencia = nr_seq_nota_fiscal_w;

	select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN 'PJ'  ELSE 'PF' END ,
		cd_cgc,
		cd_pessoa_fisica
	into STRICT	ie_tipo_pagador_w,
		cd_cgc_pagador_w,
		cd_pf_pagador_w
	from	pls_contrato_pagador
	where	nr_sequencia	= nr_seq_pagador_w;

	/* Obter a conta de crédito do imposto */

	select	max(cd_conta_contabil),
		max(cd_historico),
		max(cd_conta_estorno)
	into STRICT	cd_conta_imposto_cred_w,
		cd_historico_imposto_cred_w,
		cd_conta_estorno_cred_w
	from	pls_conta_contabil_imposto
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	trunc(clock_timestamp(),'dd') between trunc(dt_vigencia_inicial,'dd') and trunc(coalesce(dt_vigencia_final,clock_timestamp()),'dd')
	and	coalesce(ie_debito_credito,'C') = 'C'
	and	((ie_tipo_pessoa = ie_tipo_pagador_w) or (ie_tipo_pessoa = 'A'));

	/* Obter a conta de débito do imposto */

	select	max(cd_conta_contabil),
		max(cd_historico),
		max(cd_conta_estorno)
	into STRICT	cd_conta_imposto_deb_w,
		cd_historico_imposto_deb_w,
		cd_conta_estorno_deb_w
	from	pls_conta_contabil_imposto
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	trunc(clock_timestamp(),'dd') between trunc(dt_vigencia_inicial,'dd') and trunc(coalesce(dt_vigencia_final,clock_timestamp()),'dd')
	and	coalesce(ie_debito_credito,'D') = 'D'
	and	((ie_tipo_pessoa = ie_tipo_pagador_w) or (ie_tipo_pessoa = 'A'));

	select	count(1)
	into STRICT	qt_compl_hist_cred_w
	from	historico_padrao_atributo
	where	cd_tipo_lote_contabil	= 21
	and	cd_historico		= cd_historico_imposto_cred_w  LIMIT 1;

	select	count(1)
	into STRICT	qt_compl_hist_deb_w
	from	historico_padrao_atributo
	where	cd_tipo_lote_contabil	= 21
	and	cd_historico		= cd_historico_imposto_deb_w  LIMIT 1;

	if	((qt_compl_hist_cred_w > 0) or (qt_compl_hist_deb_w > 0)) then
		select (	select	x.nm_pessoa_fisica
				from	pessoa_fisica x
				where	x.cd_pessoa_fisica = a.cd_pessoa_fisica
				
union all

				select	y.ds_razao_social
				from	pessoa_juridica y
				where	y.cd_cgc	= a.cd_cgc)
		into STRICT	nm_pagador_w
		from	pls_contrato_pagador	a
		where	a.nr_sequencia		= nr_seq_pagador_w;

		select	max(nr_nota_fiscal)
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	nr_sequencia	= nr_seq_nota_fiscal_w;

		nr_nota_fiscal_w	:= somente_numero(nr_nota_fiscal_w);
	end if;

	/* Lepinski - OS 456905 - Definir o agrupador contábil */

	if (nm_agrupador_w = 'NR_SEQ_LOTE') then
		nr_seq_agrupamento_w	:= nr_seq_lote_mens_w;
	elsif (nm_agrupador_w = 'NR_SEQ_PAGADOR') then
		nr_seq_agrupamento_w	:= nr_seq_pagador_w;
	elsif (nm_agrupador_w = 'NR_TITULO') then
		nr_seq_agrupamento_w	:= nr_titulo_w;
	else
		nr_seq_agrupamento_w	:= null;
	end if;

	if (nr_lote_contab_antecip_w = nr_lote_contabil_p) then
		dt_referencia_mov_w := dt_antecipacao_w;
	elsif (trunc(dt_referencia_mens_w,'month') <> trunc(dt_mesano_referencia_w,'month')) then
		dt_referencia_mov_w	:= dt_referencia_mens_w;
	else
		dt_referencia_mov_w	:= dt_mesano_referencia_w;
	end if;

	if (coalesce(cd_conta_imposto_cred_w,'0') <> '0') and (vl_imposto_w > 0) then

		if (coalesce(cd_historico_imposto_cred_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(200300, null);
		elsif (qt_compl_hist_cred_w > 0) then
			ds_conteudo_w	:= substr(	nr_nota_fiscal_w	|| '#@' ||
							cd_cgc_pagador_w 	|| '#@' ||
							cd_pf_pagador_w		|| '#@' ||
							nr_titulo_w		|| '#@' ||
							nm_pagador_w		|| '#@' ||
							nr_seq_lote_mens_w,1,4000);

			select	obter_compl_historico(21, cd_historico_imposto_cred_w, ds_conteudo_w)
			into STRICT	ds_compl_hist_imposto_cred_ww
			;

			ds_compl_hist_imposto_cred_w	:= substr(ds_compl_hist_imposto_cred_ww,1,255);
		end if;

		nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

		nr_vetor_w		:= nr_vetor_w + 1;
		w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
		w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
		w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_imposto_cred_w;
		w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= 'C';
		w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_imposto_cred_w;
		w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
		w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_imposto_w;
		w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
		w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= null;
		w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_hist_imposto_cred_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
		w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_nota_fiscal_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
		w_movto_contabil_w[nr_vetor_w].nm_atributo		:= nm_atributo_w;

		/* Lepinski - OS 282716 - Contabilizar estorno de imposto de nota fiscal cancelada */

		if (ie_cancelamento_w = 'C') then
			if (coalesce(cd_conta_estorno_cred_w,'0') <> '0') then
				nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

				nr_vetor_w		:= nr_vetor_w + 1;
				w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
				w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
				w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_estorno_cred_w;
				w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= 'C';
				w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_imposto_cred_w;
				w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
				w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_imposto_w;
				w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
				w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= null;
				w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_hist_imposto_cred_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
				w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_nota_fiscal_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
				w_movto_contabil_w[nr_vetor_w].nm_atributo		:= nm_atributo_w;
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 190488, null);
				/* Falta cadastrar a conta contábil de crédito para estorno de impostos! (OPS - Critérios Contábeis -> Regra de contabilização dos impostos). */

			end if;
		end if;
	end if;

	if (coalesce(cd_conta_imposto_deb_w,'0') <> '0') and (vl_imposto_w > 0) then
		if (coalesce(cd_historico_imposto_deb_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort( 200300, null);
		elsif (qt_compl_hist_deb_w > 0) then
			ds_conteudo_w	:= substr(	nr_nota_fiscal_w	|| '#@' ||
							cd_cgc_pagador_w 	|| '#@' ||
							cd_pf_pagador_w		|| '#@' ||
							nr_titulo_w		|| '#@' ||
							nm_pagador_w		|| '#@' ||
							nr_seq_lote_mens_w,1,4000);

			select	obter_compl_historico(21, cd_historico_imposto_deb_w, ds_conteudo_w)
			into STRICT	ds_compl_hist_imposto_deb_ww
			;

			ds_compl_hist_imposto_deb_w	:= substr(ds_compl_hist_imposto_deb_ww,1,255);
		end if;

		nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

		nr_vetor_w		:= nr_vetor_w + 1;
		w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
		w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
		w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_imposto_deb_w;
		w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= 'D';
		w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_imposto_deb_w;
		w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
		w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_imposto_w;
		w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
		w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= null;
		w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_hist_imposto_deb_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
		w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_nota_fiscal_w;
		w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
		w_movto_contabil_w[nr_vetor_w].nm_atributo		:= nm_atributo_w;

		/* Lepinski - OS 282716 - Contabilizar estorno de imposto de nota fiscal cancelada */

		if (ie_cancelamento_w = 'C') then
			if (coalesce(cd_conta_estorno_deb_w,'0') <> '0') then
				nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

				nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

				nr_vetor_w		:= nr_vetor_w + 1;
				w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
				w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
				w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_estorno_deb_w;
				w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= 'D';
				w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_imposto_deb_w;
				w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
				w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_imposto_w;
				w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
				w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= null;
				w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_hist_imposto_deb_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
				w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_nota_fiscal_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
				w_movto_contabil_w[nr_vetor_w].nm_atributo		:= nm_atributo_w;
			else
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 190489, null);
				/* Falta cadastrar a conta contábil de débito para estorno de impostos! (OPS - Critérios Contábeis -> Regra de contabilização dos impostos). */

			end if;
		end if;
	end if;

	if (nr_vetor_w >= 1000) then
		forall m in w_movto_contabil_w.first..w_movto_contabil_w.last
			insert into w_movimento_contabil values w_movto_contabil_w(m);

		nr_vetor_w	:= 0;
		w_movto_contabil_w.delete;

		commit;
	end if;
	end;
end loop;
close c_item;

if (nr_vetor_w > 0) then
	forall m in w_movto_contabil_w.first..w_movto_contabil_w.last
		insert into w_movimento_contabil values w_movto_contabil_w(m);

	nr_vetor_w	:= 0;
	w_movto_contabil_w.delete;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_contab_receitas_pag ( nr_lote_contabil_p bigint, nm_usuario_p text) FROM PUBLIC;

