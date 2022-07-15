-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_vl_desdob_conpaci_perc ( nr_interno_conta_ant_p bigint, nr_interno_conta_nova_p bigint, vl_desdobramento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
nr_seq_proc_conta_ant_w		bigint;
vl_medico_proc_ant_w		double precision;
vl_custo_oper_proc_ant_w	double precision;
nr_seq_proc_conta_nova_w	bigint;
vl_medico_proc_nova_w		double precision;
vl_custo_oper_proc_nova_w	double precision;
vl_diferenca_w			double precision;
			
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.vl_medico, 
		a.vl_custo_operacional 
	from	procedimento_paciente a, 
		conta_paciente b 
	where	a.nr_interno_conta = b.nr_interno_conta 
	and	b.nr_interno_conta = nr_interno_conta_ant_p 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	and	coalesce(a.nr_seq_proc_pacote::text, '') = '' 
	and	a.vl_procedimento <> 0 
	and	((a.vl_medico <> 0) or (a.vl_custo_operacional <> 0)) 
	order by	a.vl_procedimento;
	
C02 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.vl_medico, 
		a.vl_custo_operacional 
	from	procedimento_paciente a, 
		conta_paciente b 
	where	a.nr_interno_conta = b.nr_interno_conta 
	and	b.nr_interno_conta = nr_interno_conta_nova_p 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	and	coalesce(a.nr_seq_proc_pacote::text, '') = '' 
	and	a.vl_procedimento <> 0 
	and	((a.vl_medico <> 0) or (a.vl_custo_operacional <> 0)) 
	order by	a.vl_procedimento;


BEGIN 
 
if (coalesce(nr_interno_conta_ant_p,0) <> 0) and (coalesce(nr_interno_conta_nova_p,0) <> 0) then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_proc_conta_ant_w, 
		vl_medico_proc_ant_w, 
		vl_custo_oper_proc_ant_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		nr_seq_proc_conta_ant_w		:= nr_seq_proc_conta_ant_w;
		vl_medico_proc_ant_w		:= vl_medico_proc_ant_w;
		vl_custo_oper_proc_ant_w	:= vl_custo_oper_proc_ant_w;
		end;
	end loop;
	close C01;
	 
	if (coalesce(nr_seq_proc_conta_ant_w,0) <> 0) then 
	 
		open C02;
		loop 
		fetch C02 into	 
			nr_seq_proc_conta_nova_w, 
			vl_medico_proc_nova_w, 
			vl_custo_oper_proc_nova_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			nr_seq_proc_conta_nova_w	:= nr_seq_proc_conta_nova_w;
			vl_medico_proc_nova_w		:= vl_medico_proc_nova_w;
			vl_custo_oper_proc_nova_w	:= vl_custo_oper_proc_nova_w;
			end;
		end loop;
		close C02;
		 
		if (coalesce(nr_seq_proc_conta_nova_w,0) <> 0) then 
		 
			vl_diferenca_w	:= (obter_valor_conta(nr_interno_conta_ant_p,0) - vl_desdobramento_p);
			 
			update	procedimento_paciente 
			set	vl_procedimento = vl_procedimento - vl_diferenca_w 
			where	nr_sequencia = nr_seq_proc_conta_ant_w;
			 
			if (coalesce(vl_medico_proc_nova_w,0) <> 0) then 
			 
				update	procedimento_paciente 
				set	vl_procedimento = vl_procedimento + vl_diferenca_w, 
					vl_medico = vl_medico + vl_diferenca_w 
				where	nr_sequencia = nr_seq_proc_conta_nova_w;
			 
			elsif (coalesce(vl_custo_oper_proc_nova_w,0) <> 0) then 
			 
				update	procedimento_paciente 
				set	vl_procedimento = vl_procedimento + vl_diferenca_w, 
					vl_custo_operacional = vl_custo_operacional + vl_diferenca_w 
				where	nr_sequencia = nr_seq_proc_conta_nova_w;
			 
			end if;
		 
		end if;
	 
	end if;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_vl_desdob_conpaci_perc ( nr_interno_conta_ant_p bigint, nr_interno_conta_nova_p bigint, vl_desdobramento_p bigint, nm_usuario_p text) FROM PUBLIC;

