-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_lista_espera_atual ON agenda_lista_espera CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_lista_espera_atual() RETURNS trigger AS $BODY$
declare
 
ie_utiliza_lista_espera_ag_w	varchar(1);
nr_conta_w				bigint;
BEGIN
  BEGIN 
if (wheb_usuario_pck.get_ie_executar_trigger	= 'S') then 
	BEGIN	 
		if (NEW.cd_pessoa_fisica is not null) then 
			NEW.nm_pessoa_lista := obter_nome_pf(NEW.cd_pessoa_fisica);
		end if;
	exception 
		when others then 
		null;
	end;
 
	BEGIN 
		update	agenda_paciente 
		set	dt_chegada_prev = NEW.dt_prevista_internacao 
		where	nr_seq_lista	= NEW.nr_sequencia;
	exception 
		when others then 
		null;
	end;
	 
	BEGIN 
	 
	select 	max(coalesce(ie_utiliza_lista_espera_ag,'N')) 
	into STRICT	ie_utiliza_lista_espera_ag_w 
	from	parametro_agenda 
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	 
	if (ie_utiliza_lista_espera_ag_w = 'S') then 
	 
		if (obter_funcao_ativa = 821) then 
			NEW.cd_tipo_agenda := 3;
		elsif (obter_funcao_ativa = 820) then 
			NEW.cd_tipo_agenda := 2;
		elsif (obter_funcao_ativa = 866) then 
			NEW.cd_tipo_agenda := 5;
		elsif (obter_funcao_ativa = 871) then 
			NEW.cd_tipo_agenda := 1;			
		end if;
 
	end if;
	 
	if (OLD.ie_status_espera <> NEW.ie_status_espera AND NEW.ie_status_espera = 'C') then 
	 CALL wheb_usuario_pck.set_ie_commit('N');
 
	 if (obter_qt_agend_opm(NEW.nr_seq_opm, NEW.DT_AGENDAMENTO, NEW.nr_sequencia, 'CLE') = 0) then 
	  CALL gravar_status_op_opm(NEW.nr_seq_opm,'CLE',NEW.cd_agenda,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
	 end if;
	 CALL wheb_usuario_pck.set_ie_commit('S');
	end if;
	 
	end;
end if;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_lista_espera_atual() FROM PUBLIC;

CREATE TRIGGER agenda_lista_espera_atual
	BEFORE INSERT OR UPDATE ON agenda_lista_espera FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_lista_espera_atual();

