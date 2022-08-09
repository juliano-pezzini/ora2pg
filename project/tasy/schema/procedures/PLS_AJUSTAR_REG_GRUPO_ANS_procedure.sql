-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_reg_grupo_ans ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_anterior_w		bigint;
nr_seq_grupo_despesa_w		bigint;
nr_seq_grupo_regra_w		bigint;
nr_seq_grupo_proc_w		bigint;
nr_seq_grupo_mat_w		bigint;
nr_seq_grupo_copartic_w		bigint;
nr_seq_tipo_atendimento_novo_w	bigint;
nr_seq_tipo_atendimento_ant_w	bigint;

C01 CURSOR FOR
	SELECT	nr_seq_anterior,
		nr_sequencia
	from	ans_grupo_despesa
	where	cd_estabelecimento	= cd_estabelecimento_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	ans_grupo_desp_regra
	where	nr_seq_grupo_ans	= nr_seq_anterior_w;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	ans_grupo_desp_proc
	where	nr_seq_grupo_ans	= nr_seq_anterior_w;

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	ans_grupo_desp_mat
	where	nr_seq_grupo_desp	= nr_seq_anterior_w;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	ans_grupo_desp_copartic
	where	nr_seq_grupo_desp	= nr_seq_anterior_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_anterior_w,
	nr_seq_grupo_despesa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_grupo_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	nr_seq_tipo_atendimento
		into STRICT	nr_seq_tipo_atendimento_ant_w
		from	ans_grupo_desp_regra
		where	nr_sequencia	= nr_seq_grupo_regra_w;

		begin
		select	nr_sequencia
		into STRICT	nr_seq_tipo_atendimento_novo_w
		from	pls_tipo_documento
		where	nr_seq_anterior	= nr_seq_tipo_atendimento_ant_w;
		exception
		when others then
			nr_seq_tipo_atendimento_novo_w	:= null;
		end;

		insert into ans_grupo_desp_regra(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_grupo_ans,nr_seq_tipo_atendimento,ie_tipo_guia,nr_seq_conselho,
				ie_regime_internacao, ie_tipo_protocolo, nr_seq_tipo_atend_princ,
				ie_tipo_guia_princ)
			(SELECT	nextval('ans_grupo_desp_regra_seq'),clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_grupo_despesa_w,nr_seq_tipo_atendimento_novo_w,ie_tipo_guia,nr_seq_conselho,
				ie_regime_internacao, ie_tipo_protocolo, nr_seq_tipo_atend_princ,
				ie_tipo_guia_princ
			from	ans_grupo_desp_regra
			where	nr_sequencia	= nr_seq_grupo_regra_w);

		end;
	end loop;
	close C02;

	open C03;
	loop
	fetch C03 into
		nr_seq_grupo_proc_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		insert into ans_grupo_desp_proc(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_grupo_ans,cd_procedimento,ie_origem_proced,cd_area_procedimento,
				cd_especialidade,cd_grupo_proc,ie_liberado)
			(SELECT	nextval('ans_grupo_desp_proc_seq'),clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_grupo_despesa_w,cd_procedimento,ie_origem_proced,cd_area_procedimento,
				cd_especialidade,cd_grupo_proc,ie_liberado
			from	ans_grupo_desp_proc
			where	nr_sequencia	= nr_seq_grupo_proc_w);
		end;
	end loop;
	close C03;

	open C04;
	loop
	fetch C04 into
		nr_seq_grupo_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		insert into ans_grupo_desp_mat(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_grupo_desp,ie_tipo_despesa,ie_liberado)
			(SELECT	nextval('ans_grupo_desp_mat_seq'),clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_grupo_despesa_w,ie_tipo_despesa,ie_liberado
			from	ans_grupo_desp_mat
			where	nr_sequencia	= nr_seq_grupo_mat_w);
		end;
	end loop;
	close C04;

	open C05;
	loop
	fetch C05 into
		nr_seq_grupo_copartic_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		insert into ans_grupo_desp_copartic(	nr_sequencia, nr_seq_clinica, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				ie_liberado, nr_seq_grupo_desp)
			(SELECT	nextval('ans_grupo_desp_copartic_seq'), nr_seq_clinica, clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				ie_liberado, nr_seq_grupo_despesa_w
			from	ans_grupo_desp_copartic
			where	nr_sequencia	= nr_seq_grupo_copartic_w);
		end;
	end loop;
	close C05;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_reg_grupo_ans ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
