-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pfcs_check_dpt_situation ON pfcs_service_request CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pfcs_check_dpt_situation() RETURNS trigger AS $BODY$
DECLARE
nm_usuario_w    setor_atendimento.nm_usuario%type := 'PFCS';

/*
    This trigger will check if a department is inactive when there is a request for it.
    The IBE integration does not send the situation of a department, just for the bed. The client can disable a department
    throught the EMR or PFCS interface. It's also possible to enable again on PFCS, but if, for some reason, it's not and
    a request for a bed in that department comes, it is implicit that the department is active again.
*/
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

    if (NEW.nr_seq_location is not null) then
        update setor_atendimento set
            IE_SITUACAO = 'A',
            NM_USUARIO = nm_usuario_w,
			IE_OCUP_HOSPITALAR = 'S',
            DT_ATUALIZACAO = LOCALTIMESTAMP
        where NM_USUARIO_NREC = nm_usuario_w
        and cd_setor_atendimento = (
            SELECT max(cd_setor_atendimento)
            from unidade_atendimento
            where nr_seq_location = NEW.nr_seq_location
        )
        and ie_situacao = 'I';
    end if;
	
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pfcs_check_dpt_situation() FROM PUBLIC;

CREATE TRIGGER pfcs_check_dpt_situation
	BEFORE INSERT OR UPDATE ON pfcs_service_request FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pfcs_check_dpt_situation();
