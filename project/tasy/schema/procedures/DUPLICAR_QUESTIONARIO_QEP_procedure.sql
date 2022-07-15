-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_questionario_qep ( nr_seq_que_atendimento_p bigint, nm_usuario_p text, nr_seq_que_atendimento_novo_p INOUT bigint) AS $body$
DECLARE


ds_campos_w				varchar(32000);
ds_campos_nao_copiar_w			varchar(32000);
nm_tabela_w          			varchar(50);
nm_atributo_w          			varchar(50);
ds_comando_w				varchar(32000);
c001					integer;
retorno_w				integer;
nr_seq_atendimento_novo_w		que_atendimento.nr_sequencia%type;
nr_seq_questao_atual_w			que_atendimento_questao.nr_sequencia%type;
nr_seq_questao_nova_w			que_atendimento_questao.nr_sequencia%type;

c10 CURSOR FOR
	SELECT	column_name
	from	user_tab_columns
	where	table_name = nm_tabela_w
	and	obter_se_contido_char(upper(column_name), upper(ds_campos_nao_copiar_w)) = 'N'
	and	data_type <> 'LONG';

C20 CURSOR FOR
	SELECT	nr_sequencia
	from	que_atendimento_questao
	where	nr_seq_que_atendimento = nr_seq_que_atendimento_p
	order by nr_sequencia;


BEGIN

/* QUE_ATENDIMENTO */

ds_campos_w			:= '';
nm_tabela_w 		:= 	'QUE_ATENDIMENTO';
ds_campos_nao_copiar_w	:= 	'NR_SEQUENCIA,'||
				'DT_ATUALIZACAO,'||
				'NM_USUARIO,'||
				'DT_LIBERACAO,'||
				'DT_LIBERACAO_TECNICO,'||
				'IE_SITUACAO,'||
				'DT_INATIVACAO,'||
				'NM_USUARIO_INATIVACAO';

select	nextval('que_atendimento_seq')
into STRICT	nr_seq_atendimento_novo_w
;

open C10;
loop
fetch C10 into
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C10 */
	begin
	if (ds_campos_w IS NOT NULL AND ds_campos_w::text <> '') then
		ds_campos_w	:= ds_campos_w || ',';
	end if;
	ds_campos_w	:= ds_campos_w || nm_atributo_w;
	end;
end loop;
close C10;

--ds_campos_w 	:=	substr(ds_campos_w,1,length(ds_campos_w)-1);
ds_comando_w	:= 	'insert into ' || nm_tabela_w || '('||
				ds_campos_nao_copiar_w || ',' ||
				ds_campos_w ||
				')' ||
			'Select	:NR_SEQUENCIA_NOVA_P, '||
				'sysdate, '||
				':nm_usuario_p, '||
				'null, '||
				'null, '||
				'''A'', '||
				'null, '||
				'null, '||
				ds_campos_w||
			' from	' || nm_tabela_w ||
			' where	nr_sequencia = :NR_SEQUENCIA_ATUAL_P';

C001 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.Native);
DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQUENCIA_NOVA_P', nr_seq_atendimento_novo_w, 255);
DBMS_SQL.BIND_VARIABLE(C001, 'NM_USUARIO_P', nm_usuario_p, 255);
DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQUENCIA_ATUAL_P', nr_seq_que_atendimento_p, 255);

Retorno_w := DBMS_SQL.execute(c001);
DBMS_SQL.CLOSE_CURSOR(C001);

/* QUE_ATENDIMENTO_QUESTAO */

open C20;
loop
fetch C20 into
	nr_seq_questao_atual_w;
EXIT WHEN NOT FOUND; /* apply on C20 */
	begin

	ds_campos_w			:= '';
	nm_tabela_w 		:= 	'QUE_ATENDIMENTO_QUESTAO';
	ds_campos_nao_copiar_w	:= 	'NR_SEQUENCIA,'||
					'NR_SEQ_QUE_ATENDIMENTO,'||
					'DT_ATUALIZACAO,'||
					'NM_USUARIO';

	select	nextval('que_atendimento_questao_seq')
	into STRICT	nr_seq_questao_nova_w
	;

	open C10;
	loop
	fetch C10 into
		nm_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on C10 */
		begin
		if (ds_campos_w IS NOT NULL AND ds_campos_w::text <> '') then
			ds_campos_w	:= ds_campos_w || ',';
		end if;
		ds_campos_w	:= ds_campos_w || nm_atributo_w;
		end;
	end loop;
	close C10;

	ds_comando_w	:= 	'insert into ' || nm_tabela_w || '('||
					ds_campos_nao_copiar_w || ',' ||
					ds_campos_w ||
					')' ||
				'Select	:nr_sequencia_nova_p, '||
					':nr_seq_que_atend_gerado_p, '||
					'sysdate, '||
					':nm_usuario_p, '||
					ds_campos_w||
				' from	' || nm_tabela_w ||
				' where	nr_sequencia = :nr_sequencia_atual_p';

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQUENCIA_NOVA_P', nr_seq_questao_nova_w, 255);
	DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQ_QUE_ATEND_GERADO_P', nr_seq_atendimento_novo_w, 255);
	DBMS_SQL.BIND_VARIABLE(C001, 'NM_USUARIO_P', nm_usuario_p, 255);
	DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQUENCIA_ATUAL_P', nr_seq_questao_atual_w, 255);

	Retorno_w := DBMS_SQL.execute(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);


	/* QUE_ATENDIMENTO _QUESTAO_OP */

	ds_campos_w			:= '';
	nm_tabela_w 		:= 	'QUE_ATENDIMENTO_QUESTAO_OP';
	ds_campos_nao_copiar_w	:= 	'NR_SEQUENCIA,'||
					'DT_ATUALIZACAO,'||
					'NM_USUARIO,'||
					'NR_SEQ_QUE_ATEND_QUESTAO';

	open C10;
	loop
	fetch C10 into
		nm_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on C10 */
		begin
		if (ds_campos_w IS NOT NULL AND ds_campos_w::text <> '') then
			ds_campos_w	:= ds_campos_w || ',';
		end if;
		ds_campos_w	:= ds_campos_w || nm_atributo_w;
		end;
	end loop;
	close C10;

	ds_comando_w	:= 	'insert into ' || nm_tabela_w || '('||
					ds_campos_nao_copiar_w || ',' ||
					ds_campos_w ||
					')' ||
				'Select	que_atendimento_questao_op_seq.nextval, '||
					'sysdate, '||
					':nm_usuario_p, '||
					':nr_seq_questao_nova_p, '||
					ds_campos_w||
				' from	' || nm_tabela_w ||
				' where	nr_seq_que_atend_questao = :nr_seq_questao_atual_p';

	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'NM_USUARIO_P', nm_usuario_p, 255);
	DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQ_QUESTAO_NOVA_P', nr_seq_questao_nova_w, 255);
	DBMS_SQL.BIND_VARIABLE(C001, 'NR_SEQ_QUESTAO_ATUAL_P', nr_seq_questao_atual_w, 255);

	Retorno_w := DBMS_SQL.execute(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);

	end;
end loop;
close C20;

commit;

nr_seq_que_atendimento_novo_p	:= nr_seq_atendimento_novo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_questionario_qep ( nr_seq_que_atendimento_p bigint, nm_usuario_p text, nr_seq_que_atendimento_novo_p INOUT bigint) FROM PUBLIC;

