-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_script_cliente (cd_versao_p text, nr_release_p text, nm_usuario_p text) AS $body$
DECLARE

			
qt_registro_w	bigint;
ds_script_w	text;
ds_comando_w	text;
ds_comando_linha_w	text;
ds_script2_w	text;
nr_index_original_w	bigint;
nr_index_final_w	bigint;
nr_byte_w			bigint;
i					bigint;
i_fim_w				bigint;
c					bigint;
ds_consulta_w	    varchar(512);
c02              	integer;
retorno_w        	integer;
script_list_w	DBMS_SQL.VARCHAR2A;
LinhaFinal			bigint:= 0;
ds_motivo_w         varchar(2000);

C01 CURSOR FOR
	SELECT	ds_comando
	--, ds_motivo
	from	ajuste_versao_cliente
	where	cd_versao = cd_versao_p
	and	nr_release = nr_release_p
	order by nr_ordem, nr_sequencia;


BEGIN

CALL exec_sql_dinamico('Tasy', 'truncate table ajuste_versao_final_w');
commit;

delete from ajuste_versao_cliente_w;
delete from ajuste_versao_cliente_dw;
commit;


select	count(*)
into STRICT	qt_registro_w
from	ajuste_versao_cliente a
where	cd_versao = cd_versao_p
and	nr_release = nr_release_p;

if (qt_registro_w > 0) then

	open C01;
	loop
	fetch C01 into	
		ds_comando_w;
		--, ds_motivo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		
		ds_script_w:= ds_script_w||CHR(13)||CHR(10)||ds_comando_w||CHR(13)||CHR(10);
		end;
	end loop;
	close C01;	
	
	insert into ajuste_versao_cliente_w(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_comando)
                    				--,ds_motivo)
				values (nextval('ajuste_versao_cliente_w_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_script_w);
                    				--,ds_motivo_w);	
	commit;			

	ds_script2_w:= substr(ds_script_w,1,32000);	
	
	insert into ajuste_versao_cliente_dw(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ds_comando_long)
					values (nextval('ajuste_versao_cliente_dw_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						ds_script2_w);	
		commit;
		
		
		
	ds_consulta_w := ' SELECT       ds_comando ' 	||
			' FROM  ajuste_versao_cliente ' ||
			' where  cd_versao = '||chr(39)||cd_versao_p||chr(39)||
			' and   nr_release = '|| nr_release_p ||
			' ORDER BY nr_ordem, nr_sequencia';

	C02 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C02, ds_consulta_w, dbms_sql.Native);
	DBMS_SQL.DEFINE_COLUMN(C02,1,ds_comando_w);
	retorno_w := DBMS_SQL.execute(C02);			
		
	while( DBMS_SQL.FETCH_ROWS(C02) > 0 ) loop
			DBMS_SQL.COLUMN_VALUE(C02, 1, ds_comando_w);

			ds_comando_w:= replace(ds_comando_w,CHR(13)||CHR(10),CHR(10));		
			select (length(ds_comando_w) - length(replace(ds_comando_w, CHR(10),'')))
			into STRICT	i_fim_w
			;
			
			i:= 0;
			nr_byte_w:= 1;
			nr_index_original_w:= 1;

			while(i < i_fim_w+1) loop
				i:= i+1;
				ds_comando_linha_w:= substr(ds_comando_w,nr_index_original_w,1000);
				nr_index_final_w:= position(CHR(10) in ds_comando_linha_w);
				if (nr_index_final_w = 0) and (i = i_fim_w+1) then
					nr_index_final_w:= 1000;
				end if;
				script_list_w(nr_byte_w) := substr(ds_comando_w,nr_index_original_w-1,nr_index_final_w);
				nr_index_original_w:= nr_index_original_w+nr_index_final_w+1;
				nr_byte_w:= nr_byte_w+1;	
			end loop;
				
			i:= 0;				
			while(i < i_fim_w+1) loop
				i:= i+1;			
				LinhaFinal:= LinhaFinal+1;
				
				if ((script_list_w(i) IS NOT NULL AND (script_list_w(i))::text <> ''))  then
					insert into ajuste_versao_final_w(ds_campo, nr_ordem) values (script_list_w(i),LinhaFinal);
					commit;
				end if;
			end loop;
			
			LinhaFinal:= LinhaFinal+1;
			CALL exec_sql_dinamico('Tasy', 'insert into ajuste_versao_final_w(ds_campo, nr_ordem) values('||chr(39)||'/'||chr(39)||','||LinhaFinal||')');
			commit;			

	END LOOP;
	DBMS_SQL.CLOSE_CURSOR(C02);

end if;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_script_cliente (cd_versao_p text, nr_release_p text, nm_usuario_p text) FROM PUBLIC;

