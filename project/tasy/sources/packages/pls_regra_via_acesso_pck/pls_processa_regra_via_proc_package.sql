-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_regra_via_acesso_pck.pls_processa_regra_via_proc ( cd_guia_referencia_p pls_conta.cd_guia_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_acao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Dependendo do tipo de acao (IE_TIPO_ACAO_P) passado por parametro, esta rotina definira quais procedimentos serao desmembrados, 
	ou definira quais regras de via de acesso serao vinculadas a cada procedimento.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 			

/* IE_TIPO_ACAO_P
	D - desmembrar procedimentos
	V - vincular as regras de via de acesso aos procedimentos
*/
 		

dt_inicio_vigencia_w	pls_tipo_via_acesso.dt_inicio_vigencia%type;	
dt_fim_vigencia_w	pls_tipo_via_acesso.dt_fim_vigencia%type;

ds_campos_select_w	varchar(4000);
ds_campos_order_by_w	varchar(4000);
ds_restricao_proc_w	varchar(4000);
ds_binds_w		varchar(4000);
ds_sql_w		varchar(4000);

nr_seq_conta_proc_w	pls_conta_proc.nr_sequencia%type;	
qt_proc_imp_w		integer;
nr_seq_proc_ref_w	pls_conta_proc.nr_seq_proc_ref%type;
ie_via_acesso_ref_w	pls_conta_proc.ie_via_acesso%type;
tx_item_ref_w		pls_conta_proc.tx_item%type;

var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;

i			integer;
qt_reg_transacao_w	integer;
nr_seq_proc_table_w	dbms_sql.number_table;
nr_seq_regra_table_w	dbms_sql.number_table;
tx_item_table_w		dbms_sql.number_table;
ie_via_acesso_table_w	dbms_sql.varchar2_table;
nr_seq_proc_pad_table_w	dbms_sql.number_table;

ie_via_acesso_regra_w	pls_parametros.ie_via_acesso_regra%type;
ie_via_acesso_inf_w	varchar(1);

ie_regra_valida_w	varchar(1);
qt_proc_regra_w		integer;
dt_procedimento_ant_w	pls_conta_proc_v.dt_procedimento_trunc%type;
dt_procedimento_w	pls_conta_proc_v.dt_procedimento_trunc%type;
qt_minuto_w		double precision;
ie_proc_ref_via_w	pls_parametros.ie_proc_ref_via%type;
cd_procedimento_w	pls_conta_proc_v.cd_procedimento%type;
ie_origem_proced_w	pls_conta_proc_v.ie_origem_proced%type;
qt_nao_localizado_w	integer;
nr_seq_regra_via_obrig_w pls_conta_proc_regra.nr_seq_regra_via_obrig%type;
nr_seq_via_obrig_regra_w pls_conta_proc_regra.nr_seq_regra_via_obrig%type;
qt_grupo_w		integer;
ie_tipo_intercambio_w	pls_regra_preco_qtde_proc.ie_tipo_intercambio%type;
ie_abrir_regras_w	varchar(1);
qt_mesmo_proc_w		integer;
qt_via_acesso_w		integer;
qt_tx_variavel_w	integer;
ie_inseriu_vetor_w	varchar(1);
idx_w			integer;
ie_nivel_via_acesso_w	pls_parametros.ie_nivel_via_acesso%type;
ie_origem_conta_w	pls_conta.ie_origem_conta%type;
ie_tipo_segurado_w	pls_segurado.ie_tipo_segurado%type;



C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_regra,
		count(b.nr_sequencia),
		sum(b.qt_procedimento)
	from	pls_tipo_via_acesso	a,
		pls_proc_via_acesso	b
	where	a.nr_sequencia		= b.nr_seq_regra
	and	a.ie_situacao		= 'A'
	group 	by a.nr_sequencia
	order 	by count(b.nr_sequencia),	-- as regras de via de acesso serao ordenados pela quantidade de regras de procedimentos e pela soma da quantidade de prcedimentos
		sum(b.qt_procedimento);
		
C02 CURSOR(	nr_seq_regra_pc		pls_tipo_via_acesso.nr_sequencia%type,
		ie_abrir_regras_pc	text) FOR
	-- regras agrupadas
	SELECT	max(a.qt_procedimento) qt_procedimento,
		sum(a.qt_proc_final) qt_proc_final,
		a.cd_procedimento,
		a.ie_origem_proced,	
		coalesce(max(a.ie_considerar_horario),'S') ie_considerar_horario,
		coalesce(max(a.qt_horario),0) qt_horario,
		max(a.ie_tipo_qt_horario) ie_tipo_qt_horario,
		max(a.ie_via_acesso) ie_via_acesso,
		max(a.tx_item_variavel) tx_item_variavel,
		max((	SELECT	max(x.ie_tipo_intercambio)
			from	pls_tipo_via_acesso	x
			where	x.nr_sequencia		= a.nr_seq_regra)) ie_tipo_intercambio,
		0 qt_min_proc,
		0 qt_max_proc
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra	= nr_seq_regra_pc
	and	a.ie_situacao	= 'A'
	and	ie_abrir_regras_pc = 'N'
	group 	by a.ie_origem_proced,
		a.cd_procedimento
	
union all

	-- regras abertas
	select	a.qt_procedimento,
		a.qt_proc_final,
		a.cd_procedimento,
		a.ie_origem_proced,	
		coalesce(a.ie_considerar_horario,'S') ie_considerar_horario,
		coalesce(a.qt_horario,0) qt_horario,
		a.ie_tipo_qt_horario,
		a.ie_via_acesso,
		a.tx_item_variavel,
		(	select	max(x.ie_tipo_intercambio)
			from	pls_tipo_via_acesso	x
			where	x.nr_sequencia		= a.nr_seq_regra) ie_tipo_intercambio,
		min(a.qt_procedimento) over (partition by a.cd_procedimento, a.ie_origem_proced) qt_min_proc,
		max(a.qt_procedimento) over (partition by a.cd_procedimento, a.ie_origem_proced) qt_max_proc
	from	pls_proc_via_acesso a
	where	a.nr_seq_regra	= nr_seq_regra_pc
	and	a.ie_situacao	= 'A'
	and	ie_abrir_regras_pc = 'S';
	
					
BEGIN

-- Obtem o controle padrao da quantidade de registros que sera enviada a cada vez para o banco de dados
qt_reg_transacao_w := pls_util_cta_pck.qt_registro_transacao_w;

-- Verifica se o sistema devera deixar em branco o campo da via de acesso do procedimento caso nao encontre uma regra de via de acesso padrao
select	coalesce(ie_via_acesso_regra,'N')
into STRICT	ie_via_acesso_regra_w
from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));

