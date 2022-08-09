-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_cartao_ant_benef ( nr_seq_segurado_p bigint, cd_usuario_ant_p text, nm_usuario_p text) AS $body$
DECLARE


cd_usuario_ant_w	varchar(30);
qt_cart_ant_w		integer;


BEGIN

select	count(*)
into STRICT	qt_cart_ant_w
from	pls_segurado_cart_ant
where	nr_seq_segurado	= nr_seq_segurado_p
and	ie_sistema_anterior = 'S';

if (qt_cart_ant_w = 0) then
	insert into pls_segurado_cart_ant(	NR_SEQUENCIA,
						DT_ATUALIZACAO,
						NM_USUARIO,
						DT_ATUALIZACAO_NREC,
						NM_USUARIO_NREC,
						CD_USUARIO_ANT,
						DT_VALIDADE,
						DT_INICIO_VIGENCIA,
						NR_SEQ_SEGURADO,
						DT_ALTERACAO,
						DS_OBSERVACAO,
						IE_STATUS_CARTEIRA,
						IE_SISTEMA_ANTERIOR)
					values (	nextval('pls_segurado_cart_ant_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						cd_usuario_ant_p,
						null,
						null,
						nr_seq_segurado_p,
						clock_timestamp(),
						'Alteração pelo SIB',
						null,
						'S');
else
	update	pls_segurado_cart_ant
	set	cd_usuario_ant	= cd_usuario_ant_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		ds_observacao	= 'Alteração pelo SIB'
	where	nr_seq_segurado	= nr_seq_segurado_p
	and	ie_sistema_anterior = 'S';

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_cartao_ant_benef ( nr_seq_segurado_p bigint, cd_usuario_ant_p text, nm_usuario_p text) FROM PUBLIC;
