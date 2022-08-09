-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_valor_padrao (qt_min_max_execucao_p bigint) AS $body$
DECLARE


nm_tabela_w				varchar(50);
nm_atributo_w          	varchar(50)    := '';
vl_default_w			varchar(50);
ie_obrigatorio_w		varchar(1);
ie_tipo_atributo_w		varchar(10);
qt_tamanho_w			bigint;
qt_decimais_w			bigint;
nr_sequencia_criacao_w	bigint;
ds_comando_count_w		varchar(255);
DS_COMANDO_W			varchar(512);
qt_registro_w			bigint;
qt_reg_acerto_w			bigint;
dt_inicio_w				timestamp;
dt_atual_w				timestamp;
qt_processo_w			bigint;
vl_retorno_w			varchar(20);
ie_situacao_w			smallint;
nr_sequencia_w			bigint;
qt_tentativas_w			bigint;
ds_erro_w				varchar(512);
c001				  	integer;
nm_objeto_w            	varchar(32)      := null;
ie_tipo_objeto_w       	varchar(32)      := null;


C01 CURSOR FOR
SELECT	a.nm_atributo,
	a.nm_tabela
FROM	tabela_atributo a,
	tabela_sistema	c
WHERE	a.nm_tabela		= c.nm_tabela
AND	a.ie_tipo_atributo 	not in ('FUNCTION','VISUAL')
AND	gerar_objeto_aplicacao(c.ds_aplicacao) = 'S'
AND	(a.vl_default IS NOT NULL AND a.vl_default::text <> '')
AND (UPPER(a.vl_default) LIKE '%@ESTAB%' OR
	 UPPER(a.vl_default) LIKE '%@EMPRESA%' OR
	 UPPER(a.vl_default) NOT LIKE '%@%')
AND 	UPPER(a.vl_default) NOT LIKE '%SYSDATE%'
AND	NOT EXISTS ( 	SELECT 	1
			FROM	user_tab_columns b
			WHERE	a.nm_atributo = b.column_name
			AND		a.nm_tabela   = b.table_name
			AND		b.NULLABLE    = 'N'
			AND		a.ie_obrigatorio = 'S')
AND		NOT EXISTS (	SELECT 	1
				FROM	tasy_ajuste_valor_padrao d
				WHERE 	a.nm_tabela = d.nm_tabela
				AND		a.nm_atributo = d.nm_atributo);

C02 CURSOR FOR
SELECT a.nm_tabela,
	   a.nm_atributo,
	   a.nr_sequencia
FROM   TASY_AJUSTE_VALOR_PADRAO a,
	   tabela_atributo_ajuste_v b
WHERE  a.nm_tabela = b.nm_tabela
AND	   a.nm_atributo = b.nm_atributo
AND    a.ie_situacao = 2
AND	   b.ie_obrigatorio = 'S'
order by a.nm_tabela;

C05 CURSOR FOR
	SELECT	a.nm_atributo,
			a.ie_obrigatorio,
			a.ie_tipo_atributo,
			a.qt_tamanho,
			a.qt_decimais,
			a.vl_default,
			a.nm_tabela,
			a.nr_sequencia_criacao,
			b.nr_sequencia,
			b.qt_tentativas
	FROM	tabela_atributo a,
			tasy_ajuste_valor_padrao b
	WHERE	a.nm_tabela = b.nm_tabela
	AND		a.nm_atributo = b.nm_atributo
	AND		b.ie_situacao = 1
	AND		NOT EXISTS (SELECT 	1
						FROM 	user_triggers b
						WHERE	a.nm_tabela = b.table_name
						AND		b.triggering_event like '%UPDATE%')
	ORDER 	BY	qt_registro_ajustar;


C06 CURSOR FOR
SELECT 	Object_name,
		object_type
FROM 	user_objects
where 	object_type in ('PROCEDURE', 'VIEW', 'TRIGGER', 'PACKAGE',
			 'PACKAGE BODY', 'FUNCTION')