select	coalesce(max(a.ie_nivel_via_acesso),'N')
into STRICT	ie_nivel_via_acesso_w
from	pls_parametros	a
where	a.cd_estabelecimento	= cd_estabelecimento_p;

ie_proc_ref_via_w	:=  pls_regra_via_acesso_pck.pls_obter_proc_ref_via(cd_estabelecimento_p);

-- Cursor de regras de via de acesso
for r_C01_w in C01 loop

	ie_regra_valida_w := 'S';	
	nr_seq_via_obrig_regra_w := null;
	i := 0;	
	
	CALL exec_sql_dinamico(nm_usuario_p, 'truncate table pls_aux_guia_ref');	

	-- padrao N
	ie_abrir_regras_w := 'N';

	-- buscar o parametro novo e testar aqui, antes de fazer o count
	with dados as ( select  count(a.cd_procedimento) over (partition by a.cd_procedimento) qt_mesmo_proc,
				0 qt_via_acesso,
				0 qt_tx_variavel
			from    pls_proc_via_acesso     a
			where   a.nr_seq_regra          = r_c01_w.nr_seq_regra
			and     a.ie_situacao           = 'A'
			
union all

			select  0 qt_mesmo_proc,
				count(distinct a.ie_via_acesso) qt_via_acesso,
				count(distinct a.tx_item_variavel) qt_tx_variavel
			from    pls_proc_via_acesso     a
			where   a.nr_seq_regra          = r_c01_w.nr_seq_regra
			and     a.ie_situacao           = 'A')
	select  max(t.qt_mesmo_proc) qt_mesmo_proc,
		sum(t.qt_via_acesso) qt_via_acesso,
		sum(t.qt_tx_variavel) qt_tx_variavel
	into STRICT	qt_mesmo_proc_w,
		qt_via_acesso_w,
		qt_tx_variavel_w
	from    dados t;

	-- se possuir o parametro
		-- possuir 3 ou mais procedimentos de mesmo codigo
		-- OU
		-- possuir 3 ou mais vias de acesso distintas
		-- OU
		-- possuir 3 ou mais taxa variavel
	-- devera marcar para abertura das regras
	if	((qt_mesmo_proc_w >= 3) or (qt_via_acesso_w >= 3) or (qt_tx_variavel_w >= 3)) and (ie_nivel_via_acesso_w = 'S') then

		ie_abrir_regras_w := 'S';
	end if;
	
	-- se for abertura de regra, entao limpa este vetor a cada regra
	nr_seq_proc_pad_table_w.delete;

	-- Cursor de regras de via de acesso de procedimento
	for r_C02_w in C02(r_C01_w.nr_seq_regra, ie_abrir_regras_w) loop
		
		select	a.dt_inicio_vigencia,
			a.dt_fim_vigencia
		into STRICT	dt_inicio_vigencia_w,
			dt_fim_vigencia_w
		from	pls_tipo_via_acesso	a
		where	a.nr_sequencia = r_C01_w.nr_seq_regra;
		
		if (r_c02_w.ie_tipo_qt_horario = 'H') then
			qt_minuto_w := coalesce(r_c02_w.qt_horario,0) * 60;
		elsif (r_c02_w.ie_tipo_qt_horario = 'M') then
			qt_minuto_w := coalesce(r_c02_w.qt_horario,0);
		end if;	
		
		if (ie_tipo_acao_p = 'D') then
			ds_campos_select_w	:= ' null, null, null, null, null, null, null, null, null, null , null, null ';
			ds_campos_order_by_w	:= ' null ';
		elsif (ie_tipo_acao_p = 'V') then				
			ds_campos_select_w	:= ' (	select	x.ie_via_acesso	
							from	pls_conta_proc	x
							where	x.nr_sequencia = b.nr_seq_proc_ref ) ie_via_acesso_ref, 	' || pls_util_pck.enter_w ||
						' (	select	x.tx_item	
							from	pls_conta_proc	x
							where	x.nr_sequencia = b.nr_seq_proc_ref ) tx_item_ref, 		' || pls_util_pck.enter_w ||
						   '	b.cd_procedimento,							' || pls_util_pck.enter_w ||
						   '	b.ie_origem_proced,   							' || pls_util_pck.enter_w ||
						   '	b.dt_procedimento_trunc,						' || pls_util_pck.enter_w ||
						   '	b.hr_inicio_proc,							' || pls_util_pck.enter_w ||	
						   '	b.hr_fim_proc,								' || pls_util_pck.enter_w ||
						   '	b.ie_status_conta,							' || pls_util_pck.enter_w ||						
						   '	b.nr_seq_conta,								' || pls_util_pck.enter_w ||
						   '	pls_obter_dados_conta(b.nr_seq_conta,''TI1'') ie_tipo_intercambio,	' || pls_util_pck.enter_w ||
						   '	b.ie_origem_conta,							' || pls_util_pck.enter_w ||
						   '	b.ie_tipo_segurado							' || pls_util_pck.enter_w;

			ds_campos_order_by_w	:=
						   '    order_proc,		 						' || pls_util_pck.enter_w ||
						   '    d.nr_seq_regra_via_obrig, 						' || pls_util_pck.enter_w ||
						   '	b.ie_status_conta,							' || pls_util_pck.enter_w ||
						   '	b.dt_inicio_proc,							' || pls_util_pck.enter_w ||
						   '	b.hr_inicio_proc,							' || pls_util_pck.enter_w ||
						   '	nvl(b.nr_seq_proc_ref,0),						' || pls_util_pck.enter_w ||
						   '	ie_via_acesso_ref,							' || pls_util_pck.enter_w ||
						   '	b.nr_seq_conta,								' || pls_util_pck.enter_w ||
						   '	b.nr_sequencia,								' || pls_util_pck.enter_w ||
						   '	b.cd_procedimento,							' || pls_util_pck.enter_w ||
						   '	b.ie_origem_proced,							' || pls_util_pck.enter_w ||
						   '	b.hr_fim_proc								';
		end if;
			
		-- Carrega as restricoes vinculadas ao procedimento
		ds_restricao_proc_w := pls_regra_via_acesso_pck.pls_obtem_restricao_regra_proc('RESTRICAO', dt_inicio_vigencia_w,
										   dt_fim_vigencia_w, 
										   cd_guia_referencia_p,
										   r_C02_w.ie_considerar_horario,
										   r_C02_w.ie_tipo_qt_horario,
										   r_C02_w.qt_horario, var_cur_w);
											
		ds_sql_w := ' 	select	distinct b.nr_sequencia nr_seq_conta_proc,						' || pls_util_pck.enter_w ||
			    ' 		b.qt_procedimento_imp qt_proc_imp,							' || pls_util_pck.enter_w ||
			    '		b.nr_seq_proc_ref,									' || pls_util_pck.enter_w ||
			    '		b.dt_inicio_proc,									' || pls_util_pck.enter_w ||
			    '		b.cd_procedimento,									' || pls_util_pck.enter_w ||
			    '		b.ie_origem_proced,									' || pls_util_pck.enter_w ||
			    ' d.nr_seq_regra_via_obrig, ' || pls_util_pck.enter_w ||
					ds_campos_select_w						 			  || pls_util_pck.enter_w ||
			    '	,decode(b.cd_procedimento, :cd_proc, 0, 1) order_proc ' || pls_util_pck.enter_w ||
			    '	from	pls_conta_proc_v	a,								' || pls_util_pck.enter_w ||
			    ' 		pls_conta_proc_v	b,								' || pls_util_pck.enter_w ||
			    '           pls_conta_proc_regra	c,								' || pls_util_pck.enter_w ||
			    '           pls_conta_proc_regra	d								' || pls_util_pck.enter_w ||
			    ' 	where	a.nr_seq_segurado	= :nr_seq_segurado						' || pls_util_pck.enter_w ||
			    ' 	and	a.ie_glosa		= ''N''								' || pls_util_pck.enter_w ||
			    '   and	a.nr_sequencia		= c.nr_sequencia						' || pls_util_pck.enter_w ||
			    '   and	b.nr_sequencia		= d.nr_sequencia						' || pls_util_pck.enter_w ||
			    '	and	d.nr_seq_regra_via_obrig= c.nr_seq_regra_via_obrig					' || pls_util_pck.enter_w ||
			    ' 	and	a.ie_status not in (''D'',''M'')							' || pls_util_pck.enter_w ||
			    ' 	and	a.ie_via_obrigatoria	= ''S''								' || pls_util_pck.enter_w ||
			    '   and 	a.ie_via_acesso_manual  = ''N''								' || pls_util_pck.enter_w ||				
			    ' 	and	b.nr_seq_segurado	= a.nr_seq_segurado						' || pls_util_pck.enter_w ||
			    ' 	and	b.cd_procedimento	= a.cd_procedimento						' || pls_util_pck.enter_w ||
			    ' 	and	b.cd_guia_referencia	= a.cd_guia_referencia						' || pls_util_pck.enter_w ||
			    ' 	and	b.dt_procedimento_trunc = a.dt_procedimento_trunc ' || pls_util_pck.enter_w ||
			    '	and	a.nr_seq_regra_via_acesso	is null							' || pls_util_pck.enter_w ||
			    '	and	b.nr_seq_regra_via_acesso	is null							' || pls_util_pck.enter_w ||
			 --   '	and	b.ie_via_obrigatoria	= a.ie_via_obrigatoria						' || pls_util_pck.enter_w ||
			    ' 	and	b.ie_glosa		= a.ie_glosa							' || pls_util_pck.enter_w ||
			    ' 	and	b.ie_status not in (''D'',''M'')							' || pls_util_pck.enter_w ||			    	    
					ds_restricao_proc_w									  || pls_util_pck.enter_w ||
			    '	order	by ' || ds_campos_order_by_w;

		-- Abri um novo cursor
		var_cur_w := dbms_sql.open_cursor;
		
		begin				
			qt_proc_imp_w		:= 0;
			qt_proc_regra_w 	:= 0;
			
			-- Cria o cursor
			dbms_sql.parse(var_cur_w, ds_sql_w, 1);
			
			dbms_sql.bind_variable(var_cur_w, ':nr_seq_segurado', nr_seq_segurado_p);
			dbms_sql.bind_variable(var_cur_w, ':cd_proc', r_C02_w.cd_procedimento);
			--dbms_sql.bind_variable(var_cur_w, ':ie_origem_proc', r_C02_w.ie_origem_proced);
		--	dbms_sql.bind_variable(var_cur_w, ':cd_procedimento', r_C02_w.cd_procedimento);
		--	dbms_sql.bind_variable(var_cur_w, ':ie_origem_proced', r_C02_w.ie_origem_proced);
			
			--Atualiza as binds que serao utilizadas no select
			ds_binds_w := pls_regra_via_acesso_pck.pls_obtem_restricao_regra_proc('BIND', dt_inicio_vigencia_w,
									     dt_fim_vigencia_w, 
									     cd_guia_referencia_p,
									     r_C02_w.ie_considerar_horario,
									     r_C02_w.ie_tipo_qt_horario,
									     r_C02_w.qt_horario, var_cur_w);	

			
			--Executa o select  dinamico
			dbms_sql.define_column(var_cur_w, 1, nr_seq_conta_proc_w);
			dbms_sql.define_column(var_cur_w, 2, qt_proc_imp_w);
			dbms_sql.define_column(var_cur_w, 3, nr_seq_proc_ref_w);
			dbms_sql.define_column(var_cur_w, 4, dt_procedimento_w);
			dbms_sql.define_column(var_cur_w, 5, cd_procedimento_w);
			dbms_sql.define_column(var_cur_w, 6, ie_origem_proced_w);
			dbms_sql.define_column(var_cur_w, 7, nr_seq_regra_via_obrig_w);
			dbms_sql.define_column(var_cur_w, 8, ie_via_acesso_ref_w, 1);
			dbms_sql.define_column(var_cur_w, 9, tx_item_ref_w);
			dbms_sql.define_column(var_cur_w, 17, ie_tipo_intercambio_w, 2);
			dbms_sql.define_column(var_cur_w, 18, ie_origem_conta_w, 1);
			dbms_sql.define_column(var_cur_w, 19, ie_tipo_segurado_w, 1);
			
			
			var_exec_w := dbms_sql.execute(var_cur_w);
			
			loop
			var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
			exit when var_retorno_w = 0;
				-- Pega os dados do SQL dinamico
				dbms_sql.column_value(var_cur_w, 1, nr_seq_conta_proc_w);
				dbms_sql.column_value(var_cur_w, 2, qt_proc_imp_w);
				dbms_sql.column_value(var_cur_w, 3, nr_seq_proc_ref_w);
				dbms_sql.column_value(var_cur_w, 4, dt_procedimento_w);
				dbms_sql.column_value(var_cur_w, 5, cd_procedimento_w);
				dbms_sql.column_value(var_cur_w, 6, ie_origem_proced_w);
				dbms_sql.column_value(var_cur_w, 7, nr_seq_regra_via_obrig_w);
				dbms_sql.column_value(var_cur_w, 8, ie_via_acesso_ref_w);				
				dbms_sql.column_value(var_cur_w, 9, tx_item_ref_w);
				dbms_sql.column_value(var_cur_w, 17, ie_tipo_intercambio_w);
				dbms_sql.column_value(var_cur_w, 18, ie_origem_conta_w);
				dbms_sql.column_value(var_cur_w, 19, ie_tipo_segurado_w);
				
				select 	count(1)
				into STRICT	qt_grupo_w
				from	PLS_REGRA_VIA_ACESSO	a
				where	nr_sequencia = nr_seq_regra_via_obrig_w
				and exists (SELECT	1
						from	table(pls_grupos_pck.obter_procs_grupo_servico(a.nr_seq_grupo_servico, r_c02_w.ie_origem_proced,r_c02_w.cd_procedimento)) grupo);
				
				
				
				if ((nr_seq_via_obrig_regra_w = nr_seq_regra_via_obrig_w) or (coalesce(nr_seq_via_obrig_regra_w::text, '') = '')) and (qt_grupo_w > 0)then
					select	count(1)
					into STRICT	qt_nao_localizado_w
					from	pls_proc_via_acesso a
					where	a.nr_seq_regra	 = r_c01_w.nr_seq_regra
					and	a.ie_situacao	 = 'A'
					and	cd_procedimento	 =  cd_procedimento_w
					and	ie_origem_proced = ie_origem_proced_w;
					
					if	((qt_nao_localizado_w	= 0)  and
						-- verifica o dia
						((dt_procedimento_ant_w IS NOT NULL AND dt_procedimento_ant_w::text <> '') and
						 ((dt_procedimento_w	= dt_procedimento_ant_w AND r_c02_w.ie_considerar_horario = 'S') or
						  ((pls_obter_minutos_intervalo(dt_procedimento_w,dt_procedimento_ant_w,qt_minuto_w) = 'S') and (r_c02_w.ie_considerar_horario = 'N'))))) then
						   
						ie_regra_valida_w := 'N';
						exit;
					end if;
					
					-- valida o tipo de intercambio
					-- aplica a negacao fora dos if, para facilitar o entendimento
					if	not	((r_C02_w.ie_tipo_intercambio = 'X') or (ie_tipo_intercambio_w = r_C02_w.ie_tipo_intercambio) or
							 (((r_C02_w.ie_tipo_intercambio = 'A') and (ie_tipo_intercambio_w in ('E', 'N'))))or
							 -- se a regra for "Nenhum", nao devera incluir nenhuma conta de A500 ou beneficiario do tipo I, desde que tenha informado a origem
							 ((r_C02_w.ie_tipo_intercambio = 'Z' and (ie_origem_conta_w != 'A' and ie_tipo_segurado_w  not in ('I', 'H'))) or (coalesce(ie_origem_conta_w::text, '') = '' and coalesce(ie_tipo_segurado_w::text, '') = ''))) then
						
						ie_regra_valida_w := 'N';
						exit;
					end if;
					
				end if;
				
				
				if (cd_procedimento_w = r_c02_w.cd_procedimento) and (ie_origem_proced_w = r_c02_w.ie_origem_proced) and
					((nr_seq_via_obrig_regra_w = nr_seq_regra_via_obrig_w) or (coalesce(nr_seq_via_obrig_regra_w::text, '') = '')) and
					-- regras de intercambio
					((r_C02_w.ie_tipo_intercambio = 'X') or (ie_tipo_intercambio_w = r_C02_w.ie_tipo_intercambio) or 
					 (((r_C02_w.ie_tipo_intercambio = 'A') and (ie_tipo_intercambio_w in ('E', 'N')))) or
					 -- se a regra for "Nenhum", nao devera incluir nenhuma conta de A500 ou beneficiari do tipo I
					 ((r_C02_w.ie_tipo_intercambio = 'Z' and (ie_origem_conta_w != 'A' and ie_tipo_segurado_w  not in ('I', 'H'))) or (coalesce(ie_origem_conta_w::text, '') = '' and coalesce(ie_tipo_segurado_w::text, '') = ''))) then

					if (ie_tipo_acao_p = 'D') then	

						-- Ao contabilizar a quantidade de procedimentos que se encaixam na regra, desem ser considerados somente os procedimentos sem um procedimento de referencia vinculado
						if (ie_proc_ref_via_w = 'S') then
							if (coalesce(nr_seq_proc_ref_w::text, '') = '') then 						
								qt_proc_regra_w	:= qt_proc_regra_w + qt_proc_imp_w;
							end if;
						else
							qt_proc_regra_w	:= qt_proc_regra_w + qt_proc_imp_w;
						end if;
						
						nr_seq_proc_table_w(i) 	:= nr_seq_conta_proc_w;
						
						if (i >= qt_reg_transacao_w) then
							-- Insere procedimentos a uma tabela temporaria
							CALL pls_regra_via_acesso_pck.pls_insere_proc_tab_temp(nr_seq_proc_table_w);	
							
							-- Limpa a variavel table
							nr_seq_proc_table_w.delete;
							
							i := 0;
						else
							i := i + 1;
						end if;		
					elsif (ie_tipo_acao_p = 'V') then
						nr_seq_via_obrig_regra_w := nr_seq_regra_via_obrig_w;
						if (coalesce(dt_procedimento_ant_w::text, '') = '') then
							dt_procedimento_ant_w	:= dt_procedimento_w;
						elsif	(dt_procedimento_w	!= dt_procedimento_ant_w AND r_c02_w.ie_considerar_horario = 'S') or
							((pls_obter_minutos_intervalo(dt_procedimento_w,dt_procedimento_ant_w,qt_minuto_w) = 'N') and (r_c02_w.ie_considerar_horario = 'N')) then
							qt_proc_regra_w	:= 0;
							dt_procedimento_ant_w	:= dt_procedimento_w;
							
						end if;

						-- padrao por proc
						ie_inseriu_vetor_w := 'N';
				
						-- Ao contabilizar a quantidade de procedimentos que se encaixam na regra, desem ser considerados somente os procedimentos sem um procedimento de referencia vinculado
						
						if (ie_proc_ref_via_w = 'S') then
							if (coalesce(nr_seq_proc_ref_w::text, '') = '') then
								qt_proc_regra_w	:= qt_proc_regra_w + 1;	
							end if;
						else	
							qt_proc_regra_w	:= qt_proc_regra_w + 1;
						end if;
						
						
						-- aqui gera um registro paro garantir que o proc vai receber alguma taxa, podendo ser um valor padrao caso nao se encaixe na regra
						-- como a regra aberta tem um contrle diferenciado, vai gerar esse primeiro registro apenas se o proc nao se encaixou em nenhuma regra
						if (ie_abrir_regras_w = 'N') then
							

							SELECT * FROM pls_regra_via_acesso_pck.add_proc_regra_vetor(	nr_seq_conta_proc_w, r_C01_w.nr_seq_regra, nr_seq_proc_ref_w, ie_proc_ref_via_w, i, ie_via_acesso_ref_w, tx_item_ref_w, nr_seq_proc_table_w, nr_seq_regra_table_w, ie_via_acesso_table_w, tx_item_table_w) INTO STRICT _ora2pg_r;
 ie_via_acesso_ref_w := _ora2pg_r.ie_via_acesso_ref_p; tx_item_ref_w := _ora2pg_r.tx_item_ref_p; nr_seq_proc_table_w := _ora2pg_r.nr_seq_proc_table_p; nr_seq_regra_table_w := _ora2pg_r.nr_seq_regra_table_p; ie_via_acesso_table_w := _ora2pg_r.ie_via_acesso_table_p; tx_item_table_w := _ora2pg_r.tx_item_table_p;
										
							ie_inseriu_vetor_w		:= 'S';
							
							
						end if;
						
						

						if (coalesce(ie_via_acesso_ref_w,'X') <> 'X') then 		

							-- apenas insere o proc se for abertura de regra
							if (ie_abrir_regras_w = 'S') then
								

								SELECT * FROM pls_regra_via_acesso_pck.add_proc_regra_vetor(	nr_seq_conta_proc_w, r_C01_w.nr_seq_regra, nr_seq_proc_ref_w, ie_proc_ref_via_w, i, ie_via_acesso_ref_w, tx_item_ref_w, nr_seq_proc_table_w, nr_seq_regra_table_w, ie_via_acesso_table_w, tx_item_table_w) INTO STRICT _ora2pg_r;
 ie_via_acesso_ref_w := _ora2pg_r.ie_via_acesso_ref_p; tx_item_ref_w := _ora2pg_r.tx_item_ref_p; nr_seq_proc_table_w := _ora2pg_r.nr_seq_proc_table_p; nr_seq_regra_table_w := _ora2pg_r.nr_seq_regra_table_p; ie_via_acesso_table_w := _ora2pg_r.ie_via_acesso_table_p; tx_item_table_w := _ora2pg_r.tx_item_table_p;
											
								ie_inseriu_vetor_w		:= 'S';
								
							end if;
						
							if (ie_inseriu_vetor_w = 'S') then

								ie_via_acesso_table_w(i) 	:= ie_via_acesso_ref_w;						
								--tx_item_table_w(i) 		:= obter_tx_proc_via_acesso(ie_via_acesso_table_w(i));
								tx_item_table_w(i) 		:= tx_item_ref_w;
							end if;

						-- Se a quantidade do procedimento respeitar a quantidade informada na regra... considera a via de acesso e taxa da regra 
						elsif (qt_proc_regra_w >= r_C02_w.qt_procedimento and
							qt_proc_regra_w <= r_C02_w.qt_proc_final) then						

							-- apenas insere o proc se for abertura de regra
							if (ie_abrir_regras_w = 'S') then 
								

								SELECT * FROM pls_regra_via_acesso_pck.add_proc_regra_vetor(	nr_seq_conta_proc_w, r_C01_w.nr_seq_regra, nr_seq_proc_ref_w, ie_proc_ref_via_w, i, ie_via_acesso_ref_w, tx_item_ref_w, nr_seq_proc_table_w, nr_seq_regra_table_w, ie_via_acesso_table_w, tx_item_table_w) INTO STRICT _ora2pg_r;
 ie_via_acesso_ref_w := _ora2pg_r.ie_via_acesso_ref_p; tx_item_ref_w := _ora2pg_r.tx_item_ref_p; nr_seq_proc_table_w := _ora2pg_r.nr_seq_proc_table_p; nr_seq_regra_table_w := _ora2pg_r.nr_seq_regra_table_p; ie_via_acesso_table_w := _ora2pg_r.ie_via_acesso_table_p; tx_item_table_w := _ora2pg_r.tx_item_table_p;
											
								ie_inseriu_vetor_w		:= 'S';
								
							end if;

							if (ie_inseriu_vetor_w = 'S') then
							
								ie_via_acesso_table_w(i) 	:= r_C02_w.ie_via_acesso;
								
								-- se a regra de obrigatoriedade tiver tipo de intercambio, prioriza a taxa da via de intercambio
								-- nao e validado se o protocolo e de intercambio neste momento, pois ja deve ter ocorrido quando foi feito
								-- o vinculo com a regra de obrigatoriedade de via de acesso.
								if (coalesce(r_C02_w.ie_tipo_intercambio, 'X') in ('E', 'N', 'A')) and (ie_nivel_via_acesso_w = 'S') then
								
									tx_item_table_w(i) 		:= r_C02_w.tx_item_variavel;
								else
								
									tx_item_table_w(i) 		:= obter_tx_proc_via_acesso(ie_via_acesso_table_w(i));
								end if;
								
							end if;
							

						-- Se nao respeitar a quantidade informada na regra... considera a via de acesso e taxa padrao (ie_via_acesso = 'U', tx_item = 100)
						-- somente vai aplicar o padrao se a regra nao for abertar no c02
						else
							-- nao e adicionaod a chamada da add_proc_regra_vetor aqui porque quando entrar neste bloco,
							-- ja vai ter incluido o novo
							-- para manter o valor padrao para os casos aonde e aberto a regra, mas genuinanmente nao existe o procedimento, e salvo o registro do proc em outro vetor
							-- posteriormente sera varrido esse outro vetor e comparado se o proc nao recebeu algum valor de regra, entao atribuio o valor padrao
							if (ie_inseriu_vetor_w = 'S') and (ie_abrir_regras_w = 'N') then
							
								ie_via_acesso_table_w(i)	:= 'U';
								tx_item_table_w(i) 		:= 100;								
								
								
							end if;
							
							-- guarda para posteriormente ser re-avaliado
							if (ie_inseriu_vetor_w = 'S') and (ie_abrir_regras_w = 'S') then
							
								nr_seq_proc_pad_table_w(nr_seq_proc_pad_table_w.count) := nr_seq_conta_proc_w;
							end if;
							
							
						end if;
						
						if (ie_inseriu_vetor_w = 'S') then
						
							i := i + 1;
						end if;

					end if;	
				end if;
			end loop;
			dbms_sql.close_cursor(var_cur_w);
		
			if (qt_proc_regra_w > 0) and (ie_regra_valida_w	= 'S')then -- QT_PROC_REGRA_W - quantidade de procedimentos que se encaixam com cada uma das regras da tabela PLS_PROC_VIA_ACESSO
				
				
				if	(qt_proc_regra_w >= r_C02_w.qt_procedimento AND qt_proc_regra_w <= r_C02_w.qt_proc_final) or
					(ie_abrir_regras_w = 'S' AND qt_proc_regra_w between r_C02_w.qt_min_proc and r_C02_w.qt_max_proc) then
					ie_regra_valida_w := 'S';
					
				else
					-- Se entrar aqui significa a regra da tabela PLS_TIPO_VIA_ACESSO nao e valida e portanto as outras regras vinculadas a ela nao precisarao ser verificadas
					ie_regra_valida_w := 'N';
					exit;
				end if;
			else
				-- Se entrar aqui significa a regra da tabela PLS_TIPO_VIA_ACESSO nao e valida e portanto as outras regras vinculadas a ela nao precisarao ser verificadas
				ie_regra_valida_w := 'N';

				exit;
			end if;
		end;	
	end loop;
	
	-- terminou de navegar pela composicao da regra, avalia se teve abertura de regra
	-- se tiver, entao gera os proc pertinentes ao valor padrao, desde que eles nao foram atribuidos a regra
	if (ie_abrir_regras_w = 'S') and (nr_seq_proc_pad_table_w.count > 0) then
	
	
		-- percorre os proc que poderao receber valor padrao
		for j in nr_seq_proc_pad_table_w.first..nr_seq_proc_pad_table_w.last loop
		
			-- se nao existe na regra
			if (not SELECT * FROM pls_regra_via_acesso_pck.inseriu_proc_regra_vetor(nr_seq_proc_table_w, nr_seq_regra_table_w, nr_seq_proc_pad_table_w(j), r_C01_w.nr_seq_regra) INTO STRICT _ora2pg_r;
 nr_seq_proc_table_w := _ora2pg_r.tb_proc_table_p; nr_seq_regra_table_w := _ora2pg_r.tb_regra_table_p) then
			
				idx_w := nr_seq_proc_table_w.count;
				
				SELECT * FROM pls_regra_via_acesso_pck.add_proc_regra_vetor(	nr_seq_proc_pad_table_w(j), r_C01_w.nr_seq_regra, nr_seq_proc_ref_w, ie_proc_ref_via_w, idx_w, ie_via_acesso_ref_w, tx_item_ref_w, nr_seq_proc_table_w, nr_seq_regra_table_w, ie_via_acesso_table_w, tx_item_table_w) INTO STRICT _ora2pg_r;
 ie_via_acesso_ref_w := _ora2pg_r.ie_via_acesso_ref_p; tx_item_ref_w := _ora2pg_r.tx_item_ref_p; nr_seq_proc_table_w := _ora2pg_r.nr_seq_proc_table_p; nr_seq_regra_table_w := _ora2pg_r.nr_seq_regra_table_p; ie_via_acesso_table_w := _ora2pg_r.ie_via_acesso_table_p; tx_item_table_w := _ora2pg_r.tx_item_table_p;
							
				ie_via_acesso_table_w(idx_w)	:= 'U';
				tx_item_table_w(idx_w) 		:= 100;	
			end if;
			
		end loop;
		
	end if;
	
	
	-- limpa para ser reutilizado na proxima regra
	nr_seq_proc_pad_table_w.delete;
	
	if (ie_regra_valida_w = 'S') then

		if (ie_tipo_acao_p = 'D') then	
			-- Caso sobre algum procedimento dentro da table, estes tambem devem ser inseridos na tabela temporaria
			CALL pls_regra_via_acesso_pck.pls_insere_proc_tab_temp(nr_seq_proc_table_w);
	
			CALL pls_regra_via_acesso_pck.pls_desmembra_proc(nm_usuario_p, cd_estabelecimento_p);
		elsif (ie_tipo_acao_p = 'V') then
			-- Caso exista algum procedimento dentro da table, estes tambem receber os dados referentes a via de acesso
			CALL pls_regra_via_acesso_pck.pls_aplica_regra_proc_via(nr_seq_proc_table_w, nr_seq_regra_table_w, ie_via_acesso_table_w, tx_item_table_w);		
		end if;
	end if;
	
	-- Limpa as variaveis table
	nr_seq_proc_table_w.delete;
	ie_via_acesso_table_w.delete;
	tx_item_table_w.delete;
	nr_seq_regra_table_w.delete;

end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_via_acesso_pck.pls_processa_regra_via_proc ( cd_guia_referencia_p pls_conta.cd_guia_referencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, ie_tipo_acao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
