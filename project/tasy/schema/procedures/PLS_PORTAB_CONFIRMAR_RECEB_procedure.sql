-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_portab_confirmar_receb ( nr_seq_portabilidade_p pls_portab_pessoa.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
qt_inconsistencias_w		integer;


BEGIN
select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	pls_portab_pessoa
where	nr_sequencia	= nr_seq_portabilidade_p;

if (obter_valor_param_usuario(1242,6,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w) = 'N') then
	CALL pls_consistir_portabilidade(nr_seq_portabilidade_p, nm_usuario_p, cd_estabelecimento_w);
	
	select	count(1)
	into STRICT	qt_inconsistencias_w
	from	pls_portab_solic_consist
	where	nr_seq_portabilidade = nr_seq_portabilidade_p;
	
	if (qt_inconsistencias_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1174705);
	end if;
end if;


update	pls_portab_pessoa
set	ie_status	= 'L',
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_portabilidade_p;

CALL pls_envio_email_portabilidade(nr_seq_portabilidade_p, 3, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_portab_confirmar_receb ( nr_seq_portabilidade_p pls_portab_pessoa.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
