-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE usuario_resp_pck.limpa_listas () AS $body$
BEGIN
current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v.delete;
current_setting('usuario_resp_pck.regra_prev_usu_w')::regra_prev_usu_v.delete;
current_setting('usuario_resp_pck.regra_prev_item_w')::regra_prev_item_v.delete;
current_setting('usuario_resp_pck.regra_prev_usu_ww')::regra_prev_usu_v.delete;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE usuario_resp_pck.limpa_listas () FROM PUBLIC;
