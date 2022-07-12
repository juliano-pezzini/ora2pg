-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_relatorio_ops_pck.imprimir_relat_2091_serv_guia ( dt_inicio_p text, dt_fim_p text, cd_prestador_p pls_prestador.cd_prestador%type, IE_TIPO_GUIA_p text, NR_SEQ_CLINICA_p bigint, NR_SEQ_PERIODO_p bigint, NR_SEQ_TIPO_ATENDIMENTO_p bigint) RETURNS SETOF T_RELAT_2091_QT_SERV_GUIA_DATA AS $body$
DECLARE


	t_relat_2091_qt_serv_guia_w	t_relat_2091_qt_serv_guia_row;

	qt_repeticoes_w			bigint;
	vl_liberado_w			double precision;
	cd_procedimento_w		procedimento.cd_procedimento%type;
	ie_origem_proced_w		procedimento.ie_origem_proced%type;
	cd_guia_w			pls_guia_plano.cd_guia%type;
	cd_prestador_w			varchar(255);
	ie_tipo_guia_w			varchar(255);
	dt_pagamento_w			timestamp;
	qt_item_w			pls_conta_medica_resumo.qt_item%type;
	ds_formacao_preco_w		varchar(255);
	ds_item_w			varchar(255);
	nm_classe_w			varchar(255);
	cd_item_w			bigint;
	nr_seq_prestador_pgto_w		bigint;
	------------------------------------------------------------------------------------------------
	ds_sql_relat_w			varchar(4000);
	ds_filtro_relat_w		varchar(4000) := '';
	ds_filtro_relat_aux_w		varchar(4000) := '';
	var_cur_w			integer;
	var_exec_w			integer;
	var_retorno_w			integer;

	
