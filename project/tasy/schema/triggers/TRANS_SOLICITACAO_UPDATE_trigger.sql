-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS trans_solicitacao_update ON trans_solicitacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_trans_solicitacao_update() RETURNS trigger AS $BODY$
DECLARE

nr_sequencia_w			bigint;

BEGIN

IF (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') THEN

  select	nextval('trans_historico_seq')
  into STRICT	nr_sequencia_w
;

  if (NEW.ie_status	<>	OLD.ie_status) then
    BEGIN
    insert into trans_historico(
          nr_sequencia,
          dt_atualizacao,         
          nm_usuario,             
          dt_atualizacao_nrec,    
          nm_usuario_nrec,        
          nr_seq_solicitacao,     
          ie_status,              
          dt_inicio,              
          dt_final)
        values (
          nr_sequencia_w,
          LOCALTIMESTAMP,
          NEW.nm_usuario,
          LOCALTIMESTAMP,
          NEW.nm_usuario,
          NEW.nr_sequencia,
          NEW.ie_status,
          LOCALTIMESTAMP,
          null);

    update	trans_historico 
    set	dt_final 		= LOCALTIMESTAMP,
      nm_usuario 		= NEW.nm_usuario
    where	nr_seq_solicitacao	= NEW.nr_sequencia
    and	dt_final		is null
    and	ie_status 	 <> NEW.ie_status
    and	nr_sequencia		= (	SELECT	max(b.nr_sequencia)
              from	trans_historico b
              where	b.NR_SEQ_SOLICITACAO	= NEW.nr_sequencia
              and	b.nr_sequencia	<> nr_sequencia_w);

    if (NEW.ie_status IN (2, 8)) then
      update	transportador
      set		ie_status_recurso = 1
      where	cd_pessoa_fisica = NEW.cd_transportador;
    end if;

    if (NEW.ie_status = 3) then
      update	transportador
      set		ie_status_recurso = 2
      where	cd_pessoa_fisica = NEW.cd_transportador;
    end if;

    end;				
  end if;

END IF;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_trans_solicitacao_update() FROM PUBLIC;

CREATE TRIGGER trans_solicitacao_update
	BEFORE UPDATE ON trans_solicitacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_trans_solicitacao_update();

