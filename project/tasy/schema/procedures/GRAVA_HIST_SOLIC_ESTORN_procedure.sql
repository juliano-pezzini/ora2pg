-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_hist_solic_estorn ( nm_usuario_p text, nr_solic_compra_p bigint, ds_historico_p text, ie_commit_p text) AS $body$
BEGIN

insert into solic_compra_hist(	NR_SEQUENCIA,
				NR_SOLIC_COMPRA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_HISTORICO,
				DS_TITULO,
				DS_HISTORICO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				IE_TIPO,
				CD_EVENTO,
				DT_LIBERACAO)
		values ( 	nextval('solic_compra_hist_seq'),
				nr_solic_compra_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				WHEB_MENSAGEM_PCK.get_texto(302535),
				ds_historico_p,
				clock_timestamp(),
				nm_usuario_p,
				'S',
				'T',
				clock_timestamp());


if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_hist_solic_estorn ( nm_usuario_p text, nr_solic_compra_p bigint, ds_historico_p text, ie_commit_p text) FROM PUBLIC;
