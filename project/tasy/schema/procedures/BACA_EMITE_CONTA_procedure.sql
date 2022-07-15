-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_emite_conta ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_proc_mat_p bigint) AS $body$
DECLARE

 
/* 
Ie_proc_mat_p 
 
0 - Ambos 
1 - Procedimento 
2 - Material 
*/
 
 
nr_interno_conta_w		bigint;
ie_tipo_atendimento_w	smallint;

nr_sequencia_w		bigint;
cd_convenio_w			integer;
cd_categoria_w		varchar(10);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_medico_executor_w		varchar(10);
cd_regra_honorario_w		varchar(5);
cd_setor_atendimento_w	integer;
cd_especialidade_medica_w 	integer;
dt_procedimento_w		timestamp;
cd_cgc_prestador_w		varchar(14);

cd_estrutura_w		integer;
cd_material_w			integer;
cd_estrutura_honor_w		integer;
ie_emite_conta_w		varchar(3);
ie_emite_conta_honor_w	varchar(3);

C01 CURSOR FOR 
	SELECT nr_interno_conta, 
		ie_tipo_atendimento 
	from 	atendimento_paciente b, 
		conta_paciente a 
	where nr_seq_protocolo = nr_seq_protocolo_p 
	 and nr_interno_conta = coalesce(nr_interno_conta_p, nr_interno_conta) 
	 and a.nr_atendimento = b.nr_atendimento 
	order by 1;

C02 CURSOR FOR 
	SELECT nr_sequencia, 
		CD_CONVENIO, 
    	CD_CATEGORIA, 
		CD_PROCEDIMENTO, 
		IE_ORIGEM_PROCED, 
	    CD_MEDICO_EXECUTOR, 
		ie_responsavel_credito, 
		CD_SETOR_ATENDIMENTO, 
		cd_especialidade, 
		DT_PROCEDIMENTO, 
		cd_cgc_prestador 
	FROM 	PROCEDIMENTO_PACIENTE 
	WHERE 	nr_interno_conta = nr_interno_conta_w 
	order by 1;

c03 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_convenio, 
		cd_categoria, 
		cd_material, 
		cd_setor_atendimento		 
	from	material_atend_paciente 
	where	nr_interno_conta = nr_interno_conta_w 
	order by 1;


BEGIN 
 
open C01;
loop 
	fetch C01 into	nr_interno_conta_w, 
				ie_tipo_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
	if (ie_proc_mat_p  (0,1)) then 
	begin 
	 
	open C02;
	loop 
		fetch C02 into nr_sequencia_w, 
				cd_convenio_w, 
				cd_categoria_w, 
				cd_procedimento_w, 
				ie_origem_proced_w, 
				cd_medico_executor_w, 
				cd_regra_honorario_w, 
				cd_setor_atendimento_w, 
				cd_especialidade_medica_w, 
				dt_procedimento_w, 
				cd_cgc_prestador_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		 
		/* Obter estrutura de emissão da conta paciente nova */
 
		cd_estrutura_w			:= 0;
		cd_estrutura_honor_w			:= 0;
		SELECT * FROM Obter_Estrut_Conta_Proc( 
			cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, null, cd_medico_executor_w, cd_regra_honorario_w, nr_sequencia_w, cd_setor_atendimento_w, ie_tipo_atendimento_w, 1, cd_especialidade_medica_w, cd_categoria_w, dt_procedimento_w, cd_cgc_prestador_w, cd_estrutura_w, cd_estrutura_honor_w) INTO STRICT cd_estrutura_w, cd_estrutura_honor_w;
 
		ie_emite_conta_w			:= null;
		ie_emite_conta_honor_w		:= null;
		if (cd_estrutura_w		> 0) then 
			ie_emite_conta_w		:= cd_estrutura_w;
		end if;
		if (cd_estrutura_honor_w	> 0) then 
			ie_emite_conta_honor_w	:= cd_estrutura_honor_w;
		end if;
 
		UPDATE PROCEDIMENTO_PACIENTE 
		SET 	IE_EMITE_CONTA	= IE_EMITE_CONTA_W, 
			IE_EMITE_CONTA_HONOR	= IE_EMITE_CONTA_HONOR_W 
		WHERE 	NR_SEQUENCIA   	= NR_SEQUENCIA_w;
	end loop;
	close C02;
	end;
	end if;
 
--Anderson inclui o c03 21/03/2006 - OS 30578 
 
	if (ie_proc_mat_p in (0,2)) then 
	begin 
 
	open c03;
	loop 
		fetch c03 into nr_sequencia_w, 
				cd_convenio_w, 
				cd_categoria_w, 
				cd_material_w, 
				cd_setor_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
 
		/* Obter estrutura de emissão da conta paciente nova */
 
		cd_estrutura_w		:= 0;
 
		cd_estrutura_w := Obter_Estrut_Conta_Mat( 
			cd_convenio_w, cd_material_w, cd_setor_atendimento_w, ie_tipo_atendimento_w, null, 1, cd_estrutura_w);
 
		ie_emite_conta_w			:= null;
		if (cd_estrutura_w		> 0) then 
			ie_emite_conta_w		:= cd_estrutura_w;
		end if;
 
		UPDATE MATERIAL_ATEND_PACIENTE 
		SET 	IE_EMITE_CONTA		= IE_EMITE_CONTA_W 
		WHERE 	NR_SEQUENCIA   		= NR_SEQUENCIA_w;
		 
	end loop;
	close c03;
 
	end;
	end if;
 
end loop;
close C01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_emite_conta ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, ie_proc_mat_p bigint) FROM PUBLIC;

