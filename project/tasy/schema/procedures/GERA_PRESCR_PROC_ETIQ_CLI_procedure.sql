-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_prescr_proc_etiq_cli ( nr_controle_p bigint, ds_mensagem_p text, nr_seq_etiqueta_p bigint, nm_usuario_p text, ie_agrupa_p text default 'N', nr_prescricao_p bigint default null) AS $body$
DECLARE



nr_prescricao_w		bigint;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	nr_prescricao_w		:= nr_prescricao_p;

else

	if (coalesce(ie_agrupa_p,'N') = 'N') then
		select	max(nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_medica
		where	nr_controle	= nr_controle_p;
	else
		select	max(a.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_medica a, prescr_procedimento b
		where	a.nr_prescricao = b.nr_prescricao
		and	b.nr_controle_ext = nr_controle_p;
	end if;

end if;

if (nr_prescricao_w > 0) then

	insert into prescr_proc_etiq_cli(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_mensagem,
		nr_prescricao,
		nr_seq_etiqueta
		)
	values (
		nextval('prescr_proc_etiq_cli_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_mensagem_p,
		nr_prescricao_w,
		nr_seq_etiqueta_p
		);

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_prescr_proc_etiq_cli ( nr_controle_p bigint, ds_mensagem_p text, nr_seq_etiqueta_p bigint, nm_usuario_p text, ie_agrupa_p text default 'N', nr_prescricao_p bigint default null) FROM PUBLIC;

