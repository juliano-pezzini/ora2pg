-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


procedure CRIAR_OBJETO_TASY_VERSAO IS 

nm_objeto_w		varchar2(50);
ie_banco_w		varchar2(15);
ie_tipo_objeto_w	varchar2(15);
ds_script_criacao_w	clob;
qt_processo_w		Number(10);
C03			Integer;
retorno_w		Number(5);
DS_COMANDO_W		clob;
dt_versao_p		date;
nr_aux_w		Number(10);
ds_script_aux_w		clob;
type t_script_table	is table of clob;
script_table_w		t_script_table;
ds_rollback_w	clob;




CREATE OR REPLACE FUNCTION split_script_type (ds_text_p text) RETURNS T_SCRIPT_TABLE AS $body$
DECLARE

	t_script_w			t_script_table := t_script_table();
	qt_index_w			bigint := 0;
	ds_text_w			text;
	ds_text_aux_w			text;
	nr_char_index_w			bigint;
BEGIN
	ds_text_w := ds_text_p;
	while(ds_text_w IS NOT NULL AND ds_text_w::text <> '') loop
		qt_index_w := qt_index_w + 1;
		nr_char_index_w := instr(ds_text_w, 'CREATE OR REPLACE', 25, 1);
		if (nr_char_index_w = 0) then
			ds_text_aux_w := ds_text_w;
			ds_text_w := null;
		else
			ds_text_aux_w := substr(ds_text_w, 0, nr_char_index_w);
		end if;

		if ((instr(ds_text_aux_w, 'FORCE AS OBJECT', 1, 1) = 0) and (instr(ds_text_aux_w, 'AS OBJECT', 1, 1) > 0)) then
			ds_text_aux_w := regexp_replace(ds_text_aux_w, 'AS OBJECT','FORCE AS OBJECT',1,1,'i');
		elsif (instr(ds_text_aux_w, 'FORCE IS TABLE', 1, 1) = 0 and (instr(ds_text_aux_w, 'IS TABLE', 1, 1) > 0)) then
			ds_text_aux_w := regexp_replace(ds_text_aux_w, 'IS TABLE','FORCE IS TABLE',1,1,'i');
		end if;

		nr_aux_w := instr(ds_text_aux_w, '/', -1);
		if (nr_aux_w <> 0 ) then
			ds_text_aux_w := substr(ds_text_aux_w, 0, (nr_aux_w - 1));
		end if;

		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_text_aux_w, null, nm_objeto_w);
		commit;	

		ds_text_w := substr(ds_text_w, nr_char_index_w);
		t_script_w.extend;
		t_script_w(qt_index_w) := ds_text_aux_w;
	end loop;

	return t_script_w;
end;

begin

CALL Exec_Sql_Dinamico('Tasy',' delete from objeto_versao_offline_w ');
commit;

CALL Exec_Sql_Dinamico('Tasy',' drop table w_temp_objeto_versao');
ds_comando_w:= 'create table w_temp_objeto_versao ' ||
		' as ' ||
		' (select /*+PARALLEL*/ ' ||
        ' to_lob(a.ds_script_criacao) ds_comando, ' ||
		' a.nm_objeto, '||
		' a.ie_banco, '||
		' a.ie_tipo_objeto '||
		' from	tasy_versao.objeto_sistema a ' ||
		' where	ie_tipo_objeto not in ('||chr(39)||'Script'||chr(39)||','||chr(39)||'Job'||chr(39)||','||chr(39)||'Baca'||chr(39)||') '||
        ' and Gerar_Objeto_Aplicacao(a.ds_aplicacao, obter_cgc_estabelecimento(1), a.CD_CNPJ) = ''S'' ' ||
		' and	a.dt_atualizacao >= (select	max(dt_versao) ' ||
									' from	tasy_versao.aplicacao_tasy_versao x, ' ||
                                    ' aplicacao_tasy z ' ||
									' where	z.cd_versao_atual = x.cd_versao ' ||
                                    ' and z.cd_aplicacao_tasy = x.cd_aplicacao_tasy ' ||
                                    ' and x.cd_aplicacao_tasy = '||chr(39)||'Tasy'||chr(39) ||')'||
		' and 	a.ds_script_criacao is not null)';

EXECUTE ds_comando_w;

qt_processo_w := qt_processo_w + 1;
ds_comando_w :=	' select /*+PARALLEL*/ a.ds_comando, ' ||
				'		 a.nm_objeto, ' ||
				'		 a.ie_banco, ' ||
				'		 trim(upper(a.ie_tipo_objeto)) ie_tipo_objeto ' ||
				' from	w_temp_objeto_versao a ' ||
				' order by  obter_ordem_Objeto(a.ie_tipo_objeto), nm_objeto ';

