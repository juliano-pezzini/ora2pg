-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_ciwaa_atual ON escala_ciwaa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_ciwaa_atual() RETURNS trigger AS $BODY$
declare
	EXEC_w          varchar(200);
	qt_resultado_w	bigint := 0;
BEGIN
  BEGIN
    if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
        BEGIN
            EXEC_w := 'CALL OBTER_SCORE_ESCALA_CIWAA_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) INTO :qt_resultado_w';

            EXECUTE EXEC_w USING  IN coalesce(NEW.IE_MAL_ESTAR,0), 
                                            IN coalesce(NEW.IE_TREMOR_BRACO,0), 
                                            IN coalesce(NEW.IE_SUDORESE,0), 
                                            IN coalesce(NEW.IE_PERTURBACAO_COCEIRA,0), 
                                            IN coalesce(NEW.IE_PERTURBACAO_AUDITIVA,0), 
                                            IN coalesce(NEW.IE_PERTURBACAO_VISUAL,0), 
                                            IN coalesce(NEW.IE_NERVOSISMO,0), 
                                            IN coalesce(NEW.IE_DOR_CABECA,0), 
                                            IN coalesce(NEW.IE_AGITACAO,0), 
                                            IN coalesce(NEW.IE_ALT_ORIENTACAO,0), 
                                            OUT qt_resultado_w;
        exception
            when others then
                qt_resultado_w := null;
        end;

        NEW.QT_SCORE  := qt_resultado_w;
    end if;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_ciwaa_atual() FROM PUBLIC;

CREATE TRIGGER escala_ciwaa_atual
	BEFORE INSERT OR UPDATE ON escala_ciwaa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_ciwaa_atual();

