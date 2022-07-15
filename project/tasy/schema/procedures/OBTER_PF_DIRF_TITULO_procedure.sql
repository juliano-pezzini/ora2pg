-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pf_dirf_titulo ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_tributo_p bigint, cd_darf_p text, ie_tipo_data_p bigint, ie_consistir_retencao_p text, dt_mes_referencia_p timestamp, ie_nota_fiscal_p text, cd_empresa_p bigint) AS $body$
DECLARE


c01				integer;
ds_comando_w			varchar(4000)	:= '';
ds_comando_subst_w		varchar(4000)	:= '';
ie_grava_w			varchar(1);
retorno_w			integer;
qt_registros_w			bigint;
qt_registros_ww			bigint;
contador_w			bigint;
dt_escolhida_w			varchar(240)	:= '';
ie_gerar_w			varchar(1);
ie_origem_titulo_w		varchar(6);
nr_titulo_w			bigint;
vl_imposto_w			double precision := 0;
vl_rendimento_w			double precision := 0;
vl_titulo_w			double precision := 0;
nr_seq_nota_fiscal_w		nota_fiscal.nr_sequencia%type;
nr_repasse_terceiro_w		repasse_terceiro.nr_repasse_terceiro%type;
dt_base_titulo_w		timestamp;
vl_nota_w			double precision;
vl_total_vencimento_w		double precision := 0;
vl_soma_rendimento_w		double precision := 0;
vl_vencimento_bruto_w		double precision := 0;
vl_item_nf_isento_w		double precision := 0;
vl_rend_prod_medica_w		double precision := 0;
vl_imposto_carta_w		double precision := 0;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
ie_corpo_item_w			tributo.ie_corpo_item%type;
vl_desc_repasse_w		repasse_terceiro_item.vl_repasse%type := 0;
--nr_seq_regra_w			repasse_terceiro_item.nr_seq_regra%type;
ie_partic_tributo_w		repasse_terceiro_item.ie_partic_tributo%type;
vl_desc_repasse_ww		repasse_terceiro_item.vl_repasse%type := 0;

C02 CURSOR FOR
	SELECT	row_number() OVER () AS nr_linha,
		nr_titulo_pagar,
		vl_vencimento,
		dt_vencimento
from (SELECT	nr_titulo_pagar,
		vl_vencimento,
		dt_vencimento
	from	nota_fiscal_venc a
	where	a.nr_sequencia = nr_seq_nota_fiscal_w
	order by
		vl_vencimento,
		dt_vencimento) alias0;
c02_w		c02%rowtype;

C03 CURSOR FOR
	SELECT	coalesce(nr_seq_regra, 0) nr_seq_regra,
		nr_sequencia_item
	from    repasse_terceiro_item
	where   nr_repasse_terceiro = nr_repasse_terceiro_w;
c03_w		c03%rowtype;


BEGIN

/*
-- #######################################################

-- ######                                                MONTAR O SELECT                                       ########

-- #######################################################

*/
ds_comando_w :=	
	'select	p.cd_pessoa_fisica,'||
		'p.nr_titulo, ' ||
		' p.vl_titulo, ' ||
		' i.vl_imposto, ' ||
		' p.nr_seq_nota_fiscal ' ||
	' from	titulo_pagar p, titulo_pagar_imposto i, tributo t, nota_fiscal n ' ||
	' where	p.nr_titulo = i.nr_titulo(+) ' ||
	' and	i.cd_tributo = t.cd_tributo(+) ' ||
	' and	p.cd_pessoa_fisica  is not null ' ||
	' and	i.ie_pago_prev <> ''R'' ' ||	
	' and   t.cd_tributo = :cd_tributo ' ||	
	' and   p.nr_seq_nota_fiscal = n.nr_sequencia(+) ' ||
	' and	not exists (	select 	1 from dirf_titulo_pagar d ' ||
				' where	d.nr_titulo = p.nr_titulo ' ||
				' and	d.cd_tributo = :cd_tributo ' ||
				' and	d.cd_darf = :cd_darf) ' ||
	' and	not exists (	select	1 ' ||
				' from	titulo_pagar x ' ||
				' where	x.nr_titulo = p.nr_titulo_original ' ||
				' and	nvl(x.ie_situacao,''X'') = ''D'' ' ||
				' ) ';
		
if (ie_consistir_retencao_p = 'N') then
	begin
	ds_comando_w := ds_comando_w ||
	' and i.vl_imposto <> 0 ';
	--' and t.cd_tributo = :cd_tributo ' ;
	end;
end if;

-- No colocar ttulos que so as parcelas de um ttulo desdobrado
ds_comando_w := ds_comando_w ||
	' and p.nr_seq_tributo is null ';

