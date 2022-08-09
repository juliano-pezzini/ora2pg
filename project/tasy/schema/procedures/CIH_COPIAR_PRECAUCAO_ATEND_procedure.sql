-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_copiar_precaucao_atend ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_precaucao_w	bigint;	
nr_seq_precaucao_novo_w	bigint;	
nr_seq_motivo_novo_w	bigint;	
nr_seq_motivo_w		bigint;
nr_seq_micro_w		bigint;
nr_seq_micro_novo_w	bigint;
nr_atendimento_ant_w	bigint;
nr_seq_amostra_w	bigint;
nr_seq_amostra_novo_w	bigint;
ie_final_prec_atend_origem_w	varchar(1);
			
C01 CURSOR FOR
	SELECT	nr_sequencia
	from	atendimento_precaucao
	where	nr_atendimento = nr_atendimento_ant_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	((coalesce(dt_termino::text, '') = '') or (trunc(dt_termino) >= trunc(clock_timestamp())))
	and	coalesce(dt_inativacao::text, '') = ''
	and	ie_situacao = 'A'
	and coalesce(nr_atend_copia::text, '') = '';			
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	atend_precaucao_motivo
	where	nr_seq_atend_precaucao = nr_seq_precaucao_w;	
	
C03 CURSOR FOR
	SELECT	nr_sequencia
	from	atend_precaucao_micro
	where	nr_seq_atend_precaucao = nr_seq_precaucao_w;	
	
C04 CURSOR FOR
	SELECT	nr_sequencia
	from	atend_precaucao_amostra
	where	nr_seq_atend_precaucao = nr_seq_precaucao_w;	
	

BEGIN
select	max(nr_atendimento)
into STRICT	nr_atendimento_ant_w
from	atendimento_paciente
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	nr_atendimento <> nr_atendimento_p;

ie_final_prec_atend_origem_w := obter_param_usuario(916, 1207, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_final_prec_atend_origem_w);

open C01;
loop
fetch C01 into	
	nr_seq_precaucao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	nextval('atendimento_precaucao_seq')
	into STRICT	nr_seq_precaucao_novo_w
	;	
	
	insert into atendimento_precaucao(	
		nr_sequencia,
		dt_registro,
		nr_seq_precaucao,
		nm_usuario,
		dt_atualizacao,
		nr_atendimento,
		ie_situacao,
		dt_liberacao,
		nr_seq_motivo_isol,
		cd_medico_solic,
		dt_inicio,
		dt_termino,
		dt_fim_acompanhamento,
		ds_observacao,
		cd_topografia,
		cd_microorganismo,
		dt_final_precaucao,
		nm_usuario_nrec,
		dt_inativacao,
		ds_justificativa,
		ds_just_fim_prec,
		nm_usuario_inativacao,
		nm_usuario_fim,
		nm_usuario_lib_iso,
		dt_atualizacao_nrec,
		nr_seq_assinatura,
		ds_obs_lib_isolamento,
		nr_seq_assinat_inativacao,
		nr_seq_movto_termino
		)
	SELECT	nr_seq_precaucao_novo_w,
		dt_registro,
		nr_seq_precaucao,
		nm_usuario,
		dt_atualizacao,
		nr_atendimento_p,
		ie_situacao,
		dt_liberacao,
		nr_seq_motivo_isol,
		cd_medico_solic,
		dt_inicio,
		dt_termino,
		dt_fim_acompanhamento,
		ds_observacao,
		cd_topografia,
		cd_microorganismo,
		dt_final_precaucao,
		nm_usuario_nrec,
		dt_inativacao,
		ds_justificativa,
		ds_just_fim_prec,
		nm_usuario_inativacao,
		nm_usuario_fim,
		nm_usuario_lib_iso,
		dt_atualizacao_nrec,
		nr_seq_assinatura,
		ds_obs_lib_isolamento,
		nr_seq_assinat_inativacao,
		nr_seq_movto_termino
	from	atendimento_precaucao
	where	nr_sequencia = nr_seq_precaucao_w;
	
	if (coalesce(ie_final_prec_atend_origem_w, 'N') = 'S') then
		update	atendimento_precaucao
		set	nr_atend_copia = nr_atendimento_p,
				dt_termino = clock_timestamp(),
				dt_final_precaucao = clock_timestamp()
		where	nr_sequencia = nr_seq_precaucao_w;
	else
		update	atendimento_precaucao
		set	nr_atend_copia = nr_atendimento_p
		where	nr_sequencia = nr_seq_precaucao_w;
	end if;
		
	open C02;
	loop
	fetch C02 into	
		nr_seq_motivo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	nextval('atend_precaucao_motivo_seq')
		into STRICT	nr_seq_motivo_novo_w
		;
		
		insert into atend_precaucao_motivo(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_atend_precaucao,
			nr_seq_motivo_isol,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		SELECT	nr_seq_motivo_novo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_precaucao_novo_w,
			nr_seq_motivo_isol,
			clock_timestamp(),
			nm_usuario_p
		from	atend_precaucao_motivo
		where	nr_sequencia = nr_seq_motivo_w;
		end;
	end loop;
	close C02;	
		
	open C03;
	loop
	fetch C03 into	
		nr_seq_micro_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		
		select	nextval('atend_precaucao_micro_seq')
		into STRICT	nr_seq_micro_novo_w
		;
		
		insert into atend_precaucao_micro(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_atend_precaucao,
			cd_microorganismo,
			cd_topografia)
		SELECT	nr_seq_micro_novo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_precaucao_novo_w,
			cd_microorganismo,
			cd_topografia
		from	atend_precaucao_micro
		where	nr_sequencia = nr_seq_micro_w;
		
		end;
	end loop;
	close C03;	
		
		
	open C04;
	loop
	fetch C04 into	
		nr_seq_amostra_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
		select	nextval('atend_precaucao_amostra_seq')
		into STRICT	nr_seq_amostra_novo_w
		;
		
		insert into atend_precaucao_amostra(	
			nr_sequencia,
			cd_amostra_cultura,
			cd_topografia,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_atend_precaucao)
		SELECT	nr_seq_amostra_novo_w,
			cd_amostra_cultura,
			cd_topografia,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_precaucao_novo_w
		from	atend_precaucao_amostra
		where	nr_sequencia = nr_seq_amostra_w;					
		
		end;
	end loop;
	close C04;	
		
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_copiar_precaucao_atend ( cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