BEGIN

	if (dt_inicio_p	<> '  /  /    ') and (dt_fim_p	<> '  /  /    ') then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and c.dt_mes_competencia between to_date(:dt_inicio) and to_date(:dt_fim)	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and y.DT_MES_COMPETENCIA between to_date(:dt_inicio) and to_date(:dt_fim)	';
	end if;

	if (coalesce(cd_prestador_p,'0') <> '0') then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and b.cd_prestador 	= :cd_prestador	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and z.cd_prestador 	= :cd_prestador	';
	end if;

	if (coalesce(IE_TIPO_GUIA_p,'0') <> '0') then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and a.ie_tipo_guia	= :ie_tipo_guia	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and x.ie_tipo_guia	= :ie_tipo_guia	';
	end if;

	if (coalesce(NR_SEQ_CLINICA_p,0) <> 0) then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and a.ie_tipo_guia = 5 and c.nr_seq_clinica = :nr_seq_clinica	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and x.ie_tipo_guia = 5 and y.nr_seq_clinica = :nr_seq_clinica	';
	end if;

	if (coalesce(NR_SEQ_PERIODO_p,0) <> 0) then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and d.NR_SEQ_PERIODO	= :NR_SEQ_PERIODO	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and w.NR_SEQ_PERIODO	= :NR_SEQ_PERIODO	';
	end if;

	if (coalesce(NR_SEQ_TIPO_ATENDIMENTO_p,0) <> 0) then
		ds_filtro_relat_w	:= ds_filtro_relat_w || '	and a.ie_tipo_guia = 4 and a.nr_seq_tipo_atendimento = :nr_seq_tipo_atendimento	';
		ds_filtro_relat_aux_w	:= ds_filtro_relat_aux_w || '	and x.ie_tipo_guia = 4 and x.nr_seq_tipo_atendimento = :nr_seq_tipo_atendimento	';
	end if;

	ds_sql_relat_w	:=	'	select	count(1),							'||
				'		a.cd_procedimento,						'||
				'		a.IE_ORIGEM_PROCED,						'||
				'		a.cd_guia,							'||
				'		b.cd_prestador,							'||
				'		a.ie_tipo_guia,							'||
				'		trunc(a.dt_competencia_pgto,''Month''),				'||
				'		sum(nvl(a.qt_item,0)),						'||
				'		sum(nvl(a.vl_liberado,0)),					'||
				'		a.nr_seq_prestador_pgto						'||
				'	from	pls_conta_medica_resumo	a,					'||
				'		pls_prestador		b,					'||
				'		pls_conta_v		c,					'||
				'		pls_lote_pagamento	d					'||
				'	where	b.nr_sequencia		= a.nr_seq_prestador_pgto		'||
				'	and	a.nr_seq_conta		= c.nr_sequencia			'||
				'	and	a.nr_seq_lote_pgto 	= d.nr_sequencia			'||
				'	and	a.cd_procedimento is not null					'||
					ds_filtro_relat_w 							 ||
				'	and exists (	select	1						'||
				'			from	pls_conta_medica_resumo x,			'||
				'				pls_conta_v		y,			'||
				'				pls_prestador		z,			'||
				'				pls_lote_pagamento	w			'||
				'			where	x.nr_seq_conta 	= y.nr_sequencia		'||
				'			and	z.nr_sequencia	= x.nr_seq_prestador_pgto	'||
				'			and	z.nr_sequencia	= b.nr_sequencia		'||
				'			and	x.nr_seq_lote_pgto 	= w.nr_sequencia	'||
				'			and	x.cd_procedimento is not null			'||
					ds_filtro_relat_aux_w							 ||
				'			and y.cd_guia = c.cd_guia				'||
				'	    		and x.cd_procedimento = a.cd_procedimento		'||
				'	    		and x.nr_seq_conta_proc <> a.nr_seq_conta_proc)		'||
				'	group by a.cd_procedimento,a.ie_origem_proced, a.cd_guia,b.cd_prestador, '||
				'		a.ie_tipo_guia,trunc(a.dt_competencia_pgto,''month''),a.nr_seq_prestador_pgto		'||
				'	having count(1) > 1							'||
				'	union all								'||
				'	select	count(1),							'||
				'		a.nr_seq_material,						'||
				'		null IE_ORIGEM_PROCED,						'||
				'		a.cd_guia,							'||
				'		b.cd_prestador,							'||
				'		a.ie_tipo_guia,							'||
				'		trunc(a.DT_COMPETENCIA_PGTO,''Month''),				'||
				'		sum(nvl(a.qt_item,0)),						'||
				'		sum(nvl(a.vl_liberado,0)),					'||
				'		a.nr_seq_prestador_pgto						'||
				'	from	pls_conta_medica_resumo	a,					'||
				'		pls_prestador		b,					'||
				'		pls_conta_v		c,					'||
				'		pls_lote_pagamento	d					'||
				'	where	b.nr_sequencia		= a.nr_seq_prestador_pgto		'||
				'	and	a.nr_seq_conta		= c.nr_sequencia			'||
				'	and	a.NR_SEQ_LOTE_PGTO 	= d.nr_sequencia			'||
				'	and	a.nr_seq_material is not null					'||
					ds_filtro_relat_w 							 ||
				'	and exists (	select	1						'||
				'			from	pls_conta_medica_resumo x,			'||
				'				pls_conta_v		y,			'||
				'				pls_prestador		z,			'||
				'				pls_lote_pagamento	w			'||
				'			where	x.nr_seq_conta 		= y.nr_sequencia	'||
				'			and	z.nr_sequencia		= x.nr_seq_prestador_pgto	'||
				'			and	z.nr_sequencia		= b.nr_sequencia	'||
				'			and	x.NR_SEQ_LOTE_PGTO 	= w.nr_sequencia	'||
				'			and	x.nr_seq_material is not null			'||
					ds_filtro_relat_aux_w							 ||
				'			and y.cd_guia = c.cd_guia				'||
				'	    		and x.nr_seq_material = a.nr_seq_material		'||
				'	    		and x.nr_seq_conta_mat <> a.nr_seq_conta_mat)		'||
				'	group by a.nr_seq_material, a.cd_guia,b.cd_prestador, 			'||
				'		a.ie_tipo_guia,trunc(a.DT_COMPETENCIA_PGTO,''Month''),a.nr_seq_prestador_pgto		'||
				'	having count(1) > 1						';

	var_cur_w := dbms_sql.open_cursor;
	dbms_sql.parse(var_cur_w, ds_sql_relat_w,1);

	if (dt_inicio_p	<> '  /  /    ') and (dt_fim_p	<> '  /  /    ') then
		dbms_sql.bind_variable(var_cur_w, ':dt_inicio', dt_inicio_p);
		dbms_sql.bind_variable(var_cur_w, ':dt_fim', dt_fim_p);
	end if;

	if (coalesce(cd_prestador_p,'0') <> '0') then
		dbms_sql.bind_variable(var_cur_w, ':cd_prestador', cd_prestador_p);
	end if;

	if (coalesce(IE_TIPO_GUIA_p,'0') <> '0') then
		dbms_sql.bind_variable(var_cur_w, ':ie_tipo_guia', IE_TIPO_GUIA_p);
	end if;

	if (coalesce(NR_SEQ_CLINICA_p,0) <> 0) then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_clinica', NR_SEQ_CLINICA_p);
	end if;

	if (coalesce(NR_SEQ_PERIODO_p,0) <> 0) then
		dbms_sql.bind_variable(var_cur_w, ':NR_SEQ_PERIODO', NR_SEQ_PERIODO_p);
	end if;

	if (coalesce(NR_SEQ_TIPO_ATENDIMENTO_p,0) <> 0) then
		dbms_sql.bind_variable(var_cur_w, ':nr_seq_tipo_atendimento', NR_SEQ_TIPO_ATENDIMENTO_p);
	end if;

	dbms_sql.define_column(var_cur_w, 1, qt_repeticoes_w);
	dbms_sql.define_column(var_cur_w, 2, cd_procedimento_w);
	dbms_sql.define_column(var_cur_w, 3, ie_origem_proced_w);
	dbms_sql.define_column(var_cur_w, 4, cd_guia_w, 255);
	dbms_sql.define_column(var_cur_w, 5, cd_prestador_w, 255);
	dbms_sql.define_column(var_cur_w, 6, ie_tipo_guia_w, 255);
	dbms_sql.define_column(var_cur_w, 7, dt_pagamento_w);
	dbms_sql.define_column(var_cur_w, 8, qt_item_w);
	dbms_sql.define_column(var_cur_w, 9, vl_liberado_w);
	dbms_sql.define_column(var_cur_w, 10, nr_seq_prestador_pgto_w);

	var_exec_w := dbms_sql.execute(var_cur_w);

	loop
	var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
		exit when var_retorno_w = 0;

		dbms_sql.column_value(var_cur_w, 1, qt_repeticoes_w);
		dbms_sql.column_value(var_cur_w, 2, cd_procedimento_w);
		dbms_sql.column_value(var_cur_w, 3, ie_origem_proced_w);
		dbms_sql.column_value(var_cur_w, 4, cd_guia_w);
		dbms_sql.column_value(var_cur_w, 5, cd_prestador_w);
		dbms_sql.column_value(var_cur_w, 6, ie_tipo_guia_w);
		dbms_sql.column_value(var_cur_w, 7, dt_pagamento_w);
		dbms_sql.column_value(var_cur_w, 8, qt_item_w);
		dbms_sql.column_value(var_cur_w, 9, vl_liberado_w);
		dbms_sql.column_value(var_cur_w, 10, nr_seq_prestador_pgto_w);


		if (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
			cd_item_w	:= cd_procedimento_w;
			ds_item_w	:= substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
			select	substr(Obter_Desc_Grupo_Rec(nr_seq_grupo_rec),1,255)
			into STRICT	nm_classe_w
			from	procedimento
			where	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w;
		else
			select	DS_MATERIAL,
				substr(pls_obter_estrutura_material(nr_seq_estrut_mat,nr_sequencia,null),1,40) nm_classe,
				coalesce(cd_material_ops, cd_material)
			into STRICT	ds_item_w,
				nm_classe_w,
				cd_item_w
			from	pls_material
			where	nr_sequencia	= cd_procedimento_w;
		end if;

		select	substr(obter_valor_dominio(1669, a.ie_preco),1,100)
		into STRICT	ds_formacao_preco_w
		from	pls_guia_plano	b,
			pls_plano	a
		where	b.nr_seq_plano	= a.nr_sequencia
		and	b.cd_guia	= cd_guia_w;

		t_relat_2091_qt_serv_guia_w.ie_tipo_contrato	:= ds_formacao_preco_w;
		t_relat_2091_qt_serv_guia_w.dt_pagamento	:= dt_pagamento_w;
		t_relat_2091_qt_serv_guia_w.cd_prestador	:= cd_prestador_w;
		t_relat_2091_qt_serv_guia_w.ds_prestador	:= substr(pls_obter_dados_prestador(nr_seq_prestador_pgto_w,'N'),1,255);
		t_relat_2091_qt_serv_guia_w.ie_tipo_guia	:= substr(obter_valor_dominio(1746,ie_tipo_guia_w),1,255);
		t_relat_2091_qt_serv_guia_w.cd_guia_referencia	:= cd_guia_w;
		t_relat_2091_qt_serv_guia_w.NM_CLASSE		:= nm_classe_w;
		t_relat_2091_qt_serv_guia_w.CD_ITEM		:= cd_item_w;
		t_relat_2091_qt_serv_guia_w.DS_ITEM		:= ds_item_w;
		t_relat_2091_qt_serv_guia_w.qt_item		:= qt_item_w;
		t_relat_2091_qt_serv_guia_w.VL_LIBERADO		:= vl_liberado_w;
		t_relat_2091_qt_serv_guia_w.qt_repeticoes	:= qt_repeticoes_w;

		RETURN NEXT t_relat_2091_qt_serv_guia_w;
	end loop;
	dbms_sql.close_cursor(var_cur_w);

	return;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_relatorio_ops_pck.imprimir_relat_2091_serv_guia ( dt_inicio_p text, dt_fim_p text, cd_prestador_p pls_prestador.cd_prestador%type, IE_TIPO_GUIA_p text, NR_SEQ_CLINICA_p bigint, NR_SEQ_PERIODO_p bigint, NR_SEQ_TIPO_ATENDIMENTO_p bigint) FROM PUBLIC;
