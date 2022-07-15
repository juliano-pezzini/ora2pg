-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_nfe_correcao (nr_seq_lote_p bigint, ds_motivo_p text, cd_motivo_p bigint, dt_recebimento_p timestamp) AS $body$
DECLARE


nr_seq_nota_w	bigint;


BEGIN

update nota_fiscal_lote_nfe set dt_envio   = clock_timestamp(),
				DT_RETORNO = dt_recebimento_p,
				DS_MENSAGEM_RETORNO = cd_motivo_p || ' - ' || obter_valor_dominio(3628,cd_motivo_p) || chr(13) || 'Erro: ' ||ds_motivo_p
where	nr_sequencia = nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_nfe_correcao (nr_seq_lote_p bigint, ds_motivo_p text, cd_motivo_p bigint, dt_recebimento_p timestamp) FROM PUBLIC;

