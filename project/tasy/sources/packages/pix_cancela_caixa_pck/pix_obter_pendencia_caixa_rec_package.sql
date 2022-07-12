-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pix_cancela_caixa_pck.pix_obter_pendencia_caixa_rec ( nr_seq_caixa_rec_p pix_cobranca.nr_seq_caixa_rec%type) RETURNS boolean AS $body$
DECLARE


	  qtd_reg_pendentes bigint;

	
BEGIN

	  select count(*)
	  into STRICT qtd_reg_pendentes
	  from pix_cobranca a
	  where a.nr_seq_caixa_rec = nr_seq_caixa_rec_p
	  and (a.ds_status = 'ATIVA' or a.ds_status = 'NAO_REGISTRADA' or a.ds_status = 'CONCLUIDA');

	  return(qtd_reg_pendentes > 0);

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pix_cancela_caixa_pck.pix_obter_pendencia_caixa_rec ( nr_seq_caixa_rec_p pix_cobranca.nr_seq_caixa_rec%type) FROM PUBLIC;
