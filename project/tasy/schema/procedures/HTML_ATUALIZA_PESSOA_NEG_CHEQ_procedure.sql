-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_atualiza_pessoa_neg_cheq ( nr_seq_caixa_receb_p bigint, nr_seq_cheque_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w	caixa_receb.cd_pessoa_fisica%type;
cd_cgc_w		caixa_receb.cd_cgc%type;


BEGIN

select	max(cd_pessoa_fisica),
	max(cd_cgc)
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w
from	caixa_receb
where	nr_sequencia = nr_seq_caixa_receb_p;

if (coalesce(cd_pessoa_fisica_w::text, '') = '' and coalesce(cd_cgc_w::text, '') = '') and (coalesce(cd_pessoa_fisica_p::text, '') = '' and coalesce(cd_cgc_p::text, '') = '') then

	select	max(cd_pessoa_fisica),
		max(cd_cgc)
	into STRICT	cd_pessoa_fisica_w,
		cd_cgc_w
	from	cheque_cr
	where	nr_seq_cheque = nr_seq_cheque_p;

	update	caixa_receb
	set	cd_pessoa_fisica	= cd_pessoa_fisica_w,
		cd_cgc			= cd_cgc_w,
		dt_atualizacao	 	= clock_timestamp(),
		nm_usuario 		= nm_usuario
	where	nr_sequencia 	= nr_seq_caixa_receb_p;

	commit;

elsif (coalesce(cd_pessoa_fisica_w::text, '') = '' and coalesce(cd_cgc_w::text, '') = '') and ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '')) then

	update	caixa_receb
	set	cd_pessoa_fisica	= cd_pessoa_fisica_p,
		cd_cgc			= cd_cgc_p,
		dt_atualizacao	 	= clock_timestamp(),
		nm_usuario 		= nm_usuario
	where	nr_sequencia 	= nr_seq_caixa_receb_p;

	commit;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_atualiza_pessoa_neg_cheq ( nr_seq_caixa_receb_p bigint, nr_seq_cheque_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text) FROM PUBLIC;

