-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_contab_cancel_fat ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Contabilizar os valores cancelados dos lotes de faturamento
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
	As informacoes de conta contabil, historico e valores, sao buscadas das tabelas
	pls_fatura_proc e pls_fatura_mat, demais informacoes sao buscadas da conta
	medica.
-------------------------------------------------------------------------------------------------------------------

Referencias:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_estabelecimento_w		w_movimento_contabil.cd_estabelecimento%type;
cd_conta_contabil_w		w_movimento_contabil.cd_conta_contabil%type;
vl_contabil_w			w_movimento_contabil.vl_movimento%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
ie_centro_custo_w		conta_contabil.ie_centro_custo%type;
nr_lote_contabil_w		lote_contabil.nr_lote_contabil%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
cd_cgc_prestador_w		pls_prestador.cd_cgc%type;
cd_cpf_prestador_w		pessoa_fisica.nr_cpf%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_prot_conta_w		pls_prot_conta_titulo.nr_sequencia%type;
nr_nota_fiscal_w		pls_prot_conta_titulo.nr_nota_fiscal%type;
cd_procedimento_w		pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w		pls_conta_proc.ie_origem_proced%type;
nr_seq_material_w		pls_conta_mat.nr_seq_material%type;
nr_seq_info_ctb_w		informacao_contabil.nr_sequencia%type;
nm_tabela_w			w_movimento_contabil.nm_tabela%type;
nm_atributo_w			w_movimento_contabil.nm_atributo%type;
cd_tipo_lote_contabil_w		lote_contabil.cd_tipo_lote_contabil%type;
nm_agrupador_w			agrupador_contabil.nm_atributo%type;
nr_seq_agrupamento_w		w_movimento_contabil.nr_seq_agrupamento%type;
ds_conteudo_w			varchar(4000);
vl_retorno_w			varchar(2000);
ds_item_w			varchar(255);
nm_prestador_w			varchar(255);
ds_compl_historico_w		varchar(255);
ds_compl_historico_ww		varchar(255);
ie_debito_credito_w		varchar(20);
ie_tipo_item_w			varchar(10);
ie_proc_mat_w			varchar(2);
ie_compl_hist_w			varchar(2);
nr_seq_w_movto_cont_w		bigint;
cd_historico_w			bigint;
nr_seq_item_w			bigint;
nr_seq_regra_cc_w		bigint;
cd_centro_custo_w		integer;
dt_referencia_w			timestamp;
dt_referencia_mens_w		timestamp;
dt_referencia_month_w		timestamp;
dt_ref_inicial_w		timestamp;
dt_ref_final_w			timestamp;

c_itens_cancelados CURSOR FOR
	SELECT	'D', /* debito procedimento*/
		'P', /*Procedimento*/
		d.nr_sequencia,
		d.cd_conta_debito,
		coalesce(d.vl_faturado,0),
		trunc(i.dt_referencia,'month'),
		d.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		b.nr_seq_prot_conta,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_FATURA_PROC' nm_tabela,
		'VL_FATURADO' nm_atributo,
		b.nr_seq_plano
	from	pls_fatura_proc 	d,
		pls_conta_proc		c,
		pls_conta 		b,
		pls_fatura_conta	g,
		pls_fatura_evento	e,
		pls_fatura		f,
		pls_cancel_rec_fatura 	h,
		pls_cancel_rec_fat_lote	i
	where	c.nr_sequencia		= d.nr_seq_conta_proc
	and	g.nr_sequencia		= d.nr_seq_fatura_conta
	and	b.nr_sequencia		= c.nr_seq_conta
	and	b.nr_sequencia		= g.nr_seq_conta
	and	e.nr_sequencia		= g.nr_seq_fatura_evento
	and	f.nr_sequencia		= e.nr_seq_fatura
	and	h.nr_sequencia		= f.nr_seq_cancel_fat
	and	i.nr_sequencia		= h.nr_seq_lote
	and	i.nr_lote_contabil	= nr_lote_contabil_p
	