-- Regra CD_ESTABELECIMENTO
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	begin
	ds_comando_w := ds_comando_w ||
	' and p.cd_estabelecimento = :cd_estabelecimento ';
	end;
end if;

if (cd_empresa_p IS NOT NULL AND cd_empresa_p::text <> '') then
	begin
	ds_comando_w	:= ds_comando_w	||	
	' and	exists	(select	1 ' ||
		' from	estabelecimento	x ' ||
		' where	x.cd_empresa = :cd_empresa ' ||
		' and	p.cd_estabelecimento = x.cd_estabelecimento) ';
	end;
end if;

-- Regra CD_DARF
if (cd_darf_p IS NOT NULL AND cd_darf_p::text <> '') then
	begin
	ds_comando_w := ds_comando_w ||
	' and nvl( i.cd_darf, ' ||
		'obter_codigo_darf(i.cd_tributo, p.cd_estabelecimento, p.cd_cgc, p.cd_pessoa_fisica)) = :cd_darf';
	/*' substr(obter_codigo_darf(i.cd_tributo, ' ||
	' to_number(obter_descricao_padrao(''TITULO_PAGAR'',''CD_ESTABELECIMENTO'',i.nr_titulo)), ' ||
	' obter_descricao_padrao(''TITULO_PAGAR'',''CD_CGC'',i.nr_titulo), ' ||
	' obter_descricao_padrao(''TITULO_PAGAR'',''CD_PESSOA_FISICA'',i.nr_titulo)),1,10)) = :cd_darf ' ;*/
	end;
end if;

-- Regra somente com nota_fiscal  / somente sem nota fiscal 
if (ie_nota_fiscal_p = 'S') then
	begin
	ds_comando_w := ds_comando_w ||
	' and p.nr_seq_nota_fiscal is not null ';
	end;
elsif (ie_nota_fiscal_p = 'T') then
	begin
	ds_comando_w := ds_comando_w ||
	' and p.nr_seq_nota_fiscal is null ';
	end;
end if;

