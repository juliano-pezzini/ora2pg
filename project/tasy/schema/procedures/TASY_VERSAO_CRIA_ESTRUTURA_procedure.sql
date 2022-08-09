-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_versao_cria_estrutura ( nm_tabela_p text, ie_Criar_Alterar_p text, ie_enterprise_p text, nr_ordem_p bigint) AS $body$
DECLARE


nm_atributo_w          		varchar(50)      := '';
nm_sequence_w          		varchar(50)      := '';
ds_virgula_w			varchar(01)	  := '';
ds_tablespace_tab_w    		varchar(50)      := '';
ds_tablespace_temp_tab_w    	varchar(50)      := '';
ds_comando_w			varchar(15000);
ds_atributo_w			varchar(6000);
vl_retorno_w			varchar(255);
vl_default_w			varchar(050);
qt_byte_reg_w			bigint;
qt_Initial_w			numeric(020);
qt_next_w			numeric(020);
qt_registro_w			bigint;
qt_seq_inicio_w			bigint;
qt_seq_incremento_w		bigint;
qt_seq_max_w			bigint;

qt_seq_ini_Atr_w			bigint;
qt_seq_incr_Atr_w			bigint;

ie_obrigatorio_w			varchar(001);
ie_tipo_atributo_w		varchar(010);
qt_tamanho_w			bigint;
qt_decimais_w			bigint;
data_type_w 		 	varchar(30)    := null;
data_precision_w		bigint      := 0;
data_length_w			bigint      := 0;
length_semantic     varchar(10);
data_scale_w			bigint      := 0;
nullable_w			varchar(1)	:= 'N';
criar_Seq_w			varchar(1)	:= 'N';
qt_reg_nulo_w			varchar(15);
qt_retorno_w			bigint	:= 0;
ie_temporaria_w			varchar(2);
ie_cadastro_geral_w		varchar(1);
ds_comando_bv_w			varchar(4000);
C010				integer;
retorno_w			integer;
nm_fase_w           cloud_upgrade_log.ds_mensagem%type := 'TASY_VERSAO_CRIA_ESTRUTURA';


BEGIN

select case when value = 'AL32UTF8' then 'CHAR' else 'BYTE' end into STRICT length_semantic from nls_database_parameters where parameter='NLS_CHARACTERSET';

ds_tablespace_temp_tab_w := obter_tablespace_tab_temp;

ds_comando_bv_w:= ' select	nvl(qt_registros_previsto,100), ' ||
							' nvl(qt_media_bytes,200), ' ||
							' ie_temporaria, ' ||
							' ie_cadastro_geral ' ||			
					' FROM 	tasy_versao.tabela_sistema '||
					' WHERE nm_tabela = :nm_tabela_p';
EXECUTE ds_comando_bv_w
INTO STRICT	qt_registro_w, qt_byte_reg_w, ie_temporaria_w, ie_cadastro_geral_w	using nm_tabela_p;

select	default_tablespace
into STRICT	ds_tablespace_tab_w
from	user_users;

ds_virgula_w		:= '';
criar_Seq_w			:= 'N';
qt_seq_inicio_w		:= 0;
qt_seq_incremento_w	:= 0;
if ( ie_temporaria_w in ('G','GD')) then
	ds_comando_w		:= 'Create global temporary Table ' || nm_tabela_p || ' (';
else
	ds_comando_w		:= 'Create Table ' || nm_tabela_p || ' (';
end if;

ds_comando_bv_w:=  ' SELECT nm_atributo, '||
						' ie_obrigatorio, '||
						' ie_tipo_atributo, '||
						' qt_tamanho, '||
						' nvl(qt_decimais,0), '||
						' nvl(qt_seq_inicio,0), '||
						' nvl(qt_seq_incremento,0), '||
						' vl_default '||
				' FROM	tasy_versao.tabela_atributo '||
				' WHERE	nm_tabela	= :nm_tabela_p '||
				' and	ie_tipo_atributo not in ('||chr(39)||'FUNCTION'||chr(39)||','||chr(39)||'VISUAL'||chr(39)||')' ||
				' order by nr_sequencia_criacao ';

