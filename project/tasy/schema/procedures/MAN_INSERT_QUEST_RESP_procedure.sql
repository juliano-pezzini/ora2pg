-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_insert_quest_resp ( nr_seq_quest_item_p bigint, nr_seq_quest_ws_p bigint, ds_resposta_p text, nr_seq_resposta_p bigint, nr_seq_ordem_serv_p bigint, nm_usuario_p text) AS $body$
BEGIN
        insert  into man_ordem_serv_quest_resp(
                nr_sequencia,
                nr_seq_quest_item,
                nr_seq_quest_ws,
                ds_resposta,
                nr_seq_resposta,
                nr_seq_ordem_serv,
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario,
                nm_usuario_nrec)
        values (
                nextval('man_ordem_serv_quest_resp_seq'),
                nr_seq_quest_item_p,
                nr_seq_quest_ws_p,
                ds_resposta_p,
                nr_seq_resposta_p,
                nr_seq_ordem_serv_p,
                clock_timestamp(),
                clock_timestamp(),
                nm_usuario_p,
                nm_usuario_p);
        commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_insert_quest_resp ( nr_seq_quest_item_p bigint, nr_seq_quest_ws_p bigint, ds_resposta_p text, nr_seq_resposta_p bigint, nr_seq_ordem_serv_p bigint, nm_usuario_p text) FROM PUBLIC;
