-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_w_itens_solic_gerar_lic ( nr_seq_licitacao_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete from w_itens_solic_gerar_lic
where	nm_usuario = nm_usuario_p
and	nr_seq_licitacao = nr_seq_licitacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_w_itens_solic_gerar_lic ( nr_seq_licitacao_p bigint, nm_usuario_p text) FROM PUBLIC;

