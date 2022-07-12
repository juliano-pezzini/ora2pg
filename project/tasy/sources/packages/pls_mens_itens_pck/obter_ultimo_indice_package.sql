-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_itens_pck.obter_ultimo_indice () RETURNS bigint AS $body$
BEGIN
return current_setting('pls_mens_itens_pck.tb_nr_seq_mensalidade_seg_w')::pls_util_cta_pck.t_number_table.count - 1; -- -1 porque o indice comeca em zero
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_itens_pck.obter_ultimo_indice () FROM PUBLIC;