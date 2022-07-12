-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.teste_lista_lotes () AS $body$
DECLARE

current_setting('conciliar_integr_resp_rec_pck2.i')::integer integer := 0;

BEGIN

if (current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.count > 0) then

    FOR current_setting('conciliar_integr_resp_rec_pck2.i')::integer IN current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.first ..  current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.last LOOP
        RAISE NOTICE 'Protocolo: %', current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_seq_protocolo;
        RAISE NOTICE 'Seq: %', current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_sequencia;
        RAISE NOTICE 'status: %', current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).ie_status;
    END LOOP;

end if;

--campos_lote_w.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.teste_lista_lotes () FROM PUBLIC;
