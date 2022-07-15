-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pj_dirf_nota ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_tributo_p bigint, cd_darf_p text, ie_tipo_data_p bigint, ie_consistir_retencao_p text, dt_mes_referencia_p timestamp, cd_empresa_p bigint) AS $body$
DECLARE


c01				integer;
ds_comando_w			varchar(4000)	:= '';
ds_comando_subst_w		varchar(4000)	:= '';
ie_grava_w			varchar(1);
retorno_w			integer;
qt_registros_w			bigint;
qt_registros_ww			bigint;
qt_registros_bn_w		bigint;
qt_registros_pm_w		bigint;
qt_registros_br_w		bigint;
qt_registros_si_w		bigint;
cd_cgc_w			varchar(14);
contador_w			bigint	:= 0;
dt_escolhida_w			varchar(200)	:= '';
ie_gerar_w			varchar(1);
ie_origem_titulo_w		varchar(6);
ie_situacao_w			varchar(2);
nr_seq_nota_fiscal_w		bigint;
nr_titulo_w			bigint;
vl_imposto_w			double precision;
vl_imposto_aux_w		double precision;
vl_imposto_total_w		double precision;
vl_mercadoria_w			double precision;
vl_rendimento_w			double precision;
vl_base_calculo_w		double precision;
dt_base_titulo_w		timestamp;
ie_tipo_titulo_w		titulo_pagar.ie_tipo_titulo%type;
nr_seq_classe_w			titulo_pagar.nr_seq_classe%type;


BEGIN
ds_comando_w :=	'select	p.cd_cgc, '									||
		'	p.nr_titulo, '									||
		'	p.nr_seq_nota_fiscal, '								||
		'	n.vl_mercadoria,  '								||
		'	c.vl_tributo vl_tributo, ' 							||
		'	c.vl_base_calculo vl_base_calculo, '						||
		'	p.ie_tipo_titulo, '								||
		'	p.nr_seq_classe '								||
		' from	titulo_pagar p, nota_fiscal n, nota_fiscal_trib c, operacao_nota o, tributo t'	||
		' where	n.nr_sequencia = p.nr_seq_nota_fiscal ' 					||
		' and	c.nr_sequencia = n.nr_sequencia '						||
		' and	n.cd_operacao_nf = o.cd_operacao_nf ' 						||
		' and	t.cd_tributo = c.cd_tributo'							||
		' and	p.cd_cgc  is not null ' 							||
		' and	p.cd_cgc = n.cd_cgc '								||
		--' and		not exists	(select 1 from nota_fiscal_venc_trib v where n.nr_sequencia = v.nr_sequencia)'	||
		' and	p.ie_tipo_titulo not in	(select	x.ie_tipo_titulo '				||
		'				from	dirf_regra_tipo_tit x '				||
		'				where 	nvl(x.ie_utilizar_nf,''N'') = ''N'' ' 		||
		'				and 	(x.cd_estabelecimento = :cd_estabelecimento or x.cd_estabelecimento is null))';

if (ie_consistir_retencao_p = 'N') then
	ds_comando_w := ds_comando_w || ' and		((c.cd_tributo = :cd_tributo) and  (c.vl_tributo <> 0)) ';
end if;

ds_comando_w :=	ds_comando_w || ' and	exists	(select	1 '					||
				'		from	dirf_regra_tributo	x '		||
				'		where 	x.cd_tributo = c.cd_tributo) '		||
				' and	not exists	(select	1 '				||
				'			from	dirf_titulo_pagar	d '  	||
				' 			where 	d.nr_titulo = p.nr_titulo '   	||
				'			and	d.cd_tributo = :cd_tributo ' 	||
				'			and	d.cd_darf = :cd_darf) ';

-- Regra DT_MES_REFERENCIA
if (ie_tipo_data_p = 1) then -- Pega pela data de emissão
	if (ie_consistir_retencao_p = 'S') then
		ds_comando_w 	:= ds_comando_w || ' and to_char(p.dt_emissao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and p.dt_emissao <= fim_mes(:dt_mes_referencia) ';
		dt_escolhida_w	:= ' and to_char(x.dt_emissao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and x.dt_emissao <= fim_mes(:dt_mes_referencia) and x.dt_emissao >= p.dt_emissao ';
	else
		ds_comando_w 	:= ds_comando_w	|| ' and to_char(p.dt_emissao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
		dt_escolhida_w	:= ' and to_char(x.dt_emissao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
	end if;
