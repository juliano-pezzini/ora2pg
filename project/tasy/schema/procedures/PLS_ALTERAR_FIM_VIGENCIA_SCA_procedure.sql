-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_fim_vigencia_sca ( nr_seq_vinculo_sca_p bigint, dt_alteracao_p timestamp, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w	bigint;
dt_fim_vigencia_w	timestamp;


BEGIN

select	nr_seq_segurado,
	dt_fim_vigencia
into STRICT	nr_seq_segurado_w,
	dt_fim_vigencia_w
from	pls_sca_vinculo
where	nr_sequencia	= nr_seq_vinculo_sca_p;

update	pls_sca_vinculo
set	dt_fim_vigencia		= dt_alteracao_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_vinculo_sca_p;

CALL pls_gerar_segurado_historico(
		nr_seq_segurado_w, '73', clock_timestamp(),
		'De: ' || dt_fim_vigencia_w || '. Para: ' || dt_alteracao_p, 'pls_alterar_fim_vigencia_sca', null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, nm_usuario_p, 'N');

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_fim_vigencia_sca ( nr_seq_vinculo_sca_p bigint, dt_alteracao_p timestamp, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
