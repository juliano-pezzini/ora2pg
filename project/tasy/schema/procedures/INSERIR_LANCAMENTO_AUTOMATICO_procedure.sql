-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_lancamento_automatico ( nr_prescricao_p bigint, nr_cirurgia_p bigint, nr_seq_proc_interno_p bigint, cd_material_p bigint, qt_material_p bigint, qt_procedimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ie_forma_lancto_p text, ie_insert_p INOUT text, nr_seq_regra_pepo_p bigint default null) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
dt_prescricao_w		timestamp;
cd_estabelecimento_w	smallint;
nr_atendimento_w		bigint;
cd_local_estoque_w	smallint;
											

BEGIN 
 
ie_insert_p	:= 'N';
 
select	cd_estabelecimento, 
	nr_atendimento 
into STRICT	cd_estabelecimento_w, 
	nr_atendimento_w 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_p;
 
if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then 
	SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_p, nr_prescricao_p, null, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
end if;
 
if (ie_forma_lancto_p in ('C','CE')) then 
	ie_insert_p	:= 'S';
	cd_local_estoque_w := cd_local_estoque_p;
	if (ie_forma_lancto_p = 'CE') then 
		cd_local_estoque_w := null;
	end if;
 
	CALL gerar_lancto_automatico_conta(nr_atendimento_w, nr_cirurgia_p, cd_material_p, qt_material_p, cd_local_estoque_w, nr_seq_proc_interno_p, 
			cd_procedimento_w, ie_origem_proced_w, qt_procedimento_p, nm_usuario_p,null,null, nr_seq_regra_pepo_p);
 
elsif (ie_forma_lancto_p = 'P')	then 
 
	if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
 
		select	coalesce(max(nr_sequencia), 0) + 1 
		into STRICT	nr_sequencia_w 
		from	prescr_procedimento 
		where	nr_prescricao = nr_prescricao_p;
		 
		select	dt_prescricao 
		into STRICT 	dt_prescricao_w 
		from 	prescr_medica 
		where 	nr_prescricao = nr_prescricao_p;
		 
		ie_insert_p	:= 'S';
		 
		insert into prescr_procedimento( 
			nr_prescricao, 
			nr_sequencia, 
			nr_seq_proc_interno, 
			cd_procedimento, 
			ie_origem_proced, 
			cd_medico_exec, 
			qt_procedimento, 
			ie_urgencia, 
			ie_suspenso, 
			dt_prev_execucao, 
			ie_status_atend, 
			dt_atualizacao, 
			nm_usuario, 
			ie_origem_inf, 
			nr_seq_interno, 
			ie_avisar_result, 
			cd_motivo_baixa, 
			nr_seq_regra_pepo) 
		values (	nr_prescricao_p, 
			nr_sequencia_w, 
			nr_seq_proc_interno_p, 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'), 
			coalesce(qt_procedimento_p,0), 
			'N', 
			'N', 
			dt_prescricao_w, 
			5, 
			clock_timestamp(), 
			nm_usuario_p, 
			'1', 
			nextval('prescr_procedimento_seq'), 
			'N', 
			0, 
			CASE WHEN nr_seq_regra_pepo_p=0 THEN null  ELSE nr_seq_regra_pepo_p END );
		commit;
		 
	end if;	
 
	if (cd_material_p IS NOT NULL AND cd_material_p::text <> '')	then 
		ie_insert_p	:= 'S';
		CALL gravar_mat_adic_barras(nr_prescricao_p, null, cd_material_p, cd_local_estoque_p, qt_material_p, nm_usuario_p, cd_estabelecimento_w, 'GI',null,null,null,null,null,null,'N',nr_seq_regra_pepo_p);
	end if;
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_lancamento_automatico ( nr_prescricao_p bigint, nr_cirurgia_p bigint, nr_seq_proc_interno_p bigint, cd_material_p bigint, qt_material_p bigint, qt_procedimento_p bigint, cd_local_estoque_p bigint, nm_usuario_p text, ie_forma_lancto_p text, ie_insert_p INOUT text, nr_seq_regra_pepo_p bigint default null) FROM PUBLIC;