elsif (ie_tipo_data_p = 2) then -- Pega pela data contábil
	if (ie_consistir_retencao_p = 'S') then
		ds_comando_w 	:= ds_comando_w || ' and to_char(p.dt_contabil,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and p.dt_contabil <= fim_mes(:dt_mes_referencia) ';
		dt_escolhida_w	:= ' and to_char(x.dt_contabil,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and x.dt_contabil <= fim_mes(:dt_mes_referencia) and x.dt_contabil >= p.dt_contabil ';
	else
		ds_comando_w 	:= ds_comando_w || ' and to_char(p.dt_contabil,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
		dt_escolhida_w	:= ' and to_char(x.dt_contabil,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
	end if;
elsif (ie_tipo_data_p = 3) then -- Pega pela data de liquidação
	if (ie_consistir_retencao_p = 'S') then
		ds_comando_w 	:= ds_comando_w || ' and to_char(p.dt_liquidacao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and p.dt_liquidacao <= fim_mes(:dt_mes_referencia) ';
		dt_escolhida_w	:= ' and to_char(x.dt_liquidacao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and x.dt_liquidacao <= fim_mes(:dt_mes_referencia) and x.dt_liquidacao >= p.dt_liquidacao';
	else
		ds_comando_w 	:= ds_comando_w	|| ' and to_char(p.dt_liquidacao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
		dt_escolhida_w	:= ' and to_char(x.dt_liquidacao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
	end if;
elsif (ie_tipo_data_p = 4) then -- Pega pela data de emissão da nota
	if (ie_consistir_retencao_p = 'S') then
		ds_comando_w 	:= ds_comando_w || ' and to_char(n.dt_emissao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and n.dt_emissao <= fim_mes(:dt_mes_referencia) ';
		dt_escolhida_w	:= ' and to_char(x.dt_emissao,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and x.dt_emissao <= fim_mes(:dt_mes_referencia) and x.dt_emissao >= p.dt_emissao ';
	else
		ds_comando_w 	:= ds_comando_w	|| ' and to_char(n.dt_emissao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
		dt_escolhida_w	:= ' and to_char(x.dt_emissao,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
	end if;
elsif (ie_tipo_data_p = 5) then -- Pega pela data de vencimento
	if (ie_consistir_retencao_p = 'S') then
		ds_comando_w 	:= ds_comando_w || ' and to_char(p.dt_vencimento_atual,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and p.dt_vencimento_atual <= fim_mes(:dt_mes_referencia) ';
		dt_escolhida_w	:= ' and to_char(x.dt_vencimento_atual,''YYYY'') = to_char(:dt_mes_referencia, ''YYYY'') and x.dt_vencimento_atual <= fim_mes(:dt_mes_referencia) and x.dt_vencimento_atual >= p.dt_vencimento_atual';
	else
		ds_comando_w 	:= ds_comando_w	|| ' and to_char(p.dt_vencimento_atual,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
		dt_escolhida_w	:= ' and to_char(x.dt_vencimento_atual,''MM/YYYY'') = to_char(:dt_mes_referencia, ''MM/YYYY'') ';
	end if;
end if;

-- Regra CD_ESTABELECIMENTO
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	ds_comando_w	:= ds_comando_w || ' and p.cd_estabelecimento = :cd_estabelecimento ';
end if;

