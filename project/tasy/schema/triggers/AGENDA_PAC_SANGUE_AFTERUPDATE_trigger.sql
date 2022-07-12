-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_sangue_afterupdate ON agenda_pac_sangue CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_sangue_afterupdate() RETURNS trigger AS $BODY$
declare
ds_acao_w	varchar(255);
BEGIN
if (OLD.nr_seq_status is not null) and (NEW.nr_seq_status <> OLD.nr_seq_status) then
	ds_acao_w := Wheb_mensagem_pck.get_texto(307613, 'DS_STATUS_SANGUE_OLD='||obter_desc_status_sangue(OLD.nr_seq_status)||';DS_STATUS_SANGUE_NEW='||obter_desc_status_sangue(NEW.nr_seq_status));  --'Alteração do status do hemocomponente de '||obter_desc_status_sangue(:old.nr_seq_status)||' para '||obter_desc_status_sangue(:new.nr_seq_status);
	CALL gerar_hist_agenda_pac_sangue(NEW.nr_sequencia,1,ds_acao_w,NEW.nm_usuario);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_sangue_afterupdate() FROM PUBLIC;

CREATE TRIGGER agenda_pac_sangue_afterupdate
	AFTER UPDATE ON agenda_pac_sangue FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_sangue_afterupdate();
