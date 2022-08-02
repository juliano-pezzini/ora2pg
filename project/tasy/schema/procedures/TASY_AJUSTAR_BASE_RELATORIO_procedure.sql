-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_base_relatorio () AS $body$
DECLARE


nm_tablespace_w		varchar(50);


BEGIN

select	' TABLESPACE '||obter_tablespace_tab_temp || ' '
into STRICT	nm_tablespace_w
;

CALL gravar_processo_longo('DROP W_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_RELATORIO', 		'drop table w_relatorio');
CALL gravar_processo_longo('DROP W_BANDA_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_BANDA_RELATORIO',	'drop table w_banda_relatorio');
CALL gravar_processo_longo('DROP W_RELATORIO_PARAMETRO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_RELATORIO_PARAMETRO',	'drop table w_relatorio_parametro');
CALL gravar_processo_longo('DROP W_RELATORIO_FUNCAO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_RELATORIO_FUNCAO',	'drop table w_relatorio_funcao');
CALL gravar_processo_longo('DROP W_ETIQUETA','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_ETIQUETA',		'drop table w_etiqueta');
CALL gravar_processo_longo('DROP W_BANDA_RELAT_CAMPO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_BANDA_RELAT_CAMPO',	'drop table w_banda_relat_campo');
CALL gravar_processo_longo('DROP W_FUNCAO_REGRA_RELAT','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_FUNCAO_REGRA_RELAT',	'drop table w_funcao_regra_relat');
CALL gravar_processo_longo('DROP W_RELATORIO_DOCUMENTACAO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_RELATORIO_DOCUMENTACAO',	'drop table w_relatorio_documentacao');
CALL gravar_processo_longo('DROP W_USUARIO_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_USUARIO_RELATORIO',	'drop table w_usuario_relatorio');
CALL gravar_processo_longo('DROP W_BANDA_RELAT_VARIAVEL','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('DROP W_BANDA_RELAT_VARIAVEL',	'drop table w_banda_relat_variavel');

CALL gravar_processo_longo('CRIAR W_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_RELATORIO', 		'create table w_relatorio '|| nm_tablespace_w || ' as (select * from tasy_versao.w_relatorio)');
CALL gravar_processo_longo('CRIAR W_BANDA_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_BANDA_RELATORIO',	'create table w_banda_relatorio '|| nm_tablespace_w || ' as (select * from tasy_versao.w_banda_relatorio)');
CALL gravar_processo_longo('CRIAR W_RELATORIO_PARAMETRO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_RELATORIO_PARAMETRO','create table w_relatorio_parametro '|| nm_tablespace_w || ' as (select * from tasy_versao.w_relatorio_parametro)');
CALL gravar_processo_longo('CRIAR W_RELATORIO_FUNCAO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_RELATORIO_FUNCAO',	'create table w_relatorio_funcao '|| nm_tablespace_w || ' as (select * from tasy_versao.w_relatorio_funcao)');
CALL gravar_processo_longo('CRIAR W_ETIQUETA','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_ETIQUETA',		'create table w_etiqueta '|| nm_tablespace_w || ' as (select * from tasy_versao.w_etiqueta)');
CALL gravar_processo_longo('CRIAR W_BANDA_RELAT_CAMPO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_BANDA_RELAT_CAMPO',	'create table w_banda_relat_campo '|| nm_tablespace_w || ' as (select * from tasy_versao.w_banda_relat_campo)');
CALL gravar_processo_longo('CRIAR W_BANDA_RELAT_CAMPO_LONGO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_BANDA_RELAT_CAMPO',	'create table w_banda_relat_campo_longo tablespace users as (select * from tasy_versao.w_banda_relat_campo_longo)');
CALL gravar_processo_longo('CRIAR W_FUNCAO_REGRA_RELAT','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_FUNCAO_REGRA_RELAT',	'create table w_funcao_regra_relat '|| nm_tablespace_w || 'as (select * from tasy_versao.w_funcao_regra_relat)');
CALL gravar_processo_longo('CRIAR W_RELATORIO_DOCUMENTACAO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_RELATORIO_DOCUMENTACAO',	'create table w_relatorio_documentacao '|| nm_tablespace_w || 'as (select * from relatorio_documentacao where 1=2)');
CALL gravar_processo_longo('CRIAR W_USUARIO_RELATORIO','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_USUARIO_RELATORIO',	'create table w_usuario_relatorio '|| nm_tablespace_w || 'as (select * from usuario_relatorio where 1=2)');
CALL gravar_processo_longo('CRIAR W_BANDA_RELAT_VARIAVEL','TASY_AJUSTAR_BASE_RELATORIO',null);
CALL Exec_Sql_Dinamico('CRIAR W_BANDA_RELAT_VARIAVEL',	'create table w_banda_relat_variavel '|| nm_tablespace_w || 'as (select * from banda_relat_variavel where 1=2)');


CALL Exec_Sql_Dinamico('CRIAR W_BANRELA_BANRELA_FK_I','CREATE INDEX W_BANRELA_BANRELA_FK_I ON W_BANDA_RELATORIO(NR_SEQ_RELATORIO,NR_SEQ_BANDA_SUPERIOR)');
CALL Exec_Sql_Dinamico('CRIAR W_BANRELA_RELATOR_FK_I','CREATE INDEX W_BANRELA_RELATOR_FK_I ON W_BANDA_RELATORIO(NR_SEQ_RELATORIO,NR_SEQUENCIA)');

CALL Exec_Sql_Dinamico('CRIAR W_BANRECA_BANRELA_FK_I','CREATE INDEX W_BANRECA_BANRELA_FK_I ON W_BANDA_RELAT_CAMPO(NR_SEQ_BANDA)');
CALL Exec_Sql_Dinamico('CRIAR W_BANRECA_BANRELA_FK_II','CREATE INDEX W_BANRECA_BANRELA_FK_II ON W_BANDA_RELAT_CAMPO(NR_SEQ_BANDA,NR_SEQUENCIA)');

CALL Exec_Sql_Dinamico('CRIAR W_ETIQUET_RELATOR_FK_I','CREATE INDEX W_ETIQUET_RELATOR_FK_I ON w_ETIQUETA(NR_SEQ_RELATORIO)');
CALL Exec_Sql_Dinamico('CRIAR W_ETIQUET_IMPRESS_FK_I','CREATE INDEX W_ETIQUET_IMPRESS_FK_I ON w_ETIQUETA(NR_SEQ_IMPRESSORA)');

CALL Exec_Sql_Dinamico('CRIAR W_FUNRERE_RELATOR_FK_I','CREATE INDEX W_FUNRERE_RELATOR_FK_I ON W_FUNCAO_REGRA_RELAT(NR_SEQ_RELATORIO)');
CALL Exec_Sql_Dinamico('CRIAR W_FUNRERE_REGRARE_FK_I','CREATE INDEX W_FUNRERE_REGRARE_FK_I ON W_FUNCAO_REGRA_RELAT(NR_SEQ_REGRA)');

CALL Exec_Sql_Dinamico('CRIAR W_RELPARA_RELATOR_FK_I','CREATE INDEX W_RELPARA_RELATOR_FK_I ON W_RELATORIO_PARAMETRO(NR_SEQ_RELATORIO)');
CALL Exec_Sql_Dinamico('CRIAR W_RELPARA_RELASEQ_FK_I','CREATE INDEX W_RELPARA_RELASEQ_FK_I ON W_RELATORIO_PARAMETRO(NR_SEQ_RELATORIO,NR_SEQUENCIA)');

CALL Exec_Sql_Dinamico('CRIAR W_BANREVA_BANRELA_FK_I','CREATE INDEX W_BANREVA_BANRELA_FK_I ON W_BANDA_RELAT_VARIAVEL(NR_SEQ_BANDA,NR_SEQUENCIA)');

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_base_relatorio () FROM PUBLIC;