if (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then
	ds_comando_w	:= ds_comando_w	||	' and	exists	(select	1 '					||
						'		from	estabelecimento	x '			||
						'		where	x.cd_empresa		= :cd_empresa '	||
						'		and	p.cd_estabelecimento	= x.cd_estabelecimento) ';
end if;

-- Regra CD_DARF
if (cd_darf_p IS NOT NULL AND cd_darf_p::text <> '') then
	ds_comando_w := ds_comando_w || ' and	nvl(decode(p.cd_darf,:cd_darf,c.cd_darf,null), ' 								||
					'	substr(obter_codigo_darf(nvl(c.cd_tributo, p.cd_tributo), ' 							||
					'	to_number(obter_descricao_padrao(''TITULO_PAGAR'',''CD_ESTABELECIMENTO'',nvl(p.nr_titulo,p.nr_titulo))), ' 	||
					'		obter_descricao_padrao(''TITULO_PAGAR'',''CD_CGC'',nvl(p.nr_titulo,p.nr_titulo)), ' 			||
					'		null),1,10)' 										||
					') = :cd_darf ';
end if;

-- Regra CD_DARF
-- Consistir retenção do tributo, isto é, trazer apenas as pessoas jurídicas que tiveram retenção deste tributo no ano.
/*
if	(ie_consistir_retencao_p = 'S') then
	ds_comando_w := ds_comando_w || ' and exists	(select 1 ' 													||
					' 		from 	titulo_pagar		x, ' 										||
					'			titulo_pagar_imposto	z, ' 										||
					'			tributo k '												||
					' 		where	x.nr_titulo = z.nr_titulo ' 										||
					' 		and	x.cd_cgc = p.cd_cgc ' 											||
					'		and	k.cd_tributo = z.cd_tributo '										||
					dt_escolhida_w 															||
					' 		and	z.vl_imposto > 0 ' 											||
					' 		and 	z.cd_tributo = :cd_tributo ' 										||
					'		and	k.cd_retencao = :cd_darf) ';
end if;
*/
-- Consistir retenção do tributo, isto é, trazer apenas as pessoas jurídicas que tiveram retenção deste tributo no ano.
if (ie_consistir_retencao_p = 'S') then
	ds_comando_w := ds_comando_w || ' and exists	(select 	1 ' 												||
					' 		from 	titulo_pagar x, ' 											||
					'			titulo_pagar_imposto z ' 										||
					' 		where	x.nr_titulo = z.nr_titulo ' 										||
					' 		and	x.cd_cgc = p.cd_cgc ' 											||
							dt_escolhida_w 													||
					' 		and	z.vl_imposto > 0 ' 											||
					' 		and 	z.cd_tributo = :cd_tributo ' 										||
					' 		and	nvl(z.cd_darf, ' 											||
					'				substr(obter_codigo_darf(z.cd_tributo, ' 							||
					'				to_number(obter_descricao_padrao(''TITULO_PAGAR'',''CD_ESTABELECIMENTO'',z.nr_titulo)), ' 	||
					'				obter_descricao_padrao(''TITULO_PAGAR'',''CD_CGC'',z.nr_titulo), ' 				||
					'				null),1,10)'											||
					'				) = :cd_darf) ';
end if;

-- Regra tipo de título
select	count(1)
into STRICT	qt_registros_w
from	dirf_regra_tipo_tit LIMIT 1;

if (qt_registros_w > 0) then
	ds_comando_w	:= ds_comando_w ||	' and p.ie_tipo_titulo in	(select	x.ie_tipo_titulo '	||
						'				from	dirf_regra_tipo_tit	x '	||
						'				where	x.cd_estabelecimento = :cd_estabelecimento or x.cd_estabelecimento is null) ';
end if;

-- Regra origem do título
select 	count(1)
into STRICT	qt_registros_w
from	dirf_regra_origem_tit LIMIT 1;

if (qt_registros_w > 0) then
	ds_comando_w	:= ds_comando_w ||	' and p.ie_origem_titulo in	(select	x.ie_origem_titulo '		||
						'				from	dirf_regra_origem_tit	x '	||
						'				where	x.cd_estabelecimento = :cd_estabelecimento or x.cd_estabelecimento is null)';
end if;

-- Situação do título
select 	count(1)
into STRICT	qt_registros_w
from	dirf_regra_situacao_tit LIMIT 1;

if (qt_registros_w > 0) then
	ds_comando_w	:= ds_comando_w ||	' and p.ie_situacao in	(select	x.ie_situacao_titulo '			||
						'			from	dirf_regra_situacao_tit	x '		||
						'			where	x.cd_estabelecimento = :cd_estabelecimento or x.cd_estabelecimento is null) ';
end if;

-- Não colocar títulos que são as parcelas de um título desdobrado
ds_comando_w	:= ds_comando_w || ' and	p.nr_seq_tributo is null';

-- Não colocar os título que têm mais de uma parcela
--ds_comando_w	:= ds_comando_w || ' and	((p.nr_parcelas is null) or (p.nr_parcelas = 1))';
-- Operação da nota
select	count(1)
into STRICT	qt_registros_w
from	dirf_regra_operacao LIMIT 1;

if (qt_registros_w > 0) then
	ds_comando_w	:= ds_comando_w ||	' and	n.cd_operacao_nf in	(select	x.cd_operacao_nf '		||
						'				from	dirf_regra_operacao	x '	||
						'				where	x.cd_estabelecimento = :cd_estabelecimento or x.cd_estabelecimento is null) ';
end if;

ds_comando_subst_w	:= ds_comando_w;
c01 := dbms_sql.open_cursor;
dbms_sql.parse(c01, ds_comando_w, dbms_sql.native);
dbms_sql.define_column(c01, 1, cd_cgc_w, 50);
dbms_sql.define_column(c01, 2, nr_titulo_w);
dbms_sql.define_column(c01, 3, nr_seq_nota_fiscal_w);
dbms_sql.define_column(c01, 4, vl_mercadoria_w);
dbms_sql.define_column(c01, 5, vl_imposto_w);
dbms_sql.define_column(c01, 6, vl_base_calculo_w);
dbms_sql.define_column(c01, 7, ie_tipo_titulo_w, 6);
dbms_sql.define_column(c01, 8, nr_seq_classe_w);

if	((ie_tipo_data_p = 1) or (ie_tipo_data_p = 2) or (ie_tipo_data_p = 3) or (ie_tipo_data_p = 4) or (ie_tipo_data_p = 5)) then
	dbms_sql.bind_variable(c01, 'DT_MES_REFERENCIA', 'S');
end if;

dbms_sql.bind_variable(c01, 'CD_DARF', 'S', 50);
dbms_sql.bind_variable(c01, 'CD_TRIBUTO', 'S');
dbms_sql.bind_variable(c01, 'CD_ESTABELECIMENTO', 'S');

if	((ie_tipo_data_p = 1) or (ie_tipo_data_p = 2) or (ie_tipo_data_p = 3) or (ie_tipo_data_p = 4) or (ie_tipo_data_p = 5)) then
	dbms_sql.bind_variable(c01, 'DT_MES_REFERENCIA', dt_mes_referencia_p);
	ds_comando_subst_w	:= replace(ds_comando_subst_w,':dt_mes_referencia',dt_mes_referencia_p);
end if;

if (cd_darf_p IS NOT NULL AND cd_darf_p::text <> '') then
	dbms_sql.bind_variable(c01, 'CD_DARF', cd_darf_p,50);
	ds_comando_subst_w	:= replace(ds_comando_subst_w,':cd_darf',cd_darf_p);
end if;

if (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then
	dbms_sql.bind_variable(c01, 'CD_EMPRESA', cd_empresa_p);
	ds_comando_subst_w	:= replace(ds_comando_subst_w,':cd_empresa',cd_empresa_p);
end if;

dbms_sql.bind_variable(c01, 'CD_TRIBUTO', cd_tributo_p);
ds_comando_subst_w	:= replace(ds_comando_subst_w,':cd_tributo',cd_tributo_p);
dbms_sql.bind_variable(c01, 'CD_ESTABELECIMENTO', cd_estabelecimento_p);
ds_comando_subst_w	:= replace(ds_comando_subst_w,':cd_estabelecimento',cd_estabelecimento_p);
retorno_w := dbms_sql.execute(c01);

qt_registros_br_w	:= coalesce(obter_regra_tipo_tit(cd_tributo_p,cd_estabelecimento_p,'BR'),0);
qt_registros_si_w	:= coalesce(obter_regra_tipo_tit(cd_tributo_p,cd_estabelecimento_p,'SI'),0);

while(dbms_sql.fetch_rows(c01) > 0 ) loop
	begin
	dbms_sql.column_value(c01, 1, cd_cgc_w);
	dbms_sql.column_value(c01, 2, nr_titulo_w);
	dbms_sql.column_value(c01, 3, nr_seq_nota_fiscal_w);
	dbms_sql.column_value(c01, 4, vl_mercadoria_w);
	dbms_sql.column_value(c01, 5, vl_imposto_w);
	dbms_sql.column_value(c01, 6, vl_base_calculo_w);
	dbms_sql.column_value(c01, 7, ie_tipo_titulo_w);
	dbms_sql.column_value(c01, 8, nr_seq_classe_w);

	ie_grava_w	:= 'S';

	-- Classificação do título
	select	count(1)
	into STRICT	qt_registros_w
	from	dirf_regra_classif_tit	d,
		dirf_regra_tipo_tit	r
	where	d.nr_regra_tipo_tit	= r.nr_sequencia
	and	r.ie_tipo_titulo	= ie_tipo_titulo_w
	and	r.cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;

	if (qt_registros_w > 0) then
		select	count(1)
		into STRICT	qt_registros_ww
		from	dirf_regra_classif_tit	d,
			dirf_regra_tipo_tit	r
		where	d.nr_regra_tipo_tit	= r.nr_sequencia
		and	r.ie_tipo_titulo	= ie_tipo_titulo_w
		and	d.nr_seq_classe		= nr_seq_classe_w
		and	r.cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;

		if (qt_registros_ww > 0) then
			ie_gerar_w	:= 'S';
		else
			ie_gerar_w	:= 'N';
		end if;
	else
		ie_gerar_w	:= 'S';
	end if;

	if (ie_gerar_w = 'S') then
		--Considerar o valor de base de cálculo do tributo do título como valor de rendimento
		qt_registros_w	:= qt_registros_br_w;

		if (qt_registros_w > 0) then
			vl_rendimento_w	:= vl_base_calculo_w;
		else
			vl_rendimento_w := vl_mercadoria_w;
		end if;

		qt_registros_w	:= qt_registros_si_w;

		if (qt_registros_w > 0) then
			select	coalesce(sum(CASE WHEN t.ie_soma_diminui='S' THEN vl_imposto * -1 WHEN t.ie_soma_diminui='D' THEN vl_imposto  ELSE 0 END ),0)
			into STRICT	vl_imposto_aux_w
			from	titulo_pagar_imposto	i,
				tributo			t
			where	t.cd_tributo = i.cd_tributo
			and	i.nr_titulo = nr_titulo_w
			and	t.ie_soma_diminui <> 'N';

			vl_rendimento_w := vl_rendimento_w + vl_imposto_aux_w;
		end if;

		if (ie_tipo_data_p in (1, 4)) then -- Pega pela data de emissão
			select	max(p.dt_emissao)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 2) then -- Pega pela data contábil
			select	max(p.dt_contabil)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 3) then -- Pega pela data de liquidação
			select	max(p.dt_liquidacao)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 5) then -- Pega pela data de vencimento
			select	max(p.dt_vencimento_atual)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		end if;

		insert into dirf_titulo_pagar(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_lote_dirf,
			nr_titulo,
			vl_rendimento,
			vl_imposto,
			cd_tributo,
			cd_darf,
			dt_base_titulo,
			ie_origem)
		values (nextval('dirf_titulo_pagar_seq'),
			clock_timestamp(),
			'Tasy',
			clock_timestamp(),
			'Tasy',
			nr_sequencia_p,
			nr_titulo_w,
			vl_rendimento_w,
			vl_imposto_w,
			cd_tributo_p,
			cd_darf_p,
			dt_base_titulo_w,
			'S');

		contador_w	:= contador_w + 1;

		if (mod(contador_w, 100) = 0) then
			commit;
		end if;

	end if;
	end;
end loop;

dbms_sql.close_cursor(c01);

insert into DIRF_LOTE_MENSAL_COMANDO(
	nr_sequencia,
	nr_seq_lote_dirf,
	nm_objeto_comando,
	ds_comando,
	ds_comando_substituido,
	nm_usuario,
	dt_atualizacao)
values (nextval('dirf_lote_mensal_comando_seq'),
	nr_sequencia_p,
	'OBTER_PJ_DIRF_NOTA',
	ds_comando_w,
	ds_comando_subst_w,
	'Tasy',
	clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pj_dirf_nota ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_tributo_p bigint, cd_darf_p text, ie_tipo_data_p bigint, ie_consistir_retencao_p text, dt_mes_referencia_p timestamp, cd_empresa_p bigint) FROM PUBLIC;

