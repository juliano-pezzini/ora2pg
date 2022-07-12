-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_customer_req_insert ON reg_customer_requirement CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_customer_req_insert() RETURNS trigger AS $BODY$
DECLARE
	dt_liberacao_w	reg_features_customer.dt_aprovacao%TYPE;
BEGIN

    IF (wheb_usuario_pck.get_ie_executar_trigger = 'S') THEN

        IF (NEW.nr_seq_features IS NOT NULL) THEN
        
            SELECT	max(dt_aprovacao)
            INTO STRICT	dt_liberacao_w
            FROM	reg_features_customer
            WHERE	nr_sequencia = NEW.nr_seq_features;

            IF (dt_liberacao_w IS NULL) THEN
                CALL wheb_mensagem_pck.exibir_mensagem_abort(901104);--Nao e possivel adicionar um requisito de cliente em uma feature ainda nao liberada
            END IF;

        END IF;

    END IF;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_customer_req_insert() FROM PUBLIC;

CREATE TRIGGER reg_customer_req_insert
	BEFORE INSERT ON reg_customer_requirement FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_customer_req_insert();
