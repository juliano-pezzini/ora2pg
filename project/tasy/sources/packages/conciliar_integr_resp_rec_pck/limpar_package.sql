-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck.limpar () AS $body$
BEGIN

current_setting('conciliar_integr_resp_rec_pck.campos_lote_w')::campos_lote_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_guia_w')::campos_guia_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_conta_w')::campos_conta_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_conta_aux_w')::campos_conta_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_conta_aux2_w')::campos_conta_v.delete;
current_setting('conciliar_integr_resp_rec_pck.tiss_conta_guia_w')::tiss_conta_guia_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_itens_w')::campos_itens_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_material_conta_w')::campos_material_conta_v.delete;
current_setting('conciliar_integr_resp_rec_pck.campos_proced_conta_w')::campos_proced_conta_v.delete;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck.limpar () FROM PUBLIC;