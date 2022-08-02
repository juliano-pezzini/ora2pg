-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_altera_bloqueio_inscrito ( nr_seq_inscrito_p bigint, dt_registro_p timestamp, ie_opcao_p text, nm_usuario_p text, ie_bloq_reab_p text default 'N') AS $body$
DECLARE


nr_seq_tipo_w				bigint;
ie_susp_reab_w				varchar(1);
cd_pessoa_fisica_w			varchar(10);
ie_status_agenda_susp_w		varchar(3);
nr_seq_pac_reab_w			bigint;
ie_status_bloq_w			bigint;
ds_log_w					varchar(2000);
nr_status_atual_w			bigint;


BEGIN
if (ie_opcao_p = 'B') then
	insert into tre_inscrito_bloqueio(
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_ini_bloqueio,
		nm_usuario,
		nm_usuario_ini_bloq,
		nm_usuario_nrec,
		nr_seq_inscrito)
	values (	nextval('tre_inscrito_bloqueio_seq'),
		clock_timestamp(),
		clock_timestamp(),
		dt_registro_p,
		nm_usuario_p,
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_inscrito_p);

	if (ie_bloq_reab_p = 'S') then

		select	max(d.nr_sequencia)
		into STRICT	nr_seq_tipo_w
		from	tre_inscrito a,
			tre_evento b,
			tre_curso c,
			tre_tipo d
		where	a.nr_seq_evento = b.nr_sequencia
		and	b.nr_seq_curso = c.nr_sequencia
		and	c.nr_seq_tipo = d.nr_sequencia
		and	a.nr_sequencia = nr_seq_inscrito_p;

		select	max(ie_susp_reab)
		into STRICT	ie_susp_reab_w
		from	tre_tipo
		where	nr_sequencia = nr_seq_tipo_w;

		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	tre_inscrito
		where	nr_sequencia = nr_seq_inscrito_p;

		select	max(ie_status_agenda_susp),
			max(nr_seq_pac_reab_bloqueio)
		into STRICT	ie_status_agenda_susp_w,
			ie_status_bloq_w
		from	rp_parametros
		where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

		select	max(nr_sequencia),
			max(nr_seq_status)
		into STRICT	nr_seq_pac_reab_w,
			nr_status_atual_w
		from	rp_paciente_reabilitacao
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;

		if (ie_susp_reab_w = 'S') and (ie_status_agenda_susp_w IS NOT NULL AND ie_status_agenda_susp_w::text <> '') and (nr_status_atual_w <> ie_status_bloq_w) then

			ds_log_w	:= obter_desc_expressao(737970)/*'Treinamentos: '*/
 ||': '||substr('nr_seq_pac_reab_w: '||to_char(nr_seq_pac_reab_w)||
							' (Data log = '||to_char(clock_timestamp(),'dd/mm/yyyy')||')',1,2000);
			CALL gravar_log_tasy(21, ds_log_w, nm_usuario_p);

			update	rp_paciente_reabilitacao
			set	nr_seq_status	= ie_status_bloq_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= 'BLOQ.AUTO'
			where	nr_sequencia 	= nr_seq_pac_reab_w;

			update	rp_tratamento
			set	nr_seq_status	= ie_status_bloq_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= 'BLOQ.AUTO'
			where	nr_seq_pac_reav = nr_seq_pac_reab_w
			and	coalesce(dt_fim_tratamento::text, '') = '';

			update	agenda_consulta
			set	ie_status_agenda 	= ie_status_agenda_susp_w
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w
			and	((nr_seq_rp_item_ind IS NOT NULL AND nr_seq_rp_item_ind::text <> '') or (nr_seq_rp_mod_item IS NOT NULL AND nr_seq_rp_mod_item::text <> ''))
			and	ie_status_agenda	<> 'E'
			and	ie_status_agenda 	<> ie_status_agenda_susp_w
			and	trunc(dt_agenda)	>= trunc(dt_registro_p);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_altera_bloqueio_inscrito ( nr_seq_inscrito_p bigint, dt_registro_p timestamp, ie_opcao_p text, nm_usuario_p text, ie_bloq_reab_p text default 'N') FROM PUBLIC;

