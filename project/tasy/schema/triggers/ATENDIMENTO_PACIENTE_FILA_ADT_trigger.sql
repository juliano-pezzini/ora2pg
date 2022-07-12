-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_paciente_fila_adt ON atendimento_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_paciente_fila_adt() RETURNS trigger AS $BODY$
declare
nr_atendimento_w bigint := NEW.nr_atendimento;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S' ) then
	if TG_OP = 'INSERT' then
        CALL gerar_fila_impressao_adt(nr_atendimento_w, 1);
    end if;

    if TG_OP = 'UPDATE' then
        if NEW.dt_alta is not null and OLD.dt_alta is null then
            CALL gerar_fila_impressao_adt(nr_atendimento_w, 3);
        end if;
    end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_paciente_fila_adt() FROM PUBLIC;

CREATE TRIGGER atendimento_paciente_fila_adt
	AFTER INSERT OR UPDATE ON atendimento_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_paciente_fila_adt();

