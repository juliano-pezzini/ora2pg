-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_obter_dados_instalar_pac ( cd_pessoa_fisica_p text, cd_tipo_evolucao_p text, nr_seq_dialise_p bigint, cd_estabelecimento_p bigint, ie_peso_ideal_prescr_p text, ds_evolucao_p INOUT text, dt_evolucao_p INOUT text, nr_seq_exame_hematocrito_p INOUT bigint, qt_altura_cm_p INOUT text, qt_idade_p INOUT text, ds_sexo_p INOUT text, ds_tempo_p INOUT text, ds_ult_resultado_p INOUT text, qt_pa_sist_pre_pe_p INOUT bigint, qt_pa_diast_pre_pe_p INOUT bigint, qt_pa_sist_pre_deitado_p INOUT bigint, qt_pa_diast_pre_deitado_p INOUT bigint, qt_peso_pre_p INOUT bigint, qt_soro_reposicao_p INOUT bigint, qt_soro_devolucao_p INOUT bigint, qt_peso_ideal_p INOUT bigint, qt_fluxo_sangue_p INOUT text, ds_duracao_p INOUT text, ds_ultrafiltracao_p INOUT text, ds_heparina_retorno_p INOUT text, ds_protocolo_p INOUT text, ds_agulha_p INOUT text, ie_pode_pesar_p INOUT text, nr_seq_motivo_peso_pac_p INOUT bigint, nr_seq_motivo_pa_pre_sentado_p INOUT bigint, nr_seq_motivo_pa_pre_pe_p INOUT bigint, dif_peso_ideal_atual_p INOUT bigint, qt_perc_gpid_p INOUT bigint, dt_dialise_retro_p INOUT text, ie_tipo_dialise_p INOUT text, qt_ultrafiltracao_p INOUT bigint, nr_seq_ultra_p INOUT text, nr_seq_mod_dialisador_p INOUT bigint, ie_tipo_hemodialise_p INOUT text, qt_sodio_p INOUT bigint, qt_bicarbonato_p INOUT bigint, qt_dose_p INOUT text, unidade_medida_p INOUT text) AS $body$
DECLARE


ds_evolucao_w			text;
dt_evolucao_w			timestamp;
nr_seq_exame_hematocrito_w	bigint;
qt_altura_cm_w			varchar(255);
qt_idade_w			varchar(255);
ds_sexo_w			varchar(100);
ds_tempo_w			varchar(255);
ds_ult_resultado_w		varchar(255);
qt_pa_sist_pre_pe_w		smallint;
qt_pa_diast_pre_pe_w		smallint;
qt_pa_sist_pre_deitado_w	smallint;
qt_pa_diast_pre_deitado_w	smallint;
qt_peso_pre_w			real;
qt_soro_reposicao_w		bigint;
qt_soro_devolucao_w	 	bigint;
qt_peso_ideal_w			real;
qt_fluxo_sangue_w		varchar(255);
ds_duracao_w			varchar(255);
ds_ultrafiltracao_w		varchar(255);
ds_heparina_retorno_w		varchar(255);
ds_protocolo_w			varchar(60);
ds_agulha_w			varchar(60);
ie_pode_pesar_w			varchar(1);
nr_seq_motivo_peso_pac_w	bigint;
nr_seq_motivo_pa_pre_sentado_w	bigint;
nr_seq_motivo_pa_pre_pe_w	bigint;
dif_peso_ideal_atual_w		double precision;
qt_perc_gpid_w			double precision;
ie_tipo_dialise_w		varchar(10);
cd_evolucao_w			bigint;
ie_tipo_hemodialise_w    varchar(10);
qt_sodio_w               bigint;
qt_bicarbonato_w         bigint;
nr_seq_mod_dialisador_w		bigint;
qt_dose_w				varchar(10);
unidade_medida_w		varchar(20);


BEGIN
if (cd_tipo_evolucao_p IS NOT NULL AND cd_tipo_evolucao_p::text <> '') then

	select	coalesce(max(cd_evolucao),0)
	into STRICT	cd_evolucao_w
	from	evolucao_paciente 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_evolucao_clinica	= cd_tipo_evolucao_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	
	if (cd_evolucao_w > 0) then
		select	ds_evolucao,
			dt_evolucao
		into STRICT	ds_evolucao_w,
			dt_evolucao_w
		from 	evolucao_paciente
		where cd_evolucao	= cd_evolucao_w;
	end if;

end if;

