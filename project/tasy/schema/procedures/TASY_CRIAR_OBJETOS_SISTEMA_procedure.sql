-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_criar_objetos_sistema (nm_owner_origem_p text, ds_sql_where_p text) AS $body$
DECLARE


nm_objeto_w	 	varchar(40);
nr_ordem_w	 	bigint;
nm_owner_origem_w	varchar(15);
qt_processada_w		bigint;

/*Variaveis para cursor dinamico*/

c02		 integer;
retorno_w	 integer;
ds_comando_w	 varchar(512);

BEGIN

qt_processada_w := 0;
CALL GRAVAR_PROCESSO_LONGO('','TASY_CRIAR_OBJETOS_SISTEMA',qt_processada_w);


nm_owner_origem_w := nm_owner_origem_p;

if ( coalesce(nm_owner_origem_p::text, '') = '' ) or ( nm_owner_origem_p = '') then
	nm_owner_origem_w := 'TASY_VERSAO';
end if;

ds_comando_w := ' SELECT	a.nm_objeto,' ||
		'		obter_ordem_Objeto(a.ie_tipo_objeto) nr_ordem ' ||
		' FROM	'||nm_owner_origem_w||'.objeto_sistema a ' || ds_sql_where_p ||
		' AND 	upper(a.ie_tipo_objeto) IN(:IE_1,:IE_2,:IE_3,:IE_4,:IE_5,:IE_6)  ' ||
		' AND		Gerar_Objeto_Aplicacao(a.ds_aplicacao) = :DS_APLICACAO ' ||
		' AND	a.nm_objeto not in (:nm_objeto_1,:nm_objeto_2,:nm_objeto_3,:nm_objeto_4) ' ||
		' ORDER BY nr_ordem';


C02 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C02, ds_comando_w, dbms_sql.Native);
DBMS_SQL.DEFINE_COLUMN(C02,1,nm_objeto_w,50);
DBMS_SQL.DEFINE_COLUMN(C02,2,nr_ordem_w,10);

DBMS_SQL.BIND_VARIABLE(C02,'IE_1', 'PROCEDURE',50);
DBMS_SQL.BIND_VARIABLE(C02,'IE_2', 'VIEW',50);
DBMS_SQL.BIND_VARIABLE(C02,'IE_3', 'TRIGGER',50);
DBMS_SQL.BIND_VARIABLE(C02,'IE_4', 'FUNCTION',50);
DBMS_SQL.BIND_VARIABLE(C02,'IE_5', 'PACKAGE',50);
DBMS_SQL.BIND_VARIABLE(C02,'IE_6', 'BASE',50);
DBMS_SQL.BIND_VARIABLE(C02,'DS_APLICACAO', 'S',50);
DBMS_SQL.BIND_VARIABLE(C02,'NM_OBJETO_1', 'TASY_CRIAR_OBJETOS_SISTEMA',50);
DBMS_SQL.BIND_VARIABLE(C02,'NM_OBJETO_2', 'TASY_CRIAR_OBJETO_SISTEMA',50);
DBMS_SQL.BIND_VARIABLE(C02,'NM_OBJETO_3', 'GRAVAR_PROCESSO_LONGO',50);
DBMS_SQL.BIND_VARIABLE(C02,'NM_OBJETO_4', 'EXEC_SQL_DINAMICO',50);

retorno_w := DBMS_SQL.execute(C02);

while( DBMS_SQL.FETCH_ROWS(C02) > 0 ) loop
	DBMS_SQL.COLUMN_VALUE(C02, 1, nm_objeto_w);
	begin
		CALL GRAVAR_PROCESSO_LONGO('Criando: ' || nm_objeto_w,'TASY_CRIAR_OBJETOS_SISTEMA',qt_processada_w);
		qt_processada_w := qt_processada_w + 1;
		CALL tasy_criar_objeto_sistema(nm_objeto_w,nm_owner_origem_w);
	exception
		when others then
		begin
			nm_objeto_w := nm_objeto_w;
		end;
	end;
END LOOP;
DBMS_SQL.CLOSE_CURSOR(C02);

CALL GRAVAR_PROCESSO_LONGO('','',0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_criar_objetos_sistema (nm_owner_origem_p text, ds_sql_where_p text) FROM PUBLIC;
