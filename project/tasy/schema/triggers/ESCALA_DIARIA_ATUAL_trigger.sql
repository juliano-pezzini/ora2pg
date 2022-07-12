-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_diaria_atual ON escala_diaria CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_diaria_atual() RETURNS trigger AS $BODY$
DECLARE

ie_situacao_w varchar(1) := 'S';
ds_bloq_alt_escala_inativa_w varchar(255);
nr_seq_escala_diaria_w	escala_diaria_adic.nr_seq_escala_diaria%type;

BEGIN
	IF (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') != 'N') THEN
		ie_situacao_w := 'S';

		IF (TG_OP = 'DELETE') THEN
			dbms_application_info.SET_ACTION('DELETE_CASCADE');
			nr_seq_escala_diaria_w := OLD.nr_seq_escala;
		else
			nr_seq_escala_diaria_w := NEW.nr_seq_escala;
		END IF;
	
		ds_bloq_alt_escala_inativa_w := obter_valor_param_usuario(3009, 40, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

		ie_situacao_w := fis_obter_escala_ativa(nr_seq_escala_diaria_w, 'ESCALA');

		IF (ie_situacao_w = 'N' AND coalesce(ds_bloq_alt_escala_inativa_w, 'N') = 'S') THEN
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1186376, 'SEQ=' || nr_seq_escala_diaria_w );
		END IF;
	END IF;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_diaria_atual() FROM PUBLIC;

CREATE TRIGGER escala_diaria_atual
	BEFORE INSERT OR UPDATE OR DELETE ON escala_diaria FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_diaria_atual();
