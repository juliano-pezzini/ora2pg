-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inativar_contrato_plano ( nr_sequencia_p bigint, dt_inativacao_p timestamp, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_plano_w		pls_contrato_plano.nr_seq_plano%type;


BEGIN

update	pls_contrato_plano
set	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	dt_inativacao	= dt_inativacao_p,
	ie_situacao	= 'I'
where	nr_sequencia	= nr_sequencia_p;

select 	nr_seq_plano
into STRICT	nr_seq_plano_w
from 	pls_contrato_plano
where	nr_sequencia	= nr_sequencia_p;

insert into pls_contrato_historico(
					nr_sequencia,
					cd_estabelecimento,
					nr_seq_contrato,
					dt_historico,
					ie_tipo_historico,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_historico)
				values (	nextval('pls_contrato_historico_seq'),
					cd_estabelecimento_p,
					nr_seq_contrato_p,
					clock_timestamp(),
					'4',
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'Inativação do produto ' || nr_seq_plano_w || ' - ' || dt_inativacao_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inativar_contrato_plano ( nr_sequencia_p bigint, dt_inativacao_p timestamp, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