select	max(nr_seq_exame_hematocrito)
into STRICT	nr_seq_exame_hematocrito_w
from 	hd_parametro
where 	cd_estabelecimento = cd_estabelecimento_p;

qt_altura_cm_w := substr(obter_dados_pf(cd_pessoa_fisica_p,'AL'),1,255);

qt_idade_w := substr(obter_dados_pf(cd_pessoa_fisica_p, 'I'),1,255);

ds_sexo_w := substr(Obter_Sexo_PF(cd_pessoa_fisica_p, 'D'),1,100);

select	max(substr(hd_obter_dados_maquina(nr_seq_maquina, 'T'),1,255))
into STRICT	ds_tempo_w
from 	hd_dialise_dialisador 
where 	nr_seq_dialise = nr_seq_dialise_p;

ds_ult_resultado_w := substr(obter_ult_resultado_lab(cd_pessoa_fisica_p, nr_seq_exame_hematocrito_w),1,255);

select 	max(qt_pa_sist_pre_pe),
	max(qt_pa_diast_pre_pe),
	max(qt_pa_sist_pre_deitado), 
	max(qt_pa_diast_pre_deitado), 
	max(qt_peso_pre), 
	max(qt_soro_reposicao), 
	max(qt_soro_devolucao),
	max(ie_tipo_dialise)
into STRICT	qt_pa_sist_pre_pe_w,
	qt_pa_diast_pre_pe_w, 
	qt_pa_sist_pre_deitado_w, 
	qt_pa_diast_pre_deitado_w, 
	qt_peso_pre_w, 
	qt_soro_reposicao_w, 
	qt_soro_devolucao_w,
	ie_tipo_dialise_w
from  	hd_dialise
where 	nr_sequencia = nr_Seq_dialise_p;

if (ie_peso_ideal_prescr_p = 'S') then

	qt_peso_ideal_w := hd_obter_peso_ideal_prescr(cd_pessoa_fisica_p);
else
	select 	max(qt_peso_ideal)
into STRICT	qt_peso_ideal_w
from 	hd_pac_renal_cronico
where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

qt_fluxo_sangue_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'FS');

ds_duracao_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'DR');

ds_ultrafiltracao_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'UF');

ds_heparina_retorno_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'HP');

ds_protocolo_w := substr(hd_obter_protocolo_tipo_sol(cd_pessoa_fisica_p, 'A'),1,60);

ds_agulha_w := substr(hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'DA'),1,60);

ie_tipo_hemodialise_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'HE');

nr_seq_mod_dialisador_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'MD');

qt_sodio_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'SO');

qt_bicarbonato_w := hd_obter_dados_prescr_dialise(cd_pessoa_fisica_p, 'BI');

qt_dose_w := HD_obter_dose_unidade_medida(cd_pessoa_fisica_p, 'A', 'D');

unidade_medida_w := HD_obter_dose_unidade_medida(cd_pessoa_fisica_p, 'A', 'UN');

ie_pode_pesar_w := substr(hd_obter_se_pode_pesar(cd_pessoa_fisica_p),1,1);

select 	max(nr_seq_motivo_peso_pac) 
into STRICT	nr_seq_motivo_peso_pac_w
from 	hd_parametro 
where  	cd_estabelecimento = cd_estabelecimento_p;

select	max(nr_seq_motivo_pa_pre_sentado) nr_seq_motivo_pa_pre_sentado
into STRICT	nr_seq_motivo_pa_pre_sentado_w
from 	hd_parametro;

select	max(nr_seq_motivo_pa_pre_pe) nr_seq_motivo_pa_pre_pe
into STRICT	nr_seq_motivo_pa_pre_pe_w
from 	hd_parametro;

dif_peso_ideal_atual_w := (coalesce(qt_peso_pre_w,0) - coalesce(qt_peso_ideal_w,0));

qt_perc_gpid_w :=  hd_obter_gpid(nr_seq_dialise_p, cd_pessoa_fisica_p, coalesce(qt_peso_pre_w,0));

