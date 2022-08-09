-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_retira_bloqueio_pac (nr_seq_inscrito_p bigint, dt_registro_p timestamp, ds_motivo_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_inscrito_bloq_w	bigint;
nr_seq_evento_w		bigint;
cd_pessoa_fisica_w	varchar(10);
dt_inicio_w		timestamp;
dt_fim_w		timestamp;
dt_fim_real_w		timestamp;
nr_seq_inscrito_w	bigint;
ds_motivo_desistencia_w	varchar(90);
nr_seq_pac_dia_w	bigint;


BEGIN
if (nr_Seq_inscrito_p IS NOT NULL AND nr_Seq_inscrito_p::text <> '') and (dt_registro_p IS NOT NULL AND dt_registro_p::text <> '') then

	select	max(nr_seq_evento),
		max(cd_pessoa_fisica)
	into STRICT	nr_seq_evento_w,
		cd_pessoa_fisica_w
	from	tre_inscrito
	where	nr_sequencia = nr_seq_inscrito_p;

	select	max(dt_inicio),
		max(dt_fim),
		max(dt_fim_real)
	into STRICT	dt_inicio_w,
		dt_fim_w,
		dt_fim_real_w
	from	tre_evento
	where	nr_sequencia = nr_seq_evento_w;


	if (dt_fim_w < dt_fim_real_w) and (dt_fim_real_w IS NOT NULL AND dt_fim_real_w::text <> '') then
		dt_fim_w := dt_fim_real_w;
	end if;

	dt_inicio_w := clock_timestamp();

	while(dt_inicio_w <= dt_fim_w) loop
		begin

		select	max(tre_obter_dados_pac_dia(b.nr_sequencia,dt_inicio_w,'C'))
		into STRICT	nr_seq_pac_dia_w
		from	tre_inscrito b,
			tre_evento c
		where	b.nr_seq_evento = c.nr_sequencia
		and	c.nr_sequencia = nr_seq_evento_w
		and	b.cd_pessoa_fisica = cd_pessoa_fisica_w
		and	((tre_valida_se_dia_curso(c.nr_sequencia,fim_dia(dt_inicio_w)) = 'S') or ((tre_obter_dados_pac_dia(b.nr_sequencia,dt_inicio_w,'CA'))::numeric  > 0))
		and (substr(tre_obter_se_data_fim_valida(dt_inicio_w,c.nr_sequencia,c.dt_fim_real,c.dt_fim),1,1) = 'S')
		and	fim_dia(dt_inicio_w) >= c.dt_inicio
		and (obter_se_feriado(wheb_usuario_pck.get_cd_estabelecimento, dt_inicio_w) = 0)
		and (substr(tre_obter_dados_pac_dia(b.nr_sequencia,dt_inicio_w,'SP'),1,2) = 'I')
		and	not exists (	SELECT	1
							from	tre_agenda v
							where	v.nr_sequencia = c.nr_seq_agenda
							and	(v.dt_cancelamento IS NOT NULL AND v.dt_cancelamento::text <> ''));

		if (nr_seq_pac_dia_w > 0) then
			update	tre_paciente_dia
			set	ie_status_paciente = 'N',
				ds_motivo_status  = NULL
			where	nr_sequencia = nr_seq_pac_dia_w;
		end if;

		dt_inicio_w := dt_inicio_w + 1;
		end;
	end loop;





	select	max(nr_sequencia)
	into STRICT	nr_seq_inscrito_bloq_w
	from	tre_inscrito_bloqueio
	where	nr_seq_inscrito = nr_seq_inscrito_p
	and	coalesce(dt_fim_bloqueio::text, '') = '';

	update	tre_inscrito_bloqueio
	set	dt_fim_bloqueio = dt_registro_p,
		nm_usuario_fim_bloq = nm_usuario_p,
		ds_motivo_desbloqueio = ds_motivo_p
	where	nr_Sequencia = nr_seq_inscrito_bloq_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_retira_bloqueio_pac (nr_seq_inscrito_p bigint, dt_registro_p timestamp, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;
