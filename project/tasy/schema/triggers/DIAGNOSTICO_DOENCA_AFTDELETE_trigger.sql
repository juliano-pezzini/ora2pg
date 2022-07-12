-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS diagnostico_doenca_aftdelete ON diagnostico_doenca CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_diagnostico_doenca_aftdelete() RETURNS trigger AS $BODY$
declare
	nr_seq_case_w		    episodio_paciente.nr_sequencia%type;
BEGIN

/*if (billing_i18n_pck.obter_se_calcula_drg = 'S') then	
	select nr_seq_episodio
	into   nr_seq_case_w
	from   atendimento_paciente
	where  nr_atendimento = :old.nr_atendimento;
	
	if(nr_seq_case_w is not null) then
	
		INATIVAR_EPISODIO_PACIENTE_DRG(nr_seq_case_w, null, null, :old.nm_usuario);
		/*update episodio_paciente_drg 
		set    ie_situacao = 'I'
		where  nr_seq_episodio_paciente = nr_seq_case_w;*/

--	end if;

--end if;


delete
from 	medic_diagnostico_doenca
where 	nr_atendimento = OLD.nr_atendimento
and	cd_doenca = OLD.cd_doenca
and	dt_diagnostico = OLD.dt_diagnostico;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_diagnostico_doenca_aftdelete() FROM PUBLIC;

CREATE TRIGGER diagnostico_doenca_aftdelete
	AFTER DELETE ON diagnostico_doenca FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_diagnostico_doenca_aftdelete();