-- Regra DT_MES_REFERENCIA
if (ie_tipo_data_p = 1) then -- Pega pela data de emisso
	if (ie_consistir_retencao_p <> 'N') then
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(p.dt_emissao,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' || 
		' and p.dt_emissao <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_emissao,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and x.dt_emissao <= fim_mes(:dt_mes_referencia) ' ||
		' and x.dt_emissao >= p.dt_emissao ';
		end;
	else
		begin
		ds_comando_w 	:= ds_comando_w	||
		' and trunc(p.dt_emissao,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_emissao,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		end;
	end if;
elsif (ie_tipo_data_p = 4) then -- Pega pela data de emisso da NF, caso nao tenha pega pela data de emissao do titulo
	if (ie_consistir_retencao_p <> 'N') then
        begin		
		ds_comando_w 	:= ds_comando_w	|| 
		' and trunc(nvl(n.dt_emissao,p.dt_emissao),''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and nvl(n.dt_emissao,p.dt_emissao) <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(nvl(n.dt_emissao,x.dt_emissao),''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and nvl(n.dt_emissao,x.dt_emissao) <= fim_mes(:dt_mes_referencia) ' ||
		' and nvl(n.dt_emissao,x.dt_emissao) >= p.dt_emissao ';
		end;
	
	else	
		begin
		ds_comando_w 	:= ds_comando_w	|| 
		' and trunc(nvl(n.dt_emissao,p.dt_emissao),''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		dt_escolhida_w	:= 
		' and trunc(nvl(n.dt_emissao,x.dt_emissao),''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		end;		
	end if;
elsif (ie_tipo_data_p = 2) then -- Pega pela data contbil
	if (ie_consistir_retencao_p <> 'N') then
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(p.dt_contabil,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and p.dt_contabil <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_contabil,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and x.dt_contabil <= fim_mes(:dt_mes_referencia) ' ||
		' and x.dt_contabil >= p.dt_contabil ';
		end;
	else
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(p.dt_contabil,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_contabil,''MM'') = trunc(:dt_mes_referencia, ''MM'')	';
		end;
	end if;
elsif (ie_tipo_data_p = 3) then -- Pega pela data de liquidao
	if (ie_consistir_retencao_p <> 'N') then
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(p.dt_liquidacao,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and p.dt_liquidacao <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_liquidacao,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and x.dt_liquidacao <= fim_mes(:dt_mes_referencia) ' ||
		' and x.dt_liquidacao >= p.dt_liquidacao ';
		end;
	else	
		ds_comando_w 	:= ds_comando_w	||
		' and trunc(p.dt_liquidacao,''MM'') = trunc(:dt_mes_referencia, ''MM'')	';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_liquidacao,''MM'') = trunc(:dt_mes_referencia, ''MM'')	';
	end if;		
elsif (ie_tipo_data_p = 5) then -- Pega pela data de vencimento
	if (ie_consistir_retencao_p <> 'N') then
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(p.dt_vencimento_atual,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and p.dt_vencimento_atual <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_vencimento_atual,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and x.dt_vencimento_atual <= fim_mes(:dt_mes_referencia) ' ||
		' and x.dt_vencimento_atual >= p.dt_vencimento_atual ';
		end;
	else
		begin
		ds_comando_w 	:= ds_comando_w	||
		' and trunc(p.dt_vencimento_atual,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		dt_escolhida_w	:=
		' and trunc(x.dt_vencimento_atual,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		end;
	end if;
elsif (ie_tipo_data_p = 6) then -- Pega pela data de vencimento do tributo
	begin
	if (ie_consistir_retencao_p <> 'N') then
		begin
		ds_comando_w 	:= ds_comando_w ||
		' and trunc(i.dt_imposto,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and i.dt_imposto <= fim_mes(:dt_mes_referencia) ';
		
		dt_escolhida_w	:=
		' and trunc(z.dt_imposto,''YYYY'') = trunc(:dt_mes_referencia, ''YYYY'') ' ||
		' and z.dt_imposto <= fim_mes(:dt_mes_referencia) and z.dt_imposto >= p.dt_liquidacao ';
		end;
	else
		begin
		ds_comando_w 	:= ds_comando_w	||
		' and trunc(i.dt_imposto,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		
		dt_escolhida_w	:=
		' and trunc(z.dt_imposto,''MM'') = trunc(:dt_mes_referencia, ''MM'') ';
		end;
	end if;	
	end;
end if;

select	count(1)
into STRICT	qt_registros_w
from	dirf_regra_tipo_tit
where	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0)) = coalesce(cd_estabelecimento_p, 0)  LIMIT 1;

-- Consistir reteno do tributo, isto , trazer apenas as pessoas jurdicas que tiveram reteno deste tributo no ano.
if (ie_consistir_retencao_p = 'S') then
	begin
	ds_comando_w := ds_comando_w ||
	' and exists (	select 	1 ' ||
		' from 	titulo_pagar x, ' ||
			' titulo_pagar_imposto z, ' ||
			' tributo t ,' ||
			' nota_fiscal n  ' ||
		' where	x.nr_titulo = z.nr_titulo ' ||
		' and	z.cd_tributo = t.cd_tributo ' ||
		' and	x.cd_pessoa_fisica = p.cd_pessoa_fisica ' ||
		' and   x.nr_seq_nota_fiscal = n.nr_sequencia(+) ' ||
		 dt_escolhida_w ||
		' and	((z.vl_imposto > 0) or ' ||
		'	(( :cd_darf = ''0588'') and ( select nvl(sum(j.vl_titulo),0) '||
						    ' from titulo_pagar j, titulo_pagar_imposto g ' ||
						    ' where j.cd_pessoa_fisica = x.cd_pessoa_fisica '||		
						    ' and   j.nr_titulo = g.nr_titulo '||						    
						    ' and   j.ie_situacao <> ''C'' ';
if (qt_registros_w > 0) then	
	ds_comando_w := ds_comando_w || 	    ' and   j.ie_tipo_titulo in (select z.ie_tipo_titulo from dirf_regra_tipo_tit z) ';
end if;	
						
	ds_comando_w := ds_comando_w || 	    ' and   nvl(g.cd_darf, ' ||
								'obter_codigo_darf(g.cd_tributo, j.cd_estabelecimento, j.cd_cgc, j.cd_pessoa_fisica)) = :cd_darf' ||
						    ' and  trunc(j.dt_contabil,''rrrr'') = trunc(:dt_mes_referencia, ''rrrr'') '||
						    ' and  j.dt_contabil <= fim_mes(:dt_mes_referencia)) > 6000) or '||						    
		' (select nvl(sum(h.vl_imposto),0) '||
		' from    pls_pag_prest_vencimento v, '||
		'  	  pls_pag_prest_venc_trib h '||
		' where   v.nr_sequencia = h.nr_seq_vencimento '||
		' and 	  obter_ds_titulo_pagar(h.nr_sequencia) > 0 '||
		' and 	  h.cd_darf = 5706 '||
		' and	  v.nr_seq_pag_prestador in (	select 	k.nr_sequencia '||
							'from   pls_lote_pagamento l, '||
							'	pls_pagamento_prestador k, '||
							'	pls_prestador z '||
							'where 	l.nr_sequencia = k.nr_seq_lote  '||
							'and	z.nr_sequencia  = k.nr_seq_prestador  '||
							'and 	k.ie_cancelamento is null '||
							'and	z.cd_pessoa_fisica = x.cd_pessoa_fisica '||
							'and 	((	select 	max(y.vl_liquido)  '||
							'		from 	pls_pag_prest_vencimento y  '||
							'		where 	y.nr_seq_pag_prestador = k.nr_sequencia) <= 0) '||
							'and 	trunc(l.dt_venc_lote,''rrrr'') = trunc(:dt_mes_referencia, ''rrrr''))) > 0) '||	    
		' and 	t.cd_tributo = :cd_tributo ' ||
		' and 	nvl(i.cd_darf, ' ||
			'obter_codigo_darf(i.cd_tributo, p.cd_estabelecimento, p.cd_cgc, p.cd_pessoa_fisica)) = :cd_darf)';				
			/*' substr(obter_codigo_darf(i.cd_tributo, ' ||
			' to_number(obter_descricao_padrao(''TITULO_PAGAR'',''CD_ESTABELECIMENTO'',i.nr_titulo)), ' ||
			' obter_descricao_padrao(''TITULO_PAGAR'',''CD_CGC'',i.nr_titulo), ' ||
			' obter_descricao_padrao(''TITULO_PAGAR'',''CD_PESSOA_FISICA'',i.nr_titulo)),1,10)) = :cd_darf) ';*/
	end;
end if;

-- Regra tipo de ttulo
select	count(1)
into STRICT	qt_registros_w
from	dirf_regra_tipo_tit
where	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0)) = coalesce(cd_estabelecimento_p, 0)  LIMIT 1;

