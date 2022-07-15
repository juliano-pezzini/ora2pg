-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_alter_vl_unit_mat_autor () AS $body$
BEGIN

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

CALL exec_sql_dinamico('TASY', 'create table material_autor_cirurgia_bkp as select * from material_autor_cirurgia');
CALL exec_sql_dinamico('TASY', 'create table material_autorizado_bkp as select * from material_autorizado');

--Criar tab backup
CALL exec_sql_dinamico('TASY', 'alter table material_autor_cirurgia add vl_unitario_material2 number(15,2)');
CALL exec_sql_dinamico('TASY', 'alter table material_autorizado add vl_unitario2 number(15,2)');

--Criar  campos temporarios
CALL exec_sql_dinamico('TASY', 'update material_autor_cirurgia set vl_unitario_material2 = vl_unitario_material');
CALL exec_sql_dinamico('TASY', 'update material_autorizado set vl_unitario2 = vl_unitario');

--atualizar os valores dos campos temporários
CALL exec_sql_dinamico('TASY', 'alter table material_autor_cirurgia modify vl_unitario_material null');

--Permitir valores nulos nos campos antigos
CALL exec_sql_dinamico('TASY', 'update	material_autor_cirurgia set vl_unitario_material = null');
CALL exec_sql_dinamico('TASY', 'update	material_autorizado set vl_unitario = null');

--setar valores nulos
CALL exec_sql_dinamico('TASY', 'alter table material_autor_cirurgia modify vl_unitario_material number(17,4)');
CALL exec_sql_dinamico('TASY', 'alter table material_autorizado modify vl_unitario number(17,4)');

-- modificar precisão dos campos
CALL exec_sql_dinamico('TASY', 'update material_autor_cirurgia set vl_unitario_material = vl_unitario_material2');
CALL exec_sql_dinamico('TASY', 'update material_autorizado set vl_unitario = vl_unitario2');

--pegar valor dos campos temporários
CALL exec_sql_dinamico('TASY', 'alter table material_autor_cirurgia drop column vl_unitario_material2');
CALL exec_sql_dinamico('TASY', 'alter table material_autorizado drop column vl_unitario2');

--Dropar campos temporarios
CALL exec_sql_dinamico('TASY', 'alter table material_autor_cirurgia modify vl_unitario_material not null');

--setar para não permitir nulos
commit;

CALL wheb_usuario_pck.set_ie_executar_trigger('S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_alter_vl_unit_mat_autor () FROM PUBLIC;

