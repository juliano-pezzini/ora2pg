-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_contab_desp ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar as movimentacoes contabies para os itens das contas 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------

Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_conteudo_w			varchar(4000);
vl_retorno_w			varchar(2000);
ds_item_w			varchar(255);
nm_prestador_w			varchar(255);
ds_compl_historico_w		varchar(255);
ds_compl_historico_ww		varchar(255);
nm_agrupador_w			varchar(255);
cd_conta_contabil_w		varchar(20);
ie_debito_credito_w		varchar(20);
cd_pessoa_fisica_w		varchar(20);
cd_cgc_prestador_w		varchar(14);
cd_cpf_prestador_w		varchar(11);
ie_tipo_item_w			varchar(10);
ie_proc_mat_w			varchar(2);
ie_compl_hist_w			varchar(2);
ie_regulamentacao_w		varchar(2);
ie_contab_item_cancel_w		varchar(2);
ie_centro_custo_w		varchar(1);
ie_esquema_contabil_w		varchar(1);
vl_contabil_w			double precision;
cd_procedimento_w		bigint;
nr_seq_w_movto_cont_w		bigint;
cd_historico_w			bigint;
nr_seq_conta_w			bigint;
nr_seq_item_w			bigint;
nr_lote_contabil_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_protocolo_w		bigint;
nr_seq_regra_cc_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_prot_conta_w		bigint;
nr_nota_fiscal_w		numeric(20);
qt_compl_hist_w			bigint;
ie_origem_proced_w		bigint;
nr_seq_material_w		bigint;
nr_seq_mvto_sem_conta_w		bigint;
nr_seq_agrupamento_w		bigint;
cd_centro_custo_w		integer;
cd_estabelecimento_w		smallint;
dt_referencia_w			timestamp;
dt_referencia_mens_w		timestamp;
dt_referencia_month_w		timestamp;
dt_ref_inicial_w		timestamp;
dt_ref_final_w			timestamp;

nr_seq_info_ctb_w		informacao_contabil.nr_sequencia%type;
nm_tabela_w			w_movimento_contabil.nm_tabela%type;
nm_atributo_w			w_movimento_contabil.nm_atributo%type;
cd_tipo_lote_contabil_w		lote_contabil.cd_tipo_lote_contabil%type;
ie_data_lote_desp_conta_w	pls_parametro_contabil.ie_data_lote_desp_conta%type;

dt_mes_ref_w			varchar(6);

c_itens_conta CURSOR FOR
	SELECT	'D', /* debito procedimento*/
		'P', /*Procedimento*/
		c.nr_sequencia,
		c.cd_conta_deb,
		(coalesce(c.vl_liberado, 0) + coalesce(c.vl_glosa, 0)),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_CONTA_PROC' nm_tabela,
		'VL_LIBERADO' nm_atributo,
		23 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	SELECT	'C', /* credito procedimento */
		'P', /*Procedimento*/
		c.nr_sequencia,
		c.cd_conta_cred,
		(coalesce(c.vl_liberado, 0) + coalesce(c.vl_glosa, 0)),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_CONTA_PROC' nm_tabela,
		'VL_LIBERADO' nm_atributo,
		23 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'D', /* debito material */
		'M', /*Material*/
	
		c.nr_sequencia,
		c.cd_conta_deb,
		(coalesce(c.vl_liberado, 0) + coalesce(c.vl_glosa, 0)),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_CONTA_MAT' nm_tabela,
		'VL_LIBERADO' nm_atributo,
		23 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'C', /* credito material */
		'M', /*Material*/
	
		c.nr_sequencia,
		c.cd_conta_cred,
		(coalesce(c.vl_liberado, 0) + coalesce(c.vl_glosa, 0)),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_CONTA_MAT' nm_tabela,
		'VL_LIBERADO' nm_atributo,
		23 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'C', /*Paulo - debito glosa procedimento - Invertido propositalmente conforme consultor Adriano*/
		'PG', /*Procedimento glosa*/
		c.nr_sequencia,
		CASE WHEN ie_esquema_contabil_w='S' THEN  c.cd_conta_glosa_cred  ELSE c.cd_conta_glosa_deb END ,
		coalesce(c.vl_glosa, 0),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico_glosa,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_CONTA_PROC' nm_tabela,
		'VL_GLOSA' nm_atributo,
		24 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	a.ie_tipo_protocolo	= 'C'
	and	coalesce(c.vl_glosa, 0) != 0
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'D', /*Paulo - credito glosa procedimento - Invertido propositalmente conforme consultor Adriano*/
		'PG', /*Procedimento glosa*/
		c.nr_sequencia,
		CASE WHEN ie_esquema_contabil_w='S' THEN  c.cd_conta_glosa_deb  ELSE c.cd_conta_glosa_cred END ,
		coalesce(c.vl_glosa, 0),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico_glosa,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_CONTA_PROC' nm_tabela,
		'VL_GLOSA' nm_atributo,
		24 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	coalesce(c.vl_glosa, 0) != 0
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'C', /*Paulo - debito glosa material - Invertido propositalmente conforme consultor Adriano*/
		'MG', /*Material glosa*/
	
		c.nr_sequencia,
		CASE WHEN ie_esquema_contabil_w='S' THEN  c.cd_conta_glosa_cred  ELSE c.cd_conta_glosa_deb END ,
		coalesce(c.vl_glosa, 0),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico_glosa,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_CONTA_MAT' nm_tabela,
		'VL_GLOSA' nm_atributo,
		24 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta 	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil	= nr_lote_contabil_p
	and	coalesce(c.vl_glosa, 0) != 0
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'))
	