if (qt_registros_w > 0) then				
	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ds_comando_w	:= ds_comando_w || 	
		' and p.ie_tipo_titulo in ( select x.ie_tipo_titulo ' ||
					' from	dirf_regra_tipo_tit x ' ||
					' where	x.cd_estabelecimento = :cd_estabelecimento or ' ||
					' x.cd_estabelecimento is null) ';
	else
		ds_comando_w	:= ds_comando_w || 	
		' and p.ie_tipo_titulo in ( select x.ie_tipo_titulo ' ||
					' from	dirf_regra_tipo_tit x ' ||
					' where	x.cd_estabelecimento is null) ';
	end if;				
end if;

-- Regra origem do ttulo
select 	count(1)
into STRICT	qt_registros_w
from	dirf_regra_origem_tit
where	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0)) = coalesce(cd_estabelecimento_p, 0)  LIMIT 1;

if (qt_registros_w > 0) then
	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ds_comando_w	:= ds_comando_w	||	
		' and p.ie_origem_titulo in (select x.ie_origem_titulo ' ||
						' from	dirf_regra_origem_tit x ' ||
						' where	x.cd_estabelecimento = :cd_estabelecimento or ' ||
						' x.cd_estabelecimento is null) ';

	else
		ds_comando_w	:= ds_comando_w	||	
		' and p.ie_origem_titulo in (select x.ie_origem_titulo ' ||
						' from	dirf_regra_origem_tit x ' ||
						' where	x.cd_estabelecimento is null) ';
	end if;		
end if;

-- Situao do ttulo
select 	count(1)
into STRICT	qt_registros_w
from	dirf_regra_situacao_tit
where	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0)) = coalesce(cd_estabelecimento_p, 0)  LIMIT 1;

if (qt_registros_w > 0) then
	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		ds_comando_w := ds_comando_w ||	
		' and p.ie_situacao in	(select	x.ie_situacao_titulo ' ||
					' from	dirf_regra_situacao_tit	x ' ||
					' where	x.cd_estabelecimento = :cd_estabelecimento or ' ||
					' x.cd_estabelecimento is null) ';
	else
		ds_comando_w := ds_comando_w ||	
		' and p.ie_situacao in	(select	x.ie_situacao_titulo ' ||
					' from	dirf_regra_situacao_tit	x ' ||
					' where	x.cd_estabelecimento is null) ';
	end if;	
end if;

/*
-- ###################################################################################################

-- ########################                                        DEFINIO DE VARIVEIS                                 ##################################

-- ###################################################################################################

*/
ds_comando_subst_w	:= ds_comando_w;
c01 := dbms_sql.open_cursor;

dbms_sql.parse(c01, ds_comando_w, dbms_sql.native);
dbms_sql.define_column(c01, 1, cd_pessoa_fisica_w, 50);
dbms_sql.define_column(c01, 2, nr_titulo_w);
dbms_sql.define_column(c01, 3, vl_titulo_w);
dbms_sql.define_column(c01, 4, vl_imposto_w);
dbms_sql.define_column(c01, 5, nr_seq_nota_fiscal_w);

