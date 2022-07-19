-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_dt_admissao_benef ( nr_seq_segurado_p bigint, dt_admissao_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


dt_admissao_w			varchar(20);
qt_segurado_compl		bigint;


BEGIN
dt_admissao_w := null;

select	count(1)
into STRICT	qt_segurado_compl
from	pls_segurado_compl
where	nr_seq_segurado = nr_seq_segurado_p;

if (qt_segurado_compl > 0) then

	select	max(a.dt_admissao)
	into STRICT	dt_admissao_w
	from	pls_segurado_compl a,
		pls_segurado b
	where	a.nr_seq_segurado = b.nr_sequencia
	and	b.nr_sequencia	  = nr_seq_segurado_p;

	update 	pls_segurado_compl
	set 	dt_admissao	= dt_admissao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_segurado	= nr_seq_segurado_p;

else
	insert	into	pls_segurado_compl(nr_sequencia, nr_seq_segurado, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			cd_cbo, dt_admissao, dt_contribuicao,
			cd_centro_custo, dt_situacao_trabalhista)
	values (nextval('pls_segurado_compl_seq'), nr_seq_segurado_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(),nm_usuario_p,
			null,dt_admissao_p,null,
			null,null);
end if;

/* Gerar histórico */

CALL pls_gerar_segurado_historico(nr_seq_segurado_p, '86', clock_timestamp(),
			     'Alteração da data de admissão do beneficiário de ' || dt_admissao_w || ' para ' || dt_admissao_p,
			     'pls_alt_dt_admissao_benef',null,null,null,null,clock_timestamp(),null,null,null,null,null,null, nm_usuario_p, 'S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_dt_admissao_benef ( nr_seq_segurado_p bigint, dt_admissao_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