union all

	SELECT	'C', /* credito procedimento */
		'P', /*Procedimento*/
		d.nr_sequencia,
		d.cd_conta_credito,
		coalesce(d.vl_faturado,0),
		trunc(i.dt_referencia,'month'),
		d.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		b.nr_seq_prot_conta,
		c.cd_procedimento,
		c.ie_origem_proced,
		null nr_seq_material,
		'PLS_FATURA_PROC' nm_tabela,
		'VL_FATURADO' nm_atributo,
		b.nr_seq_plano
	from	pls_fatura_proc 	d,
		pls_conta_proc		c,
		pls_conta 		b,
		pls_fatura_conta	g,
		pls_fatura_evento	e,
		pls_fatura		f,
		pls_cancel_rec_fatura 	h,
		pls_cancel_rec_fat_lote	i
	where	c.nr_sequencia		= d.nr_seq_conta_proc
	and	g.nr_sequencia		= d.nr_seq_fatura_conta
	and	b.nr_sequencia		= c.nr_seq_conta
	and	b.nr_sequencia		= g.nr_seq_conta
	and	e.nr_sequencia		= g.nr_seq_fatura_evento
	and	f.nr_sequencia		= e.nr_seq_fatura
	and	h.nr_sequencia		= f.nr_seq_cancel_fat
	and	i.nr_sequencia		= h.nr_seq_lote
	and	i.nr_lote_contabil	= nr_lote_contabil_p
	
union all

	select	'D', /* debito material */
		'M', /*Material*/
	
		d.nr_sequencia,
		d.cd_conta_debito,
		coalesce(d.vl_faturado,0),
		trunc(i.dt_referencia,'month'),
		d.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		b.nr_seq_prot_conta,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_FATURA_MAT' nm_tabela,
		'VL_FATURADO' nm_atributo,
		b.nr_seq_plano
	from	pls_fatura_mat		d,
		pls_conta_mat 		c,
		pls_conta 		b,
		pls_fatura_conta	g,
		pls_fatura_evento	e,
		pls_fatura		f,
		pls_cancel_rec_fatura 	h,
		pls_cancel_rec_fat_lote	i
	where	c.nr_sequencia		= d.nr_seq_conta_mat
	and	g.nr_sequencia		= d.nr_seq_fatura_conta
	and	b.nr_sequencia		= c.nr_seq_conta
	and	b.nr_sequencia		= g.nr_seq_conta
	and	e.nr_sequencia		= g.nr_seq_fatura_evento
	and	f.nr_sequencia		= e.nr_seq_fatura
	and	h.nr_sequencia		= f.nr_seq_cancel_fat
	and	i.nr_sequencia		= h.nr_seq_lote
	and	i.nr_lote_contabil	= nr_lote_contabil_p
	
union all

	select	'C', /* credito material */
		'M', /*Material*/
	
		d.nr_sequencia,
		d.cd_conta_credito,
		coalesce(d.vl_faturado,0),
		trunc(i.dt_referencia,'month'),
		d.cd_historico,
		b.nr_sequencia,
		b.nr_seq_segurado,
		b.nr_seq_protocolo,
		b.nr_seq_prestador_exec,
		b.nr_seq_prot_conta,
		null cd_procedimento,
		null ie_origem_proced,
		c.nr_seq_material,
		'PLS_FATURA_MAT' nm_tabela,
		'VL_FATURADO' nm_atributo,
		b.nr_seq_plano
	from	pls_fatura_mat		d,
		pls_conta_mat 		c,
		pls_conta 		b,
		pls_fatura_conta	g,
		pls_fatura_evento	e,
		pls_fatura		f,
		pls_cancel_rec_fatura 	h,
		pls_cancel_rec_fat_lote	i
	where	c.nr_sequencia		= d.nr_seq_conta_mat
	and	g.nr_sequencia		= d.nr_seq_fatura_conta
	and	b.nr_sequencia		= c.nr_seq_conta
	and	b.nr_sequencia		= g.nr_seq_conta
	and	e.nr_sequencia		= g.nr_seq_fatura_evento
	and	f.nr_sequencia		= e.nr_seq_fatura
	and	h.nr_sequencia		= f.nr_seq_cancel_fat
	and	i.nr_sequencia		= h.nr_seq_lote
	and	i.nr_lote_contabil	= nr_lote_contabil_p;

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
        if (cd_tipo_lote_contabil_w <> 47) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(261346);
        end if;
end if;
nr_seq_info_ctb_w	:= 19;

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

dt_referencia_month_w	:= trunc(dt_referencia_w,'month');

dt_ref_inicial_w	:= trunc(dt_referencia_month_w,'dd');
dt_ref_final_w		:= fim_dia(fim_mes(dt_referencia_month_w));