union all

	select	'D', /* Paulo - credito glosa material - Invertido propositalmente conforme consultor Adriano*/
		'MG', /*Material glosa*/
	
		c.nr_sequencia,
		CASE WHEN ie_esquema_contabil_w='S' THEN  c.cd_conta_glosa_deb  ELSE c.cd_conta_glosa_cred END ,
		coalesce(c.vl_glosa, 0),
		CASE WHEN ie_data_lote_desp_conta_w='LI' THEN a.dt_lib_pagamento  ELSE a.dt_mes_competencia END ,
		c.cd_historico_glosa,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_prot_conta,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_CONTA_MAT' nm_tabela,
		'VL_GLOSA' nm_atributo,
		24 nr_seq_info_ctb,
		b.nr_seq_plano
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	b.nr_sequencia		= c.nr_seq_conta
	and	a.nr_sequencia		= b.nr_seq_protocolo
	and	a.nr_lote_contabil 	= nr_lote_contabil_p
	and	coalesce(c.vl_glosa, 0) != 0
	and	a.ie_tipo_protocolo	= 'C'
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'));

c_movimento_w CURSOR FOR
	SELECT	oid
	from	w_movimento_contabil
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
c_movimento CURSOR FOR
	SELECT	oid
	from	movimento_contabil
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
BEGIN
/*Validacao para impedir a geracao em lotes incorretos */

if (ie_exclusao_p <> 'S') then
        select b.cd_tipo_lote_contabil
        into STRICT cd_tipo_lote_contabil_w
        from lote_contabil b
        where b.nr_lote_contabil = nr_lote_contabil_p;
        if (cd_tipo_lote_contabil_w <> 22) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(261346);
        end if;
end if;
select	dt_referencia,
	cd_estabelecimento,
	nr_lote_contabil,
	cd_tipo_lote_contabil
into STRICT 	dt_referencia_w,
	cd_estabelecimento_w,
	nr_lote_contabil_w,
	cd_tipo_lote_contabil_w
from 	lote_contabil
where 	nr_lote_contabil 	= nr_lote_contabil_p;

select	max(coalesce(ie_data_lote_desp_conta,'CO'))
into STRICT	ie_data_lote_desp_conta_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_w;

dt_referencia_month_w	:= trunc(dt_referencia_w, 'month');

delete	from w_pls_movimento_sem_conta
where	cd_tipo_lote_contabil	= cd_tipo_lote_contabil_w
and	dt_referencia		= dt_referencia_month_w;

