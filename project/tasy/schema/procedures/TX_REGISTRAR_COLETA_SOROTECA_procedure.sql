-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_registrar_coleta_soroteca (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
nr_seq_encaminhamento_w	bigint;
nr_seq_receptor_w	bigint;


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	max(nr_seq_receptor)
	into STRICT	nr_seq_receptor_w
	from	tx_recep_controle_central
	where	nr_Sequencia = nr_sequencia_p;


	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	tx_receptor
	where	nr_sequencia = nr_seq_receptor_w;


	select	max(nr_sequencia)
	into STRICT	nr_seq_encaminhamento_w
	from	tx_encaminhamento
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	ie_status not in ('CI','CIT','LTX','TR')
	and	coalesce(dt_inativacao::text, '') = ''
	and	dt_encaminhamento = (	SELECT	max(dt_encaminhamento)
					from	tx_encaminhamento
					where	cd_pessoa_fisica = cd_pessoa_fisica_w
					and	coalesce(dt_inativacao::text, '') = ''
					and	ie_status not in ('CI','CIT','LTX','TR'));


	CALL tx_alterar_status_encam(nr_seq_encaminhamento_w,'LTX',nm_usuario_p);

	update	tx_recep_controle_central
	set	dt_coleta = clock_timestamp(),
		nm_usuario_coleta = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_registrar_coleta_soroteca (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

