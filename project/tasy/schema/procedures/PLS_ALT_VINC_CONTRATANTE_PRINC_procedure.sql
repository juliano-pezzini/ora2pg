-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_vinc_contratante_princ ( nr_seq_segurado_p bigint, nr_seq_vinculo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_vinculo_ant_w	bigint;


BEGIN

select	nr_seq_vinculo
into STRICT	nr_seq_vinculo_ant_w
from	pls_segurado
where	nr_sequencia		= nr_seq_segurado_p;

update	pls_segurado
set	nr_seq_vinculo		= nr_seq_vinculo_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_segurado_p;

CALL pls_gerar_segurado_historico(	nr_seq_segurado_p, '54', clock_timestamp(), 'Alteração de Vínculo com contratante principal: '|| substr(obter_desc_grau_parentesco(nr_seq_vinculo_ant_w),1,255) ||
				' para: '||substr(obter_desc_grau_parentesco(nr_seq_vinculo_p),1,255),
				'pls_alt_vinc_contratante_princ', null, null, null,
				null, clock_timestamp(), null, null,
				null, null, null, null,
				nm_usuario_p, 'N');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_vinc_contratante_princ ( nr_seq_segurado_p bigint, nr_seq_vinculo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

