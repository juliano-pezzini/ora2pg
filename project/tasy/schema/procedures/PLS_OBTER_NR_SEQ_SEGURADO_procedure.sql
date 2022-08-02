-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_nr_seq_segurado (cd_usuario_plano_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p INOUT bigint, dt_validade_p INOUT timestamp) AS $body$
DECLARE


nr_seq_segurado_w	bigint;
dt_validade_w		timestamp;


BEGIN
if (cd_usuario_plano_p IS NOT NULL AND cd_usuario_plano_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	begin
	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_seq_segurado_w
	from	pls_segurado a,
		pls_segurado_carteira b
	where	a.nr_sequencia = b.nr_seq_segurado
	and	b.cd_usuario_plano = trim(both cd_usuario_plano_p)
	and	b.cd_estabelecimento = cd_estabelecimento_p;

	select	to_char(coalesce(dt_validade_carteira,clock_timestamp()), 'dd/mm/yyyy')
	into STRICT	dt_validade_w
	from	pls_segurado_carteira
	where	nr_seq_segurado   = nr_seq_segurado_w
	and	cd_usuario_plano  = cd_usuario_plano_p;

	end;

	nr_seq_segurado_p	:= nr_seq_segurado_w;
	dt_validade_p		:= dt_validade_w;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_nr_seq_segurado (cd_usuario_plano_p bigint, cd_estabelecimento_p bigint, nr_seq_segurado_p INOUT bigint, dt_validade_p INOUT timestamp) FROM PUBLIC;

