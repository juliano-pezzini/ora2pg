-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alteracao_glicemia (nr_seq_glicemia_p bigint, ie_evento_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;
dt_atualizacao_w	timestamp := clock_timestamp();
dt_reinicio_w		timestamp;
ie_evento_w		smallint;


BEGIN
if (nr_seq_glicemia_p IS NOT NULL AND nr_seq_glicemia_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') and
	--(ds_observacao_p is not null) and
	(nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	/* obter sequencia */

	select	nextval('atend_glicemia_evento_seq')
	into STRICT	nr_sequencia_w
	;

	/* atualizar data evento (gerar evento 'reiniciar' antes do evento medicao) */

	if (ie_evento_p = 3) then
		select	max(ie_evento)
		into STRICT	ie_evento_w
		from	atend_glicemia_evento
		where	nr_seq_glicemia = nr_seq_glicemia_p
		and	dt_evento	= (SELECT	max(dt_evento)
					   from		atend_glicemia_evento
					   where	nr_seq_glicemia = nr_seq_glicemia_p);

		if (ie_evento_w = 1) then
			select	max(dt_evento - 1/86400)
			into STRICT	dt_reinicio_w
			from	atend_glicemia_evento
			where	nr_seq_glicemia = nr_seq_glicemia_p;
		end if;

		if (dt_reinicio_w IS NOT NULL AND dt_reinicio_w::text <> '') then
			dt_atualizacao_w := dt_reinicio_w;
		end if;
	end if;


	/* gerar evento */

	insert into atend_glicemia_evento(
						nr_sequencia,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						dt_atualizacao,
						nm_usuario,
						nr_seq_glicemia,
						ie_evento,
						dt_evento,
						cd_pessoa_evento,
						ds_observacao
						)
					values (
						nr_sequencia_w,
						dt_atualizacao_w,
						nm_usuario_p,
						dt_atualizacao_w,
						nm_usuario_p,
						nr_seq_glicemia_p,
						ie_evento_p,
						dt_atualizacao_w,
						obter_dados_usuario_opcao(nm_usuario_p, 'C'),
						ds_observacao_p
						);
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alteracao_glicemia (nr_seq_glicemia_p bigint, ie_evento_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

