-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cid_sol_exame_padrao ( ds_doenca_p text, nr_seq_pedido_p bigint ) AS $body$
BEGIN
if (ds_doenca_p IS NOT NULL AND ds_doenca_p::text <> '')then
   update PEDIDO_EXAME_EXTERNO
   set    DS_CID = ds_doenca_p
   where  nr_sequencia = nr_seq_pedido_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cid_sol_exame_padrao ( ds_doenca_p text, nr_seq_pedido_p bigint ) FROM PUBLIC;

