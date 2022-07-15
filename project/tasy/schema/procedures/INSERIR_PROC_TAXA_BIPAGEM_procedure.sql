-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_proc_taxa_bipagem (nr_cirurgia_p bigint, nr_prescricao_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
					 
nr_sequencia_w		integer;					
cd_procedimento_w		varchar(255);
ie_origem_proced_w		varchar(1);
nr_atendimento_w	bigint;
					

BEGIN 
begin 
 
cd_procedimento_w := coalesce(cd_procedimento_p,0);
ie_origem_proced_w := coalesce(ie_origem_proced_p,0);
 
select nr_atendimento 
into STRICT nr_atendimento_w 
from cirurgia 
where nr_cirurgia = nr_cirurgia_p;
 
if ((cd_procedimento_w = 0 or ie_origem_proced_w = 0) AND nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
	SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_p, 0, nr_atendimento_w, 0, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
end if;
 
 
 
 
if (coalesce(nr_seq_proc_interno_p,0) > 0) then 
 
	if (coalesce(nr_prescricao_p,0) > 0) then 
		select	max(nr_sequencia) + 1 
		into STRICT	nr_sequencia_w 
		from 	prescr_procedimento 
		where 	nr_prescricao = nr_prescricao_p;
	end if;
 
 
	insert into prescr_procedimento( 
			nr_prescricao, 
			nr_sequencia, 
			nr_seq_proc_interno, 
			cd_procedimento, 
			ie_origem_proced, 
			qt_procedimento, 
			ie_urgencia, 
			ie_suspenso, 
			dt_atualizacao, 
			nm_usuario, 
			ie_origem_inf, 
			ie_avisar_result, 
			cd_motivo_baixa) 
		values (nr_prescricao_p, 
			coalesce(nr_sequencia_w,1), 
			nr_seq_proc_interno_p, 
			cd_procedimento_w, 
			1, 
			1, 
			'N', 
			'N', 
			clock_timestamp(), 
			nm_usuario_p, 
			'1', 
			'N', 
			0);
			 
			 
	commit;
 
end if;
 
 
 
exception 
when others then 
	null;
end;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_proc_taxa_bipagem (nr_cirurgia_p bigint, nr_prescricao_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text) FROM PUBLIC;

