-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_buscar_pessoa_lead ( nr_seq_solicitacao_p bigint, nr_seq_cliente_p bigint, nr_seq_simulpreco_p bigint default null, cd_pessoa_fisica_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10)	:= null;


BEGIN

if (coalesce(nr_seq_cliente_p,0) <> 0) then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pls_comercial_cliente
	where	nr_sequencia	= nr_seq_cliente_p;
end if;

if (coalesce(cd_pessoa_fisica_w::text, '') = '') and (coalesce(nr_seq_solicitacao_p,0) <> 0) then
	select	max(cd_pf_vinculado)
	into STRICT	cd_pessoa_fisica_w
	from	pls_solicitacao_comercial
	where	nr_sequencia	= nr_seq_solicitacao_p;

	if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(296131,'NR_SEQ_LEAD='||nr_seq_solicitacao_p);
	end if;
end if;

if (coalesce(nr_seq_simulpreco_p,0) <> 0) then
	update	pls_simulpreco_individual
	set	cd_pessoa_fisica	= cd_pessoa_fisica_w
	where	nr_sequencia		= nr_seq_simulpreco_p;

	commit;
end if;

cd_pessoa_fisica_p	:= cd_pessoa_fisica_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_buscar_pessoa_lead ( nr_seq_solicitacao_p bigint, nr_seq_cliente_p bigint, nr_seq_simulpreco_p bigint default null, cd_pessoa_fisica_p INOUT text DEFAULT NULL) FROM PUBLIC;

