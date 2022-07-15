-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_colunas_sql_dic_consulta ( nr_seq_dic_objeto_p bigint, nm_usuario_p text, ie_tipo_objeto_p text default 'AC') AS $body$
DECLARE


cd_funcao_w		integer;
ds_comando_sql_w		varchar(4000);
cursor_w			integer;
nr_atributos_sql_w		integer;
atributos_sql_w		dbms_sql.desc_tab;
qt_decimais_w		bigint;
ds_mascara_w		varchar(30);
ds_casas_decimais_w	varchar(20);
i			integer;
nm_atributo_sql_w		varchar(80);
qt_largura_w		bigint;

nr_seq_do_campo_w	bigint;
nr_seq_apresent_w		bigint := 10;
ie_tipo_dado_w		bigint;
ie_tipo_edicao_w	varchar(1);


BEGIN
if (nr_seq_dic_objeto_p IS NOT NULL AND nr_seq_dic_objeto_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	cd_funcao,
		ds_sql
	into STRICT	cd_funcao_w,
		ds_comando_sql_w
	from	dic_objeto
	where	nr_sequencia = nr_seq_dic_objeto_p;

	if (ds_comando_sql_w IS NOT NULL AND ds_comando_sql_w::text <> '') then
		begin
		cursor_w	:= dbms_sql.open_cursor;
		dbms_sql.parse(cursor_w, ds_comando_sql_w, dbms_sql.native);
		dbms_sql.describe_columns(cursor_w, nr_atributos_sql_w, atributos_sql_w);

		for i in 1 .. nr_atributos_sql_w loop
			begin

			nm_atributo_sql_w	:= atributos_sql_w[i].col_name;
			qt_largura_w		:= atributos_sql_w[i].col_max_len;
			qt_decimais_w		:= coalesce(atributos_sql_w[i].col_scale,0);
			ie_tipo_dado_w		:= atributos_sql_w[i].col_type;
			ds_mascara_w		:= '';

			/*qt_tamanho_ww	   	:= campos_w(i).col_max_len; */

			nr_seq_do_campo_w	:= obter_nextval_sequence('dic_objeto');
			nr_seq_apresent_w	:= nr_seq_apresent_w + 10;

			ie_tipo_edicao_w	:= 'V';

			if (ie_tipo_dado_w = 2) then /*Number*/
				ie_tipo_edicao_w	:= 'N';
				ds_casas_decimais_w	:= '';
				if (qt_decimais_w > 0) then
					for i in 1..qt_decimais_w loop
						begin
						ds_casas_decimais_w	:= ds_casas_decimais_w || '0';
						end;
					end loop;
					ds_mascara_w	:= '###,###,###,##0.' || ds_casas_decimais_w;
				end if;
			elsif (ie_tipo_dado_w = 12) then
				ie_tipo_edicao_w	:= 'D';
			end if;



			insert into dic_objeto(
				nr_sequencia,
				cd_funcao,
				nr_seq_obj_sup,
				ie_tipo_objeto,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nm_campo_base,
				ds_mascara,
				qt_largura,
				nm_campo_tela,
				nr_seq_apres,
				ie_read_only,
				ie_tipo_obj_col_wcp,
				ie_tipo_edicao)
			values (
				nr_seq_do_campo_w,
				cd_funcao_w,
				nr_seq_dic_objeto_p,
				ie_tipo_objeto_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nm_atributo_sql_w,
				ds_mascara_w,
				qt_largura_w,
				nm_atributo_sql_w,
				nr_seq_apresent_w,
				'S',
				'T',
				ie_tipo_edicao_w);
			end;
		end loop;

		dbms_sql.close_cursor(cursor_w);
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_colunas_sql_dic_consulta ( nr_seq_dic_objeto_p bigint, nm_usuario_p text, ie_tipo_objeto_p text default 'AC') FROM PUBLIC;

