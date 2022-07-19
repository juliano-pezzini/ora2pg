-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajuste_ie_orig_conta () AS $body$
DECLARE


nr_seq_segurado_w	bigint;
nr_seq_analise_w	bigint;
nr_seq_plano_w		bigint;
ie_preco_w		varchar(2);
ie_origem_conta_w	varchar(2);
cd_guia_w		varchar(20);

C01 CURSOR FOR
	SELECT	nr_Sequencia,
		nr_seq_segurado,
		cd_guia
	from 	pls_analise_conta
	where	coalesce(ie_origem_conta::text, '') = ''
	or	coalesce(ie_preco::text, '') = '';

BEGIN

open C01;
loop
fetch C01 into
	nr_seq_analise_w,
	nr_seq_segurado_w,
	cd_guia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	begin
	select	a.nr_seq_plano
	into STRICT	nr_seq_plano_w
	from	pls_segurado a
	where	a.nr_sequencia = nr_seq_segurado_w;
	exception
	when others then
		nr_seq_plano_w	:= null;
	end;

	begin
	select	ie_preco
	into STRICT	ie_preco_w
	from	pls_plano
	where	nr_sequencia = nr_seq_plano_w;
	exception
	when others then
		ie_preco_w	:= '';
	end;

	select	max(ie_origem_conta)
	into STRICT	ie_origem_conta_w
	from	pls_conta
	where	nr_seq_analise = nr_seq_analise_w;

	if ( coalesce(ie_origem_conta_w::text, '') = '' ) then
		select 	max(ie_origem_conta)
		into STRICT	ie_origem_conta_w
		from 	pls_conta
		where	coalesce(cd_guia_referencia, cd_guia) = cd_guia_w
		and	nr_seq_segurado 		 = nr_seq_segurado_w
		and	(ie_origem_conta IS NOT NULL AND ie_origem_conta::text <> '');
	end if;


	update 	pls_analise_conta
	set	ie_origem_conta = ie_origem_conta_w,
		ie_preco	= ie_preco_w
	where	nr_sequencia 	= nr_seq_analise_w;

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_ajuste_ie_orig_conta () FROM PUBLIC;

