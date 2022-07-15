-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_sala_fanep ( nr_atendimento_p bigint, nr_seq_processo_p bigint, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_entrada_unidade_w	timestamp;
qt_atendimento_w	bigint;
qt_passagem_w		bigint;
nr_sequencia_w		bigint;
nr_seq_interno_w	bigint := null;
nr_seq_interno_origem_w	bigint;
ie_obriga_inf_sala_w	varchar(1);
nr_prescricao_w		bigint;
					

BEGIN 
 
/*obter_param_usuario(10026, 34, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_obriga_inf_sala_w);*/
 
 
select	count(*) 
into STRICT	qt_atendimento_w 
from	atendimento_paciente 
where	(dt_fim_conta IS NOT NULL AND dt_fim_conta::text <> '') 
and	nr_atendimento		= nr_atendimento_p;
 
if (qt_atendimento_w > 0) then 
	--Esse atendimento possui conta fechada!#@#@ 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263473);
end if;
 
select	count(*) 
into STRICT	qt_passagem_w 
from	atend_paciente_unidade 
where	nr_atendimento 		= nr_atendimento_p 
and	dt_entrada_unidade 	= dt_inicio_real_p;
 
if (qt_passagem_w > 0) then 
	-- Já existe uma passagem de setor com esta data de entrada. ' || chr(10) ||Favor verificar a Movimentação de Pacientes ou informar outra data! #@#@' 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263474);
end if;
 
if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then 
 
	/* Gerar nova passagem */
 
	select	coalesce(max(nr_sequencia),0) + 1 
	into STRICT	nr_sequencia_w 
	from	atend_paciente_unidade 
	where	nr_atendimento		= nr_atendimento_p;
 
	select	nextval('atend_paciente_unidade_seq') 
	into STRICT	nr_seq_interno_w 
	;
 
	insert	into atend_paciente_unidade(nr_atendimento, 
		nr_sequencia, 
		cd_setor_atendimento, 
		cd_unidade_basica, 
		cd_unidade_compl, 
		dt_entrada_unidade, 
		dt_atualizacao, 
		nm_usuario, 
		nr_atend_dia, 
		ds_observacao, 
		nm_usuario_original, 
		ie_passagem_setor, 
		nr_acompanhante, 
		nr_seq_interno, 
		ie_calcular_dif_diaria, 
		nr_seq_motivo_transf) 
	values (nr_atendimento_p, 
		nr_sequencia_w, 
		cd_setor_atendimento_p, 
		cd_unidade_basica_p, 
		cd_unidade_compl_p, 
		dt_inicio_real_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		null, 
		null, 
		nm_usuario_p, 
		'S', 
		null, 
		nr_seq_interno_w, 
		'S', 
		null);
end if;
 
	update	pepo_cirurgia 
	set	nr_atendimento		= nr_atendimento_p, 
		dt_inicio_proced	= dt_inicio_real_p, 
		nr_seq_atepacu		= nr_seq_interno_w, 
		cd_setor_atendimento	= cd_setor_atendimento_p 
	where	nr_sequencia		= nr_seq_processo_p;
	 
	select	max(nr_prescricao) 
	into STRICT	nr_prescricao_w 
	from	pepo_cirurgia 
	where	nr_sequencia = nr_seq_processo_p;
	if (coalesce(nr_prescricao_w::text, '') = '') then 
		nr_prescricao_w := Gerar_prescr_Fanep(cd_estabelecimento_p, nr_seq_processo_p, nm_usuario_p, nr_prescricao_w);
		if (coalesce(nr_prescricao_w,0) > 0) then 
			update	pepo_cirurgia 
			set	nr_prescricao		= nr_prescricao_w, 
				nm_usuario 		= nm_usuario_p 
			where	nr_sequencia 		= nr_seq_processo_p;
		end if;
	end if;
	 
	commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_sala_fanep ( nr_atendimento_p bigint, nr_seq_processo_p bigint, dt_inicio_real_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

