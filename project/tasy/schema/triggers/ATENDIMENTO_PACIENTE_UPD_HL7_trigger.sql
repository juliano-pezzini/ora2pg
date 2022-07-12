-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_paciente_upd_hl7 ON atendimento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_paciente_upd_hl7() RETURNS trigger AS $BODY$
declare
ds_sep_bv_w		varchar(100);
ds_param_integ_hl7_w	varchar(4000);

BEGIN
ds_sep_bv_w := obter_separador_bv;

/*
if	(:old.dt_alta is null) and
	(:new.dt_alta is null) and
	(:new.ie_tipo_atendimento = 1) and
	(:old.nr_seq_unid_int = :new.nr_seq_unid_int) then
	begin
	ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || :new.cd_pessoa_fisica || ds_sep_bv_w ||
				'nr_atendimento=' || :new.nr_atendimento|| ds_sep_bv_w ||
				'nr_seq_interno=' || :new.nr_seq_unid_int || ds_sep_bv_w;
	gravar_agend_integracao(18, ds_param_integ_hl7_w);
	end;
end if;
*/
if (OLD.ie_tipo_atendimento != 1 ) and (NEW.ie_tipo_atendimento = 1) then
	ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || NEW.cd_pessoa_fisica || ds_sep_bv_w ||
							'nr_atendimento='   || NEW.nr_atendimento   || ds_sep_bv_w;

    if (substr(l10nger_integrar_adt_orm(NEW.cd_pessoa_fisica, NEW.nr_atendimento, null, null),1,1) = 'S') then
        CALL gravar_agend_integracao(693, ds_param_integ_hl7_w);
    end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_paciente_upd_hl7() FROM PUBLIC;

CREATE TRIGGER atendimento_paciente_upd_hl7
	AFTER UPDATE ON atendimento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_paciente_upd_hl7();

