-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vinc_contas_pag_prod_compl (nr_seq_lote_pag_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ds_sql_cursor_w			varchar(32000);
ds_sql_filtro_cm_w		varchar(32000);
ds_sql_filtro_rec_w		varchar(32000);
nr_seq_conta_w			pls_conta_medica_resumo.nr_seq_conta%type;
nr_seq_conta_resumo_w		pls_conta_medica_resumo.nr_sequencia%type;
nr_seq_conta_rec_resumo_w	pls_conta_rec_resumo_item.nr_sequencia%type;
dt_mes_competencia_w		pls_lote_pagamento.dt_mes_competencia%type;
dt_inicio_comp_w		pls_lote_pagamento.dt_inicio_comp%type;
dt_fim_comp_w			pls_lote_pagamento.dt_fim_comp%type;
cd_estabelecimento_w		pls_lote_pagamento.cd_estabelecimento%type;
dt_inicio_lib_pagamento_w	pls_lote_pagamento.dt_lib_pag_prot_inicial%type;
dt_fim_lib_pagamento_w		pls_lote_pagamento.dt_lib_pag_prot_final%type;
ie_forma_pagamento_w		pls_parametro_pagamento.ie_forma_pagamento%type;
ie_prot_sem_pagto_w		pls_parametro_pagamento.ie_prot_sem_pagto%type;
var_cur_w			integer;
var_exec_w			integer;
var_retorno_w			integer;
ie_analise_fechada_w		pls_parametro_pagamento.ie_analise_fechada%type;
ie_analise_aud_w		varchar(255);
qt_analise_aberta_w		bigint;
ie_origem_w			varchar(255);
nr_seq_analise_w		pls_analise_conta.nr_sequencia%type;
ie_gerar_pgto_ajust_fat_w	pls_parametro_pagamento.ie_gerar_pgto_ajust_fat%type;

c01 CURSOR(nr_seq_lote_cp	pls_lote_pgto_compl.nr_seq_lote%type) FOR
	SELECT	a.nr_seq_prestador,
		a.nr_seq_protocolo,
		a.nr_seq_conta,
		a.ie_tipo_guia,
		a.ie_tipo_despesa_proc,
		a.ie_tipo_despesa_mat,
		a.nr_protocolo_prestador,
		a.nr_seq_classif_prestador,
		a.nr_seq_tipo_prestador,
		a.nr_seq_grupo_contrato,
		a.nr_seq_contrato,
		a.nr_seq_plano,
		a.nr_seq_evento,
		a.ie_conta_intercambio,
		a.ie_origem_conta
	from	pls_lote_pgto_compl	a
	where	a.nr_seq_lote	= nr_seq_lote_cp;

BEGIN

delete from w_pls_conta_pag_prod;

select	fim_dia(last_day(dt_mes_competencia)),
	-- jtonon - OS 924063 - Ajustada as duas linhas abaixo visto que se há a possibilidade de informar dia mês e ano (dd/mm/yyyy) nos campos 'Início competência' e 'Fim competência' então não faz sentido levar em consideração o mês inteiro do início ao fim
	trunc(dt_inicio_comp),		-- trunc(dt_inicio_comp,'month'),
	fim_dia(dt_fim_comp),		-- fim_dia(last_day(dt_fim_comp)),
	cd_estabelecimento,
	trunc(dt_lib_pag_prot_inicial,'dd'),
	trunc(dt_lib_pag_prot_final,'dd')
into STRICT	dt_mes_competencia_w,
	dt_inicio_comp_w,
	dt_fim_comp_w,
	cd_estabelecimento_w,
	dt_inicio_lib_pagamento_w,
	dt_fim_lib_pagamento_w
from	pls_lote_pagamento
where	nr_sequencia		= nr_seq_lote_pag_p;

select	coalesce(max(ie_forma_pagamento),'P'),
	coalesce(max(IE_PROT_SEM_PAGTO),'N'),
	coalesce(max(ie_analise_fechada),'N'),
	coalesce(max(ie_gerar_pgto_ajust_fat),'N')
into STRICT	ie_forma_pagamento_w,
	ie_prot_sem_pagto_w,
	ie_analise_fechada_w,
	ie_gerar_pgto_ajust_fat_w
from	pls_parametro_pagamento
where	cd_estabelecimento	= cd_estabelecimento_w;

ds_sql_cursor_w		:= '';

for	r_c01_w in c01(nr_seq_lote_pag_p) loop


	if (r_c01_w.nr_seq_conta IS NOT NULL AND r_c01_w.nr_seq_conta::text <> '') then
		ie_analise_aud_w	:= 'N';
		nr_seq_analise_w	:= null;

		begin
		select	nr_seq_analise
		into STRICT	nr_seq_analise_w
		from	pls_conta
		where	nr_sequencia	= r_c01_w.nr_seq_conta;
		exception
		when others then
			nr_seq_analise_w	:= null;
		end;

		if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then
			ie_analise_aud_w	:= pls_obter_conta_item_auditoria(r_c01_w.nr_seq_conta);

			if (ie_analise_aud_w = 'S') then
				select	count(1)
				into STRICT	qt_analise_aberta_w
				from	pls_analise_conta
				where	nr_sequencia = nr_seq_analise_w
				and	ie_status not in ('T','C','L');

				if (qt_analise_aberta_w > 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(210206,'NR_SEQ_CONTA=' ||r_c01_w.nr_seq_conta);
				end if;
			end if;
		end if;
	end if;

	ds_sql_filtro_cm_w		:= null;
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' select	a.nr_seq_conta, ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 		a.nr_sequencia nr_seq_conta_resumo, ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 		null nr_seq_conta_rec_resumo ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' from	pls_conta c, ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 		pls_conta_medica_resumo	a, ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 		pls_protocolo_conta	b ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' where	b.nr_sequencia	= a.nr_seq_protocolo ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		a.nr_seq_conta = c.nr_sequencia ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		a.ie_situacao = ''A'' ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		a.dt_competencia_pgto <= :dt_mes_competencia ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		a.vl_liberado	>= 0 ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		a.nr_seq_lote_pgto is null ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		(a.ie_tipo_item <> ''I'' or a.ie_tipo_item is null) ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and 	a.nr_seq_prestador_pgto is not null ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and 	a.nr_seq_evento is not null ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		(a.ie_tipo_item <> ''I'' or a.ie_tipo_item is null) ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and		((a.ie_situacao != ''I'') or (a.ie_situacao is null)) ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and not exists(	select	1 ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || '			from	pls_analise_conta 		x, ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || '				pls_lote_protocolo_conta	y ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || '			where	x.nr_sequencia	= c.nr_seq_analise ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || '			and	y.nr_sequencia	= x.nr_seq_lote_protocolo ';
	ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || '			and	y.ie_status in (''X'', ''G'')) ';

	ds_sql_filtro_rec_w		:= '';
	ds_sql_filtro_rec_w		:=	'	union									' || pls_util_pck.enter_w ||
						'	select	a.nr_seq_conta,							' || pls_util_pck.enter_w ||
						'		null nr_seq_conta_resumo,					' || pls_util_pck.enter_w ||
						'		a.nr_sequencia nr_seq_conta_rec_resumo				' || pls_util_pck.enter_w ||
						'	from	pls_rec_glosa_protocolo		c,				' || pls_util_pck.enter_w ||
						'		pls_rec_glosa_conta		e,				' || pls_util_pck.enter_w ||
						'		pls_conta			b,				' || pls_util_pck.enter_w ||
						'		pls_conta_rec_resumo_item	a				' || pls_util_pck.enter_w ||
						'	where	b.nr_sequencia		= a.nr_seq_conta			' || pls_util_pck.enter_w ||
						'	and	e.nr_sequencia		= a.nr_seq_conta_rec			' || pls_util_pck.enter_w ||
						'	and	c.nr_sequencia		= e.nr_seq_protocolo			' || pls_util_pck.enter_w ||
						'	and	a.nr_seq_prestador_pgto	is not null				' || pls_util_pck.enter_w ||
						'	and	a.vl_liberado	>= 0 						' || pls_util_pck.enter_w ||
						'	and	a.nr_seq_lote_pgto is null					' || pls_util_pck.enter_w ||
						'	and	c.ie_status in (''3'',''4'')					' || pls_util_pck.enter_w ||
						'	and	e.ie_status not in (''3'')					' || pls_util_pck.enter_w ||
						'	and	a.ie_situacao = ''A''						' || pls_util_pck.enter_w ||
						' 	and	a.dt_competencia_pgto <= :dt_mes_competencia			' || pls_util_pck.enter_w ||
						' 	and not exists(	select	1 						' || pls_util_pck.enter_w ||
						'			from	pls_analise_conta 		x, 		' || pls_util_pck.enter_w ||
						'				pls_lote_protocolo_conta	y  		' || pls_util_pck.enter_w ||
						'			where	x.nr_sequencia	= e.nr_seq_analise 		' || pls_util_pck.enter_w ||
						'			and	y.nr_sequencia	= x.nr_seq_lote_protocolo 	' || pls_util_pck.enter_w ||
						'			and	y.ie_status in (''X'', ''G'')) 			';

	if (ie_gerar_pgto_ajust_fat_w = 'N') then
		ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' and	not exists (	select	1 ';
		ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 			from	pls_ajuste_fatura_conta x ';
		ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 			where	x.nr_seq_conta	= a.nr_seq_conta ';
		ds_sql_filtro_cm_w		:= ds_sql_filtro_cm_w  || ' 			and	x.ie_status	= ''N'') ';
	end if;

	if (r_c01_w.nr_seq_prestador IS NOT NULL AND r_c01_w.nr_seq_prestador::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w || ' and	a.nr_seq_prestador_pgto	= :nr_seq_prestador_pgto ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w || ' and	a.nr_seq_prestador_pgto	= :nr_seq_prestador_pgto ';
	end if;

	if (r_c01_w.nr_seq_evento IS NOT NULL AND r_c01_w.nr_seq_evento::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w || ' and	a.nr_seq_evento = :nr_seq_evento_compl ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w || ' and	a.nr_seq_evento	= :nr_seq_evento_compl ';
	end if;


	if (dt_inicio_comp_w IS NOT NULL AND dt_inicio_comp_w::text <> '') or (dt_fim_comp_w IS NOT NULL AND dt_fim_comp_w::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w || 	' and	a.dt_competencia_pgto between nvl(:dt_inicio_comp,a.dt_competencia_pgto) ' ||
									' and	nvl(:dt_fim_comp,a.dt_competencia_pgto)  ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||  ' and	a.dt_competencia_pgto between nvl(:dt_inicio_comp,a.dt_competencia_pgto) ' ||
							' and nvl(:dt_fim_comp,a.dt_competencia_pgto)  ';
	end if;

	if (dt_inicio_lib_pagamento_w IS NOT NULL AND dt_inicio_lib_pagamento_w::text <> '') or (dt_fim_lib_pagamento_w IS NOT NULL AND dt_fim_lib_pagamento_w::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	b.dt_lib_pagamento between trunc(nvl(:dt_inicio_lib_pagamento,b.dt_lib_pagamento)) and fim_dia(nvl(:dt_fim_lib_pagamento,b.dt_lib_pagamento)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	c.dt_liberacao_pag between trunc(nvl(:dt_inicio_lib_pagamento,c.dt_liberacao_pag)) and fim_dia(nvl(:dt_fim_lib_pagamento,c.dt_liberacao_pag)) ';
	end if;

	if (coalesce(ie_prot_sem_pagto_w, 'N') = 'N')	then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	c.ie_status		<> ''4'' ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	c.ie_status		<> ''4'' ';
	end if;

	if (ie_forma_pagamento_w = 'P') then
		if (ie_prot_sem_pagto_w = 'N') then
			ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
						' and 	a.ie_status_protocolo	= ''3'' ';
		else
			ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
						' and 	a.ie_status_protocolo	in (''3'',''4'') ';
		end if;
	elsif (ie_forma_pagamento_w = 'C') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.ie_status = ''F'' and	c.ie_status = ''F'' ';

	end if;

	if (r_c01_w.nr_seq_protocolo IS NOT NULL AND r_c01_w.nr_seq_protocolo::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.nr_seq_protocolo = :nr_seq_protocolo ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	b.nr_seq_protocolo = :nr_seq_protocolo ';
	end if;

	if (r_c01_w.nr_seq_conta IS NOT NULL AND r_c01_w.nr_seq_conta::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.nr_seq_conta = :nr_seq_conta ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	b.nr_sequencia = :nr_seq_conta ';
	end if;

	if (r_c01_w.ie_tipo_guia IS NOT NULL AND r_c01_w.ie_tipo_guia::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.ie_tipo_guia = :ie_tipo_guia ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	b.ie_tipo_guia = :ie_tipo_guia ';
	end if;

	if (r_c01_w.ie_tipo_despesa_proc IS NOT NULL AND r_c01_w.ie_tipo_despesa_proc::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	(a.ie_proc_mat = ''P'') and (a.ie_tipo_despesa = :ie_tipo_despesa_proc) ';
	end if;

	if (r_c01_w.ie_tipo_despesa_mat IS NOT NULL AND r_c01_w.ie_tipo_despesa_mat::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	(a.ie_proc_mat = ''M'') and (a.ie_tipo_despesa = :ie_tipo_despesa_mat) ';
	end if;

	if (r_c01_w.nr_protocolo_prestador IS NOT NULL AND r_c01_w.nr_protocolo_prestador::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.nr_protocolo_prestador = :nr_protocolo_prestador ';
	end if;

	if (r_c01_w.nr_seq_classif_prestador IS NOT NULL AND r_c01_w.nr_seq_classif_prestador::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and (exists	(select	1 ' ||
					'		from	pls_prestador x ' ||
					'		where	x.nr_sequencia		= a.nr_seq_prestador_pgto ' ||
					'		and	x.nr_seq_classificacao	= :nr_seq_classif_prestador)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and (exists	(select	1 ' ||
					'		from	pls_prestador x ' ||
					'		where	x.nr_sequencia		= a.nr_seq_prestador_pgto ' ||
					'		and	x.nr_seq_classificacao	= :nr_seq_classif_prestador)) ';
	end if;

	if (r_c01_w.nr_seq_tipo_prestador IS NOT NULL AND r_c01_w.nr_seq_tipo_prestador::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and 	(exists	(select	1 ' ||
					'		from	pls_prestador	x ' ||
					'		where	x.nr_sequencia		= a.nr_seq_prestador_pgto ' ||
					'		and	x.nr_seq_tipo_prestador	= :nr_seq_tipo_prest_pgto)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and 	(exists	(select	1 ' ||
					'		from	pls_prestador	x ' ||
					'		where	x.nr_sequencia		= a.nr_seq_prestador_pgto ' ||
					'		and	x.nr_seq_tipo_prestador	= :nr_seq_tipo_prest_pgto)) ';
	end if;

	if (r_c01_w.nr_seq_grupo_contrato IS NOT NULL AND r_c01_w.nr_seq_grupo_contrato::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	(exists	(select	1 ' ||
					'	from	pls_conta		y, ' ||
					'		pls_segurado		x, ' ||
					'		pls_preco_contrato	z ' ||
					'	where	x.nr_sequencia		= y.nr_seq_segurado ' ||
					'	and	y.nr_sequencia		= a.nr_seq_conta ' ||
					'	and	((z.nr_seq_contrato	= x.nr_seq_contrato) or ' ||
					'		(z.nr_seq_intercambio	= x.nr_seq_intercambio)) ' ||
					'	and	z.nr_seq_grupo		= :nr_seq_grupo_contrato)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	(exists	(select	1 ' ||
					'	from	pls_conta		y, ' ||
					'		pls_segurado		x, ' ||
					'		pls_preco_contrato	z ' ||
					'	where	x.nr_sequencia		= y.nr_seq_segurado ' ||
					'	and	y.nr_sequencia		= b.nr_sequencia ' ||
					'	and	((z.nr_seq_contrato	= x.nr_seq_contrato) or ' ||
					'		(z.nr_seq_intercambio	= x.nr_seq_intercambio)) ' ||
					'	and	z.nr_seq_grupo		= :nr_seq_grupo_contrato)) ';
	end if;

	if (r_c01_w.nr_seq_contrato IS NOT NULL AND r_c01_w.nr_seq_contrato::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	(exists	(select	1 ' ||
					'		from	pls_conta		y, ' ||
					'			pls_segurado		x ' ||
					'		where	x.nr_sequencia		= y.nr_seq_segurado ' ||
					'		and	y.nr_sequencia		= a.nr_seq_conta ' ||
					'		and	:nr_seq_contrato	= x.nr_seq_contrato)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	(exists	(select	1 ' ||
					'		from	pls_conta		y, ' ||
					'			pls_segurado		x ' ||
					'		where	x.nr_sequencia		= y.nr_seq_segurado ' ||
					'		and	y.nr_sequencia		= b.nr_sequencia ' ||
					'		and	:nr_seq_contrato	= x.nr_seq_contrato)) ';
	end if;


	if (r_c01_w.nr_seq_plano IS NOT NULL AND r_c01_w.nr_seq_plano::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	(exists	(select	1 ' ||
					'		from	pls_conta		y, ' ||
					'			pls_segurado		x ' ||
					'		where	x.nr_sequencia	= y.nr_seq_segurado ' ||
					'		and	y.nr_sequencia	= a.nr_seq_conta ' ||
					'		and	:nr_seq_plano	= x.nr_seq_plano)) ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	(exists	(select	1 ' ||
					'		from	pls_conta		y, ' ||
					'			pls_segurado		x ' ||
					'		where	x.nr_sequencia	= y.nr_seq_segurado ' ||
					'		and	y.nr_sequencia	= b.nr_sequencia ' ||
					'		and	:nr_seq_plano	= x.nr_seq_plano)) ';
	end if;

	if (r_c01_w.ie_conta_intercambio = 'N') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	nvl(c.ie_tipo_conta,''N'') = ''O'' ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	nvl(b.ie_tipo_conta,''N'') = ''O'' ';
	elsif (r_c01_w.ie_conta_intercambio = 'I') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and 	nvl(c.ie_tipo_conta,''N'') in (''I'',''C'') ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and 	nvl(b.ie_tipo_conta,''N'') in (''I'',''C'') ';
	end if;

	if (r_c01_w.ie_origem_conta IS NOT NULL AND r_c01_w.ie_origem_conta::text <> '') then
		ds_sql_filtro_cm_w	:= ds_sql_filtro_cm_w ||
					' and	a.ie_origem_conta	= :ie_origem_conta ';
		ds_sql_filtro_rec_w	:= ds_sql_filtro_rec_w ||
					' and	b.ie_origem_conta	= :ie_origem_conta ';
	end if;

	ds_sql_cursor_w	:= ds_sql_filtro_cm_w || pls_util_pck.enter_w || ds_sql_filtro_rec_w;

	var_cur_w := dbms_sql.open_cursor;
	dbms_sql.parse(var_cur_w, ds_sql_cursor_w, 1);

	-- INÍCIO Passagem dos parâmetros
	dbms_sql.bind_variable(var_cur_w, ':dt_mes_competencia', dt_mes_competencia_w);

	if (r_c01_w.nr_seq_prestador IS NOT NULL AND r_c01_w.nr_seq_prestador::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_prestador_pgto', r_c01_w.nr_seq_prestador);
	end if;

	if (r_c01_w.nr_seq_protocolo IS NOT NULL AND r_c01_w.nr_seq_protocolo::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_protocolo', r_c01_w.nr_seq_protocolo);
	end if;

	if (r_c01_w.nr_seq_conta IS NOT NULL AND r_c01_w.nr_seq_conta::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_conta', r_c01_w.nr_seq_conta);
	end if;

	if (r_c01_w.ie_tipo_guia IS NOT NULL AND r_c01_w.ie_tipo_guia::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':ie_tipo_guia', r_c01_w.ie_tipo_guia);
	end if;

	if (r_c01_w.ie_tipo_despesa_proc IS NOT NULL AND r_c01_w.ie_tipo_despesa_proc::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':ie_tipo_despesa_proc', r_c01_w.ie_tipo_despesa_proc);
	end if;

	if (r_c01_w.ie_tipo_despesa_mat IS NOT NULL AND r_c01_w.ie_tipo_despesa_mat::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':ie_tipo_despesa_mat', r_c01_w.ie_tipo_despesa_mat);
	end if;

	if (r_c01_w.nr_protocolo_prestador IS NOT NULL AND r_c01_w.nr_protocolo_prestador::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_protocolo_prestador', r_c01_w.nr_protocolo_prestador);
	end if;

	if (r_c01_w.nr_seq_classif_prestador IS NOT NULL AND r_c01_w.nr_seq_classif_prestador::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_classif_prestador', r_c01_w.nr_seq_classif_prestador);
	end if;

	if (r_c01_w.nr_seq_tipo_prestador IS NOT NULL AND r_c01_w.nr_seq_tipo_prestador::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_tipo_prest_pgto', r_c01_w.nr_seq_tipo_prestador);
	end if;

	if (r_c01_w.nr_seq_grupo_contrato IS NOT NULL AND r_c01_w.nr_seq_grupo_contrato::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_grupo_contrato', r_c01_w.nr_seq_grupo_contrato);
	end if;

	if (r_c01_w.nr_seq_contrato IS NOT NULL AND r_c01_w.nr_seq_contrato::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_contrato', r_c01_w.nr_seq_contrato);
	end if;

	if (r_c01_w.nr_seq_plano IS NOT NULL AND r_c01_w.nr_seq_plano::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_plano', r_c01_w.nr_seq_plano);
	end if;

	if (r_c01_w.ie_origem_conta IS NOT NULL AND r_c01_w.ie_origem_conta::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':ie_origem_conta', r_c01_w.ie_origem_conta);
	end if;

	if (dt_inicio_lib_pagamento_w IS NOT NULL AND dt_inicio_lib_pagamento_w::text <> '') or (dt_fim_lib_pagamento_w IS NOT NULL AND dt_fim_lib_pagamento_w::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':dt_inicio_lib_pagamento', dt_inicio_lib_pagamento_w);
		dbms_sql.bind_variable(var_cur_w, ':dt_fim_lib_pagamento', dt_fim_lib_pagamento_w);
	end if;

	if (dt_inicio_comp_w IS NOT NULL AND dt_inicio_comp_w::text <> '') or (dt_fim_comp_w IS NOT NULL AND dt_fim_comp_w::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':dt_inicio_comp', dt_inicio_comp_w);
		dbms_sql.bind_variable(var_cur_w, ':dt_fim_comp', dt_fim_comp_w);
	end if;

	if (r_c01_w.nr_seq_evento IS NOT NULL AND r_c01_w.nr_seq_evento::text <> '') then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_evento_compl', r_c01_w.nr_seq_evento);
	end if;

	dbms_sql.define_column(var_cur_w, 1, nr_seq_conta_w);
	dbms_sql.define_column(var_cur_w, 2, nr_seq_conta_resumo_w);
	dbms_sql.define_column(var_cur_w, 3, nr_seq_conta_rec_resumo_w);
	var_exec_w := dbms_sql.execute(var_cur_w);

	loop
	var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
	exit when var_retorno_w = 0;
		dbms_sql.column_value(var_cur_w, 1, nr_seq_conta_w);
		dbms_sql.column_value(var_cur_w, 2, nr_seq_conta_resumo_w);
		dbms_sql.column_value(var_cur_w, 3, nr_seq_conta_rec_resumo_w);

		insert into w_pls_conta_pag_prod(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_conta,
			nr_seq_conta_resumo,
			nr_seq_evento,
			nr_seq_conta_rec_resumo)
		SELECT	nextval('w_pls_conta_pag_prod_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_conta_w,
			nr_seq_conta_resumo_w,
			null,
			nr_seq_conta_rec_resumo_w
		;

	end loop;
	dbms_sql.close_cursor(var_cur_w);
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vinc_contas_pag_prod_compl (nr_seq_lote_pag_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

