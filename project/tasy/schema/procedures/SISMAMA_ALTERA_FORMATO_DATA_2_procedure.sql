-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sismama_altera_formato_data_2 () AS $body$
DECLARE


qt_registro_w		bigint;


BEGIN
/*campos a serem alterados de tamanho/tipo da tabela SISMAMA_ANAMNESE_RAD:
dt_radioterapia_dir
dt_radioterapia_esq
*/
/*1º passo, cria uma tabela temporária para não perder as informações*/

select	count(*)
into STRICT	qt_registro_w
from	user_tables
where	table_name = 'SISMAMA_ANAMNESE_RAD_BKP';

if (qt_registro_w = 0) then
	CALL exec_sql_dinamico('Anderson', 'create table SISMAMA_ANAMNESE_RAD_BKP as select * from SISMAMA_ANAMNESE_RAD');
else
	begin
	CALL exec_sql_dinamico('Anderson', 'drop table SISMAMA_ANAMNESE_RAD_BKP');
	CALL exec_sql_dinamico('Anderson', 'create table SISMAMA_ANAMNESE_RAD_BKP as select * from SISMAMA_ANAMNESE_RAD');
	end;
end if;


/*2º passo, cria todos os campos temporários para armazenar as informações*/

CALL exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD add dt_radioterapia_dir2 varchar2(4)');
CALL exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD add dt_radioterapia_esq2 varchar2(4)');


/*3º passo, faz update de todos os campos passando as informações no formato yyyy para os novos campos*/

CALL exec_sql_dinamico('Anderson', 	'update SISMAMA_ANAMNESE_RAD ' ||
				'set 	dt_radioterapia_dir2 = to_char(dt_radioterapia_dir,' || chr(39) || 'yyyy' || chr(39) || '),' ||
				'	dt_radioterapia_esq2 = to_char(dt_radioterapia_esq,' || chr(39) || 'yyyy' || chr(39) || ')');


/*4º passo, seta todos os campos que serão substituidos para nulo para fazer o modify*/

CALL exec_sql_dinamico('Anderson', 'update SISMAMA_ANAMNESE_RAD set 	 dt_radioterapia_dir = null,' ||
								'dt_radioterapia_esq = null');

/*5º passo,  fazer o modify dos campos*/

CALL exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD modify dt_radioterapia_dir varchar2(04)');
CALL exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD modify dt_radioterapia_esq varchar2(04)');


/*6º passo, seta os valores para os campos corretos*/

CALL exec_sql_dinamico('Anderson', 'update SISMAMA_ANAMNESE_RAD set 	 dt_radioterapia_dir = dt_radioterapia_dir2,' ||
								'dt_radioterapia_esq = dt_radioterapia_esq2');


/*7º passo, dropa os campos temporarios*/

--exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD drop column dt_radioterapia_dir2');
--exec_sql_dinamico('Anderson', 'alter table SISMAMA_ANAMNESE_RAD drop column dt_radioterapia_esq2');
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sismama_altera_formato_data_2 () FROM PUBLIC;

