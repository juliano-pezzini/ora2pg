-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_autenticacao_documento ( nr_seq_documento_p bigint, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/*cd_funcao_p
40 - Nota Fiscal*/
nr_autenticacao_w	bigint;
nr_sequencia_w		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	autenticacao_documento
where	nr_seq_documento = nr_seq_documento_p
and	cd_funcao = cd_funcao_p;

if (nr_sequencia_w = 0) then

	select	coalesce(max(nr_autenticacao),0) + 1
	into STRICT	nr_autenticacao_w
	from	autenticacao_documento
	where	cd_funcao = cd_funcao_p
	and	((coalesce(cd_estabelecimento_p,0) = 0) or
		((coalesce(cd_estabelecimento_p,0) > 0) and (cd_estabelecimento = cd_estabelecimento_p)));

	select	nextval('autenticacao_documento_seq')
	into STRICT	nr_sequencia_w
	;

	insert into autenticacao_documento(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_funcao,
		nr_autenticacao,
		nr_seq_documento,
		cd_estabelecimento)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_funcao_p,
		nr_autenticacao_w,
		nr_seq_documento_p,
		cd_estabelecimento_p);
end if;

commit;

nr_sequencia_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_autenticacao_documento ( nr_seq_documento_p bigint, cd_funcao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;

