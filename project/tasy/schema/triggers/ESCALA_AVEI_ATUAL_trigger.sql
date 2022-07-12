-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_avei_atual ON escala_avei CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_avei_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w	smallint;

BEGIN

if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
	BEGIN
	NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
	end;
end if;
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (NEW.dt_liberacao is null)  then
	BEGIN

	NEW.qt_pontuacao := 	coalesce(NEW.ie_conciencia,0)+
				coalesce(NEW.ie_temporal,0) 	+
				coalesce(NEW.ie_comandos,0) 	+
				coalesce(NEW.ie_movimentos,0)	+
				coalesce(NEW.ie_visual,0) 		+
				coalesce(NEW.ie_facial,0) 		+
				coalesce(NEW.ie_sensibilidade,0)+
				coalesce(NEW.ie_ataxia,0)		+
				coalesce(NEW.ie_linguagem,0)	+
				coalesce(NEW.ie_desatencao,0);

        if not(coalesce(NEW.ie_disartria,0) = 9) then
            NEW.qt_pontuacao := coalesce(NEW.ie_disartria,0) + NEW.qt_pontuacao;
        end if;

        if not(coalesce(NEW.ie_motrocidade_pe,0) = 9) then
            NEW.qt_pontuacao := coalesce(NEW.ie_motrocidade_pe,0) + NEW.qt_pontuacao;
        end if;

        if not(coalesce(NEW.ie_motrocidade_pd,0) = 9) then
            NEW.qt_pontuacao := coalesce(NEW.ie_motrocidade_pd,0) + NEW.qt_pontuacao;
        end if;

        if not(coalesce(NEW.ie_motrocidade_be,0) = 9) then
            NEW.qt_pontuacao := coalesce(NEW.ie_motrocidade_be,0) + NEW.qt_pontuacao;
        end if;

        if not(coalesce(NEW.ie_motrocidade_bd,0) = 9) then
            NEW.qt_pontuacao := coalesce(NEW.ie_motrocidade_bd,0) + NEW.qt_pontuacao;
        end if;

	end;
end if;

<<Final>>
qt_reg_w	:= 0;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_avei_atual() FROM PUBLIC;

CREATE TRIGGER escala_avei_atual
	BEFORE INSERT OR UPDATE ON escala_avei FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_avei_atual();
