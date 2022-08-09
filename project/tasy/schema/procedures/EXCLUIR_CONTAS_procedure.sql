-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_contas ( cd_estabelecimento_p bigint, dt_mes_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_interno_conta_w				bigint;
nr_contas_w						bigint;
dt_mes_inicial_w					timestamp;
dt_mes_final_w					timestamp;
nr_contas_commit_w				bigint;
nr_Processos_ok_w					bigint		:= 0;
nr_processos_w					bigint		:= 0;

c01 CURSOR FOR
	SELECT /*+ ordered*/		nr_interno_conta
	from	conta_paciente a,
		atendimento_paciente b
	where  b.cd_estabelecimento	= cd_estabelecimento_p
	  and  a.nr_atendimento		= b.nr_atendimento
        and  a.dt_mesano_referencia between dt_mes_inicial_w and dt_mes_final_w;


BEGIN
dt_mes_inicial_w				:= pkg_date_utils.start_of(dt_mes_referencia_p,'MONTH',0);
dt_mes_final_w				:= trunc(pkg_date_utils.end_of((dt_mes_referencia_p), 'MONTH', 0));
if (dt_mes_referencia_p > PKG_DATE_UTILS.GET_DATETIME(pkg_date_utils.add_month(pkg_date_utils.end_of(clock_timestamp(),'MONTH', 0), -13,0), clock_timestamp())) then
	begin
	-- Nao e permitido limpar os ultimos 12 meses fechados
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(233023);	
	end;
end if;

select /*+ ordered*/ count(*)
into STRICT nr_contas_w
from	conta_paciente a,
	atendimento_paciente b
where  b.cd_estabelecimento	= cd_estabelecimento_p
  and  a.nr_atendimento		= b.nr_atendimento
  and  a.dt_mesano_referencia between dt_mes_inicial_w and dt_mes_final_w;

nr_processos_w				:= Trunc(nr_contas_w / 200) + 1;
nr_contas_w					:= 0;
WHILE nr_processos_ok_w <= nr_processos_w LOOP
	begin
	nr_contas_commit_w			:= 0;
	open c01;
	loop
	fetch c01 into nr_interno_conta_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_contas_commit_w		:= nr_contas_commit_w + 1;
		if (nr_contas_commit_w > 200) then
			exit;
		end if;
		update material_atend_paciente
		set 	nr_prescricao 		 = NULL,
			nr_sequencia_prescricao	 = NULL,
			cd_local_estoque		 = NULL,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nr_seq_proc_princ		 = NULL
		where nr_interno_conta 		= nr_interno_conta_w;
		delete from material_atend_paciente
		where nr_interno_conta = nr_interno_conta_w;

		update procedimento_paciente
		set 	nr_prescricao 		 = NULL,
			nr_sequencia_prescricao  = NULL,
			nr_seq_proc_princ		 = NULL,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nr_seq_proc_pacote	 = NULL
		where nr_interno_conta 	= nr_interno_conta_w;
		delete from procedimento_paciente
		where nr_interno_conta = nr_interno_conta_w;

        delete from conta_paciente_resumo_imp imp
		where imp.nr_interno_conta = nr_interno_conta_w;
		delete from conta_paciente_resumo
		where nr_interno_conta = nr_interno_conta_w;

		delete from conta_paciente
		where nr_interno_conta = nr_interno_conta_w;
		nr_contas_w				:= nr_contas_w + 1;
		end;
	end loop;
	close c01;
	commit;
	end;
END LOOP;
delete from protocolo_convenio a
where a.dt_mesano_referencia between dt_mes_inicial_w and dt_mes_final_w
  and not exists (SELECT 1
   from conta_paciente b
   where a.nr_seq_protocolo = b.nr_seq_protocolo);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_contas ( cd_estabelecimento_p bigint, dt_mes_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
