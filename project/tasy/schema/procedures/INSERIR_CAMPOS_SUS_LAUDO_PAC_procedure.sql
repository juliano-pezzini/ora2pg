-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_campos_sus_laudo_pac ( nr_atendimento_p bigint, nr_laudo_sus_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_evolucao_w			evolucao_paciente.cd_evolucao%type;
ds_condicao_justificativa_w		varchar(32764);
cd_medico_requisitante_w		evolucao_paciente.cd_medico%type;
dt_pri_dialise_w			sus_laudo_paciente.dt_pri_dialise%type;
nr_seq_exame_w			sus_regra_exame_result.nr_seq_exame%type;
nr_seq_resultado_w			exame_lab_result_item.nr_seq_resultado%type;
nr_seq_resultado_ww		bigint;
qt_altura_cm_w			sus_laudo_paciente.qt_altura_cm%type;
qt_peso_w			sus_laudo_paciente.qt_peso%type;
qt_resultado_w			double precision;
qt_glicose_w			sus_laudo_paciente.qt_glicose%type;
pr_albumina_w			sus_laudo_paciente.pr_albumina%type;
pr_hb_w				sus_laudo_paciente.pr_hb%type;
ie_tipo_resultado_w			sus_regra_exame_result.ie_tipo_resultado%type;
ds_sql_w				varchar(2000);
qt_medico_w			bigint := 0;
cd_tipo_evolucao_w		varchar(3);
nr_tru_w				sus_laudo_paciente.nr_tru%type;
qt_diurese_w			sus_laudo_paciente.qt_diurese%type;
qt_fosforo_w			sus_laudo_paciente.qt_fosforo%type;
qt_ktv_semanal_w		sus_laudo_paciente.qt_ktv_semanal%type;
qt_pth_w			sus_laudo_paciente.qt_pth%type;

C01 CURSOR FOR 
	SELECT	nr_seq_exame, 
		ie_tipo_resultado 
	from 	sus_regra_exame_result;


BEGIN 
 
cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_p,'C');
 
begin 
cd_tipo_evolucao_w := Obter_Valor_Param_Usuario(281,413,Obter_perfil_Ativo, nm_usuario_p, 0);
exception 
when no_data_found then 
	cd_tipo_evolucao_w := null;
end;
 
if (cd_tipo_evolucao_w IS NOT NULL AND cd_tipo_evolucao_w::text <> '') then 
	select	coalesce(max(cd_evolucao),0) 
	into STRICT	cd_evolucao_w 
	from	evolucao_paciente 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	ie_evolucao_clinica = cd_tipo_evolucao_w;
else 
	select	coalesce(max(cd_evolucao),0) 
	into STRICT	cd_evolucao_w 
	from	evolucao_paciente 
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;
end if;
 
if (cd_evolucao_w > 0) then 
	select	max(cd_medico) 
	into STRICT	cd_medico_requisitante_w 
	from 	evolucao_paciente 
	where	cd_evolucao = cd_evolucao_w;
 
	ds_sql_w	:= substr('select ds_evolucao from evolucao_paciente where cd_evolucao	= :cd_evolucao',1,2000);
	 
	begin	 
	nr_seq_resultado_ww := converte_rtf_string(ds_sql_w, cd_evolucao_w, 'Tasy', nr_seq_resultado_ww);
	exception 
		when others then 
			nr_seq_resultado_ww := 0;
		end;
	 
	begin 
	select	substr(ds_texto_clob,1,2000) 
	into STRICT	ds_condicao_justificativa_w 
	from	tasy_conversao_rtf 
	where	nr_sequencia		= nr_seq_resultado_ww;
	exception 
		when no_data_found then 
			ds_condicao_justificativa_w := null;
		end;
 
end if;
 
select	max(dt_inicio_tratamento) 
into STRICT	dt_pri_dialise_w 
from	hd_pac_renal_cronico 
where	cd_pessoa_fisica = cd_pessoa_fisica_w;
 
select	coalesce(max(qt_altura_cm),0), 
	coalesce(max(qt_peso),0) 
into STRICT	qt_altura_cm_w, 
	qt_peso_w 
from 	atendimento_sinal_vital 
where	nr_atendimento = nr_atendimento_p;
 
open C01;
loop 
fetch C01 into 
	nr_seq_exame_w, 
	ie_tipo_resultado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	max(a.nr_seq_resultado) 
	into STRICT	nr_seq_resultado_w 
	from	exame_lab_result_item a, 
		exame_lab_resultado b, 
		prescr_medica c 
	where	a.nr_seq_resultado		= b.nr_seq_resultado 
	and	b.nr_prescricao		= c.nr_prescricao 
	and	c.cd_pessoa_fisica		= cd_pessoa_fisica_w 
	and	a.nr_seq_exame 		= nr_seq_exame_w;
 
	if (ie_tipo_resultado_w = 'G') then 
		begin 
		 
		select	coalesce(max(qt_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		qt_glicose_w := qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'A') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		pr_albumina_w := qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'H') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		pr_hb_w	:= qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'D') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		qt_diurese_w := qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'T') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		nr_tru_w	:= qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'F') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		qt_fosforo_w	:= qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'K') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		qt_ktv_semanal_w	:= qt_resultado_w;
		 
		end;
	elsif (ie_tipo_resultado_w = 'P') then 
		begin 
		 
		select	coalesce(max(pr_resultado),0) 
		into STRICT	qt_resultado_w 
		from	exame_lab_result_item 
		where	nr_seq_resultado = nr_seq_resultado_w;
		 
		qt_pth_w	:= qt_resultado_w;
		 
		end;
	end if;
	end;
end loop;
close C01;
 
select	count(1) 
into STRICT	qt_medico_w 
from	medico 
where	cd_pessoa_fisica = cd_medico_requisitante_w  LIMIT 1;
 
if (qt_medico_w = 0) then 
	cd_medico_requisitante_w := null;
end if;
 
update 	sus_laudo_paciente 
set	ds_condicao_justifica  	= substr(ds_condicao_justificativa_w,1,1999), 
	cd_medico_requisitante	= cd_medico_requisitante_w, 
	dt_pri_dialise		= dt_pri_dialise_w, 
	qt_altura_cm		= qt_altura_cm_w, 
	qt_peso			= qt_peso_w, 
	qt_glicose		= qt_glicose_w, 
	pr_albumina		= pr_albumina_w, 
	pr_hb			= pr_hb_w, 
	qt_diurese		= qt_diurese_w, 
	nr_tru			= nr_tru_w, 
	qt_fosforo		= qt_fosforo_w, 
	qt_ktv_semanal		= qt_ktv_semanal_w, 
	qt_pth			= qt_pth_w 
where	nr_atendimento 		= nr_atendimento_p 
and	nr_laudo_sus 		= nr_laudo_sus_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_campos_sus_laudo_pac ( nr_atendimento_p bigint, nr_laudo_sus_p bigint, nm_usuario_p text) FROM PUBLIC;

