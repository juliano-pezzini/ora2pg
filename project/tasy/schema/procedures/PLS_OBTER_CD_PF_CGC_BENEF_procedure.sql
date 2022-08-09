-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_cd_pf_cgc_benef ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, ie_tipo_pessoa_p bigint, cd_pessoa_fisica_p INOUT text, cd_cgc_p INOUT text) AS $body$
DECLARE


/*
ie_tipo_pessoa_p
0 - Beneficiário
1 - Pagador
2 - Estipulante
*/
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);


BEGIN

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	if (ie_tipo_pessoa_p = 0) then
		select	cd_pessoa_fisica
		into STRICT	cd_pessoa_fisica_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;
	elsif (ie_tipo_pessoa_p = 1) then
		select	a.cd_pessoa_fisica,
			a.cd_cgc
		into STRICT	cd_pessoa_fisica_w,
			cd_cgc_w
		from	pls_segurado		b,
			pls_contrato_pagador	a
		where	b.nr_seq_pagador	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_segurado_p;
	elsif (ie_tipo_pessoa_p = 2) then
		select	a.cd_pf_estipulante,
			a.cd_cgc_estipulante
		into STRICT	cd_pessoa_fisica_w,
			cd_cgc_w
		from	pls_segurado		b,
			pls_contrato		a
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	b.nr_sequencia		= nr_seq_segurado_p;
	end if;
elsif (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
	if (ie_tipo_pessoa_p = 2) then
		select	cd_pf_estipulante,
			cd_cgc_estipulante
		into STRICT	cd_pessoa_fisica_w,
			cd_cgc_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_p;
	else
		cd_pessoa_fisica_w	:= '';
		cd_cgc_w		:= '';
	end if;
end if;

cd_pessoa_fisica_p	:= cd_pessoa_fisica_w;
cd_cgc_p		:= cd_cgc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_cd_pf_cgc_benef ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, ie_tipo_pessoa_p bigint, cd_pessoa_fisica_p INOUT text, cd_cgc_p INOUT text) FROM PUBLIC;
