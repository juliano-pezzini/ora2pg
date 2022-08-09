-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_cd_anterior_benef ( nr_seq_segurado_p bigint, cd_codigo_ant_novo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cod_anterior_ant_w	varchar(20);


BEGIN

select	cd_cod_anterior
into STRICT	cd_cod_anterior_ant_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

update	pls_segurado
set	cd_cod_anterior	= cd_codigo_ant_novo_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_segurado_p;

CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '39', clock_timestamp(), 'Código anterior antigo: '|| cd_cod_anterior_ant_w||' para código anterior: '||cd_codigo_ant_novo_p,
				'pls_alterar_cd_anterior_benef', null, null, null,
				null, null, null, null,
				null, null, null, null,
				nm_usuario_p, 'N');


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_cd_anterior_benef ( nr_seq_segurado_p bigint, cd_codigo_ant_novo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
