-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tec_ajustar_base_java ( nm_usuario_p text) AS $body$
DECLARE

			 
dt_versao_atual_cliente_w 	timestamp;
qt_registro_w			bigint;


BEGIN 
CALL abortar_se_base_wheb();
 
dt_versao_atual_cliente_w	:= coalesce(to_date(to_char(obter_data_geracao_versao-1,'dd/mm/yyyy') ||' 23:59:59','dd/mm/yyyy hh24:mi:ss'),clock_timestamp() - interval '90 days');
 
--lhalves OS 02/02/2017 - Remover triggers do Schematic 
if (dt_versao_atual_cliente_w < to_date('02/02/2017','dd/mm/yyyy')) then 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'OBJETO_SCHEMATIC_INSERT';
	 
	if (qt_registro_w > 0) then 
		CALL Exec_Sql_Dinamico('lhalves',' drop trigger OBJETO_SCHEMATIC_INSERT ');
	end if;
	 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'OBJETO_SCHEMATIC_DELETE';
	 
	if (qt_registro_w > 0) then 
		CALL Exec_Sql_Dinamico('lhalves',' drop trigger OBJETO_SCHEMATIC_DELETE ');
	end if;
	 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'OBJETO_SCHEMATIC_UPDATE';
	 
	if (qt_registro_w > 0) then 
		CALL Exec_Sql_Dinamico('lhalves',' drop trigger OBJETO_SCHEMATIC_UPDATE ');
	end if;
	 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'PROJ_CRON_ETAPA_ATUAL_HTML5';
	 
	if (qt_registro_w > 0) then 
		CALL Exec_Sql_Dinamico('lhalves',' drop trigger PROJ_CRON_ETAPA_ATUAL_HTML5 ');
	end if;		
	 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'SCHEMATIC_RELATORIO_ATUAL';
	 
	if (qt_registro_w > 0) then 
		CALL Exec_Sql_Dinamico('Tasy',' drop trigger SCHEMATIC_RELATORIO_ATUAL ');
	end if;	
end if;
 
/*Bruno - Adicionado servidor de integração as integrações ativas*/
 
if (dt_versao_atual_cliente_w < to_date('08/06/2010','dd/mm/yyyy')) then 
	CALL baca_ajustar_serv_integracao();
end if;
 
/*Eduardo - Copiar valor padrão da tabela_atributo para tabela_visao*/
 
if (dt_versao_atual_cliente_w < to_date('02/08/2010','dd/mm/yyyy')) then 
	CALL baca_tabela_visao_Atributo();
end if;
 
if (dt_versao_atual_cliente_w < to_date('14/10/2010','dd/mm/yyyy')) then 
	CALL exec_sql_dinamico('epmallmann','alter table captura_software_detalhe drop column NM_USUARIO_CAPTURA');
	CALL exec_sql_dinamico('epmallmann','alter table captura_software_detalhe drop column NM_ESTACAO_CAPTURA');
end if;
 
if (dt_versao_atual_cliente_w < to_date('07/04/2011','dd/mm/yyyy')) then 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'WBARRAS_SEQ';
	 
	if (qt_registro_w = 0) then 
		 
		CALL Exec_sql_Dinamico('epmallmann',' CREATE SEQUENCE wbarras_seq '		|| 
					  ' INCREMENT BY 1 ' 				|| 
					  ' START WITH 1 '				|| 
					  ' MAXVALUE 9999999999 '			|| 
					  ' CYCLE  '					|| 
					  ' NoCache');
		 
	end if;
end if;
 
if (dt_versao_atual_cliente_w < to_date('20/06/2011','dd/mm/yyyy')) then 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	valor_dominio 
	where	cd_dominio = 2677 
	 and	vl_dominio = 'INSERT';
 
	if (qt_registro_w > 0) then 
		CALL exec_sql_dinamico('epmallmann','delete valor_dominio where cd_dominio = 2677 and vl_dominio = ' || CHR(39) || 'INS' || CHR(39));
	end if;
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	valor_dominio 
	where	cd_dominio = 2677 
	 and	vl_dominio = 'DELETE';
 
	if (qt_registro_w > 0) then 
		CALL exec_sql_dinamico('epmallmann','delete valor_dominio where cd_dominio = 2677 and vl_dominio = ' || CHR(39) || 'DEL' || CHR(39));
	end if;
end if;
 
if (dt_versao_atual_cliente_w < to_date('21/06/2011','dd/mm/yyyy')) then 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	valor_dominio 
	where	cd_dominio = 2677 
	 and	vl_dominio = 'INS';
 
	if (qt_registro_w > 0) then 
		CALL exec_sql_dinamico('epmallmann','delete valor_dominio where cd_dominio = 2677 and vl_dominio = ' || CHR(39) || 'INSERT' || CHR(39));
	end if;
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	valor_dominio 
	where	cd_dominio = 2677 
	 and	vl_dominio = 'DEL';
 
	if (qt_registro_w > 0) then 
		CALL exec_sql_dinamico('epmallmann','delete valor_dominio where cd_dominio = 2677 and vl_dominio = ' || CHR(39) || 'DELETE' || CHR(39));
	end if;
end if;
 
/* Susan - 17/09/2012 - Atualização do campo NM_ATRIBUTO_XML_PESQUISA para melhoria da performance (OS 483804) */
 
