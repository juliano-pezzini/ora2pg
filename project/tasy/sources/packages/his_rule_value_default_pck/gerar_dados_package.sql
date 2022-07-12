-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE his_rule_value_default_pck.gerar_dados ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p atendimento_paciente.cd_pessoa_fisica%type, ds_lista_tabela_p text, ds_lista_template_p text, nr_seq_template_par EHR_TEMPLATE.NR_SEQUENCIA%TYPE DEFAULT NULL) AS $body$
DECLARE

	
	
	cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
	ds_campos_w				text;
	ds_campos_id_w			text;
	ds_where_w				text;
	ds_comando_w			text;
	ds_lista_elementos_w	text;
	nm_campo_cd_paciente_w	tabela_atributo.nm_atributo%type;
	nm_campo_dt_registro_w	tabela_atributo.nm_atributo%type;
	nm_campo_dt_liberacao_w	tabela_atributo.nm_atributo%type;
	nm_campo_ie_aparelho_pa_w	tabela_atributo.nm_atributo%type;
	nr_atend_anterior_w		atendimento_paciente.nr_atendimento%type;
	nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
	v_cursor				integer;
	v_col_cnt           	integer;
	col_type_w           	bigint;
	v_line              	varchar(250);
	rec_tab             	dbms_sql.desc_tab;
	vl_conteudo_w			double precision;
	dt_conteudo_w			timestamp;
	dt_registro_w			timestamp;
	dt_liberacao_w			timestamp;
	nr_seq_elemento_w		bigint;
	ds_conteudo_w			varchar(4000);
	v_ind               	bigint;
	id_dt_registro_w    	bigint  := 0;
	id_dt_liberacao_w		bigint  := 0;
	id_nr_seq_elemento_w	bigint  := 0;
	indice_w				integer;
	id_ie_aparelho_pa_w		bigint  := 0;
	ie_aparelho_pa_w		atendimento_sinal_vital.ie_aparelho_pa%type;
	
	c_regras CURSOR FOR
		SELECT  nm_tabela,
				nr_seq_template,
				case  IE_MODO_BUSCA
				  when 'TA' then IE_MODO_BUSCA
				  when 'AA' then IE_MODO_BUSCA
				  else  null
				end   IE_MODO_BUSCA,
				coalesce(ie_aparelho_pa,'C') ie_aparelho_pa
		from    his_rule_value_default a,
				table(lista_pck.obter_lista_char(ds_lista_tabela_p,',')) b
		where   a.nm_tabela = b.cd_registro
		and     a.cd_estabelecimento = cd_estabelecimento_w
		
UNION

		SELECT  nm_tabela,
				nr_seq_template,
				case  IE_MODO_BUSCA 
				  when 'TA' then IE_MODO_BUSCA
				  when 'AA' then IE_MODO_BUSCA
				  else  null
				end   IE_MODO_BUSCA,
				coalesce(ie_aparelho_pa,'C') ie_aparelho_pa
		from    his_rule_value_default a,
				table(lista_pck.obter_lista(ds_lista_template_p,',')) b
		where   a.nr_seq_template = b.nr_registro
		and     a.cd_estabelecimento = cd_estabelecimento_w;
		
		c_restricao CURSOR(nm_tabela_p		tabela_atributo.nm_tabela%type) FOR
			SELECT	case
						when nm_atributo = 'NR_ATENDIMENTO' then ' AND NR_ATENDIMENTO = :NR_ATENDIMENTO '
						when nm_atributo = nm_campo_cd_paciente_w then ' AND '||nm_campo_cd_paciente_w||' = :CD_PESSOA_FISICA '
						when nm_atributo = 'DT_LIBERACAO' then ' AND DT_LIBERACAO IS NOT NULL '
						when nm_atributo = 'DT_INATIVACAO' then ' AND DT_INATIVACAO IS NULL '
						when nm_atributo = 'IE_APARELHO_PA' then ' AND COALESCE(IE_APARELHO_PA,''C'') = :IE_APARELHO_PA '
					end ds_restricao
			from	tabela_atributo
			where	nm_tabela = nm_tabela_p
			and		nm_atributo in ('NR_ATENDIMENTO','DT_LIBERACAO','DT_INATIVACAO',nm_campo_cd_paciente_w);
			
		c_campos CURSOR(nm_tabela_p  tabela_atributo.nm_atributo%type) FOR
			SELECT 	nm_atributo
			from	his_rule_value_default
			where	cd_estabelecimento 	=	cd_estabelecimento_w
			and		nm_tabela			=	nm_tabela_p;
				
		c_elementos CURSOR(nr_seq_template_p  ehr_template.nr_sequencia%type) FOR
			SELECT 	nr_seq_elemento
			from	his_rule_value_default
			where	cd_estabelecimento 	=	cd_estabelecimento_w
			and		nr_seq_template		=	nr_seq_template_p
			and		(nr_seq_elemento IS NOT NULL AND nr_seq_elemento::text <> '');



	
