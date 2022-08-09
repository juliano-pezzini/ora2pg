-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE compile_ajuste_versao (nm_usuario_p text, nr_seq_ajuste_versao_p text, ie_base_p text, cd_versao_p text, nr_release_p bigint) AS $body$
DECLARE




ds_consulta_w	    varchar(512);
ds_erro_w			varchar(2000);
ds_comando_w	    text;
ds_comando_linha_w	text;
c02              	integer;
retorno_w        	integer;
nr_index_original_w	bigint;
nr_index_final_w	bigint;
nr_byte_w			bigint;
i					bigint;
i_fim_w				bigint;
c					bigint;
res 				bigint;
script_list_w	DBMS_SQL.VARCHAR2A;
ds_encode_w 		varchar(100);


BEGIN

select	value
into STRICT	ds_encode_w
from	nls_database_parameters
where	parameter = 'NLS_CHARACTERSET';

if (ds_encode_w = 'AL32UTF8') then
	EXECUTE 'ALTER SESSION SET NLS_LENGTH_SEMANTICS=CHAR';
end if;

-- Rotina de Compilacao dos comandos
if (ie_base_p = 'W') then
	-- Bases internas ao liberar o script
	CALL Exec_Sql_Dinamico('Tasy','drop table ajuste_versao_comando');
	CALL Exec_Sql_Dinamico('Tasy','create table ajuste_versao_comando as select * from ajuste_versao_comando@wheb where nr_seq_ajuste_versao = '||nr_seq_ajuste_versao_p);

	ds_consulta_w := ' SELECT       ds_comando ' 	||
			' FROM  ajuste_versao_comando ' ||
			' ORDER BY nr_ordem';
else
	-- Base dos clientes
	ds_consulta_w := ' SELECT       ds_comando ' 	||
			' FROM  ajuste_versao_cliente ' ||
			' where  cd_versao = '||chr(39)||cd_versao_p||chr(39)||
			' and   nr_release = '|| nr_release_p ||
			' and ie_tipo_script <>  '||chr(39)||'E'||chr(39)||
			' ORDER BY nr_ordem, nr_sequencia';
end if;

C02 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C02, ds_consulta_w, dbms_sql.Native);
DBMS_SQL.DEFINE_COLUMN(C02,1,ds_comando_w);
retorno_w := DBMS_SQL.execute(C02);

while( DBMS_SQL.FETCH_ROWS(C02) > 0 ) loop
        DBMS_SQL.COLUMN_VALUE(C02, 1, ds_comando_w);
		begin
		
		$if dbms_db_version.version = 10 $then

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
			
			c := DBMS_SQL.open_cursor;
			DBMS_SQL.parse(c, script_list_w, 1,nr_byte_w-1, TRUE, DBMS_SQL.NATIVE);
			res := DBMS_SQL.execute(c);
			DBMS_SQL.close_cursor(c);
			
		$else
			EXECUTE ds_comando_w;
		$end
			
			
		exception
					when others then
					begin
					
							$if dbms_db_version.version = 10 $then
								DBMS_SQL.close_cursor(c);
							$end
							
							ds_erro_w := substr(SQLERRM,1,2000);
							-- Inserindo alerta da base
							insert into log_ajuste_versao( nr_sequencia,
							 dt_atualizacao,
							 nm_usuario,
							 dt_atualizacao_nrec,
							 nm_usuario_nrec,
							 nr_seq_ajuste_versao,
							 ds_erro,
							 ie_tipo_alerta)
			values (nextval('log_ajuste_versao_seq'),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_seq_ajuste_versao_p,
							ds_erro_w,
							'A');
						commit;

					end;
		   end;

END LOOP;
DBMS_SQL.CLOSE_CURSOR(C02);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE compile_ajuste_versao (nm_usuario_p text, nr_seq_ajuste_versao_p text, ie_base_p text, cd_versao_p text, nr_release_p bigint) FROM PUBLIC;