delete	from w_pls_movimento_sem_conta
where	ie_tipo_item in ('PCM','MCM')
and	dt_referencia between dt_ref_inicial_w and dt_ref_final_w;

if (ie_exclusao_p = 'S') then
	CALL wheb_usuario_pck.set_ie_lote_contabil('S');
	
	for reg in c_movimento
		loop
		delete	from movimento_contabil
		where   rowid	= reg.rowid;
		end loop;
	
	update	pls_cancel_rec_fat_lote
	set	nr_lote_contabil	= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	commit;
	
	update	pls_fatura_proc
	set	nr_lote_contabil	= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	commit;
	
	update	pls_fatura_mat
	set	nr_lote_contabil	= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	commit;
	
	update	lote_contabil
	set	vl_credito		= 0,
		vl_debito		= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	commit;
	
	CALL wheb_usuario_pck.set_ie_lote_contabil('N');
else
	CALL wheb_usuario_pck.set_ie_lote_contabil('S');
	
	for reg in c_movimento_w
		loop
		delete	from w_movimento_contabil
		where   rowid	= reg.rowid;
		end loop;
	
	update	pls_cancel_rec_fat_lote a
	set	a.nr_lote_contabil		= nr_lote_contabil_p
	where	coalesce(a.nr_lote_contabil,0) 	= 0
	and	a.dt_referencia between dt_ref_inicial_w and dt_ref_final_w;
	
	commit;
	
	update	pls_fatura_proc 	d
	set	d.nr_lote_contabil	= nr_lote_contabil_p
	where	exists (SELECT	1
			from	pls_conta_proc		c,
				pls_conta 		b,
				pls_fatura_conta	g,
				pls_fatura_evento	e,
				pls_fatura		f,
				pls_cancel_rec_fatura 	h,
				pls_cancel_rec_fat_lote	i
			where	c.nr_sequencia		= d.nr_seq_conta_proc
			and	g.nr_sequencia		= d.nr_seq_fatura_conta
			and	b.nr_sequencia		= c.nr_seq_conta
			and	b.nr_sequencia		= g.nr_seq_conta
			and	e.nr_sequencia		= g.nr_seq_fatura_evento
			and	f.nr_sequencia		= e.nr_seq_fatura
			and	h.nr_sequencia		= f.nr_seq_cancel_fat
			and	i.nr_sequencia		= h.nr_seq_lote
			and	i.nr_lote_contabil	= nr_lote_contabil_p);
			
	commit;		
			
	update	pls_fatura_mat	d
	set	d.nr_lote_contabil	= nr_lote_contabil_p
	where	exists (SELECT	1
			from	pls_conta_mat 		c,
				pls_conta 		b,
				pls_fatura_conta	g,
				pls_fatura_evento	e,
				pls_fatura		f,
				pls_cancel_rec_fatura 	h,
				pls_cancel_rec_fat_lote	i
			where	c.nr_sequencia		= d.nr_seq_conta_mat
			and	g.nr_sequencia		= d.nr_seq_fatura_conta
			and	b.nr_sequencia		= c.nr_seq_conta
			and	b.nr_sequencia		= g.nr_seq_conta
			and	e.nr_sequencia		= g.nr_seq_fatura_evento
			and	f.nr_sequencia		= e.nr_seq_fatura
			and	h.nr_sequencia		= f.nr_seq_cancel_fat
			and	i.nr_sequencia		= h.nr_seq_lote
			and	i.nr_lote_contabil	= nr_lote_contabil_p);
			
	commit;		
			
	CALL wheb_usuario_pck.set_ie_lote_contabil('N');
	
	begin
	ie_compl_hist_w	:= obter_se_compl_tipo_lote(cd_estabelecimento_w, cd_tipo_lote_contabil_w);
	exception
	when others then
		ie_compl_hist_w	:= null;
	end;
	
	nm_agrupador_w := coalesce(trim(both obter_agrupador_contabil(cd_tipo_lote_contabil_w)),'NR_SEQ_CONTA');
	
	nr_seq_w_movto_cont_w	:= 0;
	
	open c_itens_cancelados;
	loop
	fetch c_itens_cancelados into
		ie_debito_credito_w,
		ie_proc_mat_w,
		nr_seq_item_w,
		cd_conta_contabil_w,
		vl_contabil_w,
		dt_referencia_mens_w,
		cd_historico_w,
		nr_seq_conta_w,
		nr_seq_segurado_w,
		nr_seq_protocolo_w,
		nr_seq_prestador_w,
		nr_seq_prot_conta_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_material_w,
		nm_tabela_w,
		nm_atributo_w,
		nr_seq_plano_w;
	EXIT WHEN NOT FOUND; /* apply on c_itens_cancelados */
		cd_centro_custo_w	:= null;
		ds_compl_historico_w	:= null;
		
		vl_contabil_w		:= vl_contabil_w * -1; /* Sempre vai contabilizar estorno nesse lote contabil */
		
		if (coalesce(nr_seq_plano_w::text, '') = '') then
			begin
			select	b.ie_regulamentacao,
					b.nr_sequencia
			into STRICT	ie_regulamentacao_w,
					nr_seq_plano_w
			from	pls_segurado	a,
					pls_plano	b
			where	b.nr_sequencia 	= a.nr_seq_plano
			and		a.nr_sequencia	= nr_seq_segurado_w;
			exception
			when others then
					ie_regulamentacao_w	:= null;
					nr_seq_plano_w		:= null;
			end;
		else
			begin
			select	b.ie_regulamentacao
			into STRICT	ie_regulamentacao_w
			from	pls_plano	b
			where	b.nr_sequencia 	= nr_seq_plano_w;
			exception
			when others then
				ie_regulamentacao_w	:= null;
			end;
		end if;
		
		if (coalesce(cd_conta_contabil_w::text, '') = '') then
			if (ie_proc_mat_w	= 'P') then
				ie_tipo_item_w := 'PCM';
				ds_item_w	:= substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			else
				ie_tipo_item_w := 'MCM';
				ds_item_w	:= substr(obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',nr_seq_material_w),1,255);
			end if;
			
			insert	into w_pls_movimento_sem_conta(nr_sequencia,
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
				ds_observacao)
			values (nextval('w_pls_movimento_sem_conta_seq'),
				nr_seq_item_w,
				ds_item_w,
				ie_tipo_item_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_contabil_w,
				dt_referencia_w,
				nr_lote_contabil_w,
				ie_proc_mat_w,
				ie_debito_credito_w,
				'Provisao de producao medica');
		else
			select	ie_centro_custo
			into STRICT	ie_centro_custo_w
			from	conta_contabil
			where	cd_conta_contabil	= cd_conta_contabil_w;
			
			if (ie_centro_custo_w = 'S') then
				SELECT * FROM pls_obter_centro_custo(	'D', nr_seq_plano_w, cd_estabelecimento_w, '', '', ie_regulamentacao_w, nr_seq_segurado_w, '', cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
			end if;
			
			if (ie_compl_hist_w = 'S') then
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
				
				ds_conteudo_w	:= substr(	nr_seq_prestador_w	|| '#@' ||
								nm_prestador_w 		|| '#@' ||
								nr_seq_protocolo_w	|| '#@' ||
								nr_seq_conta_w		|| '#@' ||
								cd_cgc_prestador_w	|| '#@' ||
								cd_cpf_prestador_w,1,4000);
				
				begin
				ds_compl_historico_ww	:= substr(obter_compl_historico(cd_tipo_lote_contabil_w, cd_historico_w, ds_conteudo_w),1,255);
				exception
				when others then
					ds_compl_historico_ww	:= null;
				end;
				
				ds_compl_historico_w	:= substr(coalesce(ds_compl_historico_ww, ds_compl_historico_w),1,255);
			end if;
			
			nr_seq_agrupamento_w	:= null;
		
			if (nm_agrupador_w = 'NR_SEQ_CONTA') then
				nr_seq_agrupamento_w	:= substr(nr_seq_conta_w, 1, 10);
			end if;
			
			if (coalesce(nr_seq_agrupamento_w,0) = 0)then
				nr_seq_agrupamento_w := substr(nr_seq_conta_w, 1, 10);			
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
				nr_seq_info,
				nr_seq_tab_orig,
				nm_tabela,
				nm_atributo,
				nr_seq_agrupamento)
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
				nr_seq_info_ctb_w,
				nr_seq_item_w,
				nm_tabela_w,
				nm_atributo_w,
				nr_seq_agrupamento_w);
		end if;
	end loop;
	close c_itens_cancelados;
	
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
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(165188);
	else
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(165187);
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
-- REVOKE ALL ON PROCEDURE ctb_pls_contab_cancel_fat ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) FROM PUBLIC;