if (ie_exclusao_p = 'S') then
	CALL wheb_usuario_pck.set_ie_lote_contabil('S');
	
	for reg in c_movimento
		loop
		delete	from movimento_contabil
		where   rowid	= reg.rowid;
		end loop;
	
	commit;

	update	lote_contabil
	set	vl_credito 		= 0,
		vl_debito  		= 0,
		dt_geracao_lote		 = NULL
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	commit;
	
	update	pls_conta_proc a
	set	a.nr_lote_contabil	 = NULL
	where	a.nr_seq_conta	in (SELECT	x.nr_sequencia
					from	pls_conta		x,
						pls_protocolo_conta	y
					where	y.nr_sequencia		= x.nr_seq_protocolo
					and	y.nr_lote_contabil	= nr_lote_contabil_p);
					
	commit;
	
	update	pls_conta_mat a
	set	a.nr_lote_contabil	 = NULL
	where	a.nr_seq_conta	in (SELECT	x.nr_sequencia
					from	pls_conta		x,
						pls_protocolo_conta	y
					where	y.nr_sequencia		= x.nr_seq_protocolo
					and	y.nr_lote_contabil	= nr_lote_contabil_p);
					
	commit;

	update	pls_protocolo_conta
	set	nr_lote_contabil	= 0
	where	nr_lote_contabil 	= nr_lote_contabil_p;
	
	commit;

	CALL wheb_usuario_pck.set_ie_lote_contabil('N');
