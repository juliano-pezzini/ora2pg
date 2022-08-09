-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_implementacao_tabs ( nr_seq_tab_p bigint, nm_package_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_classe_w			bigint;
nm_classe_w			varchar(50);
nm_variavel_classe_w		varchar(50);
nm_package_w			varchar(50);
ds_declaracao_variavel_w	varchar(2000);
ds_variaveis_w			text;
ds_metodo_get_w			varchar(2000);
ds_metodo_set_w			varchar(2000);
/*Foi alterada a variável para o tipo clob, devido o projeto CorPls_F9 estourar com o campo Long*/

ds_metodos_w			text;
ds_tabs_creation_w		text;
ds_add_tab_w			varchar(2000);
ds_add_tabs_w			text;
ds_tabs_ativation_w		text;
ds_evt_state_changed_w		text;
ie_primeiro_loop_w		varchar(1) := 'S';
ds_tabs_imports_w		text;
tab_w				varchar(4) := '    ';
ds_reg_comp_menu_w		text;
ds_filters_ativation_w		text;

ds_conteudo_1_w			varchar(32764);
ds_conteudo_2_w			varchar(32764);
c001				integer;
ds_sql_w			varchar(2000);
retorno_w			integer;

c01 CURSOR FOR
SELECT	nr_sequencia,
	nm_objeto,
	obter_initcap_var_classe_java(nm_objeto),
	gerar_nome_package_java(nm_objeto)
from	dic_objeto
where	nr_seq_obj_sup = nr_seq_tab_p
and	ie_tipo_objeto = 'P'
order by
	nr_seq_apres;


BEGIN
CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_var_implement_wjpum');
CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_metodos_implement_wjpum');
CALL exec_sql_dinamico(nm_usuario_p, 'truncate table w_implementacao_wjpum');
if (nr_seq_tab_p IS NOT NULL AND nr_seq_tab_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_tabs_creation_w	:= tab_w || 'public void criarTabs() {' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || tab_w || tab_w || 'try {' || chr(10);
	ds_evt_state_changed_w	:= tab_w || '   if   (!containerWJTP.isMontandoTabs()) {' || chr(10);
	ds_reg_comp_menu_w	:= tab_w || 'public void registrarComportamentosMenus() {' || chr(10);
	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || tab_w || tab_w || 'try {' || chr(10);
	ds_filters_ativation_w	:= tab_w || 'public void ativarFiltros() {' || chr(10);
	ds_filters_ativation_w	:= ds_filters_ativation_w || tab_w || tab_w || 'try {' || chr(10);
	open c01;
	loop
	fetch c01 into	nr_seq_classe_w,
			nm_classe_w,
			nm_variavel_classe_w,
			nm_package_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_tabs_imports_w		:= ds_tabs_imports_w || replace(nm_package_p,'package','import') || '.' || nm_package_w || '.' || nm_classe_w || ';' || chr(10);

		ds_declaracao_variavel_w	:= tab_w || 'private ' || nm_classe_w || ' ' || nm_variavel_classe_w || ';';
		ds_variaveis_w			:= ds_variaveis_w || ds_declaracao_variavel_w || chr(10);

		ds_metodo_get_w			:= tab_w || 'public ' || nm_classe_w || ' get' || nm_classe_w || '() {' || chr(10);
		ds_metodo_get_w			:= ds_metodo_get_w || tab_w || tab_w || 'return this.' || nm_variavel_classe_w || ';' || chr(10);
		ds_metodo_get_w			:= ds_metodo_get_w || tab_w || '}' || chr(10);
		ds_metodos_w			:= ds_metodos_w || ds_metodo_get_w || chr(10);

		ds_metodo_set_w			:= tab_w || 'public void set' || nm_classe_w || '(' || nm_classe_w || ' ' || nm_variavel_classe_w ||') {' || chr(10);
		ds_metodo_set_w			:= ds_metodo_set_w || tab_w || tab_w || 'this.' || nm_variavel_classe_w || ' = ' || nm_variavel_classe_w || ';' || chr(10);
		ds_metodo_set_w			:= ds_metodo_set_w || tab_w || '}' || chr(10);
		ds_metodos_w			:= ds_metodos_w || ds_metodo_set_w || chr(10);

		ds_tabs_creation_w		:= ds_tabs_creation_w || tab_w || tab_w || tab_w || 'set' || nm_classe_w || '(new ' || nm_classe_w || '(this));' || chr(10);

		ds_add_tab_w			:= tab_w || tab_w || tab_w || 'containerWJTP.addTab(' || to_char(nr_seq_classe_w) || ', ' || 'get' || nm_classe_w || '());';
		ds_add_tabs_w			:= ds_add_tabs_w || ds_add_tab_w || chr(10);

		if (ie_primeiro_loop_w = 'S') then
			begin
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || tab_w || tab_w || tab_w || 'if  (' || nm_variavel_classe_w || '.equals(containerWJTP.getSelectedComponent())) {' || chr(10);
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || tab_w || tab_w || tab_w || tab_w || nm_variavel_classe_w || '.ativar();' || chr(10);
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || tab_w || tab_w || tab_w || '}';
			ie_primeiro_loop_w	:= 'N';
			end;
		else
			begin
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || ' else if  (' || nm_variavel_classe_w || '.equals(containerWJTP.getSelectedComponent())) {' || chr(10);
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || tab_w || tab_w || tab_w || tab_w || nm_variavel_classe_w || '.ativar();' || chr(10);
			ds_evt_state_changed_w	:= ds_evt_state_changed_w || tab_w || tab_w || tab_w || '}';
			end;
		end if;
		end;
	end loop;
	close c01;
	ds_tabs_creation_w	:= ds_tabs_creation_w || chr(10) || ds_add_tabs_w;
	ds_tabs_creation_w	:= ds_tabs_creation_w || chr(10) || tab_w || tab_w || tab_w || 'containerWJTP.montarTab();' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || chr(10) || tab_w || tab_w || tab_w || 'isTabsCriadas = true;' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || tab_w || tab_w || '} catch (Exception ex) {' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || tab_w || tab_w || tab_w || 'UGeneric.tratarErro(this, ex);' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || tab_w || tab_w || '}' || chr(10);
	ds_tabs_creation_w	:= ds_tabs_creation_w || tab_w || '}';

	ds_tabs_ativation_w	:= tab_w || tab_w || tab_w || 'if  (!isTabsCriadas) {' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'criarTabs();' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'registrarComportamentosMenus();' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'ativarFiltros();' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'containerWJTPWStateChanged(null);' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || '} else if  (containerWJTP.getSelectedIndex() != 0) {' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'containerWJTP.setSelectedIndex(0);' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || '} else {' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || tab_w || 'containerWJTPWStateChanged(null);' || chr(10);
	ds_tabs_ativation_w	:= ds_tabs_ativation_w || tab_w || tab_w || tab_w || '}';

	ds_evt_state_changed_w	:= ds_evt_state_changed_w || chr(10) || tab_w || '   }';

	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || chr(10) || tab_w || tab_w || tab_w || '' || chr(10);
	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || tab_w || tab_w || '} catch (Exception ex) {' || chr(10);
	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || tab_w || tab_w || tab_w || 'UGeneric.tratarErro(this, ex);' || chr(10);
	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || tab_w || tab_w || '}' || chr(10);
	ds_reg_comp_menu_w	:= ds_reg_comp_menu_w || tab_w || '}' || chr(10);

	ds_filters_ativation_w	:= ds_filters_ativation_w || chr(10) || tab_w || tab_w || tab_w || '' || chr(10);
	ds_filters_ativation_w	:= ds_filters_ativation_w || tab_w || tab_w || '} catch (Exception ex) {' || chr(10);
	ds_filters_ativation_w	:= ds_filters_ativation_w || tab_w || tab_w || tab_w || 'UGeneric.tratarErro(this, ex);' || chr(10);
	ds_filters_ativation_w	:= ds_filters_ativation_w || tab_w || tab_w || '}' || chr(10);
	ds_filters_ativation_w	:= ds_filters_ativation_w || tab_w || '}';

	ds_metodos_w		:= ds_metodos_w || ds_reg_comp_menu_w || chr(10) || ds_filters_ativation_w;

	insert into w_implementacao_wjpum(
		ds_implementacao,
		id)
	values (
		ds_tabs_imports_w,
		'I');

	insert into w_var_implement_wjpum(
		ds_variaveis)
	values (
		ds_variaveis_w);

	/*Essa rotina abaixo trata para inserir na tabela valores com mais de 32 mil caracteres*/

	ds_conteudo_1_w := substr(ds_metodos_w,32764,1);
	ds_conteudo_2_w := substr(ds_metodos_w,32764,32765);

	ds_sql_w	:= ' insert into w_metodos_implement_wjpum (ds_metodos) values (:ds_metodos)';
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.BIND_VARIABLE(C001, 'DS_METODOS', ds_conteudo_1_w || ds_conteudo_2_w);
	retorno_w := DBMS_SQL.EXECUTE(c001);
	DBMS_SQL.CLOSE_CURSOR(C001);

	/*insert into w_metodos_implement_wjpum (
		ds_metodos)
	values (
		ds_metodos_w);
	*/
	insert into w_implementacao_wjpum(
		ds_implementacao,
		id)
	values (
		ds_tabs_creation_w,
		'C');

	insert into w_implementacao_wjpum(
		ds_implementacao,
		id)
	values (
		ds_tabs_ativation_w,
		'A');

	insert into w_implementacao_wjpum(
		ds_implementacao,
		id)
	values (
		ds_evt_state_changed_w,
		'E');
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_implementacao_tabs ( nr_seq_tab_p bigint, nm_package_p text, nm_usuario_p text) FROM PUBLIC;
