-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_intercambio_guia ( nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
ie_tipo_segurado_w		varchar(2);
nr_seq_uni_exec_w		bigint;
ie_tipo_intercambio_w		varchar(1);


BEGIN

begin
	select	nr_seq_segurado,
		nr_seq_uni_exec
	into STRICT	nr_seq_segurado_w,
		nr_seq_uni_exec_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;
exception
when others then
	nr_seq_segurado_w := '';
end;

begin
	select	ie_tipo_segurado
	into STRICT	ie_tipo_segurado_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
exception
when others then
	ie_tipo_segurado_w := '';
end;

if (nr_seq_uni_exec_w IS NOT NULL AND nr_seq_uni_exec_w::text <> '') then
	ie_tipo_intercambio_w := 'I';
elsif (ie_tipo_segurado_w not in ('A','B','P')) then
	ie_tipo_intercambio_w := 'E';
end if;

if (ie_tipo_intercambio_w IS NOT NULL AND ie_tipo_intercambio_w::text <> '') then
	update	pls_guia_plano
	set	ie_tipo_intercambio	= ie_tipo_intercambio_w
	where	nr_sequencia		= nr_seq_guia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_intercambio_guia ( nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;
