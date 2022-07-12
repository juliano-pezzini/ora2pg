-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proj_cronograma_atual ON proj_cronograma CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proj_cronograma_atual() RETURNS trigger AS $BODY$
DECLARE
qt_reg_w	smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

/*if	(:new.IE_TIPO_CRONOGRAMA = 'E') then
	update	proj_cron_etapa
	set	PR_ETAPA		= nvl(:new.PR_REALIZACAO,0),
		QT_HORA_PREV		= nvl(:new.QT_TOTAL_HORAS,0),
		QT_HORA_REAL		= nvl(:new.QT_HORAS_REALIZADO,0),
		QT_HORA_SALDO		= nvl(:new.QT_HORAS_SALDO,0),
		DT_INICIO_PREV		= :new.DT_INICIO,
		DT_FIM_PREV		= :new.DT_FIM
	where	nr_seq_sub_proj		= nvl(:new.NR_SEQ_PROJ,0);
end if;
*/
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proj_cronograma_atual() FROM PUBLIC;

CREATE TRIGGER proj_cronograma_atual
	BEFORE INSERT OR UPDATE ON proj_cronograma FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proj_cronograma_atual();

