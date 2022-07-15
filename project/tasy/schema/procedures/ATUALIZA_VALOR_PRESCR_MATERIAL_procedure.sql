-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_valor_prescr_material (nr_prescricao_p text, valor_p text, campo_p text, nm_usuario_p text) AS $body$
BEGIN

if ('QT_' = substr(campo_p,1,3) or
	'VL_' = substr(campo_p,1,3) or
	'NR_' = substr(campo_p,1,3)) then
	CALL Exec_Sql_Dinamico(nm_usuario_p,'update prescr_material set ' || campo_p || ' = ' || valor_p || ' where nr_prescricao = '||nr_prescricao_p);
else
	CALL Exec_Sql_Dinamico(nm_usuario_p,'update prescr_material set ' || campo_p || ' = ' || chr(39) || valor_p || chr(39) || ' where nr_prescricao = '||nr_prescricao_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_valor_prescr_material (nr_prescricao_p text, valor_p text, campo_p text, nm_usuario_p text) FROM PUBLIC;

