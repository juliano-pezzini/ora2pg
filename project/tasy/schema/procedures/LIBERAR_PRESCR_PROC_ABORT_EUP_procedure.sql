-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescr_proc_abort_eup (nr_prescricao_p bigint, nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, qt_prescr_proced_p INOUT bigint, ds_consistencia_p INOUT text, qt_pep_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_agrupa_fleury_p INOUT text, ds_prescr_fleury_p INOUT text, ds_pr_fleury_p INOUT text, ds_evento_pri_p INOUT text, ds_evento_sec_p INOUT text, ds_evento_ter_p INOUT text, ie_autorizacao_p INOUT text, nr_seq_agenda_pac_p INOUT bigint, nr_seq_agenda_cons_p INOUT bigint, ie_tipo_agenda_p INOUT text, ds_imprimir_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

										 
qt_pep_pac_ci_w		bigint;


BEGIN 
 
select	count(*) 
into STRICT	qt_prescr_proced_p 
from	prescr_procedimento 
where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '') 
and		nr_prescricao = nr_prescricao_p;
 
ds_consistencia_p := wheb_mensagem_pck.get_texto(110218);
 
select 	count(*) 
into STRICT	qt_pep_p 
from 	pep_pac_ci 
where 	(ds_texto IS NOT NULL AND ds_texto::text <> '') 
and  	(nr_seq_agenda IS NOT NULL AND nr_seq_agenda::text <> '') 
and		nr_seq_agenda = nr_seq_agenda_p;
 
ds_imprimir_p := wheb_mensagem_pck.get_texto(110315);
 
SELECT 	COUNT(*) 
into STRICT	qt_pep_pac_ci_w 
FROM 	pep_pac_ci 
WHERE	nr_seq_agenda = nr_seq_agenda_p;
 
if (qt_pep_pac_ci_w > 0) then 
	select 	coalesce(nr_sequencia,0) 
	into STRICT	nr_sequencia_p 
	from 	pep_pac_ci 
	where	nr_seq_agenda = nr_seq_agenda_p;
end if;
 
select 	coalesce(max(ie_agrupa_ficha_fleury),'N') 
into STRICT	ie_agrupa_fleury_p 
from 	lab_parametro a 
where 	a.cd_estabelecimento = cd_estabelecimento_p;
 
select 	obter_se_int_prescr_fleury(nr_prescricao_p), 
		obter_se_int_pr_fleury_diag(nr_prescricao_p) 
into STRICT	ds_prescr_fleury_p, 
		ds_pr_fleury_p
;
 
ds_evento_pri_p := obter_se_existe_evento(106);
 
ds_evento_sec_p := obter_se_existe_evento(148);
 
ds_evento_ter_p := obter_se_existe_evento(128);
 
select 	max(ie_autorizacao_eup) 
into STRICT	ie_autorizacao_p 
from 	convenio_estabelecimento 
where 	cd_convenio 		= cd_convenio_p 
and 	cd_estabelecimento 	= cd_estabelecimento_p;
 
select coalesce(max(nr_seq_agenda),0) nr_seq_agenda_pac, 
		coalesce(max(nr_seq_agecons),0) nr_seq_agenda_cons, 
		coalesce(max(obter_tipo_agenda_seq(nr_seq_agenda, 'E')),0) ie_tipo_agenda 
into STRICT	nr_seq_agenda_pac_p, 
		nr_seq_agenda_cons_p, 
		ie_tipo_agenda_p 
from  prescr_medica 
where  nr_prescricao = nr_prescricao_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescr_proc_abort_eup (nr_prescricao_p bigint, nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, qt_prescr_proced_p INOUT bigint, ds_consistencia_p INOUT text, qt_pep_p INOUT bigint, nr_sequencia_p INOUT bigint, ie_agrupa_fleury_p INOUT text, ds_prescr_fleury_p INOUT text, ds_pr_fleury_p INOUT text, ds_evento_pri_p INOUT text, ds_evento_sec_p INOUT text, ds_evento_ter_p INOUT text, ie_autorizacao_p INOUT text, nr_seq_agenda_pac_p INOUT bigint, nr_seq_agenda_cons_p INOUT bigint, ie_tipo_agenda_p INOUT text, ds_imprimir_p INOUT text, nm_usuario_p text) FROM PUBLIC;
