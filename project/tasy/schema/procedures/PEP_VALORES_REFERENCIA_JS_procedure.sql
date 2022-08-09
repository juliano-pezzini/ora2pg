-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_valores_referencia_js ( nm_campo_p text, dt_coluna_p timestamp, nr_sequencia_p bigint, nr_seq_exame_p bigint, nr_seq_result_item_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, nr_seq_material_p bigint, ds_observacao_p INOUT text, ds_resul_microor_p INOUT text, ds_resultado_p INOUT text, ds_tit_observacao_p INOUT text, ds_dt_coleta_exam_p INOUT text, dt_coleta_p INOUT text, ds_tit_material_p INOUT text, dt_aprovacao_exame_p INOUT text, ds_tit_aprov_exame_p INOUT text, ds_tit_unid_medida_p INOUT text, ds_tit_vlr_ref_p INOUT text, ds_tit_vlr_ref_res_p INOUT text, ds_tit_resultado_referencia_p INOUT text, ie_resultado_referencia_p INOUT text, ds_tit_resultado_critico_p INOUT text, ie_resultado_critico_p INOUT text, ds_tit_regra_result_critico_p INOUT text, ds_regra_result_critico_p INOUT text, ds_tit_material_especial_p INOUT text, ds_material_especial_p INOUT text, ds_tit_flag_p INOUT text, ds_flag_p INOUT text) AS $body$
DECLARE


ds_update_w			            varchar(4000) := null;
ds_parametros_w			        varchar(4000) := null;
ds_observacao_w			        w_result_exame_obs.ds_observacao%TYPE;
ds_coluna_aux_w			        varchar(255);
ds_resul_microor_w		        varchar(4000);
dt_coleta_w			            varchar(20);
ds_resultado_w			        varchar(255);
ds_tit_observacao_w		        varchar(255);
ds_dt_coleta_exam_w		        varchar(255);
ds_tit_material_w		        varchar(255);
dt_aprovacao_exame_w		    varchar(255);
ds_tit_aprov_exame_w		    varchar(255);
ds_tit_unid_medida_w		    varchar(255);
ds_material_especial_w		    varchar(255);
ds_tit_vlr_ref_w		        varchar(255);
nr_prescricao_w			        bigint;
ds_tit_vlr_ref_res_w	        varchar(255);
nr_seq_resultado_lab_w		    integer := 0;
ds_tit_resultado_referencia_w 	varchar(255);
ie_resultado_referencia_w		exame_lab_result_item.ie_resultado_referencia%type;
ds_tit_resultado_critico_w 		varchar(255);
ie_resultado_critico_w 			exame_lab_result_item.ie_resultado_critico%type;
ds_tit_regra_result_critico_w 	varchar(255);
ds_regra_result_critico_w 		exame_lab_result_item.ds_regra_result_critico%type;
ds_tit_flag_w   		        varchar(255);
ds_flag_w                       exame_lab_result_item.ds_flag%type;


BEGIN

