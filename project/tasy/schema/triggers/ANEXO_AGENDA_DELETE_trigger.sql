-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS anexo_agenda_delete ON anexo_agenda CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_anexo_agenda_delete() RETURNS trigger AS $BODY$
declare
 
nr_seq_evento_w		bigint;
qt_idade_w		bigint;
cd_convenio_w		bigint;
cd_medico_w		varchar(15);
cd_pessoa_fisica_w	varchar(15);
ie_sexo_w		varchar(15);
nr_seq_proc_interno_w	bigint;
ie_evento_w		varchar(15);
cd_estabelecimento_w	smallint;
cd_agenda_w		bigint;
hr_inicio_w		timestamp;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
dt_cancelamento_w	timestamp;
cd_motivo_cancel_w	varchar(15);
nr_atendimento_w	bigint;
ds_observacao_w		varchar(255);
 
 
c01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento		= cd_estabelecimento_w 
	and	ie_evento_disp			= 'EAN' 
	and	coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999) 
	and	coalesce(ie_sexo,coalesce(ie_sexo_w,'XPTO')) = coalesce(ie_sexo_w,'XPTO') 
	and	coalesce(cd_medico,coalesce(cd_medico_w,'0')) = coalesce(cd_medico_w,'0') 
	and (obter_se_convenio_rec_alerta(cd_convenio_w,nr_sequencia) = 'S') 
	and (obter_se_proc_rec_alerta(nr_seq_proc_interno_w,nr_sequencia,cd_procedimento_w,ie_origem_proced_w) = 'S') 
	and (obter_se_regra_envio(nr_sequencia,nr_atendimento_w) = 'S') 
	and (obter_classif_regra(nr_sequencia,coalesce(obter_classificacao_pf(cd_pessoa_fisica_w),0)) = 'S') 
	and	coalesce(ie_situacao,'A') = 'A';
	--and	(obter_se_mat_rec_alerta(cd_material_w,nr_sequencia) = 'S')	 
BEGIN
  BEGIN 
 
BEGIN 
 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
select	cd_pessoa_fisica, 
	coalesce(obter_idade_pf(cd_pessoa_fisica,LOCALTIMESTAMP,'A'),coalesce(qt_idade_paciente,0)), 
	Obter_Sexo_PF(cd_pessoa_fisica,'C'), 
	cd_medico, 
	cd_convenio, 
	nr_seq_proc_interno, 
	cd_agenda, 
	hr_inicio, 
	cd_procedimento, 
	ie_origem_proced, 
	dt_cancelamento, 
	cd_motivo_cancelamento, 
	nr_atendimento, 
	substr(ds_observacao,1,255) 
into STRICT	cd_pessoa_fisica_w, 
	qt_idade_w, 
	ie_sexo_w, 
	cd_medico_w, 
	cd_convenio_w, 
	nr_seq_proc_interno_w, 
	cd_agenda_w, 
	hr_inicio_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	dt_cancelamento_w, 
	cd_motivo_cancel_w, 
	nr_atendimento_w, 
	ds_observacao_w 
from	agenda_paciente 
where	nr_sequencia = OLD.nr_seq_agenda;	
 
 
 
open c01;
loop 
fetch c01 into 
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN 
	CALL gerar_evento_agenda_trigger(	nr_seq_evento_w, 
					null, 
					cd_pessoa_fisica_w, 
					null, 
					OLD.nm_usuario, 
					cd_agenda_w, 
					hr_inicio_w, 
					cd_medico_w, 
					cd_procedimento_w, 
					ie_origem_proced_w, 
					dt_cancelamento_w, 
					null, 
					null, 
					null, 
					cd_convenio_w, 
					cd_motivo_cancel_w, 
					'S', 
					null, 
					null, 
					null, 
					null, 
					null, 
					ds_observacao_w);
	end;
end loop;
close c01;
 
exception 
when others then 
	cd_estabelecimento_w	:= 0;
end;
	 
  END;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_anexo_agenda_delete() FROM PUBLIC;

CREATE TRIGGER anexo_agenda_delete
	BEFORE DELETE ON anexo_agenda FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_anexo_agenda_delete();