C010 := dbms_sql.open_cursor;
dbms_sql.parse(C010, ds_comando_bv_w, dbms_sql.native);
dbms_sql.define_column(C010, 1, nm_atributo_w, 50);	
dbms_sql.define_column(C010, 2, ie_obrigatorio_w, 1);	
dbms_sql.define_column(C010, 3, ie_tipo_atributo_w, 10);	
dbms_sql.define_column(C010, 4, qt_tamanho_w);	
dbms_sql.define_column(C010, 5, qt_decimais_w);
dbms_sql.define_column(C010, 6, qt_seq_ini_atr_w);	
dbms_sql.define_column(C010, 7, qt_seq_incr_atr_w);	
dbms_sql.define_column(C010, 8, vl_default_w, 50);	
dbms_sql.bind_variable(C010, 'NM_TABELA_P', nm_tabela_p,255);	
retorno_w := dbms_sql.execute(C010);

while( dbms_sql.fetch_rows(C010) > 0 ) loop
	dbms_sql.column_value(C010, 1, nm_atributo_w);
	dbms_sql.column_value(C010, 2, ie_obrigatorio_w);
	dbms_sql.column_value(C010, 3, ie_tipo_atributo_w);
	dbms_sql.column_value(C010, 4, qt_tamanho_w);
	dbms_sql.column_value(C010, 5, qt_decimais_w);
	dbms_sql.column_value(C010, 6, qt_seq_ini_atr_w);
	dbms_sql.column_value(C010, 7, qt_seq_incr_atr_w);
	dbms_sql.column_value(C010, 8, vl_default_w);

	if (ie_criar_alterar_p	= 'A') then

		begin
		select	data_type,
				data_precision,
				char_length,
				data_scale,
				CASE WHEN nullable='Y' THEN 'N'  ELSE 'S' END
		into STRICT	data_type_w,
				data_precision_w,
				data_length_w,
				data_scale_w,
				nullable_w
		from 	user_tab_columns
		where	table_name 	= nm_tabela_p
		and	column_name	= nm_atributo_w;
		exception
			when others then
				begin
				data_type_w		:= 'Novo';
				data_precision_w	:= 0;
				data_length_w	:= 0;
				data_scale_w	:= 0;
				end;
		end;
	end if;

	ds_atributo_w	:= nm_atributo_w  || ' ' || ie_tipo_atributo_w;
	if (ie_tipo_atributo_w = 'NUMBER') then
		begin
		ds_atributo_w:= ds_atributo_w  || '(' || qt_tamanho_w;
		ds_atributo_w:= ds_atributo_w  || ',' || qt_decimais_w || ')';
		end;
	elsif (ie_tipo_atributo_w = 'VARCHAR2') then
		ds_atributo_w:= ds_atributo_w  || '(' || qt_tamanho_w || ' ' || length_semantic || ')';
	end if;

	if (length(ds_comando_w) > 10000) then
		ds_comando_w	:= ds_comando_w;
	elsif (ie_criar_alterar_p	= 'C') then
		ds_comando_w	:= ds_comando_w  || ds_virgula_w || ds_atributo_w;
		if (ie_obrigatorio_w = 'S') then
			ds_comando_w:= ds_comando_w  || ' not null';
		else
			ds_comando_w:= ds_comando_w  || ' null';
		end if;
		ds_virgula_w	:= ',';
	elsif (data_type_w	= 'Novo') then
		ds_comando_w	:= 'Alter Table ' || nm_tabela_p || ' ADD(';
		ds_comando_w	:= ds_comando_w  || ds_atributo_w || ' Null)';

		CALL gravar_processo_longo(ds_comando_w,nm_fase_w,null);
		--Exec_Sql_Dinamico(nm_tabela_p || ',' || nm_atributo_w, ds_comando_w);
		insert into TABELA_VERSAO_OFFLINE_W(nr_sequencia, nr_ordem, ds_comando) values (nextval('tabela_versao_offline_w_seq'),nr_ordem_p,ds_comando_w);
		COMMIT;
        CALL insert_log_cloud(null,null, 'atualizacao', nm_fase_w||'_LOG', null, nm_fase_w);
		nullable_w		:= 'N';
		if ( ie_cadastro_geral_w in ('S','W') ) and (vl_default_w IS NOT NULL AND vl_default_w::text <> '') then
			nullable_w := ie_obrigatorio_w;
			CALL TASY_VERSAO_ALTERAR_COLUNA(nm_tabela_p,nm_atributo_w,ie_tipo_atributo_w,qt_tamanho_w,qt_decimais_w,ie_obrigatorio_w,vl_default_w,ie_enterprise_p,nr_ordem_p);
		end if;
	end if;

	if (qt_seq_ini_atr_w > 0) and (qt_seq_incr_atr_w > 0)  then
		begin
		nm_sequence_w  := substr(nm_tabela_p || '_SEQ',1,30);
		select qt_seq_inicio_w
		into STRICT qt_seq_inicio_w
		FROM user_objects
		where object_name	= nm_sequence_w;
		exception
			when others then
				begin
				qt_seq_inicio_w		:= qt_seq_ini_atr_w;
				qt_seq_incremento_w	:= qt_seq_incr_atr_w;
				criar_Seq_w		:= 'S';
				end;
		end;
	end if;	

