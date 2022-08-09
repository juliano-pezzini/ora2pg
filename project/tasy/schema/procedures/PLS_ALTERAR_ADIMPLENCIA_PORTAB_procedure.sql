-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_adimplencia_portab ( nr_seq_portabilidade_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_alteracao_w			varchar(200);
ds_novo_w			varchar(200);
ie_adimplente_atual_w		varchar(1);


BEGIN

select	CASE WHEN ie_adimplente='S' THEN 'Adimplente'  ELSE 'Inadimplente' END ,
	CASE WHEN ie_acao_p='S' THEN 'Adimplente'  ELSE 'Inadimplente' END ,
	ie_adimplente
into STRICT	ds_alteracao_w,
	ds_novo_w,
	ie_adimplente_atual_w
from	pls_portab_pessoa
where	nr_sequencia	= nr_seq_portabilidade_p;

if (ie_adimplente_atual_w <> ie_acao_p) then
	update	pls_portab_pessoa
	set	ie_adimplente	= ie_acao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_portabilidade_p;

	insert into pls_portab_historico(	nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_solic_portab,
						dt_historico,
						ds_historico,
						ie_tipo_historico,
						nm_usuario_cadastro)
					values (	nextval('pls_portab_historico_seq'),
						cd_estabelecimento_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_portabilidade_p,
						clock_timestamp(),
						'Alterada o cadastro da solicitação de ' || ds_alteracao_w || ' para ' || ds_novo_w || '.',
						'S',
						nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_adimplencia_portab ( nr_seq_portabilidade_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
