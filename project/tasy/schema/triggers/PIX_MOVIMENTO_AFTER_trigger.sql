-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pix_movimento_after ON pix_movimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pix_movimento_after() RETURNS trigger AS $BODY$
BEGIN

    if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
        update pix_cobranca
        set vl_recebido = vl_recebido + NEW.vl_movimento 
        where nr_sequencia = NEW.nr_seq_cobranca;
    end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pix_movimento_after() FROM PUBLIC;

CREATE TRIGGER pix_movimento_after
	AFTER INSERT ON pix_movimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pix_movimento_after();