BEGIN
	cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;
	
	nr_atendimento_w	:= nr_atendimento_p;
	select  coalesce(max(nr_atendimento),0)
	into STRICT	nr_atend_anterior_w
	from    atendimento_paciente
	where   cd_pessoa_fisica  = cd_pessoa_fisica_p
	and		dt_entrada		  < (SELECT max(dt_entrada) from atendimento_paciente where nr_atendimento = nr_atendimento_p)
	and     coalesce(dt_cancelamento::text, '') = '';
	
	<<read_regras>>
	for r_regras in c_regras
		loop
		id_dt_registro_w    	:= 0;
		id_dt_liberacao_w		:= 0;
		id_nr_seq_elemento_w	:= 0;
		id_ie_aparelho_pa_w		:= 0;
		ds_campos_id_w			:= null;

		nr_atendimento_w	:= nr_atendimento_p;
		if (r_regras.ie_modo_busca = 'AA') then
			nr_atendimento_w	:= nr_atend_anterior_w;
		end if;
		if (r_regras.nm_tabela IS NOT NULL AND r_regras.nm_tabela::text <> '') then
			select	max(nm_atributo)
			into STRICT	nm_campo_dt_registro_w
			from	linked_data a,
					documento_atributo_ref b
			where	a.nr_sequencia 	= b.nr_seq_linked_data
			and		a.nm_table		= r_regras.nm_tabela
			and		b.ie_referencia = 'R';
			
			select	max(nm_atributo)
			into STRICT	nm_campo_cd_paciente_w
			from	linked_data a,
					documento_atributo_ref b
			where	a.nr_sequencia 	= b.nr_seq_linked_data
			and		a.nm_table		= r_regras.nm_tabela
			and		b.ie_referencia = 'P';
			
			select	max(', '||nm_atributo)
			into STRICT	nm_campo_dt_liberacao_w
			from 	tabela_atributo
			where 	nm_tabela 	=	r_regras.nm_tabela 
			and 	nm_atributo =	'DT_LIBERACAO';
			
			select	max(', '||nm_atributo)
			into STRICT	nm_campo_ie_aparelho_pa_w
			from 	tabela_atributo
			where 	nm_tabela 	=	r_regras.nm_tabela 
			and 	nm_atributo =	'IE_APARELHO_PA';
			
			ds_campos_id_w	:= upper(nm_campo_dt_registro_w|| ' DT_REGISTRO '||nm_campo_dt_liberacao_w||nm_campo_ie_aparelho_pa_w);
			ds_campos_w		:= ds_campos_id_w;
			
			<<cria_select>>
			for r_campos in c_campos(r_regras.nm_tabela)
				loop
				ds_campos_w	:= ds_campos_w ||','||r_campos.nm_atributo;
				end loop cria_select;
				
			ds_where_w	:= ' WHERE 1 = 1 ';
			<<read_restricao>>
			for r_restricao in c_restricao(r_regras.nm_tabela)
				loop
				ds_where_w	:= ds_where_w ||r_restricao.ds_restricao;
				end loop	read_restricao;

        if (r_regras.ie_modo_busca = 'TA') then
            ds_where_w := ds_where_w || ' AND NR_SEQ_FORMULARIO is not null AND (SELECT NR_SEQ_TEMPL FROM EHR_REGISTRO WHERE nr_sequencia = NR_SEQ_FORMULARIO) = '''|| nr_seq_template_par ||'''';
        end if;
		
			ds_comando_w	:=	UPPER('select	'||ds_campos_w||' from	'||r_regras.nm_tabela||ds_where_w);
		elsif (r_regras.nr_seq_template IS NOT NULL AND r_regras.nr_seq_template::text <> '') then
			ds_lista_elementos_w	:= null;
			ds_campos_id_w			:= upper('NR_SEQ_TEMPLATE,NR_SEQ_TEMP_CONTEUDO,DT_REGISTRO');
			<<cria_lista>>
			for r_elementos in c_elementos(r_regras.nr_seq_template)
				loop
				if (coalesce(ds_lista_elementos_w::text, '') = '') then
					ds_lista_elementos_w	:= to_char(r_elementos.nr_seq_elemento);
				else
					ds_lista_elementos_w	:= ds_lista_elementos_w ||','||to_char(r_elementos.nr_seq_elemento);
				end if;	
				end loop cria_lista;	
				
			if (ds_lista_elementos_w IS NOT NULL AND ds_lista_elementos_w::text <> '') then
				ds_comando_w	:=	'select	b.nr_seq_template,a.nr_seq_temp_conteudo,a.dt_resultado,a.ds_resultado,a.vl_resultado,c.dt_registro '||
									'from	EHR_REG_ELEMENTO a, '||
									'		ehr_reg_template b, '||
									'		ehr_registro c '||
									'where	a.nr_seq_reg_template	= b.nr_sequencia '||
									'and	b.nr_seq_reg			= c.nr_sequencia '||
									'and    c.nr_atendimento      	= :nr_atendimento '||
									'and    c.dt_liberacao        	is not null '||
									'and    c.dt_inativacao       	is null '||
									'and	a.nr_seq_temp_conteudo	in ('||ds_lista_elementos_w||')';
			end if;						
		end if;	
		ds_comando_w	:= upper(ds_comando_w);

		v_cursor := dbms_sql.open_cursor;

		dbms_sql.parse(v_cursor, ds_comando_w, dbms_sql.native);

		if (position(':NR_ATENDIMENTO' in ds_comando_w) > 0) then
			dbms_sql.bind_variable(v_cursor, ':NR_ATENDIMENTO', nr_atendimento_w);
		end if;
		
		if (position(':IE_APARELHO_PA' in ds_comando_w) > 0) then
			dbms_sql.bind_variable(v_cursor, ':IE_APARELHO_PA', r_regras.ie_aparelho_pa);
		end if;
		
		if (position(':CD_PESSOA_FISICA' in ds_comando_w) > 0) then
			dbms_sql.bind_variable(v_cursor, ':CD_PESSOA_FISICA', cd_pessoa_fisica_p);
		end if;
		
		dbms_sql.describe_columns(v_cursor, v_col_cnt, rec_tab);
		
		FOR v_pos IN 1..rec_tab.COUNT()
			loop
			col_type_w  := rec_tab[v_pos].col_type;
			v_line      := rec_tab[v_pos].col_name;
			case col_type_w
				when 2 then
					DBMS_SQL.DEFINE_COLUMN(v_cursor, v_pos, vl_conteudo_w);
				when 12 then
					DBMS_SQL.DEFINE_COLUMN(v_cursor, v_pos, dt_conteudo_w);
				else
					DBMS_SQL.DEFINE_COLUMN(v_cursor, v_pos, ds_conteudo_w, 4000);
			end case;
			
			case v_line
				when 'DT_REGISTRO' then
					id_dt_registro_w     	:= v_pos;
				when 'DT_LIBERACAO' then
					id_dt_liberacao_w     	:= v_pos;
				when 'NR_SEQ_TEMP_CONTEUDO' then
					id_nr_seq_elemento_w   	:= v_pos;	
				when 'IE_APARELHO_PA' then
					id_ie_aparelho_pa_w   	:= v_pos;		
				else
					null;
			end case;

			end loop;
			
			
			v_ind := dbms_sql.EXECUTE(v_cursor);
			
		
			loop v_ind := dbms_sql.fetch_rows(v_cursor);
			exit when v_ind = 0;
			for v_col_seq in 1 .. rec_tab.count
				loop
				ds_conteudo_w		:= NULL;
				vl_conteudo_w		:= NULL;
				dt_conteudo_w		:= NULL;
				dt_registro_w		:= NULL;
				dt_liberacao_w		:= NULL;
				nr_seq_elemento_w	:= NULL;
				ie_aparelho_pa_w	:= NULL;
				
				if (id_dt_registro_w > 0) then
					dbms_sql.column_value(v_cursor, id_dt_registro_w, dt_registro_w);
				end if;
				
				if (id_dt_liberacao_w > 0) then
					dbms_sql.column_value(v_cursor, id_dt_liberacao_w, dt_liberacao_w);
				end if;
				
				if (id_nr_seq_elemento_w > 0) then
					dbms_sql.column_value(v_cursor, id_nr_seq_elemento_w, nr_seq_elemento_w);
				end if;
				
				if (id_ie_aparelho_pa_w > 0) then
					dbms_sql.column_value(v_cursor, id_ie_aparelho_pa_w, ie_aparelho_pa_w);
				end if;
				
				
				
				


				if (rec_tab[v_col_seq].col_type = 1) then
					dbms_sql.column_value(v_cursor, v_col_seq, ds_conteudo_w);
				elsif (rec_tab[v_col_seq].col_type = 2) then
					dbms_sql.column_value(v_cursor, round((v_col_seq)::numeric,3), vl_conteudo_w);
				elsif (rec_tab[v_col_seq].col_type = 12) then
					dbms_sql.column_value(v_cursor, v_col_seq, dt_conteudo_w);
				end if;
				if (position(upper(rec_tab[v_col_seq].col_name) in ds_campos_id_w) <= 0) and
					((dt_conteudo_w IS NOT NULL AND dt_conteudo_w::text <> '') or (vl_conteudo_w IS NOT NULL AND vl_conteudo_w::text <> '') or (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '')) then
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table.extend(1);
					indice_w := current_setting('his_rule_value_default_pck.dados_w')::t_value_table.count;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].ds_resultado		:= 	ds_conteudo_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].vl_resultado		:= 	vl_conteudo_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].dt_resultado		:= 	dt_conteudo_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].dt_registro		:= 	dt_registro_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].nm_tabela			:= 	upper(r_regras.nm_tabela);
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].nm_atributo		:= 	upper(rec_tab[v_col_seq].col_name);
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].nr_seq_template	:= 	upper(r_regras.nr_seq_template);
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].nr_seq_elemento	:= 	nr_seq_elemento_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].ie_modo_busca		:= 	r_regras.ie_modo_busca;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].dt_liberacao		:= 	dt_liberacao_w;
					current_setting('his_rule_value_default_pck.dados_w')::t_value_table[indice_w].ie_aparelho_pa	:= 	ie_aparelho_pa_w;
				end if;	
				end loop;
			end loop;
			dbms_sql.close_cursor(v_cursor);
		end loop	read_regras;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE his_rule_value_default_pck.gerar_dados ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p atendimento_paciente.cd_pessoa_fisica%type, ds_lista_tabela_p text, ds_lista_template_p text, nr_seq_template_par EHR_TEMPLATE.NR_SEQUENCIA%TYPE DEFAULT NULL) FROM PUBLIC;
