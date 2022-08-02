-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_contas_medicas ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_criterio_hor_w		bigint;
nr_seq_grau_participacao_w	bigint;
nr_seq_motivo_cancel_defesa_w	bigint;
nr_seq_motivo_saida_consulta_w	bigint;
nr_seq_motivo_saida_w		bigint;
nr_seq_motivo_saida_sadt_w	bigint;
nr_seq_regra_honorario_w	bigint;
nr_seq_tipo_desp_mat_w		bigint;
nr_seq_tipo_desp_proc_w		bigint;
nr_seq_clinica_w		bigint;
nr_seq_tipo_atendimento_w	bigint;
qt_registro_w			bigint;
nr_seq_prest_novo_w		bigint;
nr_seq_prest_ant_w		bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proc_criterio_horario
	where	cd_estabelecimento	= cd_estab_origem_p;

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_grau_participacao
	where	cd_estabelecimento	= cd_estab_origem_p;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_motivo_cancel_defesa
	where	cd_estabelecimento	= cd_estab_origem_p;

c04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_motivo_saida_consulta
	where	cd_estabelecimento	= cd_estab_origem_p;

c05 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_motivo_saida
	where	cd_estabelecimento	= cd_estab_origem_p;

c06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_motivo_saida_sadt
	where	cd_estabelecimento	= cd_estab_origem_p;

c07 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_honorario
	where	cd_estabelecimento	= cd_estab_origem_p;

c08 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_tipo_desp_mat
	where	cd_estabelecimento	= cd_estab_origem_p;

c09 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_tipo_desp_proc
	where	cd_estabelecimento	= cd_estab_origem_p;

c11 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_tipo_atendimento
	where	cd_estabelecimento	= cd_estab_origem_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_criterio_hor_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_proc_criterio_horario
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_criterio_hor_w;

	if (qt_registro_w	= 0) then
		select	max(nr_seq_prestador)
		into STRICT	nr_seq_prest_ant_w
		from	pls_proc_criterio_horario
		where	nr_sequencia	= nr_seq_criterio_hor_w;

		begin
		select	nr_sequencia
		into STRICT	nr_seq_prest_novo_w
		from	pls_prestador
		where	nr_seq_anterior		= nr_seq_prest_ant_w
		and	cd_estabelecimento	= cd_estab_destino_p;
		exception
		when others then
			nr_seq_prest_novo_w	:= nr_seq_prest_ant_w;
		end;

		insert into pls_proc_criterio_horario(nr_sequencia, cd_estabelecimento, ie_prioridade,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, cd_edicao_amb, cd_procedimento,
			ie_origem_proced, cd_area_procedimento, cd_especialidade,
			cd_grupo_proc, tx_auxiliares, tx_medico,
			tx_materiais, tx_anestesista, tx_custo_operacional,
			dt_dia_semana, ie_feriado, hr_inicial,
			hr_final, nr_seq_prestador, tx_procedimento,
			nr_seq_anterior,nr_seq_tipo_prestador)
		(SELECT	nextval('pls_proc_criterio_horario_seq'), cd_estab_destino_p, ie_prioridade,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, cd_edicao_amb, cd_procedimento,
			ie_origem_proced, cd_area_procedimento, cd_especialidade,
			cd_grupo_proc, tx_auxiliares, tx_medico,
			tx_materiais, tx_anestesista, tx_custo_operacional,
			dt_dia_semana, ie_feriado, hr_inicial,
			hr_final, nr_seq_prest_novo_w, tx_procedimento,
			nr_seq_criterio_hor_w,nr_seq_tipo_prestador
		from	pls_proc_criterio_horario
		where	nr_sequencia	= nr_seq_criterio_hor_w);
	end if;

	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
	nr_seq_grau_participacao_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_grau_participacao
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_grau_participacao_w;

	if (qt_registro_w	= 0) then
		insert into pls_grau_participacao(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ds_grau_participacao,
			cd_tiss, ie_situacao, ie_medico,
			ie_anestesista, ie_auxiliar, cd_estabelecimento,
			nr_seq_anterior)
		(SELECT	nextval('pls_grau_participacao_seq'), clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, ds_grau_participacao,
			cd_tiss, ie_situacao, ie_medico,
			ie_anestesista, ie_auxiliar, cd_estab_destino_p,
			nr_seq_grau_participacao_w
		from	pls_grau_participacao
		where	nr_sequencia = nr_seq_grau_participacao_w);
	end if;

	end;
end loop;
close c02;

open c03;
loop
fetch c03 into
	nr_seq_motivo_cancel_defesa_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_motivo_cancel_defesa
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_motivo_cancel_defesa_w;

	if (qt_registro_w	= 0) then
		insert into pls_motivo_cancel_defesa(nr_sequencia, ds_motivo, cd_estabelecimento,
			ie_situacao, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_anterior)
		(SELECT	nextval('pls_motivo_cancel_defesa_seq'), ds_motivo, cd_estab_destino_p,
			ie_situacao, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, nr_seq_motivo_cancel_defesa_w
		from	pls_motivo_cancel_defesa
		where	nr_sequencia	= nr_seq_motivo_cancel_defesa_w);
	end if;

	end;
end loop;
close c03;

open c04;
loop
fetch c04 into
	nr_seq_motivo_saida_consulta_w;
