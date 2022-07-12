-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_espera_update ON paciente_espera CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_espera_update() RETURNS trigger AS $BODY$
declare
ie_atualiza_gestao_w		varchar(2);

BEGIN

--obter_param_usuario(895, 27, obter_perfil_ativo, :new.nm_usuario, obter_estabelecimento_ativo, ie_atualiza_gestao_w);
IF (NEW.cd_setor_atendimento is null) then


	NEW.cd_unidade_basica	:= null;
	NEW.cd_unidade_compl	:= null;

end if;
/*  FOI TRATADO DENTRO DO CÓDIGO FONTE DO DELPHI!!!!!!!!!!!
begin
if	(:new.nr_seq_agenda is not null) then
	begin
	update	agenda_paciente
	set	dt_chegada_prev	= :new.dt_prevista_internacao
	where	nr_sequencia	= :new.nr_seq_agenda;

	if (ie_atualiza_gestao_w = 'S') then
		begin
		update	gestao_vaga
		set	dt_prevista	= :new.dt_prevista_internacao
		where	nr_seq_agenda	= :new.nr_seq_agenda;
		end;
	end if;
	end;
end if;
exception
	when others then
	null;
end;*/
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_espera_update() FROM PUBLIC;

CREATE TRIGGER paciente_espera_update
	BEFORE UPDATE ON paciente_espera FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_espera_update();