C03 := dbms_sql.open_cursor;
dbms_sql.parse(C03, ds_comando_w, dbms_sql.native);
dbms_sql.define_column(C03, 1, ds_comando_w);
dbms_sql.define_column(C03, 2, nm_objeto_w, 50);
dbms_sql.define_column(C03, 3, ie_banco_w, 15);
dbms_sql.define_column(C03, 4, ie_tipo_objeto_w, 15);
retorno_w := dbms_sql.execute(C03);

while( dbms_sql.fetch_rows(C03) > 0 ) loop
	dbms_sql.column_value(C03, 1, ds_script_criacao_w);
	dbms_sql.column_value(C03, 2, nm_objeto_w);
	dbms_sql.column_value(C03, 3, ie_banco_w);
	dbms_sql.column_value(C03, 4, ie_tipo_objeto_w);
	qt_processo_w := qt_processo_w + 1;

	ds_script_criacao_w := trim(both ds_script_criacao_w);
	nr_aux_w := instr(ds_script_criacao_w, '/', -1);
	if (nr_aux_w <> 0) then
		ds_script_criacao_w := substr(ds_script_criacao_w, 0, (nr_aux_w - 1));
	end if;

	if (ie_tipo_objeto_w = 'TRIGGER') then
		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'PROCEDURE') then
		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'FUNCTION') then
		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'SCRIPT') then
		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'BASE') then
		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'VIEW') then
		ds_script_criacao_w := trim(both ds_script_criacao_w);
		nr_aux_w := instr(ds_script_criacao_w, ';', -1);
		if (nr_aux_w <> 0 ) then
			ds_script_criacao_w := substr(ds_script_criacao_w, 0, (nr_aux_w - 1));
		end if;

		if ((instr(upper(ds_script_criacao_w), 'FORCE VIEW', 1, 1) = 0) and (instr(upper(ds_script_criacao_w), 'VIEW', 1, 1) > 0)) then
			ds_script_criacao_w := regexp_replace(ds_script_criacao_w, 'VIEW','FORCE VIEW',1,1,'i');
		end if;

		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'SEQUENCE') then
		ds_script_criacao_w := trim(both ds_script_criacao_w);
		nr_aux_w := instr(ds_script_criacao_w, ';', -1);
		if (nr_aux_w <> 0 ) then
			ds_script_criacao_w := substr(ds_script_criacao_w, 0, (nr_aux_w - 1));
		end if;

		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_criacao_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'PACKAGE') then
		nr_aux_w := position('PACKAGE BODY' in upper(ds_script_criacao_w));
		if (nr_aux_w = 0) then
			nr_aux_w := position('PACKAGE	BODY' in upper(ds_script_criacao_w));
		end if;

		ds_script_aux_w := substr(ds_script_criacao_w, 0, nr_aux_w);
		nr_aux_w := instr(ds_script_aux_w, '/', -1);		
		ds_script_aux_w := substr(ds_script_criacao_w, 0, (nr_aux_w - 1));

		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_aux_w, null, nm_objeto_w);
		commit;

		ds_script_aux_w := substr(ds_script_criacao_w, (nr_aux_w - 1), length(ds_script_criacao_w));
		nr_aux_w := position('CREATE OR REPLACE' in upper(ds_script_aux_w));
		ds_script_aux_w := substr(ds_script_aux_w, nr_aux_w, length(ds_script_criacao_w));	

		insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
		values (nextval('objeto_versao_offline_w_seq'), 1, ds_script_aux_w, null, nm_objeto_w);
		commit;
	elsif (ie_tipo_objeto_w = 'TYPE') then
		script_table_w := split_script_type(ds_script_criacao_w);

		for i in script_table_w.first .. script_table_w.last loop
			if (instr(script_table_w(i), 'TYPE', 1, 1) > 0) then
				script_table_w(i) := regexp_replace(script_table_w(i), 'TYPE',' TYPE  ',1,1);

				insert into objeto_versao_offline_w(nr_sequencia, nr_ordem, ds_comando, ds_log, nm_objeto)
				values (nextval('objeto_versao_offline_w_seq'), 1, script_table_w(i), null, nm_objeto_w);
				commit;	
			end if;
		end loop;
	end if;	

end loop;
dbms_sql.close_cursor(C03);

end;
$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON FUNCTION split_script_type (ds_text_p text) FROM PUBLIC;
