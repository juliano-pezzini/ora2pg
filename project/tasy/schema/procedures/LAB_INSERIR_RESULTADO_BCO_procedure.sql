-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_inserir_resultado_bco ( ds_sigla_padrao_p text, nr_prescricao_p bigint, nr_seq_amostra_p bigint, cd_exame_p text, cd_analito_p text, pr_resultado_p bigint, qt_resultado_p bigint, ds_resultado_p text, dt_coleta_p timestamp, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_resultado_p text, ds_observacao_p text, ie_reenvio_p text, dt_resultado_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_prescricao_w			bigint;
nr_seq_prescr_w			bigint;
nr_seq_resultado_w		bigint;
nr_seq_resultado_gerado_w	bigint;
nr_seq_material_w		bigint;
nr_seq_exame_princ_w		bigint;
nr_seq_exame_w			bigint;
nr_seq_exame_tmp_w		bigint;
qt_anos_w			double precision;
ie_sexo_w			varchar(1);
cd_material_exame_w		varchar(20);
nr_seq_material_amostra_w	bigint;


BEGIN 
 
 
select 	max(nr_prescricao) 
into STRICT	nr_prescricao_w 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_p;
 
if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then 
	 
	select 	max(a.nr_sequencia), 
		max(c.nr_sequencia), 
		max(b.nr_seq_exame) 
	into STRICT	nr_seq_prescr_w, 
		nr_seq_material_w, 
		nr_seq_exame_princ_w 
	from  	exame_laboratorio b, 
		prescr_procedimento a, 
		material_exame_lab c 
	where 	a.nr_seq_exame   = b.nr_seq_exame 
	and 	a.cd_material_exame = c.cd_material_exame 
	and 	a.nr_prescricao   = nr_prescricao_w 
	and 	coalesce(b.cd_exame_integracao, b.cd_exame) = cd_exame_p 
	and	a.cd_motivo_baixa = 0;
	 
	if (coalesce(nr_seq_prescr_w::text, '') = '') then 
 
		select 	max(a.nr_sequencia), 
			max(c.nr_sequencia), 
			max(b.nr_seq_exame) 
		into STRICT	nr_seq_prescr_w, 
			nr_seq_material_w, 
			nr_seq_exame_princ_w 
		from  	material_exame_lab c, 
			exame_laboratorio b, 
			prescr_procedimento a 
		where 	a.nr_seq_exame   = b.nr_seq_exame 
		and 	a.cd_material_exame = c.cd_material_exame 
		and 	obter_equip_exame_integracao(cd_exame_p,ds_sigla_padrao_p,1) = a.nr_seq_exame 
		and 	a.nr_prescricao   = nr_prescricao_w 
		and	a.cd_motivo_baixa = 0;
		 
	end if;	
	 
	if (nr_seq_amostra_p IS NOT NULL AND nr_seq_amostra_p::text <> '') and (nr_seq_exame_princ_w IS NOT NULL AND nr_seq_exame_princ_w::text <> '') then 
 
		select distinct 
			a.nr_seq_material, 
			c.nr_sequencia 
		into STRICT 	nr_seq_material_amostra_w, 
			nr_seq_prescr_w 
		from 	prescr_proc_material a, 
			prescr_proc_mat_item b, 
			prescr_procedimento c, 
			prescr_medica d 
		where  b.nr_seq_prescr_proc_mat = a.nr_sequencia 
		and   c.nr_prescricao = b.nr_prescricao 
		and	c.nr_sequencia	= b.nr_seq_prescr 
		and	d.nr_prescricao = c.nr_prescricao 
		and	a.nr_prescricao = d.nr_prescricao 
		and	coalesce(c.ie_suspenso,'N') = 'N' 
		and	c.nr_seq_exame = nr_seq_exame_princ_w 
		and   a.nr_prescricao = nr_prescricao_w 
		and   a.nr_sequencia = nr_seq_amostra_p;
			 
	end if;
		 
	if (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then 
 
		select 	max(a.nr_seq_resultado) 
		into STRICT	nr_seq_resultado_w 
		from 	exame_lab_resultado a, 
			exame_lab_result_item b 
		where	a.nr_seq_resultado = b.nr_seq_resultado 
		and	nr_prescricao	= nr_prescricao_w 
		and	b.nr_seq_prescr	= nr_seq_prescr_w;
		 
		if (coalesce(nr_seq_resultado_w::text, '') = '') then 
		 
			begin 
			CALL gera_exame_result_lab(nr_prescricao_w,nr_seq_prescr_w,'N','N','N',nm_usuario_p);
			 
			exception 
			when others then 
				ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277245,null) ||nr_prescricao_w || WHEB_MENSAGEM_PCK.get_texto(277246,null) || nr_seq_prescr_w || ' ' || substr(sqlerrm,1,90);
			end;
 
			select 	max(nr_seq_resultado) 
			into STRICT	nr_seq_resultado_w 
			from 	exame_lab_resultado 
			where	nr_prescricao   = nr_prescricao_w;
 
			if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then 
				begin 
				 
				select 	trunc(dividir(obter_dias_entre_datas(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp()),365),4), 
					obter_sexo_prescricao(nr_prescricao_p) 
				into STRICT 	qt_anos_w, 
					ie_sexo_w 
				;
 
				CALL gera_resultado_lab_imp(nr_seq_resultado_w, nr_prescricao_w, nr_seq_prescr_w, nr_seq_exame_princ_w, nr_seq_material_w,qt_anos_w,ie_sexo_w,nm_usuario_p);
 
				exception 
				when others then 
					ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277245,null) ||nr_prescricao_w || WHEB_MENSAGEM_PCK.get_texto(277246,null) || nr_Seq_prescr_w || ' ' || substr(sqlerrm,1,90);
				end;
 
			else 
				ds_erro_p	:= ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(277248,null) || nr_prescricao_w;
			end if;
			 
		end if;
		 
		 
		if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then 
			 
			ds_erro_p := Atualizar_Lab_Result_Item(	nr_prescricao_w, nr_seq_prescr_w, coalesce(cd_analito_p,cd_exame_p), qt_resultado_p, pr_resultado_p, ds_resultado_p, ds_observacao_p, cd_material_exame_w, ie_reenvio_p, nm_usuario_p, dt_coleta_p, null, null, null, dt_resultado_p, ds_erro_p);
			 
			if (cd_microorganismo_p IS NOT NULL AND cd_microorganismo_p::text <> '') then 
			 
				ds_erro_p := Lab_inserir_item_micro_result( 	nr_prescricao_w, nr_seq_prescr_w, coalesce(cd_analito_p, cd_exame_p), cd_microorganismo_p, cd_medicamento_p, qt_microorganismo_p, qt_mic_p, ie_resultado_p, nm_usuario_p, ds_erro_p);
			end if;
			 
			 
		end if;
 
 
	else 
		ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277250,null) || nr_prescricao_w || WHEB_MENSAGEM_PCK.get_texto(277253,null) || cd_exame_p;
	end if;
 
else 
 
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(277254,null) || nr_prescricao_p;
 
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_inserir_resultado_bco ( ds_sigla_padrao_p text, nr_prescricao_p bigint, nr_seq_amostra_p bigint, cd_exame_p text, cd_analito_p text, pr_resultado_p bigint, qt_resultado_p bigint, ds_resultado_p text, dt_coleta_p timestamp, cd_microorganismo_p text, cd_medicamento_p text, qt_microorganismo_p text, qt_mic_p text, ie_resultado_p text, ds_observacao_p text, ie_reenvio_p text, dt_resultado_p timestamp, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
