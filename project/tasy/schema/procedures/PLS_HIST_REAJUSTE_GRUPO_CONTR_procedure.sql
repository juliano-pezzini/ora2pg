-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_hist_reajuste_grupo_contr ( nr_seq_grupo_contrato_p bigint, dt_data_alteracao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_data_anterior_w	timestamp;


BEGIN
select  coalesce(trunc(dt_reajuste,'dd'), to_date('01/01/0001'))
into STRICT 	dt_data_anterior_w
from    pls_grupo_contrato
where   nr_sequencia   = nr_seq_grupo_contrato_p;

if (dt_data_anterior_w <> dt_data_alteracao_p) then
	begin
	insert into pls_grupo_contrato_hist(nr_sequencia, nr_seq_grupo_contrato, cd_estabelecimento,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, ds_historico, dt_historico,
		ds_titulo, nm_usuario_historico)
	values (	nextval('pls_grupo_contrato_hist_seq'), nr_seq_grupo_contrato_p, cd_estabelecimento_p,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, 'Data de reajuste alterada.' || chr(13) || 'De: ' || CASE WHEN dt_data_anterior_w=to_date('01/01/0001') THEN  '__/__/____'  ELSE dt_data_anterior_w END
		|| chr(13) || 'Para: ' || CASE WHEN dt_data_alteracao_p='  /  /    ' THEN  '__/__/____'  ELSE dt_data_alteracao_p END , clock_timestamp(),
		'Alteração da data do reajuste', nm_usuario_p);
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_hist_reajuste_grupo_contr ( nr_seq_grupo_contrato_p bigint, dt_data_alteracao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