EXIT WHEN NOT FOUND; /* apply on c04 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_motivo_saida_consulta
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_motivo_saida_consulta_w;

	if (qt_registro_w	= 0) then
		insert into pls_motivo_saida_consulta(nr_sequencia, cd_estabelecimento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ds_motivo_saida, cd_tiss, ie_situacao,
			nr_seq_anterior)
		(SELECT	nextval('pls_motivo_saida_consulta_seq'),  cd_estab_destino_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			ds_motivo_saida, cd_tiss, ie_situacao,
			nr_seq_motivo_saida_consulta_w
		from	pls_motivo_saida_consulta
		where	nr_sequencia	= nr_seq_motivo_saida_consulta_w);
	end if;

	end;
end loop;
close c04;

open c05;
loop
fetch c05 into
	nr_seq_motivo_saida_w;
EXIT WHEN NOT FOUND; /* apply on c05 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_motivo_saida
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_motivo_saida_w;

	if (qt_registro_w	= 0) then
		insert into pls_motivo_saida(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, ds_motivo_saida,
			cd_tiss, ie_situacao, cd_estabelecimento,
			cd_ptu, nr_seq_anterior)
		(SELECT	nextval('pls_motivo_saida_seq'), clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p,  ds_motivo_saida,
			cd_tiss, ie_situacao, cd_estab_destino_p,
			cd_ptu, nr_seq_motivo_saida_w
		from	pls_motivo_saida
		where	nr_sequencia	= nr_seq_motivo_saida_w);
	end if;

	end;
end loop;
close c05;

open c06;
loop
fetch c06 into
	nr_seq_motivo_saida_sadt_w;
EXIT WHEN NOT FOUND; /* apply on c06 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_motivo_saida_sadt
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_motivo_saida_sadt_w;

	if (qt_registro_w	= 0) then
		insert into pls_motivo_saida_sadt(nr_sequencia, cd_estabelecimento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			ds_motivo_saida, cd_tiss, ie_situacao,
			nr_seq_anterior)
		(SELECT	nextval('pls_motivo_saida_sadt_seq'), cd_estab_destino_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			ds_motivo_saida, cd_tiss, ie_situacao,
			nr_seq_motivo_saida_sadt_w
		from	pls_motivo_saida_sadt
		where	nr_sequencia	= nr_seq_motivo_saida_sadt_w);
	end if;

	end;
end loop;
close c06;

open c07;
loop
fetch c07 into
	nr_seq_regra_honorario_w;
EXIT WHEN NOT FOUND; /* apply on c07 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_regra_honorario
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_regra_honorario_w;

	if (qt_registro_w	= 0) then
		insert into pls_regra_honorario(nr_sequencia, cd_estabelecimento, ds_regra,
			ie_calcula_valor, ie_repassa_medico, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			nr_seq_anterior)
		(SELECT	nextval('pls_regra_honorario_seq'), cd_estab_destino_p, ds_regra,
			ie_calcula_valor, ie_repassa_medico, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			nr_seq_regra_honorario_w
		from	pls_regra_honorario
		where	nr_sequencia	= nr_seq_regra_honorario_w);
	end if;

	end;
end loop;
close c07;

open c08;
loop
fetch c08 into
	nr_seq_tipo_desp_mat_w;
EXIT WHEN NOT FOUND; /* apply on c08 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_tipo_desp_mat
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_tipo_desp_mat_w;

	if (qt_registro_w	= 0) then
		insert into pls_tipo_desp_mat(nr_sequencia, nr_seq_material, ie_tipo_despesa,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, cd_estabelecimento, nr_seq_anterior)
		(SELECT	nextval('pls_tipo_desp_mat_seq'), nr_seq_material, ie_tipo_despesa,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, cd_estab_destino_p, nr_seq_tipo_desp_mat_w
		from	pls_tipo_desp_mat
		where	nr_sequencia	= nr_seq_tipo_desp_mat_w);
	end if;

	end;
end loop;
close c08;

open c09;
loop
fetch c09 into
	nr_seq_tipo_desp_proc_w;
EXIT WHEN NOT FOUND; /* apply on c09 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_tipo_desp_proc
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_tipo_desp_proc_w;

	if (qt_registro_w	= 0) then
		insert into pls_tipo_desp_proc(nr_sequencia, cd_procedimento, ie_origem_proced,
			ie_tipo_despesa, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, cd_estabelecimento,
			nr_seq_anterior)
		(SELECT	nextval('pls_tipo_desp_proc_seq'), cd_procedimento, ie_origem_proced,
			ie_tipo_despesa, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, cd_estab_destino_p,
			nr_seq_tipo_desp_proc_w
		from	pls_tipo_desp_proc
		where	nr_sequencia	= nr_seq_tipo_desp_proc_w);
	end if;

	end;
end loop;
close c09;

open c11;
loop
fetch c11 into
	nr_seq_tipo_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c11 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_tipo_atendimento
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_tipo_atendimento_w;

	if (qt_registro_w	= 0) then
		insert into pls_tipo_atendimento(nr_sequencia, cd_estabelecimento, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			cd_tipo_atendimento, ie_situacao, ds_tipo_atendimento,
			cd_tiss, ie_internado, nr_seq_anterior)
		(SELECT	nextval('pls_tipo_atendimento_seq'), cd_estab_destino_p, clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			cd_tipo_atendimento, ie_situacao, ds_tipo_atendimento,
			cd_tiss, ie_internado, nr_seq_tipo_atendimento_w
		from	pls_tipo_atendimento
		where	nr_sequencia	= nr_seq_tipo_atendimento_w);
	end if;

	end;
end loop;
close c11;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_contas_medicas ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

