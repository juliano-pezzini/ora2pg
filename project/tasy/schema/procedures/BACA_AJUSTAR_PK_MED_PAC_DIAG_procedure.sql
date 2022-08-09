-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_pk_med_pac_diag () AS $body$
BEGIN
CALL exec_sql_dinamico('Rafael','delete from indice_atributo where nm_tabela = ''MED_PAC_DIAGNOSTICO'' and nm_indice = ''MEDPADI_PK''');

CALL exec_sql_dinamico('Rafael','delete from indice where nm_tabela = ''MED_PAC_DIAGNOSTICO'' and nm_indice = ''MEDPADI_PK''');

CALL exec_sql_dinamico('Rafael', 'insert into indice (nm_tabela, nm_indice, ie_tipo, dt_atualizacao, nm_usuario, ds_indice, ie_criar_alterar, ie_situacao, dt_criacao) ' ||
			'values (''MED_PAC_DIAGNOSTICO'', ''MEDPADI_PK'', ''PK'', sysdate, ''Rafael'', ''Chave primária'',''M'',''A'',sysdate)');

CALL exec_sql_dinamico('Rafael', 'insert into indice_atributo (nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario, ds_indice_function) ' ||
			'values (''MED_PAC_DIAGNOSTICO'', ''MEDPADI_PK'', 1, ''NR_SEQUENCIA'', sysdate, ''Rafael'', null)');

CALL exec_sql_dinamico('Rafael','alter table MED_PAC_DIAGNOSTICO drop constraint MEDPADI_PK');

CALL exec_sql_dinamico('Rafael','drop index MEDPADI_PK');

CALL exec_sql_dinamico('Rafael','alter table MED_PAC_DIAGNOSTICO add (constraint MEDPADI_PK primary key (NR_SEQUENCIA) using index tablespace TASY_INDEX)');

CALL exec_sql_dinamico('Rafael', 'create sequence med_pac_diagnostico_seq ' ||
			'increment by 1 ' ||
			'start with 1 ' ||
			'maxvalue 9999999999 ' ||
			'cycle ' ||
			'nocache');

update	med_pac_diagnostico
set	nr_sequencia = nextval('med_pac_diagnostico_seq')
where	coalesce(nr_sequencia::text, '') = '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_pk_med_pac_diag () FROM PUBLIC;