end loop;
dbms_sql.close_cursor(C010);

if (ie_criar_alterar_p = 'C') then
	begin

	ds_comando_w	:= ds_comando_w  || ')';
	if (coalesce(qt_registro_w,0) = 0) or (coalesce(qt_byte_reg_w,0) = 0) then
		qt_initial_w	:= 0;
	else
		qt_Initial_w	:= round(qt_registro_w * qt_byte_reg_w / 1024);
	end if;
	if (coalesce(qt_initial_w,0) < 10) then
		qt_initial_w:= 10;
	end if;

	if ( ie_temporaria_w = 'G' ) then
		ds_comando_w := ds_comando_w || ' ON COMMIT PRESERVE ROWS';
	elsif ( ie_temporaria_w = 'GD' ) then
		ds_comando_w := ds_comando_w || ' ON COMMIT DELETE ROWS';
	else
		begin
		qt_next_w		:= round(qt_initial_w / 10);
		ds_comando_w	:= ds_comando_w || ' STORAGE(INITIAL ' || qt_initial_w;
		ds_comando_w	:= ds_comando_w || 'K NEXT ';
		ds_comando_w	:= ds_comando_w || qt_next_w || 'K PCTINCREASE 0)';
		ds_comando_w 	:= ds_comando_w ||  'Tablespace ';

		if ( ie_temporaria_w = 'S' ) then
			if (wheb_usuario_pck.get_configurar_tablespace = 'S') then
				ds_comando_w := ds_comando_w || obter_tablespace_tab_temp(nm_tabela_p);
			else
				ds_comando_w := ds_comando_w || ds_tablespace_temp_tab_w;
			end	if;
		elsif (wheb_usuario_pck.get_configurar_tablespace = 'S') then
			ds_comando_w := ds_comando_w || obter_tablespace_tab_temp(nm_tabela_p);
		else
			ds_comando_w := ds_comando_w ||  ds_tablespace_tab_w;
		end	if;
		end;
	end if;

	if (ie_enterprise_p = 'S') then
		ds_comando_w	:= ds_comando_w  || ' PARALLEL ';
	end if;	

	CALL gravar_processo_longo(ds_comando_w,nm_fase_w,null);
	--Exec_Sql_Dinamico(nm_tabela_p, ds_comando_w);
	insert into TABELA_VERSAO_OFFLINE_W(nr_sequencia, nr_ordem, ds_comando) values (nextval('tabela_versao_offline_w_seq'),nr_ordem_p,ds_comando_w);
	COMMIT;
    CALL insert_log_cloud(null,null, 'atualizacao', nm_fase_w||'_LOG', null, nm_fase_w);
	end;
end if;

if (qt_seq_inicio_w > 0) and (qt_seq_incremento_w > 0) and (criar_Seq_w = 'S') then
	begin
	qt_seq_max_w	:= 9999999999;
	ds_comando_w	:= 'Create Sequence ' || nm_sequence_w;
	ds_comando_w	:= ds_comando_w || ' Increment by ' || qt_seq_incremento_w;
	ds_comando_w	:= ds_comando_w || ' Start with ' || qt_seq_inicio_w;
	ds_comando_w	:= ds_comando_w || ' MaxValue ' || qt_seq_max_w;
	ds_comando_w	:= ds_comando_w || ' Cycle';
	ds_comando_w	:= ds_comando_w || ' NoCache';
	CALL gravar_processo_longo(ds_comando_w,nm_fase_w,null);
	--Exec_Sql_Dinamico(nm_sequence_w, ds_comando_w);
	insert into TABELA_VERSAO_OFFLINE_W(nr_sequencia, nr_ordem, ds_comando) values (nextval('tabela_versao_offline_w_seq'),nr_ordem_p,ds_comando_w);
	COMMIT;	
    CALL insert_log_cloud(null,null, 'atualizacao', nm_fase_w||'_LOG', null, nm_fase_w);
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_versao_cria_estrutura ( nm_tabela_p text, ie_Criar_Alterar_p text, ie_enterprise_p text, nr_ordem_p bigint) FROM PUBLIC;
