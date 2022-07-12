-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tre_agenda_insert ON tre_agenda CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tre_agenda_insert() RETURNS trigger AS $BODY$
declare
ie_modulos_automatico_w		varchar(255);

BEGIN
ie_modulos_automatico_w := obter_valor_param_usuario(7004,26,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

if (ie_modulos_automatico_w = 'S') then
	CALL tre_inserir_mod_agenda(NEW.nr_sequencia,NEW.nr_seq_curso,NEW.nm_usuario, NEW.dt_inicio, NEW.dt_termino);

end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tre_agenda_insert() FROM PUBLIC;

CREATE TRIGGER tre_agenda_insert
	AFTER INSERT ON tre_agenda FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tre_agenda_insert();

