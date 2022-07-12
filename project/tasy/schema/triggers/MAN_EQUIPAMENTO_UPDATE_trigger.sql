-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS man_equipamento_update ON man_equipamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_man_equipamento_update() RETURNS trigger AS $BODY$
declare

ds_mensagem_w			varchar(4000);
qt_regra_fixa_w			bigint := 0;

BEGIN
if (NEW.ie_situacao = 'I') then
	/*'O usuário ' || :new.nm_usuario || ' inativou o equipamento ' || :old.nr_sequencia || ' - ' || :old.ds_equipamento || '.' || chr(13) ||
				'Imobilizado: ' || :old.cd_imobilizado || '.';*/
	ds_mensagem_w := 	wheb_mensagem_pck.get_texto(305911,'NM_USUARIO_W='||NEW.nm_usuario||';NR_SEQUENCIA_W='||OLD.nr_sequencia||';DS_EQUIPAMENTO_W='||OLD.ds_equipamento||';CD_IMOBILIZADO_W='||OLD.cd_imobilizado);

	select	count(*)
	into STRICT	qt_regra_fixa_w
	from	man_regra_data_frequencia
	where	nr_seq_equipamento = OLD.nr_sequencia;

	if (qt_regra_fixa_w > 0) then
		BEGIN
		delete  from man_regra_data_frequencia
		where	nr_seq_equipamento = OLD.nr_sequencia;

		end;
	end if;

end if;

if (NEW.nr_seq_superior <> OLD.nr_seq_superior) then

	insert	into	man_equip_log_equip_sup(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_equipamento,
		nr_seq_superior
	)values (
		nextval('man_equip_log_equip_sup_seq'),
		LOCALTIMESTAMP,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		NEW.nm_usuario,
		OLD.nr_sequencia,
		NEW.nr_seq_superior);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_man_equipamento_update() FROM PUBLIC;

CREATE TRIGGER man_equipamento_update
	BEFORE UPDATE ON man_equipamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_man_equipamento_update();
