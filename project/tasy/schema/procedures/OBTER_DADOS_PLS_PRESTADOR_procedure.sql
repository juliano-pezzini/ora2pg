-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_pls_prestador ( nr_sequencia_p INOUT bigint, cd_cgc_p text, cd_pf_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
		begin
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	pls_prestador
		where	cd_estabelecimento = cd_estabelecimento_p
		and	cd_cgc = cd_cgc_p;
		end;
	else
		begin
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	pls_prestador
		where	cd_estabelecimento = cd_estabelecimento_p
		and	cd_pessoa_fisica = cd_pf_p;
		end;
	end if;
	end;
end if;
commit;
nr_sequencia_p	:= nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_pls_prestador ( nr_sequencia_p INOUT bigint, cd_cgc_p text, cd_pf_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
