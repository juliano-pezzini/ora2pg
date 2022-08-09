-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_descredenciar_prestador ( nr_seq_prestador_p bigint, ie_tipo_prestador_p bigint, dt_descredenciamento_p timestamp, nm_usuario_p text, nr_seq_motivo_descred_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10)	:= '0';
cd_estabelecimento_w	smallint;
nr_seq_prestador_w	bigint;


BEGIN

if (ie_tipo_prestador_p	= 1) then
	update	pls_prestador
	set	ie_tipo_vinculo	= 'V',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_prestador_p
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '')
	and	ie_tipo_vinculo	= 'C';

	select	coalesce(max(cd_pessoa_fisica),'0'),
		max(nr_sequencia)
	into STRICT	cd_pessoa_fisica_w,
		nr_seq_prestador_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_p;

	CALL pls_altera_vinculo_prof(nr_seq_prestador_p,'V');

elsif (ie_tipo_prestador_p	= 2) then
	update	pls_prestador_medico
	set	ie_tipo_vinculo	= 'V',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_prestador_p
	and	ie_tipo_vinculo	= 'C';

	select	coalesce(max(cd_medico),'0'),
		max(nr_seq_prestador)
	into STRICT	cd_pessoa_fisica_w,
		nr_seq_prestador_w
	from	pls_prestador_medico
	where	nr_sequencia	= nr_seq_prestador_p;
end if;

if (cd_pessoa_fisica_w	<> '0') then
	/* Obter o estabelecimento do prestador */

	select	coalesce(max(cd_estabelecimento),1)
	into STRICT	cd_estabelecimento_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_w;

	/* Gravar histórico da ação */

	insert into pls_credenciamento_hist(nr_sequencia,
			        cd_estabelecimento,
			        dt_atualizacao,
			        nm_usuario,
			        dt_atualizacao_nrec,
			        nm_usuario_nrec,
			        nr_seq_prestador,
			        cd_pessoa_fisica,
			        ie_tipo_historico,
			        dt_historico,
			        nr_seq_motivo_descred)
			values ( nextval('pls_credenciamento_hist_seq'),
			        cd_estabelecimento_w,
			        clock_timestamp(),
			        nm_usuario_p,
			        clock_timestamp(),
			        nm_usuario_p,
			        nr_seq_prestador_w,
			        cd_pessoa_fisica_w,
			        'D',
			        dt_descredenciamento_p,
			        CASE WHEN nr_seq_motivo_descred_p=0 THEN null  ELSE nr_seq_motivo_descred_p END );
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_descredenciar_prestador ( nr_seq_prestador_p bigint, ie_tipo_prestador_p bigint, dt_descredenciamento_p timestamp, nm_usuario_p text, nr_seq_motivo_descred_p bigint) FROM PUBLIC;
