-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS rel_tasy_projeto_assinat_atual ON tasy_projeto_assinatura CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_rel_tasy_projeto_assinat_atual() RETURNS trigger AS $BODY$
BEGIN

CALL exec_sql_dinamico('',
	' UPDATE RELATORIO '||
	' SET 	IE_GERAR_RELATORIO = ''S'' ,'||
	'		DT_LAST_MODIFICATION     = SYSDATE,'||
	'		DT_ATUALIZACAO     = SYSDATE,'||
	'		NM_USUARIO         = '|| CHR(39) || coalesce(NEW.NM_USUARIO,OLD.NM_USUARIO) || CHR(39) ||
	' WHERE 	NR_SEQUENCIA 	     = '|| coalesce(NEW.NR_SEQ_RELATORIO,OLD.NR_SEQ_RELATORIO));
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_rel_tasy_projeto_assinat_atual() FROM PUBLIC;

CREATE TRIGGER rel_tasy_projeto_assinat_atual
	BEFORE INSERT OR UPDATE OR DELETE ON tasy_projeto_assinatura FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_rel_tasy_projeto_assinat_atual();

