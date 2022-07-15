-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_procedimento ( nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nm_usuario_p text, nr_seq_proc_interno_p text ) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
dt_prescricao_w			timestamp;
cd_estabelecimento_w	bigint;
ie_kit_automatico_w		varchar(5);

cd_procedimento_w	prescr_procedimento.cd_procedimento%type;
ie_origem_proced_w	prescr_procedimento.ie_origem_proced%type;
nr_atendimento_w	prescr_medica.nr_atendimento%type;


BEGIN 
 
select	max(dt_prescricao), 
	max(cd_estabelecimento), 
	max(nr_atendimento) 
into STRICT 	dt_prescricao_w, 
	cd_estabelecimento_w, 
	nr_atendimento_w 
from 	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
ie_kit_automatico_w := Obter_Param_Usuario(998, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_kit_automatico_w);
 
select	coalesce(max(nr_sequencia), 0) + 1 
into STRICT	nr_sequencia_w 
from	prescr_procedimento 
where	nr_prescricao	= nr_prescricao_p;
 
cd_procedimento_w	:= cd_procedimento_p;
ie_origem_proced_w	:= ie_origem_proced_p;
 
if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then 
	SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_p, nr_prescricao_p, nr_atendimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
end if;
 
insert into prescr_procedimento( 
	nr_prescricao, 
	nr_sequencia, 
	cd_procedimento, 
	ie_origem_proced, 
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
	 nr_seq_proc_interno) 
values (nr_prescricao_p, 
	nr_sequencia_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	qt_procedimento_p, 
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
	nr_seq_proc_interno_p);
	 
commit;
 
CALL Gerar_med_mat_assoc(nr_prescricao_p,nr_sequencia_w);
	 
if (ie_kit_automatico_w = 'S') then 
	CALL Gerar_kit_procedimento(cd_estabelecimento_w, nr_prescricao_p, nr_sequencia_w, nm_usuario_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_procedimento ( nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nm_usuario_p text, nr_seq_proc_interno_p text ) FROM PUBLIC;

