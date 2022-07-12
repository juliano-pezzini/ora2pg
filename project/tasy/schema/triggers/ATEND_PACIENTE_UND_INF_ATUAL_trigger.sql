-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_paciente_und_inf_atual ON atend_paciente_unidade_inf CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_paciente_und_inf_atual() RETURNS trigger AS $BODY$
declare

CD_MEDICO_ATENDIMENTO_W		ATEND_PACIENTE_UNIDADE_INF.CD_PROF_MEDICO%type;
NR_SEQ_ATEND_PAC_UNIDADE_W		ATEND_PACIENTE_UNIDADE_INF.NR_SEQ_ATEND_PAC_UNIDADE%type;

BEGIN
	if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
    		NR_SEQ_ATEND_PAC_UNIDADE_W	:=	coalesce(NEW.NR_SEQ_ATEND_PAC_UNIDADE, OLD.NR_SEQ_ATEND_PAC_UNIDADE);
    		CD_MEDICO_ATENDIMENTO_W		:=	coalesce(NEW.CD_PROF_MEDICO, OLD.CD_PROF_MEDICO);

		if (CD_MEDICO_ATENDIMENTO_W is not null)	then
			update 	ATENDIMENTO_PACIENTE ap
			set	ap.CD_MEDICO_RESP = CD_MEDICO_ATENDIMENTO_W
			where	ap.NR_ATENDIMENTO = (SELECT   	apu.NR_ATENDIMENTO
							from      	ATEND_PACIENTE_UNIDADE apu
							where     	apu.NR_SEQ_INTERNO = NR_SEQ_ATEND_PAC_UNIDADE_W);
		end if;
	end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_paciente_und_inf_atual() FROM PUBLIC;

CREATE TRIGGER atend_paciente_und_inf_atual
	AFTER INSERT OR UPDATE ON atend_paciente_unidade_inf FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_paciente_und_inf_atual();
