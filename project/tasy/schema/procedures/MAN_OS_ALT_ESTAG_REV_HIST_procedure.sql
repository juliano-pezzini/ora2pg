-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_os_alt_estag_rev_hist ( nr_seq_ordem_serv_p bigint, nr_seq_historico_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_idioma_w				bigint;
ds_destinatarios_w			varchar(4000);
dt_historico_w				timestamp;
ds_assunto_w				varchar(100);
ds_mensagem_w				varchar(2000);

c_revisores CURSOR FOR
SELECT	cd_pessoa_fisica
from	cadastro_revisor_historico
where	nr_seq_idioma = nr_seq_idioma_w;

BEGIN

	select	max(c.nr_seq_idioma) nr_seq_idioma
	into STRICT	nr_seq_idioma_w
	from	man_ordem_servico a,
			man_localizacao b,
			pessoa_juridica c
	where	a.nr_seq_localizacao = b.nr_sequencia
	and		b.cd_cnpj = c.cd_cgc
	and		a.nr_sequencia = nr_seq_ordem_serv_p;

	for r_c_revisores in c_revisores loop
		if (ds_destinatarios_w <> '') then
			ds_destinatarios_w := ds_destinatarios_w || ',' || substr(obter_email_pf(r_c_revisores.cd_pessoa_fisica), 1, 255);
		else
			ds_destinatarios_w := substr(obter_email_pf(r_c_revisores.cd_pessoa_fisica), 1, 255);
		end if;
	end loop;

	select	max(dt_historico)
	into STRICT	dt_historico_w
	from	man_ordem_serv_tecnico
	where	nr_sequencia = nr_seq_historico_p;

	ds_assunto_w := wheb_mensagem_pck.get_texto(781998);
	ds_mensagem_w := wheb_mensagem_pck.get_texto(781999, 'DT_HISTORICO=' || dt_historico_w || ';NR_SEQ_ORDEM_SERV=' || nr_seq_ordem_serv_p);

	CALL enviar_email(ds_assunto_w, ds_mensagem_w, 'support.informatics@philips.com', ds_destinatarios_w, 'Tasy', 'M');

	update	man_ordem_servico
	set		nr_seq_estagio = 2082,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_ordem_serv_p;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_os_alt_estag_rev_hist ( nr_seq_ordem_serv_p bigint, nr_seq_historico_p bigint, nm_usuario_p text ) FROM PUBLIC;
