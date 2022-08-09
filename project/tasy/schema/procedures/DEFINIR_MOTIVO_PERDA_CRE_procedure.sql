-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_motivo_perda_cre ( nr_seq_perda_p bigint, nr_seq_motivo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_motivo_w	varchar(255);
ds_historico_w	varchar(4000);

nr_seq_motivo_ant_w	bigint;


BEGIN
select	nr_seq_motivo_perda
into STRICT	nr_seq_motivo_ant_w
from	perda_contas_receber
where	nr_sequencia = nr_seq_perda_p;

update	perda_contas_receber
set	nr_Seq_motivo_perda = nr_seq_motivo_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_sequencia = nr_seq_perda_p;

select	ds_motivo
into STRICT	ds_motivo_w
from	motivo_perda_financ
where	nr_sequencia = nr_seq_motivo_p;

ds_historico_w := wheb_mensagem_pck.get_texto(303681,	'NR_SEQ_MOTIVO=' || nr_Seq_motivo_p || ';' ||
							'DS_MOTIVO=' || ds_motivo_w);

if (nr_seq_motivo_ant_w IS NOT NULL AND nr_seq_motivo_ant_w::text <> '') then
	begin
	select	ds_motivo
	into STRICT	ds_motivo_w
	from	motivo_perda_financ
	where	nr_sequencia = nr_seq_motivo_ant_w;

	ds_historico_w 	:= 	wheb_mensagem_pck.get_texto(303685,	'DS_HISTORICO=' || ds_historico_w || ';' ||
									'NR_SEQ_MOTIVO_ANT=' || nr_seq_motivo_ant_w || ';' ||
									'DS_MOTIVO=' || ds_motivo_w);
	end;
end if;

insert into perda_contas_receber_hist(
	nr_Sequencia,
	nr_seq_perda,
	ie_tipo,
	ds_historico,
	dt_liberacao,
	nm_usuario,
	nm_usuario_nrec,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nm_usuario_lib)
values (	nextval('perda_contas_receber_hist_seq'),
	nr_seq_perda_p,
	'DM',
	ds_historico_w,
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_motivo_perda_cre ( nr_seq_perda_p bigint, nr_seq_motivo_p bigint, nm_usuario_p text) FROM PUBLIC;
