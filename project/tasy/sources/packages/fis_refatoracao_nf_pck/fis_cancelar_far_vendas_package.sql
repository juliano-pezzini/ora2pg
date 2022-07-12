-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*fis_cancelar_far_vendas*/

CREATE OR REPLACE PROCEDURE fis_refatoracao_nf_pck.fis_cancelar_far_vendas () AS $body$
BEGIN

--Ao cancelar a nota fiscal ja libera a venda novamente.
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_refatoracao_nf_pck.fis_cancelar_far_vendas () FROM PUBLIC;