/*
-- ###################################################################################################

-- ########################                                       PASSAGEM DE PARAMETROS                               ##################################

-- ###################################################################################################

*/
if (ie_tipo_data_p in (1, 2, 3, 4, 5, 6)) then
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

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	dbms_sql.bind_variable(c01, 'CD_ESTABELECIMENTO', cd_estabelecimento_p);
	ds_comando_subst_w	:= replace(ds_comando_subst_w,':cd_estabelecimento',cd_estabelecimento_p);
end if;
/*
-- ###################################################################################################

-- ########################                                             EXECUTE DO CURSOR                                       ##################################

-- ###################################################################################################

*/
retorno_w := dbms_sql.execute(c01);

/*
-- ###################################################################################################

-- ########################                                              INICIO DO CURSOR                                        ##################################

-- ###################################################################################################

*/
while(dbms_sql.fetch_rows(c01) > 0 ) loop
	begin
	dbms_sql.column_value(c01, 1, cd_pessoa_fisica_w);
	dbms_sql.column_value(c01, 2, nr_titulo_w);
	dbms_sql.column_value(c01, 3, vl_titulo_w);
	dbms_sql.column_value(c01, 4, vl_imposto_w);
	dbms_sql.column_value(c01, 5, nr_seq_nota_fiscal_w);
	
	ie_grava_w	:= 'S';
	
	-- Classificao do ttulo
	select	count(1)
	into STRICT	qt_registros_w
	from	titulo_pagar		t,
		dirf_regra_classif_tit	d,
		dirf_regra_tipo_tit	r
	where	d.nr_regra_tipo_tit	= r.nr_sequencia
	and	r.ie_tipo_titulo	= t.ie_tipo_titulo
	and	r.cd_estabelecimento	= cd_estabelecimento_p
	and	t.nr_titulo		= nr_titulo_w  LIMIT 1;
	
	if (qt_registros_w > 0) then
		select	count(1)
		into STRICT	qt_registros_ww
		from	titulo_pagar		t,
			dirf_regra_classif_tit	d,
			dirf_regra_tipo_tit	r
		where	r.nr_sequencia		= d.nr_regra_tipo_tit
		and	r.ie_tipo_titulo	= t.ie_tipo_titulo
		and	d.nr_seq_classe		= t.nr_seq_classe
		and	r.cd_estabelecimento	= cd_estabelecimento_p
		and	t.nr_titulo		= nr_titulo_w  LIMIT 1;
		
		if (qt_registros_ww > 0) then
			ie_gerar_w	:= 'S';
		else
			ie_gerar_w	:= 'N';
		end if;
	else
		ie_gerar_w	:= 'S';
	end if;
	
	ie_gerar_w	:= 'S';
	if (ie_gerar_w = 'S') then
		/*
		VL_DOMINIO      | DESCRICAO                             
		--------------- | --------------------------------------

		0	| Importao
		1	| Nota Fiscal                           
		2	| Manual                                
		3	| Repasse                               
		4	| Imposto                               
		5	| OPS - Contas mdicas                  
		6	| OPS - Reembolso                       
		7	| Ordem de Compra                       
		8	| OPS - Comisso de vendas              
		9	| OPS - Ressarcimento                   
		10	| OPS - Taxa de sade suplementar       
		11	| Ressarcimento ao convnio             
		12	| OPS - Provises Tcnicas              
		13	| Distribuio de lucros                
		14	| Contrato                              
		15	| OPS - Cmara de compensao           
		16	| OPS - Intercmbio                     
		17	| Encontro de contas                    
		18	| OPS - Ocorrncia financeira           
		19	| OPS - Contestaes e Recursos de Glosa
		20	| OPS - Pagamento de produo mdica    
		21	| Unificao                            
		22	| Solicitao de compra                 
		23	| OPS - Devoluo de mensalidade        
		25	| OPS - Pagamento de produo mdica  (Nova)
		*/
		
		begin
		select	ie_origem_titulo
		into STRICT	ie_origem_titulo_w
		from	titulo_pagar
		where	nr_titulo = nr_titulo_w;
		exception
		when others then
			ie_origem_titulo_w := -1;
		end;

		vl_rendimento_w := vl_titulo_w;
		
		if (ie_origem_titulo_w = 1) then -- Nota Fiscal
			begin
			vl_vencimento_bruto_w	:= 0;
			vl_soma_rendimento_w	:= 0;
			qt_registros_w		:= 0;
			vl_nota_w		:= 0;
			begin
			-- Pegar o valor da nota bruto menos os descontos
			select	coalesce(a.vl_mercadoria,0) - coalesce(a.vl_descontos,0)
			into STRICT	vl_nota_w
			from	nota_fiscal a
			where	a.nr_sequencia = nr_seq_nota_fiscal_w;
			
			-- Regra de materiais no tributados
			select	count(*)
			into STRICT	qt_registros_w
			from	dirf_regra_item;
			
			if (qt_registros_w > 0) then
				begin
				--obter_se_estrutura_mat(x.cd_grupo_material, x.cd_subgrupo_material, x.cd_classe_material, x.cd_material, a.cd_material, 'S') = 'S'
				vl_item_nf_isento_w := 0;
				
				select	sum(vl_total_item_nf)
				into STRICT	vl_item_nf_isento_w
				from	nota_fiscal c,
					nota_fiscal_item b
				where	c.nr_sequencia = b.nr_sequencia
				and	c.nr_sequencia = nr_seq_nota_fiscal_w
				and	exists (SELECT	1
						from	dirf_regra_item a
						where	obter_se_estrutura_mat(a.cd_grupo_material, a.cd_subgrupo_material, a.cd_classe_material, a.cd_material, b.cd_material, 'S') = 'S'
						and	c.cd_estabelecimento = coalesce(a.cd_estab_exclusivo, c.cd_estabelecimento)
						and	a.cd_empresa = obter_empresa_estab(c.cd_estabelecimento)
						and	dt_mes_referencia_p between trunc(coalesce(a.dt_inicio_vig,dt_mes_referencia_p)) and
										fim_dia(coalesce(a.dt_fim_vig,dt_mes_referencia_p))
						);
				/*
				select	sum(vl_total_item_nf)
				into	vl_item_nf_isento_w
				from	nota_fiscal c,
					nota_fiscal_item b,
					dirf_regra_item a
				where	b.nr_sequencia = c.nr_sequencia
				and	obter_se_estrutura_mat(a.cd_grupo_material, a.cd_subgrupo_material, a.cd_classe_material, a.cd_material, b.cd_material, 'S') = 'S'
				and	c.nr_sequencia = nr_seq_nota_fiscal_w;
				*/
				vl_nota_w := vl_nota_w - coalesce(vl_item_nf_isento_w,0);
				
				end;
			end if;
			
			-- Soma dos vencimentos e quantidade
			select	count(*),
				sum(vl_vencimento)
			into STRICT	qt_registros_w,
				vl_total_vencimento_w
			from	nota_fiscal_venc a
			where	a.nr_sequencia = nr_seq_nota_fiscal_w;

			-- Se o campo 'ie_corpo_item' for do tipo 'C' o sistema ir gerar o tributo em apenas um ttulo do vencimento
			select 	max(coalesce(ie_corpo_item, 'V'))
			into STRICT	ie_corpo_item_w
			from 	tributo
			where 	cd_tributo = cd_tributo_p;
			
			-- Se s possuir um vencimento ou  a opo 'ie_corpo_item' for do tipo 'C' ento o valor que deve ir  o valor da mercadoria menos os descontos
			if (qt_registros_w = 1) or (ie_corpo_item_w = 'C') then
				begin
				vl_rendimento_w := vl_nota_w;
				end;
			-- Se existe mais de um vencimento, ento deve ratear o valor de mercadoria menos os descontos, de acordo com o valor de vencimento, e no ltimo vencimenteo arredontar para fechar o valor total da mercadoria
			elsif (qt_registros_w > 1) then
				begin
				open C02;
				loop
				fetch C02 into	
					c02_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					vl_vencimento_bruto_w := (vl_nota_w * c02_w.vl_vencimento) / vl_total_vencimento_w;
					vl_soma_rendimento_w := vl_soma_rendimento_w + vl_vencimento_bruto_w;
					-- Se for o ttulo do vencimento, ento entra pra pegar o valor 
					if (c02_w.nr_titulo_pagar = nr_titulo_w) then
						begin
						-- Se for o ltimo vencimento da parada, ento tem que arredondar o valor, para mais ou para menos, para adequar aos outros valores j gerados
						if (qt_registros_w = c02_w.nr_linha) then
							begin
							-- Aqui a conta '(vl_nota_w- vl_soma_rendimento_w)' deve retornar 1 , 2, -1 ou -2 centavos, do contrrio tem alguma coisa errada
							vl_rendimento_w := vl_vencimento_bruto_w + (vl_nota_w - vl_soma_rendimento_w);
							end;
						else
							begin
							vl_rendimento_w := vl_vencimento_bruto_w;
							end;
						end if;
						-- Se encontrou o registro, ento cai fora do c01
						exit;
						end;
					end if;
					end; -- end do c01
				end loop;
				close C02;
				end;
			end if;
			
			exception
			when others then
				vl_rendimento_w := vl_titulo_w;
			end;
			
			end;
		elsif (ie_origem_titulo_w = 3) then -- Repasse
			begin
			
			vl_desc_repasse_w := 0;
			
			if (coalesce(obter_dados_dirf_estab(cd_estabelecimento_p, 'CDR'), 'N') = 'S') then
				select	a.nr_repasse_terceiro
				into STRICT	nr_repasse_terceiro_w
				from	titulo_pagar a
				where	a.nr_titulo = nr_titulo_w;
				
				open C03;
				loop
				fetch C03 into	
					c03_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin

					if (c03_w.nr_seq_regra > 0)then
						select	coalesce(max(ie_partic_tributo),'X')
						into STRICT	ie_partic_tributo_w
						from	regra_calc_item_repasse
						where	nr_sequencia = c03_w.nr_seq_regra;

						if (ie_partic_tributo_w = 'N') then

							select (coalesce(x.vl_repasse,0) * -1)
							into STRICT	vl_desc_repasse_ww
							from 	repasse_terceiro_item x
							where 	x.nr_repasse_terceiro = nr_repasse_terceiro_w
							and	x.nr_sequencia_item = c03_w.nr_sequencia_item
							and	x.vl_repasse < 0;

							vl_desc_repasse_w := vl_desc_repasse_w + vl_desc_repasse_ww;

						end if;
					end if;

					end;
				end loop;
				close C03;
			end if;
			
			begin
			select	vl_vencimento
			into STRICT	vl_rendimento_w
			from	titulo_pagar a,
				repasse_terceiro_venc b
			where	a.nr_repasse_terceiro = b.nr_repasse_terceiro
			and	a.nr_titulo = b.nr_titulo
			and	a.nr_titulo = nr_titulo_w;			

			vl_rendimento_w := vl_rendimento_w + coalesce(vl_desc_repasse_w, 0);
			
			exception
			when others then
				vl_rendimento_w := vl_titulo_w;
			end;
			

			end;
		elsif (ie_origem_titulo_w = 20) then -- OPS - Pagamento de produo mdica
			begin

			select  sum(i.vl_item) - sum(( 	select	coalesce(sum(x.vl_vencimento),0)
							from	pls_pag_prest_venc_valor x
							where	x.nr_seq_evento = ev.nr_sequencia
							and	x.nr_seq_vencimento = v.nr_sequencia
							and	x.ie_tipo_valor = 'PP')) vl_remuneracao
			into STRICT	vl_rend_prod_medica_w
			from 	pls_lote_pagamento       l,
				pls_pagamento_prestador  p,
				pls_pag_prest_vencimento v,
				pls_pagamento_item 	 i,
				pls_evento 		 ev,
				pls_prestador		pe
			where	l.nr_sequencia = p.nr_seq_lote
			and 	p.nr_sequencia = v.nr_seq_pag_prestador
			and 	p.nr_sequencia = i.nr_seq_pagamento
			and	i.nr_seq_evento = ev.nr_sequencia
			and	v.nr_titulo 	= nr_titulo_w
			and	p.nr_seq_prestador = pe.nr_sequencia
			and	coalesce(pe.cd_pessoa_fisica,'X') <> 'X'
			and 	l.ie_status = 'D'
			and	coalesce(p.ie_cancelamento,'X') = 'X'
			and (exists (SELECT	1
					from	pls_evento_tributo evt,
						tributo t
					where	evt.nr_seq_evento = ev.nr_sequencia
					and	evt.cd_tributo = t.cd_tributo
					and	t.ie_tipo_tributo in ('INSS','IR','O')
					/*and	evt.ie_situacao = 'A'*/
));
		
			vl_rendimento_w	:= vl_rend_prod_medica_w;
			
			if coalesce(vl_rendimento_w::text, '') = '' then
				vl_rendimento_w := vl_titulo_w;
			end if;
			
			end;
		elsif (ie_origem_titulo_w = 25) then -- OPS - Pagamento de produo mdica (Nova)
			begin
					
			select	sum(i.vl_item) - sum((	select	coalesce(sum(abs(x.vl_acao_negativo)),0)
							from	pls_pp_prest_evento_valor x
							where	x.nr_seq_lote	= p.nr_seq_lote
							and	x.nr_seq_prestador = p.nr_seq_prestador
							and	x.nr_seq_evento	= i.nr_seq_evento
							and	x.ie_acao_pgto_negativo	= 'PP'))
			into STRICT	vl_rend_prod_medica_w
			from	pls_pp_lote l,
				pls_prestador pe,
				pls_pp_prestador p,
				pls_pp_prest_evento_valor i
			where	l.nr_sequencia	= p.nr_seq_lote
			and	p.nr_seq_lote	= i.nr_seq_lote
			and	p.nr_seq_prestador = i.nr_seq_prestador
			and	pe.nr_sequencia = p.nr_seq_prestador
			and	p.nr_titulo_pagar = nr_titulo_w
			and	coalesce(pe.cd_pessoa_fisica,'X') <> 'X'
			and 	l.ie_status = 'D'
			and	coalesce(p.ie_cancelado,'N') = 'N'
			and	exists (SELECT	1
					from	pls_pp_regra_vl_base_trib evt,
						tributo t
					where	evt.nr_seq_evento = i.nr_seq_evento
					and	evt.cd_tributo = t.cd_tributo
					and	t.ie_tipo_tributo in ('INSS','IR','O')
					/*and	evt.ie_situacao = 'A'*/
);
			
			-- Acontece de ficar nulo com ttulo de terceiro
			if (coalesce(vl_rend_prod_medica_w::text, '') = '') then
				select	abs(sum(h.vl_item)) - abs(sum(h.vl_acao_negativo))
				into STRICT	vl_rend_prod_medica_w
				from	pls_pp_lote l,
					pls_prestador pe,
					pls_pp_prestador p,
					pls_pp_prest_evento_valor i,
					pls_pp_item_lote h
				where	l.nr_sequencia	= p.nr_seq_lote
				and	p.nr_seq_lote	= i.nr_seq_lote
				and	p.nr_seq_prestador = i.nr_seq_prestador
				and	pe.nr_sequencia = p.nr_seq_prestador 
				and	h.nr_seq_prestador = i.nr_seq_prestador
				and	h.nr_seq_evento = i.nr_seq_evento
				and	h.nr_seq_lote	= i.nr_seq_lote
				and	h.nr_tit_pagar_terceiro = nr_titulo_w
				and	coalesce(pe.cd_pessoa_fisica,'X') <> 'X'
				and 	l.ie_status = 'D'
				and	coalesce(p.ie_cancelado,'N') = 'N'
				and	exists (SELECT	1
						from	pls_pp_regra_vl_base_trib evt,
							tributo t
						where	evt.nr_seq_evento = h.nr_seq_evento
						and	evt.cd_tributo = t.cd_tributo
						and	t.ie_tipo_tributo in ('INSS','IR','O')
						/*and	evt.ie_situacao = 'A'*/
);
			end if;	

      if vl_rend_prod_medica_w < 0 then
        vl_rend_prod_medica_w := 0;
      end if;

			vl_rendimento_w	:= vl_rend_prod_medica_w;
			
			if coalesce(vl_rendimento_w::text, '') = '' then
				vl_rendimento_w := vl_titulo_w;
			end if;
			
			end;
		elsif (ie_origem_titulo_w = 5) then
			begin
			select	max(a.vl_vencimento)
			into STRICT	vl_rendimento_w
			from	pls_lote_protocolo_venc a
			where	nr_titulo = nr_titulo_w;	
			exception
			when others then
				vl_rendimento_w := vl_titulo_w;
			end;
		end if;
		
		if (ie_tipo_data_p = 1) then -- Pega pela data de emisso
			select	max(p.dt_emissao)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 2) then -- Pega pela data contbil
			select	max(p.dt_contabil)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 3) then -- Pega pela data de liquidao
			select	max(p.dt_liquidacao)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 4) then -- Pega pela data de emissao da nota fiscal OS 1795100
			select	max(n.dt_emissao)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar p,
					nota_fiscal n
			where	p.nr_seq_nota_fiscal = n.nr_sequencia
			and 	p.nr_titulo = nr_titulo_w;
		elsif (ie_tipo_data_p = 5) then -- Pega pela data de vencimento
			select	max(p.dt_vencimento_atual)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar	p
			where	nr_titulo	= nr_titulo_w;
		elsif (ie_tipo_data_p = 6) then -- Pega pela data de vencimento do tributo
			select	max(i.dt_imposto)
			into STRICT	dt_base_titulo_w
			from	titulo_pagar_imposto	i
			where	i.nr_titulo	= nr_titulo_w
			and	i.cd_tributo	= cd_tributo_p;
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
			'Tasy2',
			clock_timestamp(),
			'Tasy2',
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

/*
-- ###################################################################################################

-- ########################                                   GRAVAR COMANDO EXECUTADO                            ##################################

-- ###################################################################################################

*/
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
	'OBTER_PF_DIRF_TITULO',
	ds_comando_w,
	ds_comando_subst_w,
	'Tasy',
	clock_timestamp());

commit;

CALL obter_dirf_prod_medica(	nr_sequencia_p,
			cd_estabelecimento_p,
			cd_tributo_p,	
			cd_darf_p,		
			ie_tipo_data_p,
			ie_consistir_retencao_p,
			dt_mes_referencia_p,
			ie_nota_fiscal_p,	
			cd_empresa_p,
			'PF');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pf_dirf_titulo ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_tributo_p bigint, cd_darf_p text, ie_tipo_data_p bigint, ie_consistir_retencao_p text, dt_mes_referencia_p timestamp, ie_nota_fiscal_p text, cd_empresa_p bigint) FROM PUBLIC;

