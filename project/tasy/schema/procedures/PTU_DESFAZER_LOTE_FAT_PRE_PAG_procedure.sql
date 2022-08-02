-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_desfazer_lote_fat_pre_pag ( nr_seq_fatura_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete	FROM PTU_FATURA_PRE_DIGITAVEL
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_OBSERVACAO
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_INSTRUCAO
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_BOLETO
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_CORPO
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_SACADO
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_COBRANCA
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE_TOTAL
where	nr_seq_fatura	= nr_seq_fatura_p;

delete	FROM PTU_FATURA_PRE
where	nr_sequencia	= nr_seq_fatura_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_desfazer_lote_fat_pre_pag ( nr_seq_fatura_p bigint, nm_usuario_p text) FROM PUBLIC;

