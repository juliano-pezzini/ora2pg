-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_escala_morse_atual ON escala_morse CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_escala_morse_atual() RETURNS trigger AS $BODY$
declare
  EXEC_W          varchar(200);
  qt_pontuacao_w  bigint;
  qt_reg_w        bigint;
BEGIN
  BEGIN
  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
    goto Final;
  end if;

  if (coalesce(OLD.dt_avaliacao, LOCALTIMESTAMP + interval '10 days') <> NEW.dt_avaliacao)
    and (NEW.dt_avaliacao is not null)
    then NEW.ds_utc := obter_data_utc(NEW.dt_avaliacao, 'HV');
  end if;
		
  if (coalesce(OLD.dt_liberacao,LOCALTIMESTAMP + interval '10 days') <> NEW.dt_liberacao)
    and (NEW.dt_liberacao is not null)
    then NEW.ds_utc_atualizacao := obter_data_utc(NEW.dt_liberacao, 'HV');
  end if;

  if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
    BEGIN  
    NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
    end;
  end if;

  BEGIN
      EXEC_W := 'CALL CALCULA_ESCALA_MORSE_MD(:1,:2,:3,:4,:5,:6) INTO :qt_pontuacao_w';

      EXECUTE EXEC_W USING IN coalesce(NEW.IE_HIST_QUEDA,'N'), 
                                     IN coalesce(NEW.IE_DIAG_SECUNDARIO,'N'), 
                                     IN coalesce(NEW.IE_USO_HEPARINA,'N'), 
                                     IN coalesce(NEW.IE_AJUDA_DEAMBULAR,0), 
                                     IN coalesce(NEW.IE_MODO_ANDAR,0), 
                                     IN coalesce(NEW.IE_ESTADO_MENTAL,0),
                                     OUT qt_pontuacao_w;
  exception
    when others then
      qt_pontuacao_w := null;
  end;

  NEW.qt_pontuacao	:= qt_pontuacao_w;

  if (NEW.dt_liberacao is not null) and (OLD.dt_liberacao is null) and (NEW.nr_atendimento is not null) then
    BEGIN
      CALL gravar_agend_rothman(NEW.nr_atendimento,NEW.nr_sequencia,'MOR',NEW.nm_usuario);
    exception
    when others then
      null;
    end;		
  end if;

  <<Final>>
  qt_reg_w	:= 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_escala_morse_atual() FROM PUBLIC;

CREATE TRIGGER atend_escala_morse_atual
	BEFORE INSERT OR UPDATE ON escala_morse FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_escala_morse_atual();
