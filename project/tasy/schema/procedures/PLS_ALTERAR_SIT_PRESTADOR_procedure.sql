-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_sit_prestador ( nr_seq_prest_sit_p bigint, nr_seq_prestador_p bigint, nr_seq_cooperado_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


/* ######  IE_ACAO_P ##### */

/*    C    -   Credenciamento	*/

/*    D    -   Descredenciamento	*/

/*####################*/

dt_alteracao_w		timestamp;
ie_alteracao_w		varchar(3);
nr_seq_prestador_w	bigint;
dt_exclusao_w		timestamp;
cd_pessoa_fisica_w	varchar(10);


BEGIN
if (nr_seq_prest_sit_p IS NOT NULL AND nr_seq_prest_sit_p::text <> '') then

	select	a.dt_alteracao,
		a.ie_alteracao,
		a.nr_seq_prestador
	into STRICT	dt_alteracao_w,
		ie_alteracao_w,
		nr_seq_prestador_w
	from	pls_prestador_situacao a
	where	a.nr_sequencia	= nr_seq_prest_sit_p;

	if (ie_alteracao_w = 'C') then
		update	pls_prestador
		set	dt_exclusao		 = NULL,
			dt_inicio_contrato	= clock_timestamp()
		where	nr_sequencia		= nr_seq_prestador_w;
	elsif (ie_alteracao_w = 'D') then
		update	pls_prestador
		set	dt_exclusao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_prestador_w;
	end if;

--elsif	(ie_acao_p = 'C') then
elsif (ie_acao_p = 'D') then
	select	cd_pessoa_fisica,
		dt_exclusao
	into STRICT	cd_pessoa_fisica_w,
		dt_exclusao_w
	from	pls_cooperado
	where	nr_sequencia	= nr_seq_cooperado_p;

	update	pls_prestador
	set	dt_exclusao	= dt_exclusao_w
	where	nr_sequencia	= nr_seq_prestador_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		update	pls_prestador_medico
		set	dt_exclusao	= dt_exclusao_w,
			ie_situacao	= 'I'
		where	cd_medico	= cd_pessoa_fisica_w;
	end if;

	insert into pls_prestador_situacao(	nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_prestador,
			dt_alteracao,
			ie_alteracao,
			ds_observacao)
	values (	nextval('pls_prestador_situacao_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_prestador_p,
			clock_timestamp(),
			'D',
			'Gerado pelo sistema após inativação do cooperado.');

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_sit_prestador ( nr_seq_prest_sit_p bigint, nr_seq_prestador_p bigint, nr_seq_cooperado_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
