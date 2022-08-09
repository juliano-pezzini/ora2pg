-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_produto_benef_a300 ( nr_seq_plano_empresa_p bigint, ie_gerar_sca_nao_liberado_p pls_parametros.ie_gerar_sca_nao_liberado%type, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prestador_w		bigint;
nr_seq_segurado_w		bigint;
nm_beneficiario_w		varchar(120);
cd_pessoa_fisica_w		varchar(20);
dt_nascimento_w			timestamp;
dt_inclusao_w			timestamp;
ie_sexo_w			varchar(1);
ie_estado_civil_w		varchar(2);
dt_inclusao_operadora_w		timestamp;
dt_contratacao_w		timestamp;
nr_seq_parentesco_w		bigint;
nr_cpf_w			varchar(14);
nr_identidade_w			varchar(30);
sg_emissora_ci_w		varchar(2);
dt_rescisao_w			timestamp;
ie_nascido_plano_w		varchar(1);
nm_abreviado_w			varchar(25);
nr_seq_titular_w		bigint;
cd_origem_empresa_w		bigint;
nr_seq_beneficiario_w		bigint;
cd_usuario_plano_w		varchar(13);
cd_familia_w			integer;
cd_plano_destino_w		varchar(6);
dt_inicio_carencia_w		timestamp;
cd_titular_plano_w		varchar(13);
ie_tipo_acomodacao_w		varchar(1);
nr_seq_lote_w			bigint;
cd_estabelecimento_w		bigint;
ie_tipo_movimentacao_w		varchar(1);
cd_destino_w			varchar(10);
nr_seq_classificacao_w		bigint;
dt_mov_inicio_w			timestamp;
dt_mov_fim_w			timestamp;
cd_cgc_outorgante_w		varchar(15);
nr_seq_congenere_w		bigint;
cd_cooperativa_w		varchar(10);
cd_dependencia_w		varchar(2);
nr_seq_pais_w			bigint;
cd_pais_w			smallint;
dt_ultima_carencia_w		timestamp;
ie_abrangencia_w		varchar(2);
ie_abrangencia_ww		varchar(2);
cd_plano_w			varchar(30);
dt_contrato_w			timestamp;
qt_prazo_vinculado_w		integer;
ds_orgao_emissor_w		pessoa_fisica.ds_orgao_emissor_ci%type;
qt_dias_carencia_w		bigint;
vl_mensalidade_w		double precision;
dt_adesao_sca_w			timestamp;
dt_base_carencia_w		timestamp;
ds_tipo_acomodacao_w		varchar(30);
nr_seq_plano_w			bigint;
nr_seq_vinculo_sca_w		bigint;
ie_gerar_complemento_w		varchar(10);
qt_w				bigint;
nr_seq_plano_sca_w		bigint;
nr_seq_sub_classificacao_w	bigint;
nr_seq_vinculo_sca_sub_w	bigint;
nr_cartao_nac_sus_w		varchar(20);
ie_tipo_movimento_w		varchar(1);
nm_mae_benef_w			varchar(255);
nr_pis_pasep_w			varchar(11);
nr_contrato_w			bigint;
id_filho_w			ptu_regra_id_filho.id_filho%type;
ie_tipo_classificacao_w		pls_sca_classificacao.ie_tipo_classificacao%type;
ie_tipo_beneficiario_w		ptu_mov_produto_lote.ie_tipo_beneficiario%type;
-------------------------------------------------------------------------------
ds_sql_sca_benef_w 		varchar(2000);
ds_filtro_sca_benef_w		varchar(2000);
var_cur_w			integer;
var_exec_w			integer;
var_retorno_w			integer;
nr_versao_transacao_w		ptu_movimentacao_produto.nr_versao_transacao%type;
nr_idade_benef_w		bigint;
nr_seq_contrato_w		bigint;
ie_calculo_vl_mens_padrao_w	varchar(1);
cd_usuario_plano_benef_w	ptu_mov_produto_benef.cd_usuario_plano_benef%type;
cd_titular_benef_plano_w	ptu_mov_produto_benef.cd_titular_benef_plano%type;
qt_excessoes_w			bigint;
nr_seq_contrato_benef_w		bigint;
ie_data_inclusao_ptu_w		pls_sca_classificacao.ie_data_inclusao_ptu%type;
vl_sca_w			double precision;


BEGIN

select	c.nr_seq_contrato,
	c.nr_contrato,
	b.nr_seq_lote,
	trunc(b.dt_mov_inicio,'dd'),
	fim_dia(b.dt_mov_fim),
	a.cd_estabelecimento,
	a.ie_tipo_movimento,
	a.cd_destino,
	coalesce(a.nr_seq_classificacao,0),
	b.nr_versao_transacao,
	nr_seq_prestador,
	coalesce(a.ie_tipo_beneficiario,'A')
into STRICT	nr_seq_contrato_w,
	nr_contrato_w,
	nr_seq_lote_w,
	dt_mov_inicio_w,
	dt_mov_fim_w,
	cd_estabelecimento_w,
	ie_tipo_movimentacao_w,
	cd_destino_w,
	nr_seq_classificacao_w,
	nr_versao_transacao_w,
	nr_seq_prestador_w,
	ie_tipo_beneficiario_w
from	ptu_mov_produto_empresa		c,
	ptu_movimentacao_produto	b,
	ptu_mov_produto_lote		a
where	c.nr_seq_mov_produto		= b.nr_sequencia
and	b.nr_seq_lote			= a.nr_sequencia
and	c.nr_sequencia			= nr_seq_plano_empresa_p;

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_w;

select	max(nr_sequencia)
into STRICT	nr_seq_congenere_w
from	pls_congenere
where	cd_cgc			= cd_cgc_outorgante_w
and	ie_tipo_congenere	= 'CO';

select	max(cd_cooperativa)
into STRICT	cd_cooperativa_w
from	pls_congenere
where	nr_sequencia	= nr_seq_congenere_w;

select	ie_tipo_classificacao,
	ie_tipo_classificacao,
	nr_seq_sub_classificacao,
	ie_data_inclusao_ptu
into STRICT	cd_plano_destino_w,
	ie_tipo_classificacao_w,
	nr_seq_sub_classificacao_w,
	ie_data_inclusao_ptu_w
from	pls_sca_classificacao
where	nr_sequencia	= nr_seq_classificacao_w;

qt_w	:= 0;

if (ie_tipo_movimentacao_w = 'P') then
	ds_filtro_sca_benef_w	:=	ds_filtro_sca_benef_w || ' and ((b.dt_inicio_vigencia between :dt_mov_inicio and :dt_mov_fim) ' ||
								' or (b.dt_fim_vigencia between :dt_mov_inicio and :dt_mov_fim)) ';
elsif (ie_tipo_movimentacao_w = 'A') then
	ds_filtro_sca_benef_w	:=	ds_filtro_sca_benef_w || ' and :dt_mov_inicio >= trunc(b.dt_inicio_vigencia,''mm'') ' ||
								' and ((b.dt_fim_vigencia is null) or (fim_dia(b.dt_fim_vigencia) > :dt_mov_inicio)) ';
elsif (ie_tipo_movimentacao_w = 'M') then
	ds_filtro_sca_benef_w	:=	ds_filtro_sca_benef_w || ' and trunc(b.dt_inicio_vigencia,''mm'') <= trunc(:dt_mov_inicio,''mm'') ';
elsif (ie_tipo_movimentacao_w = 'I') then
	ds_filtro_sca_benef_w	:=	ds_filtro_sca_benef_w || ' and ((b.dt_inicio_vigencia between :dt_mov_inicio and :dt_mov_fim) ' ||
								' and ((b.dt_fim_vigencia is null) or (trunc(b.dt_fim_vigencia,''dd'') > :dt_mov_inicio))) ';
elsif (ie_tipo_movimentacao_w = 'E') then
	ds_filtro_sca_benef_w	:=	ds_filtro_sca_benef_w || ' and ((trunc(b.dt_fim_vigencia,''dd'') between :dt_mov_inicio and :dt_mov_fim) and (b.dt_fim_vigencia is not null)) ';
end if;

ds_filtro_sca_benef_w := ds_filtro_sca_benef_w || ' and ((trunc(b.dt_inicio_vigencia,''dd'') <> trunc(b.dt_fim_vigencia,''dd'') and b.dt_fim_vigencia is not null) or b.dt_fim_vigencia is null) ';

if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then
	ds_filtro_sca_benef_w	:= 	ds_filtro_sca_benef_w || '  and e.nr_contrato = :nr_contrato ';
end if;

if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
	ds_filtro_sca_benef_w	:= 	ds_filtro_sca_benef_w || '  and	e.nr_sequencia = :nr_seq_contrato ';
elsif (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
	ds_filtro_sca_benef_w	:= 	ds_filtro_sca_benef_w || '  and	d.nr_seq_prestador = :nr_seq_prestador ';
end if;

if (ie_tipo_beneficiario_w <> 'A') then
	if (ie_tipo_beneficiario_w = 'T') then -- Titulares
		ds_filtro_sca_benef_w	:= 	ds_filtro_sca_benef_w || '  and	a.nr_seq_titular is null ';
	elsif (ie_tipo_beneficiario_w = 'D') then -- Dependentes
		ds_filtro_sca_benef_w	:= 	ds_filtro_sca_benef_w || '  and	a.nr_seq_titular is not null ';
	end if;
end if;

ds_sql_sca_benef_w	:= 	'	select	distinct b.nr_sequencia,				' ||
				'		substr(f.nm_pessoa_fisica,1,120),			' ||
				'		f.cd_pessoa_fisica,					' ||
				'		f.dt_nascimento,					' ||
				'		nvl(f.ie_sexo,''M''),					' ||
				'		nvl(decode(f.ie_estado_civil,''1'',''S'',''2'',''M'',''3'',''D'',''4'',''D'',''5'',''W'',''6'',''A'',''7'',''U'',''9'',''S''),''S''), ' ||
				'		a.dt_inclusao_operadora,				' ||
				'		a.nr_seq_parentesco,					' ||
				'		f.nr_cpf,						' ||
				'		f.nr_identidade,					' ||
				'		f.sg_emissora_ci,					' ||
				'		a.ie_nascido_plano,					' ||
				'		substr(f.nm_abreviado,1,25),				' ||
				'		a.nr_seq_titular,					' ||
				'		nvl(a.cd_operadora_empresa,e.cd_operadora_empresa),	' ||
				'		nvl(substr(cd_matricula_familia,1,6),000000),		' ||
				'		f.nr_seq_pais,						' ||
				'		e.dt_contrato,						' ||
				'		f.ds_orgao_emissor_ci,					' ||
				'		a.nr_seq_plano,						' ||
				'		f.nr_cartao_nac_sus,					' ||
				'		f.nr_pis_pasep,						' ||
				'		e.nr_sequencia,						' ||
				'		a.dt_contratacao					' ||
				'	from	pessoa_fisica		f,				' ||
				'		pls_sca_vinculo		b,				' ||
				'		pls_segurado		a,				' ||
				'		pls_plano		c,				' ||
				'		pls_plano_fornecedor	d,				' ||
				'		pls_contrato		e				' ||
				'	where	f.cd_pessoa_fisica	= a.cd_pessoa_fisica		' ||
				'	and	b.nr_seq_segurado	= a.nr_sequencia		' ||
				'	and	b.nr_seq_plano		= c.nr_sequencia		' ||
				'	and	d.nr_seq_plano		= c.nr_sequencia		' ||
				'	and	a.nr_seq_contrato	= e.nr_sequencia		' ||
				'	and	a.dt_liberacao 		is not null			' ||
				'	and	a.dt_cancelamento 	is null				' ||
				'	and	((c.nr_seq_classificacao	= :nr_seq_classificacao) or
						 (c.nr_seq_classificacao	= :nr_seq_sub_classificacao))	' || ds_filtro_sca_benef_w;

if (ie_gerar_sca_nao_liberado_p = 'N') then
	ds_sql_sca_benef_w	:= ds_sql_sca_benef_w || '	and	b.dt_liberacao is not null ';
end if;				
						
var_cur_w := dbms_sql.open_cursor;
dbms_sql.parse(var_cur_w, ds_sql_sca_benef_w, 1);

dbms_sql.bind_variable(var_cur_w, ':nr_seq_classificacao', nr_seq_classificacao_w);
dbms_sql.bind_variable(var_cur_w, ':nr_seq_sub_classificacao', nr_seq_sub_classificacao_w);
dbms_sql.bind_variable(var_cur_w, ':dt_mov_inicio', dt_mov_inicio_w);

if (ie_tipo_movimentacao_w in ('P','I','E')) then
	dbms_sql.bind_variable(var_cur_w, ':dt_mov_fim', dt_mov_fim_w);
end if;

if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_contrato', nr_contrato_w);
end if;

if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_contrato', nr_seq_contrato_w);
elsif (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_prestador', nr_seq_prestador_w);
end if;

dbms_sql.define_column(var_cur_w, 1, nr_seq_vinculo_sca_w);
dbms_sql.define_column(var_cur_w, 2, nm_beneficiario_w,120);
dbms_sql.define_column(var_cur_w, 3, cd_pessoa_fisica_w,10);
dbms_sql.define_column(var_cur_w, 4, dt_nascimento_w);
dbms_sql.define_column(var_cur_w, 5, ie_sexo_w,1);
dbms_sql.define_column(var_cur_w, 6, ie_estado_civil_w,2);
dbms_sql.define_column(var_cur_w, 7, dt_inclusao_operadora_w);
dbms_sql.define_column(var_cur_w, 8, nr_seq_parentesco_w);
dbms_sql.define_column(var_cur_w, 9, nr_cpf_w,14);
dbms_sql.define_column(var_cur_w, 10, nr_identidade_w,30);
dbms_sql.define_column(var_cur_w, 11, sg_emissora_ci_w,2);
dbms_sql.define_column(var_cur_w, 12, ie_nascido_plano_w,1);
dbms_sql.define_column(var_cur_w, 13, nm_abreviado_w,25);
dbms_sql.define_column(var_cur_w, 14, nr_seq_titular_w);
dbms_sql.define_column(var_cur_w, 15, cd_origem_empresa_w);
dbms_sql.define_column(var_cur_w, 16, cd_familia_w);
dbms_sql.define_column(var_cur_w, 17, nr_seq_pais_w);
dbms_sql.define_column(var_cur_w, 18, dt_contrato_w);
dbms_sql.define_column(var_cur_w, 19, ds_orgao_emissor_w,40);
dbms_sql.define_column(var_cur_w, 20, nr_seq_plano_w);
dbms_sql.define_column(var_cur_w, 21, nr_cartao_nac_sus_w,20);
dbms_sql.define_column(var_cur_w, 22, nr_pis_pasep_w, 11);
dbms_sql.define_column(var_cur_w, 23, nr_seq_contrato_benef_w);
dbms_sql.define_column(var_cur_w, 24, dt_contratacao_w);
var_exec_w := dbms_sql.execute(var_cur_w);

loop
	var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
	exit when var_retorno_w = 0;

	dbms_sql.column_value(var_cur_w, 1, nr_seq_vinculo_sca_w);
	dbms_sql.column_value(var_cur_w, 2, nm_beneficiario_w);
	dbms_sql.column_value(var_cur_w, 3, cd_pessoa_fisica_w);
	dbms_sql.column_value(var_cur_w, 4, dt_nascimento_w);
	dbms_sql.column_value(var_cur_w, 5, ie_sexo_w);
	dbms_sql.column_value(var_cur_w, 6, ie_estado_civil_w);
	dbms_sql.column_value(var_cur_w, 7, dt_inclusao_operadora_w);
	dbms_sql.column_value(var_cur_w, 8, nr_seq_parentesco_w);
	dbms_sql.column_value(var_cur_w, 9, nr_cpf_w);
	dbms_sql.column_value(var_cur_w, 10, nr_identidade_w);
	dbms_sql.column_value(var_cur_w, 11, sg_emissora_ci_w);
	dbms_sql.column_value(var_cur_w, 12, ie_nascido_plano_w);
	dbms_sql.column_value(var_cur_w, 13, nm_abreviado_w);
	dbms_sql.column_value(var_cur_w, 14, nr_seq_titular_w);
	dbms_sql.column_value(var_cur_w, 15, cd_origem_empresa_w);
	dbms_sql.column_value(var_cur_w, 16, cd_familia_w);
	dbms_sql.column_value(var_cur_w, 17, nr_seq_pais_w);
	dbms_sql.column_value(var_cur_w, 18, dt_contrato_w);
	dbms_sql.column_value(var_cur_w, 19, ds_orgao_emissor_w);
	dbms_sql.column_value(var_cur_w, 20, nr_seq_plano_w);
	dbms_sql.column_value(var_cur_w, 21, nr_cartao_nac_sus_w);
	dbms_sql.column_value(var_cur_w, 22, nr_pis_pasep_w);
	dbms_sql.column_value(var_cur_w, 23, nr_seq_contrato_benef_w);
	dbms_sql.column_value(var_cur_w, 24, dt_contratacao_w);
	
	nr_idade_benef_w	:= coalesce(obter_idade(dt_nascimento_w, dt_mov_fim_w, 'A'),0); -- Buscar a idade do beneficiario no mes do lote		
	
	select	nr_seq_segurado,
		nr_seq_plano,
		dt_inicio_vigencia,
		dt_fim_vigencia
	into STRICT	nr_seq_segurado_w,
		nr_seq_plano_sca_w,
		dt_adesao_sca_w,
		dt_rescisao_w
	from	pls_sca_vinculo
	where	nr_sequencia	= nr_seq_vinculo_sca_w;
	
	begin
	select	ie_acomodacao,
		ie_abrangencia,
		cd_plano,
		coalesce(cd_plano_intercambio,cd_plano_destino_w)
	into STRICT	ie_tipo_acomodacao_w,
		ie_abrangencia_w,
		cd_plano_w,
		cd_plano_destino_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_sca_w;
	exception
	when others then
		ie_tipo_acomodacao_w	:= null;
		ie_abrangencia_w	:= null;
		cd_plano_w		:= null;
		cd_plano_destino_w	:= null;
	end;
	
	if (ie_data_inclusao_ptu_w = 'C') then
		dt_inclusao_w	:= dt_contratacao_w;
	else
		dt_inclusao_w	:= dt_inclusao_operadora_w;
	end if;
	
	
	if (coalesce(ie_tipo_acomodacao_w::text, '') = '') then
		ds_tipo_acomodacao_w	:= pls_obter_dados_cart_unimed(nr_seq_segurado_w,nr_seq_plano_w,'DA',0);
		
		if (ds_tipo_acomodacao_w = 'APARTAMENTO') then
			ie_tipo_acomodacao_w	:= 'B';
		elsif (ds_tipo_acomodacao_w = 'ENFERMARIA') then
			ie_tipo_acomodacao_w	:= 'A';
		else
			ie_tipo_acomodacao_w	:= 'C';
		end if;
	else
		if (ie_tipo_acomodacao_w = 'C') then
			ie_tipo_acomodacao_w	:= 'A';
		elsif (ie_tipo_acomodacao_w = 'I') then
			ie_tipo_acomodacao_w	:= 'B';
		else
			ie_tipo_acomodacao_w	:= 'C';
		end if;
	end if;
	
	--Obter o tipo de movimentacao do SCA
	if (ie_tipo_movimentacao_w = 'I') then
		ie_tipo_movimento_w	:= 'I';
	elsif (ie_tipo_movimentacao_w = 'E') then
		ie_tipo_movimento_w	:= 'E';
	else
		if	(( dt_adesao_sca_w between dt_mov_inicio_w and dt_mov_fim_w) and ((coalesce(dt_rescisao_w::text, '') = '') or (dt_rescisao_w > dt_mov_inicio_w))) then
			ie_tipo_movimento_w	:= 'I';
		elsif	(dt_rescisao_w between dt_mov_inicio_w and dt_mov_fim_w AND dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
			ie_tipo_movimento_w	:= 'E';
		else
			ie_tipo_movimento_w	:= 'A';
		end if;
	end if;
	
	--Buscar a quantidade de dias de carencia do SCA
	select	max(qt_dias)
	into STRICT	qt_dias_carencia_w
	from	pls_carencia		c,
		pls_sca_vinculo		b,
		pls_plano		a
	where	b.nr_seq_plano		= a.nr_sequencia
	and	c.nr_seq_plano		= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_vinculo_sca_w
	and	c.ie_cpt		= 'N';
	
	ie_calculo_vl_mens_padrao_w := 'S';
	
	if (cd_cgc_outorgante_w = '76767219000182') then -- Unimed Regional Maringa
		if (ie_tipo_classificacao_w in ('W','O')) then -- W = Remissao / O = Protecao Familiar
			ie_calculo_vl_mens_padrao_w := 'N';
			
			select	coalesce(sum(a.vl_item),0)
			into STRICT	vl_mensalidade_w
			from	pls_mensalidade_seg_item	a,
				pls_mensalidade_segurado	b,
				pls_segurado			c,
				pls_mensalidade			d,
				pls_lote_mensalidade		e
			where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
			and	b.nr_seq_segurado		= c.nr_sequencia
			and	b.nr_seq_mensalidade		= d.nr_sequencia
			and	d.nr_seq_lote			= e.nr_sequencia
			and	b.dt_mesano_referencia		= dt_mov_inicio_w
			and	c.nr_seq_contrato		= nr_seq_contrato_benef_w
			and	coalesce(d.ie_cancelamento::text, '') = ''
			and	((ie_tipo_classificacao_w = 'W' and (c.nr_seq_titular IS NOT NULL AND c.nr_seq_titular::text <> '')) or (ie_tipo_classificacao_w = 'O')) -- W = Remissao / O = Protecao Familiar
			and	a.ie_tipo_item in ('1','4','5','25'); -- 1-Preco Pre Establecido / 4-Reajuste Cobranca Retroativa / 5-Reajuste Mudanca de Faixa Etaria / 25-Reajuste Variacao de Custo
		
			select	coalesce(sum(a.vl_item),0)
			into STRICT	vl_sca_w
			from  	pls_mensalidade_seg_item  a,
				pls_mensalidade_segurado  b,
				pls_segurado      c,
				pls_mensalidade     d,
				pls_mensalidade_sca f,
				pls_sca_vinculo g,
				pls_plano p,
				pls_sca_classificacao e
			where 	a.nr_seq_mensalidade_seg = b.nr_sequencia
			and 	b.nr_seq_segurado = c.nr_sequencia
			and 	b.nr_seq_mensalidade = d.nr_sequencia
			and 	a.nr_sequencia = f.nr_seq_item_mens
			and	e.nr_sequencia = p.nr_seq_classificacao
			and	p.nr_sequencia = g.nr_seq_plano
			and 	g.nr_sequencia = f.nr_seq_vinculo_sca
			and 	b.dt_mesano_referencia    = dt_mov_inicio_w
			and 	c.nr_seq_contrato   = nr_seq_contrato_benef_w
			and 	coalesce(d.ie_cancelamento::text, '') = ''
			and 	((ie_tipo_classificacao_w = 'W' and (c.nr_seq_titular IS NOT NULL AND c.nr_seq_titular::text <> '')) or (ie_tipo_classificacao_w = 'O')) -- W = Remissao / O = Protecao Familiar
			and 	a.ie_tipo_item in ('15');
			
			vl_mensalidade_w	:= vl_mensalidade_w + vl_sca_w;
		else
			ie_calculo_vl_mens_padrao_w := 'S';
		end if;
	end if;
	
	if (ie_calculo_vl_mens_padrao_w = 'S') then
		select	sum(a.vl_item)
		into STRICT	vl_mensalidade_w
		from	pls_mensalidade_seg_item	a,
			pls_mensalidade_segurado	b,
			pls_mensalidade			d,
			pls_sca_vinculo			c,
			pls_lote_mensalidade		e
		where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
		and	a.nr_seq_vinculo_sca		= c.nr_sequencia
		and	b.nr_seq_mensalidade		= d.nr_sequencia
		and	d.nr_seq_lote			= e.nr_sequencia
		and	c.nr_sequencia			= nr_seq_vinculo_sca_w
		and	b.dt_mesano_referencia		= dt_mov_inicio_w
		and	coalesce(d.ie_cancelamento::text, '') = ''
		and	a.ie_tipo_item			= '15';
	end if;
	
	begin
	select	nm_contato
	into STRICT	nm_mae_benef_w
	from	compl_pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	ie_tipo_complemento	= 5  LIMIT 1;
	exception
	when others then
		nm_mae_benef_w	:= '';
	end;
	
	if (ie_abrangencia_w IS NOT NULL AND ie_abrangencia_w::text <> '') then
		select	CASE WHEN ie_abrangencia_w='GE' THEN 'E' WHEN ie_abrangencia_w='GM' THEN 'L' WHEN ie_abrangencia_w='M' THEN 'L'  ELSE ie_abrangencia_w END
		into STRICT	ie_abrangencia_ww
		;
	else
		ie_abrangencia_ww	:= '';
	end if;
	
	if (coalesce(vl_mensalidade_w::text, '') = '') then
		vl_mensalidade_w	:= 0;
	end if;
	
	if (coalesce(dt_adesao_sca_w::text, '') = '') then
		dt_adesao_sca_w	:= dt_inclusao_operadora_w;
	end if;
	
	if (qt_dias_carencia_w IS NOT NULL AND qt_dias_carencia_w::text <> '') then
		dt_ultima_carencia_w	:= dt_adesao_sca_w + qt_dias_carencia_w;
		dt_base_carencia_w	:= dt_adesao_sca_w;
	else
		dt_ultima_carencia_w	:= null;
		dt_base_carencia_w	:= dt_adesao_sca_w;
	end if;
	
	if (coalesce(nm_abreviado_w::text, '') = '') then
		nm_abreviado_w	:= substr(pls_gerar_nome_abreviado(nm_beneficiario_w),1,25);
	end if;

	if (dt_contrato_w >= to_date('01/01/2011', 'dd/mm/rrrr')) then
		qt_prazo_vinculado_w	:= 3;
	else
		qt_prazo_vinculado_w	:= 5;
	end if;
	
	cd_usuario_plano_w		:= '';
	cd_usuario_plano_benef_w 	:= '';
	cd_titular_plano_w		:= '';
	cd_titular_benef_plano_w	:= '';
	
	begin
	select	substr(cd_usuario_plano,5,13),
		cd_usuario_plano
	into STRICT	cd_usuario_plano_w,
		cd_usuario_plano_benef_w
	from	pls_segurado_carteira
	where	nr_seq_segurado = nr_seq_segurado_w;
	exception
	when others then
		cd_usuario_plano_w		:= 0000000000000;
		cd_usuario_plano_benef_w 	:= 000000000000000000000000000000;
	end;
	
	if (coalesce(cd_usuario_plano_w::text, '') = '') then
		cd_usuario_plano_w := cd_usuario_plano_benef_w;
	end if;
	
	if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
		begin
		select	substr(cd_usuario_plano,5,13),
			cd_usuario_plano
		into STRICT	cd_titular_plano_w,
			cd_titular_benef_plano_w
		from	pls_segurado_carteira
		where	nr_seq_segurado = nr_seq_titular_w;
		exception
		when others then
			cd_titular_plano_w		:= 0000000000000;
			cd_titular_benef_plano_w	:= 000000000000000000000000000000;
		end;
		
		if (coalesce(cd_titular_plano_w::text, '') = '') then
			cd_titular_plano_w := cd_titular_benef_plano_w;
		end if;
	elsif (coalesce(nr_seq_titular_w::text, '') = '') then
		cd_titular_plano_w		:= cd_usuario_plano_w;
		cd_titular_benef_plano_w	:= cd_usuario_plano_benef_w;
	end if;
	
	if (cd_cooperativa_w IS NOT NULL AND cd_cooperativa_w::text <> '') then -- Cooperativas (Exemplo: Unimed)
		cd_usuario_plano_benef_w	:= '';
		cd_titular_benef_plano_w	:= '';
	else -- Outras operadoras que nao sao cooperativas
		cd_usuario_plano_w		:= '';
		cd_titular_plano_w		:= '';
	end if;
	
	begin
	select	coalesce(cd_ptu,0)
	into STRICT	cd_dependencia_w
	from	grau_parentesco
	where	nr_sequencia	= nr_seq_parentesco_w;
	exception
	when others then
		cd_dependencia_w	:= 00;
	end;
	
	begin
	select	coalesce(cd_pais_sib,32)
	into STRICT	cd_pais_w
	from	pais
	where	nr_sequencia	= nr_seq_pais_w;
	exception
	when others then
		cd_pais_w	:= 000;
	end;
	
	if (coalesce(cd_origem_empresa_w::text, '') = '') then
		cd_origem_empresa_w	:= 0;
	end if;
	
	if ( coalesce(dt_rescisao_w::text, '') = '') then
		select	max(dt_rescisao)
		into STRICT	dt_rescisao_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	end if;	
	
	if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (dt_rescisao_w > fim_mes(dt_mov_fim_w)) then
		dt_rescisao_w	:= null;
	end if;
	
	nr_identidade_w		:= replace(replace(nr_identidade_w,'.',''),'-','');
	nm_beneficiario_w	:= replace(replace(replace(nm_beneficiario_w,lower(obter_expressao_dic_objeto(1106015)),'c'),upper(obter_expressao_dic_objeto(1106015)),'C'),'''',' ');
	nm_beneficiario_w	:= elimina_acentuacao(nm_beneficiario_w);
	
	nm_mae_benef_w		:= replace(replace(nm_mae_benef_w,chr(180),''),chr(96),'');
	nm_mae_benef_w		:= replace(replace(replace(nm_mae_benef_w,lower(obter_expressao_dic_objeto(1106015)),'c'),upper(obter_expressao_dic_objeto(1106015)),'C'),'''',' ');
	nm_mae_benef_w		:= elimina_acentuacao(nm_mae_benef_w);
	
	nm_abreviado_w		:= replace(replace(replace(nm_abreviado_w,lower(obter_expressao_dic_objeto(1106015)),'c'),upper(obter_expressao_dic_objeto(1106015)),'C'),'''',' ');
	nm_abreviado_w		:= elimina_acentuacao(nm_abreviado_w);
	
	ie_gerar_complemento_w	:= 'S';
	
	select	count(*)
	into STRICT	qt_excessoes_w
	from	ptu_prod_lote_restricao a,
		ptu_movimentacao_produto b,
		ptu_mov_produto_empresa c
	where	a.nr_seq_lote		= b.nr_seq_lote
	and	c.nr_seq_mov_produto	= b.nr_sequencia
	and	c.nr_sequencia		= nr_seq_plano_empresa_p
	and	a.nr_seq_contrato	= nr_seq_contrato_benef_w;
	
	if (qt_excessoes_w = 0) then
		select	nextval('ptu_mov_produto_benef_seq')
		into STRICT	nr_seq_beneficiario_w
		;
		
		id_filho_w	:= pls_obter_id_regra_ident_filho(nr_seq_segurado_w);
		
		begin
		insert into ptu_mov_produto_benef(	nr_sequencia,		nr_seq_empresa,		cd_unimed,			cd_usuario_plano,
				cd_familia,		nm_benef_abreviado,	cd_plano_destino,		dt_nascimento,
				ie_sexo,		ie_estado_civil,	dt_atualizacao,			nm_usuario,
				dt_atualizacao_nrec,	nm_usuario_nrec,	dt_inclusao,			cd_dependencia,
				dt_repasse,		dt_inclusao_plano_dest,	cd_cgc_cpf,			nr_rg,
				sg_uf_rg,		dt_exclusao,		ie_filho,			nr_identidade,
				dt_base_carencia,	cd_empresa_origem,	cd_titular_plano,		nm_beneficiario,
				dt_inclusao_empr_uni,	ie_tipo_acomodacao,	cd_pais,			dt_ultima_carencia,
				cd_plano,		ie_area_abrangencia,	qt_prazo_vinculo,		nr_seq_segurado,
				ds_orgao_emissor,	vl_mensalidade,		nr_cartao_nac_sus,		nr_seq_vinculo_sca_sub,
				nr_seq_vinculo_sca,	cd_pessoa_fisica,	ie_tipo_movimento,		nm_mae_benef,
				nr_pis_pasep,		nr_seq_titular,		cd_usuario_plano_benef,		cd_titular_benef_plano)
		values (	nr_seq_beneficiario_w,	nr_seq_plano_empresa_p,	cd_cooperativa_w,		cd_usuario_plano_w,
				cd_familia_w,		upper(nm_abreviado_w),	cd_plano_destino_w,		dt_nascimento_w,
				ie_sexo_w,		ie_estado_civil_w,	clock_timestamp(),			nm_usuario_p,
				clock_timestamp(),		nm_usuario_p,		dt_inclusao_w,			cd_dependencia_w,
				dt_adesao_sca_w,	dt_adesao_sca_w,	nr_cpf_w,			nr_identidade_w,
				sg_emissora_ci_w,	dt_rescisao_w,		id_filho_w,			nr_identidade_w,
				dt_base_carencia_w,	cd_origem_empresa_w,	cd_titular_plano_w,		upper(nm_beneficiario_w),
				dt_contrato_w,		ie_tipo_acomodacao_w,	cd_pais_w,			dt_ultima_carencia_w,
				cd_plano_w,		ie_abrangencia_ww,	qt_prazo_vinculado_w,		nr_seq_segurado_w,
				ds_orgao_emissor_w,	vl_mensalidade_w,	nr_cartao_nac_sus_w,		nr_seq_vinculo_sca_sub_w,
				nr_seq_vinculo_sca_w,	cd_pessoa_fisica_w,	ie_tipo_movimento_w,		nm_mae_benef_w,
				nr_pis_pasep_w,		nr_seq_titular_w,	cd_usuario_plano_benef_w,	cd_titular_benef_plano_w);
		exception
		when others then
			ie_gerar_complemento_w	:= 'N';
			CALL ptu_gravar_log_erro_a300(nr_seq_lote_w,nr_seq_segurado_w, obter_expressao_dic_objeto(1106017) ||chr(13)||chr(10)|| sqlerrm(SQLSTATE),cd_estabelecimento_w,nm_usuario_p);
		end;
		
		if (ie_gerar_complemento_w  = 'S') then
			if (nr_versao_transacao_w > 12) then -- PTU 6.0
				if (nr_idade_benef_w < 18) then
					if	((coalesce(trim(both nr_pis_pasep_w)::text, '') = '') and (coalesce(trim(both nm_mae_benef_w)::text, '') = '') and (coalesce(nr_cpf_w::text, '') = '')) then
						CALL ptu_gravar_incon_benef_envio(null,nr_seq_beneficiario_w, obter_expressao_dic_objeto(1106031),
									null, cd_estabelecimento_w, nm_usuario_p);
					end if;
				else
					if (coalesce(trim(both nr_pis_pasep_w)::text, '') = '') and (coalesce(trim(both nm_mae_benef_w)::text, '') = '') and (coalesce(dt_rescisao_w::text, '') = '') then
						commit;
						CALL ptu_gravar_incon_benef_envio(null,nr_seq_beneficiario_w, obter_expressao_dic_objeto(1106032),
									null, cd_estabelecimento_w, nm_usuario_p);
					end if;
				end if;
			end if;
		end if;
		
		if (ie_gerar_complemento_w = 'S') then
			CALL ptu_gerar_benef_compl_a300(nr_seq_beneficiario_w,cd_pessoa_fisica_w,nm_usuario_p);
		end if;
		
		qt_w	:= qt_w + 1;
		
		if (qt_w = 1000) then
			commit;
			qt_w	:= 0;
		end if;
	end if;
	end loop;
	
dbms_sql.close_cursor(var_cur_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_produto_benef_a300 ( nr_seq_plano_empresa_p bigint, ie_gerar_sca_nao_liberado_p pls_parametros.ie_gerar_sca_nao_liberado%type, nm_usuario_p text) FROM PUBLIC;
