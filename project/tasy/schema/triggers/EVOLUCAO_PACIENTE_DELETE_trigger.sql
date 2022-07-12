-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS evolucao_paciente_delete ON evolucao_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_evolucao_paciente_delete() RETURNS trigger AS $BODY$
declare

PRAGMA AUTONOMOUS_TRANSACTION;

ie_perm_exc_evol_lib_w	varchar(1);
ie_possui_w varchar(1);
qt_reg_w	smallint;
soap_data_w bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

ie_perm_exc_evol_lib_w := Obter_param_Usuario(916, 1077, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_perm_exc_evol_lib_w);

if ( OLD.dt_liberacao is not null) and (ie_perm_exc_evol_lib_w = 'N') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(248453);
end if;

select 	coalesce(max('S'),'N')
into STRICT	ie_possui_w
from 	evolucao_paciente_compl
where 	nr_seq_evo_paciente = OLD.cd_evolucao;

if (ie_possui_w = 'S') then

	delete from evolucao_paciente_compl
	where nr_seq_evo_paciente = OLD.cd_evolucao;
	
	commit;
	
end if;

select   count(*)
into STRICT soap_data_w
from
    clinical_note_soap_data
where
    cd_evolucao = OLD.cd_evolucao;

if ( soap_data_w > 0 ) then
    CALL clinical_notes_pck.update_clinical_note_code(OLD.cd_evolucao, null);
    commit;
end if;

<<Final>>
qt_reg_w	:= 0;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_evolucao_paciente_delete() FROM PUBLIC;

CREATE TRIGGER evolucao_paciente_delete
	BEFORE DELETE ON evolucao_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_evolucao_paciente_delete();

