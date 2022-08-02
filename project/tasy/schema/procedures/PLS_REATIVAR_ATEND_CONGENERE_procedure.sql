-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_reativar_atend_congenere ( nr_seq_suspensao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_congenere_w	bigint;
nr_seq_segurado_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	NR_SEQ_SUSPENSAO	= nr_seq_suspensao_p;



BEGIN

select	nr_seq_congenere
into STRICT	nr_seq_congenere_w
from	PLS_SEGURADO_SUSPENSAO
where	nr_sequencia	= nr_seq_suspensao_p;

update	pls_segurado_suspensao
set	dt_fim_suspensao 	= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_suspensao_p;

update	PLS_CONGENERE
set	ie_situacao_atend	= 'A',
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	NR_SEQ_SUSPENSAO	 = NULL
where	nr_sequencia		= nr_seq_congenere_w;

insert into PLS_COOPERATIVA_HISTORICO(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		NR_SEQ_COOPERATIVA,dt_historico,ie_tipo_historico,ds_historico)
values (	nextval('pls_cooperativa_historico_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_congenere_w,clock_timestamp(),'3','Reativação de atendimento');

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	pls_segurado
	set	ie_situacao_atend	= 'A',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		NR_SEQ_SUSPENSAO	 = NULL
	where	nr_sequencia		= nr_seq_segurado_w;

	CALL pls_gerar_segurado_historico(	nr_seq_segurado_w, '59', clock_timestamp(), 'Reativação de atendimento através da cooperativa',
					'pls_reativar_atend_congenere', null, null, null,
					null, null, null, null,
					null, null, null, null,
					nm_usuario_p, 'N');
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reativar_atend_congenere ( nr_seq_suspensao_p bigint, nm_usuario_p text) FROM PUBLIC;