ds_evolucao_p 			:= ds_evolucao_w;
dt_evolucao_p 			:= to_char(dt_evolucao_w,'dd/mm/yyyy hh24:mi:ss');
nr_seq_exame_hematocrito_p 	:= nr_seq_exame_hematocrito_w;
qt_altura_cm_p			:= qt_altura_cm_w;
qt_idade_p 			:= qt_idade_w;
ds_sexo_p 			:= ds_sexo_w;
ds_tempo_p 			:= ds_tempo_w;
ds_ult_resultado_p 		:= ds_ult_resultado_w;
qt_pa_sist_pre_pe_p 		:= qt_pa_sist_pre_pe_w;
qt_pa_diast_pre_pe_p 		:= qt_pa_diast_pre_pe_w;
qt_pa_sist_pre_deitado_p 	:= qt_pa_sist_pre_deitado_w;
qt_pa_diast_pre_deitado_p 	:= qt_pa_diast_pre_deitado_w;
qt_peso_pre_p 			:= qt_peso_pre_w;
qt_soro_reposicao_p 		:= qt_soro_reposicao_w;
qt_soro_devolucao_p 		:= qt_soro_devolucao_w;
qt_peso_ideal_p 		:= qt_peso_ideal_w;
qt_fluxo_sangue_p 		:= qt_fluxo_sangue_w;
ds_duracao_p 			:= ds_duracao_w;
ds_ultrafiltracao_p 		:= ds_ultrafiltracao_w;
ds_heparina_retorno_p 		:= ds_heparina_retorno_w;
ds_protocolo_p 			:= ds_protocolo_w;
ds_agulha_p  			:= ds_agulha_w;
ie_pode_pesar_p 		:= ie_pode_pesar_w;
nr_seq_motivo_peso_pac_p 	:= nr_seq_motivo_peso_pac_w;
nr_seq_motivo_pa_pre_sentado_p 	:= nr_seq_motivo_pa_pre_sentado_w;
nr_seq_motivo_pa_pre_pe_p 	:= nr_seq_motivo_pa_pre_pe_w;
dif_peso_ideal_atual_p 		:= dif_peso_ideal_atual_w;
qt_perc_gpid_p 			:= qt_perc_gpid_w;
dt_dialise_retro_p		:= hd_obter_dt_dialise_retro(nr_seq_dialise_p);
ie_tipo_dialise_p		:= ie_tipo_dialise_w;
nr_seq_mod_dialisador_p := nr_seq_mod_dialisador_w;
ie_tipo_hemodialise_p   := ie_tipo_hemodialise_w;
qt_sodio_p				:= qt_sodio_w;
qt_bicarbonato_p		:= qt_bicarbonato_w;
qt_dose_p				:= qt_dose_w;
unidade_medida_p		:= unidade_medida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_obter_dados_instalar_pac ( cd_pessoa_fisica_p text, cd_tipo_evolucao_p text, nr_seq_dialise_p bigint, cd_estabelecimento_p bigint, ie_peso_ideal_prescr_p text, ds_evolucao_p INOUT text, dt_evolucao_p INOUT text, nr_seq_exame_hematocrito_p INOUT bigint, qt_altura_cm_p INOUT text, qt_idade_p INOUT text, ds_sexo_p INOUT text, ds_tempo_p INOUT text, ds_ult_resultado_p INOUT text, qt_pa_sist_pre_pe_p INOUT bigint, qt_pa_diast_pre_pe_p INOUT bigint, qt_pa_sist_pre_deitado_p INOUT bigint, qt_pa_diast_pre_deitado_p INOUT bigint, qt_peso_pre_p INOUT bigint, qt_soro_reposicao_p INOUT bigint, qt_soro_devolucao_p INOUT bigint, qt_peso_ideal_p INOUT bigint, qt_fluxo_sangue_p INOUT text, ds_duracao_p INOUT text, ds_ultrafiltracao_p INOUT text, ds_heparina_retorno_p INOUT text, ds_protocolo_p INOUT text, ds_agulha_p INOUT text, ie_pode_pesar_p INOUT text, nr_seq_motivo_peso_pac_p INOUT bigint, nr_seq_motivo_pa_pre_sentado_p INOUT bigint, nr_seq_motivo_pa_pre_pe_p INOUT bigint, dif_peso_ideal_atual_p INOUT bigint, qt_perc_gpid_p INOUT bigint, dt_dialise_retro_p INOUT text, ie_tipo_dialise_p INOUT text, qt_ultrafiltracao_p INOUT bigint, nr_seq_ultra_p INOUT text, nr_seq_mod_dialisador_p INOUT bigint, ie_tipo_hemodialise_p INOUT text, qt_sodio_p INOUT bigint, qt_bicarbonato_p INOUT bigint, qt_dose_p INOUT text, unidade_medida_p INOUT text) FROM PUBLIC;

