-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_script_insert_tabela ( nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


nm_atributo_w			varchar(50);
ie_tipo_atributo_w		varchar(10);
qt_tamanho_w			bigint;
qt_decimais_w			bigint;
ie_obrigatorio_w		varchar(1);

ds_declaracao_variavel_w	varchar(2000);
ds_variaveis_w			text;

ds_atributo_insert_w		varchar(2000);
ds_clausula_insert_w		text;

ds_atributo_values_w		varchar(2000);
ds_clausula_values_w		text;

tab_w				varchar(4) := '	';

ds_script_insert_w		text;

qt_tab_w			bigint;
nr_tab_w			bigint;

ie_primeiro_loop_w		varchar(1) := 'S';
ie_atrib_ant_obrig_w		varchar(1);

c01 CURSOR FOR
SELECT	nm_atributo,
	ie_tipo_atributo,
	qt_tamanho,
	qt_decimais,
	ie_obrigatorio
from	tabela_atributo
where	lower(nm_tabela) = lower(nm_tabela_p)
and	ie_tipo_atributo not in ('FUNCTION','VISUAL')
order by
	nr_sequencia_criacao;


BEGIN
if (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_implementacao_wjpum');

	ie_primeiro_loop_w	:= 'S';
	ds_variaveis_w		:= null;
	ds_clausula_insert_w	:= 'insert into ' || lower(nm_tabela_p) || ' (' || chr(10);
	ds_clausula_values_w	:= chr(10) || ' values (' || chr(10);

	open c01;
	loop
	fetch c01 into	nm_atributo_w,
			ie_tipo_atributo_w,
			qt_tamanho_w,
			qt_decimais_w,
			ie_obrigatorio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		-- Montar declaração variáveis
		ds_declaracao_variavel_w := lower(nm_atributo_w) || '_w';

		while(length(ds_declaracao_variavel_w) < 50) loop
			begin
			ds_declaracao_variavel_w := ds_declaracao_variavel_w || ' ';
			end;
		end loop;

		ds_declaracao_variavel_w := ds_declaracao_variavel_w || tab_w;

		if (ie_tipo_atributo_w = 'NUMBER') then
			begin
			ds_declaracao_variavel_w := ds_declaracao_variavel_w || lower(ie_tipo_atributo_w) || '(' || qt_tamanho_w || ',' || qt_decimais_w || ');';
			end;
		elsif (ie_tipo_atributo_w = 'VARCHAR2') then
			begin
			ds_declaracao_variavel_w := ds_declaracao_variavel_w || lower(ie_tipo_atributo_w) || '(' || qt_tamanho_w || ');';
			end;
		else
			begin
			ds_declaracao_variavel_w := ds_declaracao_variavel_w || lower(ie_tipo_atributo_w) || ';';
			end;
		end if;

		ds_declaracao_variavel_w := ds_declaracao_variavel_w || chr(10);

		ds_variaveis_w := ds_variaveis_w || ds_declaracao_variavel_w;

		-- Montar cláusula insert
		if (ie_primeiro_loop_w = 'S') then
			begin
			ds_clausula_insert_w := ds_clausula_insert_w || tab_w || lower(nm_atributo_w);
			end;
		else
			begin
			ds_clausula_insert_w := ds_clausula_insert_w || ',' || chr(10) || tab_w || lower(nm_atributo_w);
			end;
		end if;

		-- Montar cláusula values
		if (ie_primeiro_loop_w = 'S') then
			begin
			ds_clausula_values_w := ds_clausula_values_w || tab_w || lower(nm_atributo_w) || '_w';
			end;
		else
			begin
			ds_clausula_values_w := ds_clausula_values_w || ',';

			if (ie_atrib_ant_obrig_w = 'S') then
				begin
				ds_clausula_values_w := ds_clausula_values_w || ' -- >>> ATRIBUTO OBRIGATÓRIO !!! <<<';
				end;
			end if;

			ds_clausula_values_w := ds_clausula_values_w || chr(10) || tab_w || lower(nm_atributo_w) || '_w';
			end;
		end if;

		ie_primeiro_loop_w := 'N';
		ie_atrib_ant_obrig_w := ie_obrigatorio_w;
		end;
	end loop;
	close c01;

	-- Montar script
	ds_clausula_insert_w := ds_clausula_insert_w || ')';
	ds_clausula_values_w := ds_clausula_values_w || ');';

	ie_atrib_ant_obrig_w := 'S';
	-- Tratar obrigatoriedade último atributo loop
	if (ie_atrib_ant_obrig_w = 'S') then
		begin
		ds_clausula_values_w := ds_clausula_values_w || ' -- >>> ATRIBUTO OBRIGATÓRIO !!! <<<';
		end;
	end if;

	ds_script_insert_w := ds_variaveis_w || chr(10) || ds_clausula_insert_w || ds_clausula_values_w;

	insert into w_implementacao_wjpum(
		ds_implementacao,
		id)
	values (
		ds_script_insert_w,
		'T');
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_script_insert_tabela ( nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;

