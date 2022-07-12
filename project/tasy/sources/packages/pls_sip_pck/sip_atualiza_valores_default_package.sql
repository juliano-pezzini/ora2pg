-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.sip_atualiza_valores_default (nr_seq_lote_p pls_lote_sip.nr_sequencia%type) AS $body$
BEGIN

update	sip_item_assistencial
set	ie_permite_regra		= 'S',
	nm_usuario			= 'Tasy-GerarSIP',
	dt_atualizacao			= clock_timestamp();
commit;

-- Atualiza os valores do campo IE_PERMITE_REGRA

update	sip_item_assistencial
set	ie_permite_regra	= 'N',
	nm_usuario		= 'Tasy-GerarSIP',
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia in (1,65,64,83);
commit;

CALL pls_sip_pck.atualiza_nv_dados_default(nr_seq_lote_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.sip_atualiza_valores_default (nr_seq_lote_p pls_lote_sip.nr_sequencia%type) FROM PUBLIC;