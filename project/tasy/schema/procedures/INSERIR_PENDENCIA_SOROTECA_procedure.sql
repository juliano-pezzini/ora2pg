-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pendencia_soroteca (nr_seq_receptor_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_nao_liberado_p text, ie_contra_indicado_p text) AS $body$
DECLARE


ie_gerar_pendencia_w	varchar(1);
cd_pessoa_fisica_w	varchar(10);
nr_seq_encaminhamento_w	bigint;
ie_status_w		varchar(3);



BEGIN
select	coalesce(max(ie_soroteca),'N')
into STRICT	ie_gerar_pendencia_w
from	hd_parametro
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_gerar_pendencia_w = 'S') and (nr_seq_receptor_p IS NOT NULL AND nr_seq_receptor_p::text <> '') then

	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	tx_receptor
	where	nr_sequencia = nr_seq_receptor_p;


	select	max(nr_sequencia)
	into STRICT	nr_seq_encaminhamento_w
	from	tx_encaminhamento
	where	cd_pessoa_fisica = cd_pessoa_fisica_w
	and	coalesce(dt_inativacao::text, '') = ''
	and	ie_status in ('ET','PT','NL')
	and	dt_encaminhamento = (	SELECT	max(dt_encaminhamento)
					from	tx_encaminhamento
					where	cd_pessoa_fisica = cd_pessoa_fisica_w
					and	coalesce(dt_inativacao::text, '') = ''
					and	ie_status in ('ET','PT','NL'));


	if (nr_seq_encaminhamento_w IS NOT NULL AND nr_seq_encaminhamento_w::text <> '') then

		if (ie_nao_liberado_p = 'S') then
			ie_status_w := 'NL';
		elsif (ie_contra_indicado_p = 'S') then
			ie_status_w := 'CIT';
		else
			ie_status_w := 'LV';
		end if;

		CALL tx_alterar_status_encam(nr_seq_encaminhamento_w,ie_status_w,nm_usuario_p);

	end if;


	insert into tx_recep_controle_central(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_vencimento,
		nr_seq_receptor)
	values (	nextval('tx_recep_controle_central_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_receptor_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pendencia_soroteca (nr_seq_receptor_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_nao_liberado_p text, ie_contra_indicado_p text) FROM PUBLIC;
