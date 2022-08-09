-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dropar_tabela_xml () AS $body$
DECLARE


qt_reg_w	smallint;


BEGIN

select count(*)
into STRICT	qt_reg_w
from user_tab_columns
where table_name = 'XML_PROJETO'
  and column_name = 'NM_PROJETO';

if (qt_reg_w > 0) then
	CALL exec_sql_dinamico('xml','drop table xml_atributo');
	CALL exec_sql_dinamico('xml','drop table xml_tabela');
	CALL exec_sql_dinamico('xml','drop table xml_elemento');
	CALL exec_sql_dinamico('xml','drop table xml_projeto cascade constraint');
	CALL exec_sql_dinamico('xml','drop function obter_nome_tabela_xml'
);

	CALL tasy_sincronizar_base();
	CALL valida_objetos_sistema();
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dropar_tabela_xml () FROM PUBLIC;