else
	dt_ref_inicial_w	:= trunc(trunc(dt_referencia_w, 'month'),'dd');
	dt_ref_final_w		:= fim_dia(fim_mes(dt_ref_inicial_w));

	select	max(ie_esquema_contabil),
		max(ie_contab_proc_cancel)
	into STRICT	ie_esquema_contabil_w,
		ie_contab_item_cancel_w
	from	pls_parametro_contabil
	where	cd_estabelecimento	= cd_estabelecimento_w;

	ie_esquema_contabil_w	:= coalesce(ie_esquema_contabil_w, 'N');
	ie_contab_item_cancel_w	:= coalesce(ie_contab_item_cancel_w, 'S');

	CALL wheb_usuario_pck.set_ie_lote_contabil('S');
	
	for reg in c_movimento_w
		loop
		delete	from w_movimento_contabil
		where   rowid	= reg.rowid;
		end loop;
	
	commit;
	
	if (ie_data_lote_desp_conta_w = 'LI') then
		update	pls_protocolo_conta
		set	nr_lote_contabil 			= nr_lote_contabil_p
		where 	coalesce(nr_lote_contabil,0) 		= 0
		and	dt_lib_pagamento between dt_ref_inicial_w and dt_ref_final_w
		and	trunc(dt_lib_pagamento)			<= dt_referencia_w
		and	cd_estabelecimento			= cd_estabelecimento_w
		and	ie_tipo_protocolo			= 'C'
		and	ie_situacao				!= 'RE'
		and	ie_status in (3,4,6);
	else
		update	pls_protocolo_conta
		set	nr_lote_contabil 			= nr_lote_contabil_p
		where 	coalesce(nr_lote_contabil,0) 		= 0
		and	dt_mes_competencia between dt_ref_inicial_w and dt_ref_final_w
		and	cd_estabelecimento			= cd_estabelecimento_w
		and	ie_tipo_protocolo			= 'C'
		and	ie_situacao				!= 'RE'
		and	ie_status in (3,4,6);
	end if;	
	
	commit;
	
	update	pls_conta_proc		c
	set	c.nr_lote_contabil 	= nr_lote_contabil_p
	where	exists (SELECT	1
			from	pls_conta		b,
				pls_protocolo_conta	a
			where	b.nr_sequencia		= c.nr_seq_conta
			and	a.nr_sequencia		= b.nr_seq_protocolo
			and	a.nr_lote_contabil	= nr_lote_contabil_p
			and	a.ie_tipo_protocolo	= 'C')
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'));
	
	commit;

	update	pls_conta_mat		c
	set	c.nr_lote_contabil 	= nr_lote_contabil_p
	where	exists (SELECT	1
			from	pls_conta		b,
				pls_protocolo_conta	a
			where	b.nr_sequencia		= c.nr_seq_conta
			and	a.nr_sequencia		= b.nr_seq_protocolo
			and	a.nr_lote_contabil	= nr_lote_contabil_p
			and	a.ie_tipo_protocolo	= 'C')
	and	((c.ie_status  <> 'D') or (ie_contab_item_cancel_w = 'S'));
	
	commit;
	
	CALL wheb_usuario_pck.set_ie_lote_contabil('N');
	
	nm_agrupador_w	:= coalesce(trim(both obter_agrupador_contabil(cd_tipo_lote_contabil_w)),'NR_SEQ_CONTA');
	dt_mes_ref_w	:= to_char(dt_referencia_w,'mmyyyy');
	
	/*  Paulo 29/09/2009 - OS 168594 */

	ie_compl_hist_w	:= obter_se_compl_tipo_lote(cd_estabelecimento_w, cd_tipo_lote_contabil_w);
	
	nr_seq_w_movto_cont_w	:= 0;
	
	open c_itens_conta;
	loop
	fetch c_itens_conta into
		ie_debito_credito_w,
		ie_proc_mat_w,
		nr_seq_item_w,
		cd_conta_contabil_w,
		vl_contabil_w,
		dt_referencia_mens_w,
		cd_historico_w,
		nr_seq_conta_w,
		nr_seq_segurado_w,
		nr_seq_prot_conta_w,
		nr_seq_protocolo_w,
		nr_seq_prestador_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_material_w,
		nm_tabela_w,
		nm_atributo_w,
		nr_seq_info_ctb_w,
		nr_seq_plano_w;
	EXIT WHEN NOT FOUND; /* apply on c_itens_conta */
		begin
		cd_centro_custo_w	:= null;
		nr_nota_fiscal_w	:= null;
		ds_compl_historico_w	:= null;
		
		if (coalesce(cd_conta_contabil_w::text, '') = '') then
			if (substr(ie_proc_mat_w, 1, 1) = 'P') then
				ie_tipo_item_w	:= 'PCM';
				ds_item_w	:= substr(obter_descricao_procedimento(cd_procedimento_w, ie_origem_proced_w), 1, 255);
			else
				ie_tipo_item_w	:= 'MCM';
				
				select	max(a.ds_material)
				into STRICT	ds_item_w
				from	pls_material	a
				where	a.nr_sequencia	= nr_seq_material_w;
			end if;
			
			select	nextval('w_pls_movimento_sem_conta_seq')
			into STRICT	nr_seq_mvto_sem_conta_w
			;
			
			insert into w_pls_movimento_sem_conta(nr_sequencia,
				cd_item,
				ds_item,
				ie_tipo_item,
				dt_atualizacao,
				nm_usuario,
				vl_item,
				dt_referencia,
				nr_lote_contabil,
				ie_proc_mat_item,
				ie_deb_cred,
				ds_observacao,
				cd_tipo_lote_contabil)
			values (nr_seq_mvto_sem_conta_w,
				nr_seq_item_w,
				ds_item_w,
				ie_tipo_item_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_contabil_w,
				dt_referencia_month_w,
				nr_lote_contabil_w,
				ie_proc_mat_w,
				ie_debito_credito_w,
				CASE WHEN substr(ie_proc_mat_w, 2, 1)='G' THEN  obter_desc_expressao(290935)  ELSE '' END ,
				cd_tipo_lote_contabil_w);
		else
			if (coalesce(nr_seq_plano_w::text, '') = '') then
				begin		
				select	b.ie_regulamentacao,
					b.nr_sequencia
				into STRICT	ie_regulamentacao_w,
					nr_seq_plano_w
				from	pls_segurado a,
					pls_plano b
				where	b.nr_sequencia  = a.nr_seq_plano
				and	a.nr_sequencia	= nr_seq_segurado_w;
				exception
				when others then
					ie_regulamentacao_w	:= null;
					nr_seq_plano_w		:= null;
				end;
			else
				begin		
				select	b.ie_regulamentacao
				into STRICT	ie_regulamentacao_w
				from	pls_plano b
				where	b.nr_sequencia  = nr_seq_plano_w;
				exception
				when others then
					ie_regulamentacao_w	:= null;
				end;
			end if;
			
			if (nm_agrupador_w = 'NR_SEQ_CONTA') then
				nr_seq_agrupamento_w	:= nr_seq_conta_w;
			elsif (nm_agrupador_w = 'DT_MES_REF') then
				nr_seq_agrupamento_w	:= dt_mes_ref_w;
			elsif (nm_agrupador_w = 'NR_SEQ_PROTOCOLO') then
				nr_seq_agrupamento_w	:= nr_seq_protocolo_w;
			end if;
			
			if (coalesce(nr_seq_agrupamento_w,0) = 0)then
				nr_seq_agrupamento_w	:= nr_seq_conta_w;
			end if;
			
			select	ie_centro_custo
			into STRICT	ie_centro_custo_w
			from	conta_contabil
			where	cd_conta_contabil	= cd_conta_contabil_w;
			
			if (ie_centro_custo_w = 'S') then
				SELECT * FROM pls_obter_centro_custo(	'D', nr_seq_plano_w, cd_estabelecimento_w, '', '', ie_regulamentacao_w, nr_seq_segurado_w, '', cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
			end if;
			
			if (coalesce(cd_historico_w::text, '') = '') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(0 , 'NR_SEQ_CONTA=' || nr_seq_conta_w);
			else
				if (ie_compl_hist_w = 'S') then
					select	count(*)
					into STRICT	qt_compl_hist_w
					from	historico_padrao_atributo
					where	cd_tipo_lote_contabil	= 22
					and	cd_historico		= cd_historico_w  LIMIT 1;
					
					if (qt_compl_hist_w > 0) then
						if (coalesce(nr_seq_prestador_w,0) > 0) then
							select	a.cd_pessoa_fisica,
								a.cd_cgc
							into STRICT	cd_pessoa_fisica_w,
								cd_cgc_prestador_w
							from	pls_prestador	a
							where	a.nr_sequencia	= nr_seq_prestador_w;
							
							begin
							nm_prestador_w	:= substr(obter_nome_pf_pj(cd_pessoa_fisica_w, cd_cgc_prestador_w),1,255);
							exception
							when others then
								nm_prestador_w	:= null;
							end;
							
							select	max(nr_cpf)
							into STRICT	cd_cpf_prestador_w
							from	pessoa_fisica
							where	cd_pessoa_fisica	= cd_pessoa_fisica_w;	
						end if;
						
						select	max(nr_nota_fiscal)
						into STRICT	nr_nota_fiscal_w
						from	pls_prot_conta_titulo
						where	nr_sequencia	= nr_seq_prot_conta_w;
						
						ds_conteudo_w	:= substr(	nr_seq_prestador_w	|| '#@' ||
										nm_prestador_w 		|| '#@' ||
										nr_seq_protocolo_w	|| '#@' ||
										nr_seq_conta_w		|| '#@' ||
										cd_cgc_prestador_w	|| '#@' ||
										cd_cpf_prestador_w	|| '#@'	||
										nr_nota_fiscal_w,1,4000);
						
						begin
						ds_compl_historico_ww	:= substr(obter_compl_historico(cd_tipo_lote_contabil_w, cd_historico_w, ds_conteudo_w), 1, 255);
						exception
						when others then
							ds_compl_historico_ww	:= null;
						end;
						
						ds_compl_historico_w	:= substr(ds_compl_historico_ww, 1, 255);
					end if;
				end if;
			end if;
			
			nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;
			
			insert into w_movimento_contabil(nr_lote_contabil,
				nr_sequencia,
				cd_conta_contabil,
				ie_debito_credito,
				cd_historico,
				dt_movimento,
				vl_movimento,
				cd_estabelecimento,
				cd_centro_custo,
				ds_compl_historico,
				nr_seq_agrupamento,
				nr_seq_tab_orig,
				nr_seq_info,
				nm_tabela,
				nm_atributo)
			values (nr_lote_contabil_p,
				nr_seq_w_movto_cont_w,
				cd_conta_contabil_w,
				ie_debito_credito_w,
				cd_historico_w,
				dt_referencia_mens_w,
				vl_contabil_w,
				cd_estabelecimento_w,
				cd_centro_custo_w,
				ds_compl_historico_w,
				nr_seq_agrupamento_w,
				nr_seq_item_w,
				nr_seq_info_ctb_w,
				nm_tabela_w,
				nm_atributo_w);
		end if;
		end;
	end loop;
	close c_itens_conta;
	
	CALL agrupa_movimento_contabil(	nr_lote_contabil_p,
					nm_usuario_p);
end if;

if (coalesce(ds_retorno_p::text, '') = '') then
	begin
	update	lote_contabil
	set	ie_situacao 		= 'A',
		dt_geracao_lote		= CASE WHEN ie_exclusao_p='N' THEN clock_timestamp() WHEN ie_exclusao_p='S' THEN null END
	where	nr_lote_contabil 	= nr_lote_contabil_p;
	
      	if (ie_exclusao_p	= 'S') then
		ds_retorno_p		:= wheb_mensagem_pck.get_texto(165188);
	else
		ds_retorno_p		:= wheb_mensagem_pck.get_texto(165187);
	end if;
	
	commit;
	end;
else
	rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_contab_desp ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) FROM PUBLIC;