and 	status =  'INVALID'
and		object_name not in ('TASY_AJUSTAR_VALOR_PADRAO','GRAVAR_PROCESSO_LONGO')
order by obter_ordem_objeto(object_type), object_name;


BEGIN
qt_processo_w:=0;
CALL gravar_processo_longo('','TASY_AJUSTAR_VALOR_PADRAO',qt_processo_w);
dt_inicio_w := clock_timestamp();

if (qt_min_max_execucao_p < 30 )  then
	OPEN C01;
	LOOP
		FETCH C01 INTO
				nm_atributo_w,
				nm_tabela_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
			dt_atual_w := clock_timestamp();
			if (dt_atual_w < (dt_inicio_w + (qt_min_max_execucao_p/1440))) then
			begin
				ds_comando_w := 'select count(*) from ' || nm_tabela_w;
				qt_registro_w := Obter_Valor_Dinamico(ds_comando_w, qt_registro_w);

				CALL gravar_processo_longo('Verifica tabela->'||nm_tabela_w||'('||nm_atributo_w||')','TASY_AJUSTAR_VALOR_PADRAO',qt_processo_w);
				ds_comando_count_w := 'select count(*) from ' || nm_tabela_w || ' where ' || nm_atributo_w || ' is null';
				qt_reg_acerto_w := obter_valor_dinamico(ds_comando_count_w, qt_reg_acerto_w);

				ie_situacao_w := 1;
				if ( qt_reg_acerto_w = 0) then
					ie_situacao_w := 2;
				end if;

				insert into tasy_ajuste_valor_padrao(
					nr_sequencia,
					nm_tabela,
					nm_atributo,
					qt_total_registro,
					qt_registro_ajustar,
					qt_tentativas,
					ie_situacao,
					dt_atualizacao,
					nm_usuario)
				values (
					nextval('tasy_ajuste_valor_padrao_seq'),
					nm_tabela_w,
					nm_atributo_w,
					qt_registro_w,
					qt_reg_acerto_w,
					0,
					ie_situacao_w,
					clock_timestamp(),
					'Tasy'
				);
				qt_processo_w := qt_processo_w + 1;
				commit;
			end;
			end if;
		END;
	END LOOP;
	CLOSE C01;
	qt_processo_w := 0;
	OPEN C05;
	LOOP
		FETCH C05 INTO
				nm_atributo_w,
				ie_obrigatorio_w,
				ie_tipo_atributo_w,
				qt_tamanho_w,
				qt_decimais_w,
				vl_default_w,
				nm_tabela_w,
				nr_sequencia_criacao_w,
				nr_sequencia_w,
				qt_tentativas_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
		BEGIN
			dt_atual_w := clock_timestamp();

			if (dt_atual_w < (dt_inicio_w + (qt_min_max_execucao_p/1440))) then
			begin
				qt_tentativas_w := qt_tentativas_w + 1;
				CALL gravar_processo_longo('Verifica tabela->'||nm_tabela_w||'('||nm_atributo_w||')','TASY_AJUSTAR_VALOR_PADRAO',qt_processo_w);
				ds_comando_w	:= 'Update ' || nm_tabela_w || ' set ' || nm_atributo_w || ' = ';
				if (ie_tipo_atributo_w = 'VARCHAR2') then
					ds_comando_w	:= ds_comando_w  || chr(39) || vl_default_w || chr(39);
				else
					if (upper(vl_default_w) = '@ESTAB') then
						select min(cd_estabelecimento)
						into STRICT vl_default_w
						from estabelecimento;
					elsif (upper(vl_default_w) = '@EMPRESA') then
						select min(cd_empresa)
						into STRICT vl_default_w
						from empresa;
					end if;
					ds_comando_w	:= ds_comando_w  || vl_default_w;
				end if;
				ds_comando_w	:= ds_comando_w  || ' where ' || nm_atributo_w || ' is null ';
				ds_comando_w	:= ds_comando_w  || ' and rownum < 1000 ';
				ds_comando_count_w := 'select count(*) from ' || nm_tabela_w || ' where ' || nm_atributo_w || ' is null';
				qt_reg_acerto_w := obter_valor_dinamico(ds_comando_count_w, qt_reg_acerto_w);
				begin
					ds_erro_w := '';
					while(qt_reg_acerto_w > 0) and
							(dt_atual_w < (dt_inicio_w + (qt_min_max_execucao_p/1440))) loop
						begin
							dt_atual_w := clock_timestamp();
							CALL gravar_processo_longo('Atualizando ->'||nm_tabela_w||'('||nm_atributo_w||')','TASY_AJUSTAR_VALOR_PADRAO',qt_processo_w);
							C001 := DBMS_SQL.OPEN_CURSOR;
							DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.Native);
							vl_retorno_w := DBMS_SQL.execute(c001);
							DBMS_SQL.CLOSE_CURSOR(C001);
							commit;
							ds_comando_count_w := 'select count(*) from ' || nm_tabela_w || ' where ' || nm_atributo_w || ' is null';
							qt_reg_acerto_w := obter_valor_dinamico(ds_comando_count_w, qt_reg_acerto_w);
							qt_processo_w := qt_processo_w + 1;
						end;
					end loop;
				exception
				when others then
						ds_erro_w := obter_desc_expressao(621817)/*'Excessão: '*/
 || substr(SQLERRM(SQLSTATE),1,500);
				end;
				ds_comando_count_w := 'select count(*) from ' || nm_tabela_w || ' where ' || nm_atributo_w || ' is null';
				qt_reg_acerto_w := obter_valor_dinamico(ds_comando_count_w, qt_reg_acerto_w);

				ie_situacao_w := 1;
				if ( qt_reg_acerto_w = 0) then
					ie_situacao_w := 2;
				else
					if ( qt_tentativas_w > 4 ) then
						ie_situacao_w := 3;
					end if;
					if ( qt_tentativas_w > 4 ) and ( coalesce(ds_erro_w::text, '') = '' ) and ( qt_reg_acerto_w > 0 ) then
						ie_situacao_w := 1;
					end if;
				end if;

				update 	tasy_ajuste_valor_padrao
				set		qt_registro_ajustado	= (qt_registro_ajustar-qt_reg_acerto_w),
						ie_situacao				= ie_situacao_w,
						qt_tentativas 			= qt_tentativas_w,
						ds_erro					= substr(ds_erro_w,1,512),
						ds_comando				= substr(ds_comando_w,1,2000)
				where	nr_sequencia 			= nr_sequencia_w;
				commit;
			end;
			end if;
		END;
	END LOOP;
	CLOSE C05;

	open C02;
	loop
	fetch C02 into
		nm_tabela_w,
		nm_atributo_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			ds_comando_w := 'alter table ' || nm_tabela_w || ' MODIFY( ' || nm_atributo_w || ' NOT NULL ) ';
			update	tasy_ajuste_valor_padrao
			set		ds_comando_alter = ds_comando_w
			where	nr_sequencia	 = nr_sequencia_w;
			commit;
			CALL Exec_Sql_Dinamico(nm_tabela_w || ',' || nm_atributo_w, ds_comando_w);
		end;
	end loop;
	close C02;


	OPEN C06;
	LOOP
		FETCH C06 INTO 	nm_objeto_w,
						ie_tipo_objeto_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
		BEGIN
			if (ie_tipo_objeto_w = 'PACKAGE BODY') then
				ie_tipo_objeto_w := 'PACKAGE ';
			end if;
			ds_comando_w := 'ALTER '||ie_tipo_objeto_w||' '||nm_objeto_w|| ' COMPILE';
			qt_processo_w := qt_processo_w + 1;
			CALL gravar_processo_longo(ds_comando_w,'VALIDA_OBJETOS_SISTEMA',qt_processo_w);
	 		C001 := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.v7);
			DBMS_SQL.CLOSE_CURSOR(C001);
		EXCEPTION
			WHEN OTHERS THEN
				DBMS_SQL.CLOSE_CURSOR(C001);
	      END;
	END LOOP;
	CLOSE C06;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_valor_padrao (qt_min_max_execucao_p bigint) FROM PUBLIC;