if (dt_versao_atual_cliente_w < to_date('17/09/2012','dd/mm/yyyy')) then 
	CALL exec_sql_dinamico('Tasy',' update xml_atributo set nm_atributo_xml_pesquisa = upper(nm_atributo_xml) where NM_ATRIBUTO_XML_PESQUISA is null');
end if;
 
/*Diego - 21/01/2013 - Mudar tamanho do campo CD_SUPERIOR da tabela MATERIAL_PROCESSO_WBARRAS - OS 537350*/
 
if (dt_versao_atual_cliente_w < to_date('21/01/2013','dd/mm/yyyy')) then 
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	user_tab_columns 
	where	table_name	= 'MATERIAL_PROCESSO_WBARRAS' 
	and		column_name	= 'CD_SUPERIOR';
	 
	if (qt_registro_w	> 0) then	 
		CALL exec_sql_dinamico('dalira',' alter table material_processo_wbarras modify cd_superior number(20) ');
	end if;
	 
end if;
 
/*Jairo - 07/02/2013 - Alterar valor padrão do fundo de Geral.css*/
 
if (dt_versao_atual_cliente_w < to_date('07/02/2013','dd/mm/yyyy')) then 
 
	select 	count(*) 
	into STRICT	qt_registro_w 
	from 	web_css_elemento_atrib a 
	where  a.nr_seq_css_elemento = (SELECT b.nr_sequencia 
					from 	web_css_elemento b 
					where 	b.nm_elemento = '.corFundoLogo');
					 
	if (qt_registro_w > 0) then 
							 
		select 	count(*) 
		into STRICT	qt_registro_w 
		from 	web_css_atributo 
		where	nm_atributo = 'backGround';
		 
		if (qt_registro_w > 0) then 
		 
			select	data_length 
			into STRICT	qt_registro_w 
			from	user_tab_columns a 
			where	table_name = 'WEB_CSS_ELEMENTO_ATRIB' 
			and	column_name = 'DS_VALOR_SISTEMA';
			 
			if (qt_registro_w >= 80) then 
				CALL exec_sql_dinamico('jojunior','update web_css_elemento_atrib a set a.nr_seq_css_atributo = (select nr_sequencia from web_css_atributo where nm_atributo = ' || CHR(39) || 'backGround' || CHR(39) || '), a.ds_valor_sistema = ' || CHR(39) || 'url("../../../Wheb_Config/figuras/logo_centro.png") 0 0 #9CB9C9 repeat-x' || CHR(39) || 'where a.nr_seq_css_elemento = (select b.nr_sequencia from web_css_elemento b where b.nm_elemento = ' || CHR(39) || '.corFundoLogo' || CHR(39) || ')');
			end if;
		end if;
	end if;
	 
end if;
 
/*Diego - 07/03/2012 - Criar a sequence USUARIO_TASY_ID_SEQ utilizada somente no java durante o login*/
 
if (dt_versao_atual_cliente_w < to_date('07/03/2013','dd/mm/yyyy')) then 
 
	select	count(1) 
	into STRICT	qt_registro_w 
	from	user_objects 
	where	object_name = 'USUARIO_TASY_ID_SEQ';
	 
	if (qt_registro_w = 0) then 
		CALL Exec_sql_Dinamico('dalira','CREATE SEQUENCE usuario_tasy_id_Seq INCREMENT BY 1 start with 1 MAXVALUE 999999999 cycle CACHE 100');
	end if;
 
end if;
 
 
/*Oraci - 17/06/2016 - Atualizar campo ds_rota */
 
if (dt_versao_atual_cliente_w < to_date('17/06/2016','dd/mm/yyyy')) then 
 
	CALL Exec_sql_Dinamico('oicorrea', 'UPDATE FUNCAO SET ds_rota = ds_action, dt_atualizacao = sysdate WHERE ds_rota IS NULL AND ds_action IS NOT NULL');
 
end if;
 
/*Rother - 03/08/2016 - Enabling Oracle Text usage for person name searching in Oracle >= 12*/
 
if (dt_versao_atual_cliente_w < to_date('03/08/2016','dd/mm/yyyy') and (dbms_db_version.version >= '12')) then 
	EXECUTE 'begin ctx_ddl.create_preference(''person_name_multi'', ''MULTI_COLUMN_DATASTORE''); end;';
	EXECUTE 'begin ctx_ddl.set_attribute(''person_name_multi'', ''columns'', ''ds_given_name, ds_component_name_1, ds_component_name_2, ds_family_name''); end;';
	EXECUTE 'begin ctx_ddl.create_preference(''default_lexer'', ''basic_lexer''); end;';
	 
	CALL Exec_sql_Dinamico('rrother', ' CREATE INDEX person_name_ix ON person_name(ds_given_name) ' || 
								 ' INDEXTYPE IS CTXSYS.CONTEXT ' || 
								 ' PARAMETERS(''lexer default_lexer datastore person_name_multi sync (on commit)'') ');
end if;
 
/*Inconsistência de base */
 
if (dt_versao_atual_cliente_w < to_date('30/08/2016','dd/mm/yyyy')) then 
	CALL Exec_sql_Dinamico('rrother', 'alter table person_name modify ds_type not null');
	CALL Exec_sql_Dinamico('rrother', 'update tabela_atributo set ie_obrigatorio = ''S'' where nm_atributo = ''DS_TYPE'' and nm_tabela = ''PERSON_NAME''');
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tec_ajustar_base_java ( nm_usuario_p text) FROM PUBLIC;
