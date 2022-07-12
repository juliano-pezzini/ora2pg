-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_pac_cme_atual ON agenda_pac_cme CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_pac_cme_atual() RETURNS trigger AS $BODY$
declare

ds_equipamento_w	varchar(255) 	:= null;
ds_equipamento_w		varchar(255);
ie_permite_alt_executada_w	varchar(1);
ie_status_agenda_w		varchar(3);
cd_tipo_agenda_w		bigint;
ie_situacao_w			varchar(10);

pragma autonomous_transaction;	
BEGIN
  BEGIN

BEGIN

ie_permite_alt_executada_w := obter_param_usuario(871, 758, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_alt_executada_w);

select  max(a.ie_status_agenda),
	max(b.cd_tipo_agenda)
into STRICT	ie_status_agenda_w,
	cd_tipo_agenda_w
from    agenda_paciente a,
	agenda b
where   a.cd_agenda = b.cd_agenda
and	nr_sequencia = NEW.nr_seq_agenda;

exception
	when others then
      	null;
end;

if	((ie_permite_alt_executada_w = 'N') and (cd_tipo_agenda_w = 1) and (ie_status_agenda_w = 'E')) then
	CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(236679);
	
end if;

/*
if	(:new.nr_seq_conjunto is not null) and
	(nvl(:new.nr_seq_conjunto,0) <> nvl(:old.nr_seq_conjunto,0)) then
	select	nvl(max(ie_situacao),'A')
	into	ie_situacao_w
	from	cm_conjunto
	where	nr_sequencia	= :new.nr_seq_conjunto;
	
	if	(ie_situacao_w = 'I') then
		wheb_mensagem_pck.Exibir_Mensagem_Abort(269022);
	end if;

end if;
*/
	

if (NEW.nr_seq_conjunto is not null and NEW.nr_seq_classif is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1051032);
end if;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_pac_cme_atual() FROM PUBLIC;

CREATE TRIGGER agenda_pac_cme_atual
	BEFORE INSERT OR UPDATE ON agenda_pac_cme FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_pac_cme_atual();