ds_resultado_w		:= substr(obter_texto_tasy(49044, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_observacao_w	:= substr(obter_texto_tasy(49042, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_dt_coleta_exam_w	:= substr(obter_texto_tasy(49043, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_material_w		:= substr(obter_texto_tasy(145479, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_aprov_exame_w	:= substr(obter_texto_tasy(145483, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_unid_medida_w	:= substr(obter_texto_tasy(282693, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_vlr_ref_w		:= substr(obter_texto_tasy(282694, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_vlr_ref_res_w		:= substr(obter_texto_tasy(318946, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_resultado_referencia_w := substr(obter_texto_tasy(835133, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_resultado_critico_w 	  := substr(obter_texto_tasy(835134, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_regra_result_critico_w := substr(obter_texto_tasy(835135, wheb_usuario_pck.get_nr_seq_idioma), 1, 255);
ds_tit_material_especial_p	  := substr(obter_texto_tasy(853616, wheb_usuario_pck.get_nr_seq_idioma), 1, 255)||':';
ds_tit_flag_w                 := substr(obter_texto_tasy(1099881, wheb_usuario_pck.get_nr_seq_idioma), 1, 255)||':';

if (dt_coluna_p IS NOT NULL AND dt_coluna_p::text <> '') then
	begin
	ds_update_w	:= 	'SELECT ' || nm_campo_p ||
					' from	w_result_exame_grid ' ||
					'	where	ie_ordem = -4 ' ||
					' 	and     nm_usuario = :nm_usuario ';
	ds_parametros_w	:= 'nm_usuario='||nm_usuario_p||OBTER_SEPARADOR_BV;
	nr_prescricao_w := OBTER_VALOR_DINAMICO_BV(ds_update_w, ds_parametros_w, nr_prescricao_w);	

	select	max(ds_observacao)
	into STRICT 	ds_observacao_w
	from	w_result_exame_obs
	where	nr_seq_result = nr_sequencia_p
	and	to_char(dt_resultado,'dd/mm/yy hh24:mi') = to_char(dt_coluna_p ,'dd/mm/yy hh24:mi');

	select	max(to_char(b.dt_coleta ,'dd/mm/yyyy hh24:mi:ss'))
	into STRICT	dt_coleta_w
	from	exame_lab_result_item b,
		exame_lab_resultado a
	where	a.nr_seq_resultado = b.nr_seq_resultado
	and	a.nr_prescricao = nr_prescricao_w
	and	b.nr_seq_exame = nr_seq_exame_p;
	
	select max(b.dt_aprovacao)
	into STRICT	dt_aprovacao_exame_w
	from	exame_lab_result_item b,
		exame_lab_resultado a
	where	a.nr_seq_resultado = b.nr_seq_resultado
	and	a.nr_prescricao = nr_prescricao_w
	and	b.nr_seq_exame = nr_seq_exame_p;

	select	max(nr_seq_resultado_lab)
	into STRICT	nr_seq_resultado_lab_w
	from	w_result_exame_grid
	where	nr_sequencia = nr_sequencia_p;
	
	select 	max(obter_ds_material_especial(a.nr_sequencia,a.nr_prescricao)),
			max(ie_resultado_referencia),
			max(ie_resultado_critico),	
			max(ds_regra_result_critico),
            max(ds_flag)
	into STRICT	ds_material_especial_w,
			ie_resultado_referencia_w,
			ie_resultado_critico_w,
			ds_regra_result_critico_w,
            ds_flag_w
	from    prescr_procedimento a,
	        exame_lab_resultado b,   
	        exame_lab_result_item c 
	where   a.nr_prescricao     = b.nr_prescricao     
	and	    b.nr_seq_resultado  = c.nr_seq_resultado 
	and	    a.nr_sequencia      = c.nr_seq_prescr    
	and	    a.nr_prescricao     = nr_prescricao_w
	and	    c.nr_seq_exame      = nr_seq_exame_p
	and  	a.cd_material_exame = Obter_Material_Exame_Lab(nr_seq_material_p, null,2);
	
	ds_resul_microor_w := obter_resultado_microorganismo(nr_prescricao_w,nr_seq_exame_p,null,nr_seq_resultado_lab_w);
	end;
end if;

ds_observacao_p		:= ds_observacao_w;
dt_coleta_p		:= dt_coleta_w;
ds_resul_microor_p		:= ds_resul_microor_w;
ds_resultado_p		:= ds_resultado_w;
ds_tit_observacao_p	:= ds_tit_observacao_w;
ds_dt_coleta_exam_p	:= ds_dt_coleta_exam_w;
ds_tit_material_p		:= ds_tit_material_w;
dt_aprovacao_exame_p	:= dt_aprovacao_exame_w;
ds_tit_aprov_exame_p	:= ds_tit_aprov_exame_w;
ds_tit_unid_medida_p	:= ds_tit_unid_medida_w;
ds_tit_vlr_ref_p		:= ds_tit_vlr_ref_w;
ds_tit_vlr_ref_res_p		:= ds_tit_vlr_ref_res_w;
ds_tit_resultado_referencia_p 	:= ds_tit_resultado_referencia_w;
ie_resultado_referencia_p 		:= ie_resultado_referencia_w;
ds_flag_p                       := ds_flag_w;
ds_tit_flag_p                   := ds_tit_flag_w;
ds_tit_resultado_critico_p 	  	:= ds_tit_resultado_critico_w;
ie_resultado_critico_p 	  		:= ie_resultado_critico_w;
ds_tit_regra_result_critico_p 	:= ds_tit_regra_result_critico_w;
ds_regra_result_critico_p 		:= ds_regra_result_critico_w;
ds_material_especial_p			:= ds_material_especial_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_valores_referencia_js ( nm_campo_p text, dt_coluna_p timestamp, nr_sequencia_p bigint, nr_seq_exame_p bigint, nr_seq_result_item_p bigint, nr_seq_resultado_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, nr_seq_material_p bigint, ds_observacao_p INOUT text, ds_resul_microor_p INOUT text, ds_resultado_p INOUT text, ds_tit_observacao_p INOUT text, ds_dt_coleta_exam_p INOUT text, dt_coleta_p INOUT text, ds_tit_material_p INOUT text, dt_aprovacao_exame_p INOUT text, ds_tit_aprov_exame_p INOUT text, ds_tit_unid_medida_p INOUT text, ds_tit_vlr_ref_p INOUT text, ds_tit_vlr_ref_res_p INOUT text, ds_tit_resultado_referencia_p INOUT text, ie_resultado_referencia_p INOUT text, ds_tit_resultado_critico_p INOUT text, ie_resultado_critico_p INOUT text, ds_tit_regra_result_critico_p INOUT text, ds_regra_result_critico_p INOUT text, ds_tit_material_especial_p INOUT text, ds_material_especial_p INOUT text, ds_tit_flag_p INOUT text, ds_flag_p INOUT text) FROM PUBLIC;
