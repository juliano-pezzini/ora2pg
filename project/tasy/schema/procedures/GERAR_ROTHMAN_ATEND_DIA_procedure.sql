-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rothman_atend_dia ( nr_atendimento_p bigint, dt_registro_p timestamp, nm_usuario_p text, ie_opcao_p text default null, nr_seq_reg_p bigint default null, cd_perfil_p bigint default null) AS $body$
DECLARE

 
										 
			 
 
 
qt_pa_diastolica_w		double precision;
qt_pa_sistolica_w    double precision;
qt_freq_cardiaca_w    double precision;
qt_freq_resp_w      double precision;
qt_temp_w        double precision;
qt_saturacao_o2_w		double precision;
IE_RITMO_ECG_w			varchar(15);

 
qt_ureia_w				double precision;
qt_creatinina_w			double precision;
qt_glob_brancos_w		double precision;
qt_glob_vermelhos_w		double precision;
qt_cloro_w				double precision;
qt_sodio_w				double precision;
qt_potassio_serico_w	double precision;

qt_braden_score_w		bigint;
qt_morse_score_w		bigint;
ie_nutricao_w			bigint;

ie_sist_cardiaco_w			varchar(10);
ie_sist_gastrointestinal_w	varchar(10);
ie_sist_geniturinario_w		varchar(10);
ie_sist_musc_esq_w			varchar(10);
ie_sist_neurologico_w		varchar(10);
ie_sist_respiratorio_w		varchar(10);
ie_reg_risco_queda_w		varchar(10);
ie_sist_tegumentar_w		varchar(10);
ie_sist_vasc_periferico_w	varchar(10);
ie_psicossocial_comport_w	varchar(10);

ie_sb_w 					varchar(10);
ie_sr_w 					varchar(10);
ie_vt_w 					varchar(10);
ie_af_w 					varchar(10);
ie_afl_w 					varchar(10);
ie_exp_w 					varchar(10);
ie_jr_w 					varchar(10);
ie_vf_w 					varchar(10);
ie_p_w 					varchar(10);
ie_st_w 					varchar(10);
ie_hb_w 					varchar(10);

 
 
dt_pa_sistolica_w 					timestamp;
dt_pa_diastolica_w 					timestamp;
dt_freq_cardiaca_w 					timestamp;
dt_freq_resp_w 					timestamp;
dt_temp_w 					timestamp;
dt_saturacao_o2_w 					timestamp;
dt_ureia_w 					timestamp;
dt_creatinina_w 					timestamp;
dt_glob_brancos_w 					timestamp;
dt_glob_vermelhos_w 					timestamp;
dt_cloro_w 					timestamp;
dt_sodio_w 					timestamp;
dt_potassio_serico_w 					timestamp;
dt_sb_w 					timestamp;
dt_sr_w 					timestamp;
dt_hb_w 					timestamp;
dt_p_w 					timestamp;
dt_af_w 					timestamp;
dt_afl_w 					timestamp;
dt_st_w 					timestamp;
dt_jr_w 					timestamp;
dt_vt_w 					timestamp;
dt_vf_w 					timestamp;
dt_exp_w 					timestamp;
dt_RITMO_ECG_w				timestamp;
dt_braden_score_w 					timestamp;
dt_morse_score_w 					timestamp;
dt_nutricao_w 					timestamp;
dt_sist_cardiaco_w 					timestamp;
dt_sist_gastrointestinal_w 					timestamp;
dt_sist_geniturinario_w 					timestamp;
dt_sist_musc_esq_w 					timestamp;
dt_sist_neurologico_w 					timestamp;
dt_sist_respiratorio_w 					timestamp;
dt_reg_risco_queda_w 					timestamp;
dt_sist_tegumentar_w 					timestamp;
dt_sist_vasc_periferico_w 					timestamp;
dt_psicossocial_comport_w 					timestamp;
nr_sequencia_w			bigint;

ds_hint_sist_cardiaco_w 					varchar(255);
ds_hint_sist_gastroint_w 					varchar(255);
ds_hint_sist_geniturinario_w 					varchar(255);
ds_hint_sist_musc_esq_w 					varchar(255);
ds_hint_sist_neurologico_w 					varchar(255);
ds_hint_sist_respiratorio_w 					varchar(255);
ds_hint_reg_risco_queda_w 					varchar(255);
ds_hint_sist_tegumentar_w 					varchar(255);
ds_hint_sist_vasc_periferico_w 					varchar(255);
ds_hint_psicossocial_comport_w 					varchar(255);

 
 
 
ds_hint_pa_sistolica_w 					varchar(255);
ds_hint_pa_diastolica_w 					varchar(255);
ds_hint_freq_cardiaca_w 					varchar(255);
ds_hint_freq_resp_w 					varchar(255);
ds_hint_temp_w 					varchar(255);
ds_hint_saturacao_o2_w 					varchar(255);
ds_hint_braden_score_w						varchar(255);
ds_hint_morse_score_w						varchar(255);
ds_hint_nutricao_w							varchar(255);
ds_hint_ritmo_ecg_w									varchar(255);

ds_hint_ureia_w 					varchar(255);
ds_hint_creatinina_w 					varchar(255);
ds_hint_glob_brancos_w 					varchar(255);
ds_hint_glob_vermelhos_w 					varchar(255);
ds_hint_cloro_w 					varchar(255);
ds_hint_sodio_w 					varchar(255);
ds_hint_potassio_serico_w 					varchar(255);

 
ds_hint_sb_w 					varchar(255);
ds_hint_sr_w 					varchar(255);
ds_hint_hb_w 					varchar(255);
ds_hint_p_w 					varchar(255);
ds_hint_af_w 					varchar(255);
ds_hint_afl_w 					varchar(255);
ds_hint_st_w 					varchar(255);
ds_hint_jr_w 					varchar(255);
ds_hint_vt_w 					varchar(255);
ds_hint_vf_w 					varchar(255);
ds_hint_exp_w 					varchar(255);

 
 
nr_seq_hemoglobina_w			bigint;
nr_seq_leucocitos_w				bigint;
nr_seq_creatinina_w				bigint;
nr_seq_ureia_w					bigint;
nr_seq_sodio_w					bigint;
nr_seq_potassio_w				bigint;
nr_seq_cloro_w					bigint;

cd_estabelecimento_w			bigint;

			 
			procedure	Obter_SV(	nm_coluna_p	text, 
									vl_retorno_p	out bigint, 
									dt_sv_p			out timestamp, 
									ds_hint_p		out text) as 
			ds_comando_w	varchar(2000);
			ds_parametro_w	varchar(2000);
			vl_retorno_w	double precision;
			C04				integer;
			dt_referencia_w	timestamp;
			retorno_w			integer;
			
BEGIN
			 
			ds_comando_w	:= 'select	a.dt_sinal_vital,a.'||nm_coluna_p 
							  ||' 	from		atendimento_sinal_vital a ' 
							  ||'	where		a.nr_atendimento	= :nr_atendimento ' 
							  ||'	and			a.nr_sequencia		= :NR_SEQUENCIA ';			
			 
			 
			C04 := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(C04, ds_comando_w, dbms_sql.Native);
			 
			DBMS_SQL.DEFINE_COLUMN(C04,1,dt_referencia_w);
			DBMS_SQL.DEFINE_COLUMN(C04,2,vl_retorno_w);
			 
			DBMS_SQL.BIND_VARIABLE(C04,'NR_ATENDIMENTO', NR_ATENDIMENTO_P);
			DBMS_SQL.BIND_VARIABLE(C04,'NR_SEQUENCIA', nr_seq_reg_p);
	 
			retorno_w := DBMS_SQL.execute(C04);
	 
			while( DBMS_SQL.FETCH_ROWS(C04) > 0 ) loop 
				begin 
				DBMS_SQL.COLUMN_VALUE(C04,1,dt_referencia_w);
				DBMS_SQL.COLUMN_VALUE(C04,2,vl_retorno_w);		
				end;
			end loop;
							  
			 
			vl_retorno_p	:= vl_retorno_w;
			dt_sv_p			:= dt_referencia_w;
			ds_hint_p		:= null;
			if (dt_sv_p IS NOT NULL AND dt_sv_p::text <> '') then 
				ds_hint_p	:= wheb_mensagem_pck.get_texto(308529) || ': '||to_char(dt_sv_p,'dd/mm hh24:mi'); -- Data SV 
			end if;
			DBMS_SQL.CLOSE_CURSOR(C04);
			end;
										 
										 
										 
	procedure	Obter_Result_Lab(	nr_seq_exame_p		number, 
									qt_result_P		out number, 
									dt_result_p		out date, 
									ds_hint_p		out varchar2) as 
	 
	qt_result_w			number(15,4);
	dt_coleta_w			date;
	c01 CURSOR FOR 
		SELECT 	b.qt_resultado, 
				coalesce(b.dt_aprovacao,a.dt_resultado), 
				coalesce(x.dt_coleta,b.dt_coleta)	 
		from 	exame_lab_result_item b, 
				exame_lab_resultado a, 
				prescr_procedimento x, 
				prescr_medica c 
		where	a.nr_seq_resultado	= b.nr_seq_resultado 
		and		a.nr_prescricao		= c.nr_prescricao 
		and		x.nr_sequencia		= b.nr_seq_prescr 
		and		x.nr_prescricao		= c.nr_prescricao 
		and		b.nr_seq_exame		= nr_seq_exame_p 
		and		a.NR_SEQ_RESULTADO	= nr_seq_reg_p 
		and		c.nr_atendimento	= nr_atendimento_p 
		and		x.ie_status_atend	>= 35 
		order by coalesce(b.dt_aprovacao,a.dt_resultado);
	 
	 
	begin 
	 
	open C01;
	loop 
	fetch C01 into	 
		qt_result_P, 
		dt_result_p, 
		dt_coleta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	 
 
	if (dt_coleta_w IS NOT NULL AND dt_coleta_w::text <> '') then 
		ds_hint_p	:= wheb_mensagem_pck.get_texto(308491) || ' ' || lower(wheb_mensagem_pck.get_texto(308532)) || ': '||to_char(dt_coleta_w,'dd/mm hh24:mi'); -- Data coleta 
	end if;
	 
	end;
	 
 
	 
	 
	procedure obter_Score_Braden(	qt_score_p	out number, 
									dt_reg_p	out date, 
									ds_hint_p	out varchar2) as 
	qt_ponto_w	number(5);
	begin 
	 
	select	max(qt_ponto), 
			max(DT_AVALIACAO) 
	into STRICT	qt_score_p, 
			dt_reg_p 
	from	ATEND_ESCALA_BRADEN	 a 
	where	nr_sequencia = nr_seq_reg_p;
	 
	if (dt_reg_p IS NOT NULL AND dt_reg_p::text <> '') then 
		ds_hint_p	:= wheb_mensagem_pck.get_texto(308491) || ': '||to_char(dt_reg_p,'dd/mm hh24:mi'); -- Data 
	end if;
	end;
	 
	 
	 
	procedure obter_Score_Morse(	qt_score_p	out number, 
									dt_reg_p	out date, 
									ds_hint_p	out varchar2) as 
	qt_ponto_w	number(5);
	begin 
	 
	select	max(QT_PONTUACAO), 
			max(DT_AVALIACAO) 
	into STRICT	qt_score_p, 
			dt_reg_p 
	from	escala_morse	 a 
	where	nr_sequencia = nr_seq_reg_p;
	 
	if (dt_reg_p IS NOT NULL AND dt_reg_p::text <> '') then 
		ds_hint_p	:= wheb_mensagem_pck.get_texto(308491) || ': '||to_char(dt_reg_p,'dd/mm hh24:mi'); -- Data 
	end if;
	end;
	 
	 
	 
	procedure obter_Nutricao_Braden(	qt_score_p	out number, 
										dt_reg_p	out date, 
										ds_hint_p	out varchar2) as 
	qt_ponto_w	number(5);
	begin 
	 
	select	max( IE_NUTRICAO ), 
			max(dt_avaliacao) 
	into STRICT	qt_score_p, 
			dt_reg_p 
	from	ATEND_ESCALA_BRADEN	 a 
	where	nr_sequencia = nr_seq_reg_p;
	 
	if (dt_reg_p IS NOT NULL AND dt_reg_p::text <> '') then 
		ds_hint_p	:= wheb_mensagem_pck.get_texto(308491) || ': '||to_char(dt_reg_p,'dd/mm hh24:mi'); -- Data 
	end if;
	 
	end;
	 
	 
	procedure Obter_Value_Rothman_Index(		ie_tipo_rothman_p		varchar2, 
												ie_retorno_p			out varchar2, 
												dt_sae_P				out date, 
												ds_hint_p				out varchar2) as 
	 
	nr_seq_sae_w		number(10);
	ie_retorno_w		varchar2(10);
	ds_resultado_w		varchar2(255);
	ds_resultados_w		varchar2(255);	
 
	C06 CURSOR FOR 
		SELECT	f.ds_resultado 
		from	pe_prescricao a, 
				PE_PRESCR_ITEM_RESULT b, 
				PE_ITEM_EXAMINAR c, 
				PE_ITEM_TIPO_ITEM d, 
				PE_TIPO_ITEM e, 
				PE_ITEM_RESULTADO f 
		where	a.nr_sequencia	= b.nr_seq_prescr 
		and		a.nr_sequencia	= nr_seq_sae_w 
		and		b.nr_seq_item		= c.nr_sequencia 
		and		d.nr_seq_item		= c.nr_sequencia 
		and		e.nr_sequencia		= d.nr_seq_tipo_item 
		and		e.ie_tipo_rothman	= ie_tipo_rothman_p 
		and		f.nr_sequencia		= b.NR_SEQ_RESULT 
		and		f.ie_rothman_value = ie_retorno_w 
		and		a.ie_situacao = 'A' 
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
		and		coalesce(a.dt_inativacao::text, '') = '';
	 
	 
	begin 
	 
	select	max(a.nr_sequencia), 
			max(a.dt_prescricao) 
	into STRICT	nr_seq_sae_w, 
			dt_sae_P 
	from	pe_prescricao a, 
			PE_PRESCR_ITEM_RESULT b, 
			PE_ITEM_EXAMINAR c, 
			PE_ITEM_TIPO_ITEM d, 
			PE_TIPO_ITEM e 
	where	a.nr_sequencia	= b.nr_seq_prescr 
	and		a.nr_atendimento	= nr_atendimento_p 
	and		a.nr_sequencia		= nr_seq_reg_p 
	and		b.nr_seq_item		= c.nr_sequencia 
	and		d.nr_seq_item		= c.nr_sequencia 
	and		e.nr_sequencia		= d.nr_seq_tipo_item 
	and		e.ie_tipo_rothman	= ie_tipo_rothman_p 
	and		a.ie_situacao = 'A' 
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and		coalesce(a.dt_inativacao::text, '') = '';
	 
	 
	if (nr_seq_sae_w IS NOT NULL AND nr_seq_sae_w::text <> '') then 
		select	max(f.IE_ROTHMAN_VALUE) 
		into STRICT	ie_retorno_w 
		from	pe_prescricao a, 
				PE_PRESCR_ITEM_RESULT b, 
				PE_ITEM_EXAMINAR c, 
				PE_ITEM_TIPO_ITEM d, 
				PE_TIPO_ITEM e, 
				PE_ITEM_RESULTADO f 
		where	a.nr_sequencia	= b.nr_seq_prescr 
		and		a.nr_sequencia	= nr_seq_sae_w 
		and		b.nr_seq_item		= c.nr_sequencia 
		and		d.nr_seq_item		= c.nr_sequencia 
		and		e.nr_sequencia		= d.nr_seq_tipo_item 
		and		e.ie_tipo_rothman	= ie_tipo_rothman_p 
		and		f.nr_sequencia		= b.NR_SEQ_RESULT 
		and		f.ie_rothman_value in ('0','1') 
		and		a.ie_situacao = 'A' 
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
		and		coalesce(a.dt_inativacao::text, '') = '';
	end if;
	 
	if (ie_retorno_w	in (0,1)) then 
	 
		open C06;
		loop 
		fetch C06 into	 
			ds_resultado_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin 
			 
			if (coalesce(ds_resultados_w::text, '') = '') then 
				ds_resultados_w	:= ds_resultado_w;
			else 
				ds_resultados_w	:= substr(ds_resultado_w||','||ds_resultados_w,1,255);
			end if;
			end;
		end loop;
		close C06;	
	 
	end if;
	 
	if (coalesce(ie_retorno_w::text, '') = '') then 
		ds_hint_p	:= wheb_mensagem_pck.get_texto(308538); -- Não avaliado 
	end if;
	 
	 
	if (ds_resultados_w IS NOT NULL AND ds_resultados_w::text <> '') then 
		ds_hint_p	:= substr(wheb_mensagem_pck.get_texto(308491) || ': '||to_char(dt_sae_P,'dd/mm hh24:mi')||chr(13)||chr(10)||ds_resultados_w,1,255); -- Data 
	end if;
	 
	ie_retorno_p	:= ie_retorno_w;
	 
	end;
	 
	 
	 
	procedure Obter_Value_Rothman_Cardio(		IE_VALUE_P			varchar2, 
												ie_retorno_p			out varchar2, 
												dt_sae_P				out date, 
												ds_hint_p				out	varchar2) as 
	 
	nr_seq_sae_w		number(10);
	ie_retorno_w		number(10);
	ds_resultado_w		varchar2(255);
	ds_resultados_w		varchar2(255);
	 
	 
	C05 CURSOR FOR 
		SELECT	f.ds_resultado 
		from	pe_prescricao a, 
				PE_PRESCR_ITEM_RESULT b, 
				PE_ITEM_EXAMINAR c, 
				PE_ITEM_TIPO_ITEM d, 
				PE_TIPO_ITEM e, 
				PE_ITEM_RESULTADO f 
		where	a.nr_sequencia	= b.nr_seq_prescr 
		and		a.nr_sequencia	= nr_seq_sae_w 
		and		b.nr_seq_item		= c.nr_sequencia 
		and		d.nr_seq_item		= c.nr_sequencia 
		and		e.nr_sequencia		= d.nr_seq_tipo_item 
		and		e.ie_tipo_rothman	= 'RITCARD' 
		and		f.nr_sequencia		= b.NR_SEQ_RESULT 
		and		f.IE_ROTHMAN_VALUE = ie_value_p 
		and		a.ie_situacao = 'A' 
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
		and		coalesce(a.dt_inativacao::text, '') = '';
	 
	begin 
	 
	select	max(a.nr_sequencia), 
			max(a.dt_prescricao) 
	into STRICT	nr_seq_sae_w, 
			dt_sae_P 
	from	pe_prescricao a, 
			PE_PRESCR_ITEM_RESULT b, 
			PE_ITEM_EXAMINAR c, 
			PE_ITEM_TIPO_ITEM d, 
			PE_TIPO_ITEM e 
	where	a.nr_sequencia	= b.nr_seq_prescr 
	and		a.nr_atendimento	= nr_atendimento_p 
	and		a.nr_sequencia		= nr_seq_reg_p 
	and		b.nr_seq_item		= c.nr_sequencia 
	and		d.nr_seq_item		= c.nr_sequencia 
	and		e.nr_sequencia		= d.nr_seq_tipo_item 
	and		e.ie_tipo_rothman	= 'RITCARD' 
	and		a.ie_situacao = 'A' 
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and		coalesce(a.dt_inativacao::text, '') = '';
	 
	 
	if (nr_seq_sae_w IS NOT NULL AND nr_seq_sae_w::text <> '') then 
		 
		open C05;
		loop 
		fetch C05 into	 
			ds_resultado_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin 
			 
			if (coalesce(ds_resultados_w::text, '') = '') then 
				ds_resultados_w	:= ds_resultado_w;
			else 
				ds_resultados_w	:= substr(ds_resultado_w||','||ds_resultados_w,1,255);
			end if;
			ie_retorno_w	:= 1;
			end;
		end loop;
		close C05;
		 
	end if;
	 
	 
	ie_retorno_p	:= ie_retorno_w;
	 
	if (ds_resultados_w IS NOT NULL AND ds_resultados_w::text <> '') then 
		ds_hint_p	:= substr(wheb_mensagem_pck.get_texto(308491) || ': '||to_char(dt_sae_P,'dd/mm hh24:mi')||chr(13)||chr(10)||ds_resultados_w,1,255); -- Data 
	end if;
	 
	--return nvl(ie_retorno_w); 
	end;
	 
										 
begin 
 
 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
CALL wheb_usuario_pck.set_informacoes_usuario(0,cd_perfil_p,cd_estabelecimento_w,0,nm_usuario_p,1,'');
 
if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 'SV') then 
	Obter_SV('QT_PA_DIASTOLICA',qt_pa_diastolica_w,dt_pa_diastolica_w,ds_hint_pa_diastolica_w  );
	Obter_SV('QT_PA_SISTOLICA',qt_pa_sistolica_w,dt_pa_sistolica_w,ds_hint_pa_sistolica_w );
	Obter_SV('QT_FREQ_CARDIACA',qt_freq_cardiaca_w,dt_freq_cardiaca_w,ds_hint_freq_cardiaca_w );
	Obter_SV('QT_FREQ_RESP',qt_freq_resp_w,dt_freq_resp_w,ds_hint_freq_resp_w );
	Obter_SV('QT_TEMP',qt_temp_w,dt_temp_w,ds_hint_temp_w );
	Obter_SV('QT_SATURACAO_O2',qt_saturacao_o2_w,dt_saturacao_o2_w,ds_hint_saturacao_o2_w );
	Obter_SV('IE_RITMO_ECG',ie_ritmo_ecg_w,dt_ritmo_ecg_w,ds_hint_ritmo_ecg_w);
	 
end if;
 
 
 
if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 'EX') then 
	select	max(nr_seq_hemoglobina), 
			max(nr_seq_leucocitos), 
			max(nr_seq_creatinina), 
			max(nr_seq_ureia), 
			max(nr_seq_sodio), 
			max(nr_seq_potassio), 
			max(nr_seq_cloro) 
	into STRICT	nr_seq_hemoglobina_w, 
			nr_seq_leucocitos_w, 
			nr_seq_creatinina_w, 
			nr_seq_ureia_w, 
			nr_seq_sodio_w, 
			nr_seq_potassio_w, 
			nr_seq_cloro_w 
	from	parametro_rothman 
	where	cd_estabelecimento	= cd_estabelecimento_w;
 
 
	Obter_Result_Lab(nr_seq_ureia_w,qt_ureia_w,dt_ureia_w,ds_hint_ureia_w);
	Obter_Result_Lab(nr_seq_creatinina_w,qt_creatinina_w,dt_creatinina_w,ds_hint_creatinina_w);
	Obter_Result_Lab(nr_seq_leucocitos_w,qt_glob_brancos_w,dt_glob_brancos_w,ds_hint_glob_brancos_w);
	Obter_Result_Lab(nr_seq_hemoglobina_w,qt_glob_vermelhos_w,dt_glob_vermelhos_w,ds_hint_glob_vermelhos_w);
	Obter_Result_Lab(nr_seq_cloro_w,qt_cloro_w,dt_cloro_w,ds_hint_cloro_w);
	Obter_Result_Lab(nr_seq_sodio_w,qt_sodio_w,dt_sodio_w,ds_hint_sodio_w);
	Obter_Result_Lab(nr_seq_potassio_w,qt_potassio_serico_w,dt_potassio_serico_w,ds_hint_potassio_serico_w);
 
 
end if;
 
 
if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 'BRA') then 
	obter_Score_Braden(qt_braden_score_w,dt_braden_score_w,ds_hint_braden_score_w);
	obter_Nutricao_Braden(ie_nutricao_w,dt_nutricao_w,ds_hint_nutricao_w);
end if;
 
if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 'MOR') then 
	obter_Score_Morse(qt_Morse_score_w,dt_morse_score_w,ds_hint_morse_score_w);
end if;
 
 
 
 
if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 'SAE') then 
 
	Obter_Value_Rothman_Index('SISCAD'	,ie_sist_cardiaco_w,dt_sist_cardiaco_w,ds_hint_sist_cardiaco_w);
	Obter_Value_Rothman_Index('SISGAST'	,ie_sist_gastrointestinal_w,dt_sist_gastrointestinal_w,ds_hint_sist_gastroint_w );
 
	Obter_Value_Rothman_Index('SISGENIT',ie_sist_geniturinario_w,dt_sist_geniturinario_w,ds_hint_sist_geniturinario_w);
	Obter_Value_Rothman_Index('SISMUESQ',ie_sist_musc_esq_w,dt_sist_musc_esq_w,ds_hint_sist_musc_esq_w);
	Obter_Value_Rothman_Index('SISNEURO',ie_sist_neurologico_w,dt_sist_neurologico_w,ds_hint_sist_neurologico_w);
	Obter_Value_Rothman_Index('SISRESP',ie_sist_respiratorio_w,dt_sist_respiratorio_w,ds_hint_sist_respiratorio_w);
	Obter_Value_Rothman_Index('SEGQUEDA',IE_REG_RISCO_QUEDA_w,dt_REG_RISCO_QUEDA_w,ds_hint_reg_risco_queda_w);
 
	Obter_Value_Rothman_Index('SISTEGU',IE_SIST_TEGUMENTAR_w,dt_SIST_TEGUMENTAR_w,ds_hint_sist_tegumentar_w );
	Obter_Value_Rothman_Index('SISVASPER',IE_SIST_VASC_PERIFERICO_w,dt_SIST_VASC_PERIFERICO_w,ds_hint_sist_vasc_periferico_w);
	Obter_Value_Rothman_Index('PSICOMP',IE_PSICOSSOCIAL_COMPORT_w,dt_PSICOSSOCIAL_COMPORT_w,ds_hint_psicossocial_comport_w );
 
 
 
	Obter_Value_Rothman_Cardio('SB',ie_sb_w,dt_sb_w,ds_hint_sb_w );
	Obter_Value_Rothman_Cardio('SR',ie_sr_w,dt_sr_w,ds_hint_sr_w);
	Obter_Value_Rothman_Cardio('VT',ie_vt_w,dt_vt_w,ds_hint_vt_w);
	Obter_Value_Rothman_Cardio('AF',ie_af_w,dt_af_w,ds_hint_af_w);
	Obter_Value_Rothman_Cardio('AFL',ie_afl_w,dt_afl_w,ds_hint_afl_w );
	Obter_Value_Rothman_Cardio('EXP',ie_exp_w,dt_exp_w,ds_hint_exp_w );
	Obter_Value_Rothman_Cardio('JR',ie_jr_w,dt_jr_w,ds_hint_jr_w);
	Obter_Value_Rothman_Cardio('VF',ie_vf_w,dt_vf_w,ds_hint_vf_w);
	Obter_Value_Rothman_Cardio('P',ie_p_w,dt_p_w,ds_hint_p_w);
	Obter_Value_Rothman_Cardio('ST',ie_st_w,dt_st_w,ds_hint_st_w);
	Obter_Value_Rothman_Cardio('HB',ie_hb_w,dt_hb_w,ds_hint_hb_w );
 
end if;
 
select	nextval('escala_rothman_seq') 
into STRICT	nr_sequencia_w
;
 
insert into ESCALA_ROTHMAN(	nr_sequencia, 
								dt_avaliacao, 
								dt_atualizacao, 
								nm_usuario, 
								dt_atualizacao_nrec, 
								nm_usuario_nrec, 
								ie_situacao, 
								nr_atendimento, 
								QT_PA_DIASTOLICA, 
								QT_PA_SISTOLICA, 
								QT_FREQ_CARDIACA, 
								QT_FREQ_RESP, 
								QT_TEMP, 
								QT_SATURACAO_O2, 
								qt_ureia, 
								qt_creatinina, 
								qt_glob_brancos, 
								qt_glob_vermelhos, 
								qt_cloro, 
								qt_sodio, 
								qt_potassio_serico, 
								qt_braden_score, 
								ie_sist_cardiaco, 
								ie_sist_gastrointestinal, 
								ie_sist_geniturinario, 
								ie_sist_musc_esq, 
								ie_sist_neurologico, 
								ie_sist_respiratorio, 
								ie_reg_risco_queda, 
								ie_sist_tegumentar, 
								IE_SIST_VASC_PERIFERICO, 
								IE_PSICOSSOCIAL_COMPORT, 
								ie_nutricao, 
								dt_liberacao, 
								dt_pa_sistolica, 
								dt_pa_diastolica, 
								dt_freq_cardiaca, 
								dt_freq_resp, 
								dt_temp, 
								dt_saturacao_o2, 
								dt_ureia, 
								dt_creatinina, 
								dt_glob_brancos, 
								dt_glob_vermelhos, 
								dt_cloro, 
								dt_sodio, 
								dt_potassio_serico, 
								dt_braden_score, 
								dt_nutricao, 
								dt_sist_cardiaco, 
								dt_sist_gastrointestinal, 
								dt_sist_geniturinario, 
								dt_sist_musc_esq, 
								dt_sist_neurologico, 
								dt_sist_respiratorio, 
								dt_reg_risco_queda, 
								dt_sist_tegumentar, 
								dt_sist_vasc_periferico, 
								dt_psicossocial_comport, 
								ds_hint_pa_sistolica , 
								ds_hint_pa_diastolica , 
								ds_hint_freq_cardiaca , 
								ds_hint_freq_resp , 
								ds_hint_temp , 
								ds_hint_saturacao_o2 , 
								ds_hint_braden_score, 
								ds_hint_nutricao, 
								ds_hint_ureia , 
								ds_hint_creatinina , 
								ds_hint_glob_brancos , 
								ds_hint_glob_vermelhos , 
								ds_hint_cloro , 
								ds_hint_sodio , 
								ds_hint_potassio_serico, 
								ds_hint_sist_cardiaco , 
								ds_hint_sist_GASTROINTESTINAL , 
								ds_hint_sist_geniturinario , 
								ds_hint_sist_musc_esq , 
								ds_hint_sist_neurologico , 
								ds_hint_sist_respiratorio , 
								ds_hint_reg_risco_queda , 
								ds_hint_sist_tegumentar , 
								ds_hint_sist_vasc_periferico , 
								ds_hint_psicossocial_comport, 
								qt_Morse_score, 
								dt_morse_score, 
								ds_hint_morse_score, 
								ie_ritmo_ecg, 
								dt_ritmo_ecg, 
								ds_hint_ritmo_ecg) 
	values (		nr_sequencia_w, 
								dt_registro_p, 
								clock_timestamp(), 
								nm_usuario_p, 
								clock_timestamp(), 
								nm_usuario_p, 
								'A', 
								nr_atendimento_p, 
								qt_pa_diastolica_w, 
								qt_pa_sistolica_w, 
								qt_freq_cardiaca_w, 
								qt_freq_resp_w, 
								qt_temp_w, 
								qt_saturacao_o2_w, 
								qt_ureia_w, 
								qt_creatinina_w, 
								qt_glob_brancos_w, 
								qt_glob_vermelhos_w, 
								qt_cloro_w, 
								qt_sodio_w, 
								qt_potassio_serico_w, 
								qt_braden_score_w, 
								ie_sist_cardiaco_w, 
								ie_sist_gastrointestinal_w, 
								ie_sist_geniturinario_w, 
								ie_sist_musc_esq_w, 
								ie_sist_neurologico_w, 
								ie_sist_respiratorio_w, 
								ie_reg_risco_queda_w, 
								ie_sist_tegumentar_w, 
								IE_SIST_VASC_PERIFERICO_w, 
								IE_PSICOSSOCIAL_COMPORT_w, 
								ie_nutricao_w, 
								clock_timestamp(), 
								dt_pa_sistolica_w, 
								dt_pa_diastolica_w, 
								dt_freq_cardiaca_w, 
								dt_freq_resp_w, 
								dt_temp_w, 
								dt_saturacao_o2_w, 
								dt_ureia_w, 
								dt_creatinina_w, 
								dt_glob_brancos_w, 
								dt_glob_vermelhos_w, 
								dt_cloro_w, 
								dt_sodio_w, 
								dt_potassio_serico_w, 
								dt_braden_score_w, 
								dt_nutricao_w, 
								dt_sist_cardiaco_w, 
								dt_sist_gastrointestinal_w, 
								dt_sist_geniturinario_w, 
								dt_sist_musc_esq_w, 
								dt_sist_neurologico_w, 
								dt_sist_respiratorio_w, 
								dt_reg_risco_queda_w, 
								dt_sist_tegumentar_w, 
								dt_sist_vasc_periferico_w, 
								dt_psicossocial_comport_w, 
								ds_hint_pa_sistolica_w , 
								ds_hint_pa_diastolica_w , 
								ds_hint_freq_cardiaca_w , 
								ds_hint_freq_resp_w , 
								ds_hint_temp_w , 
								ds_hint_saturacao_o2_w, 
								ds_hint_braden_score_w, 
								ds_hint_nutricao_w, 
								ds_hint_ureia_w , 
								ds_hint_creatinina_w , 
								ds_hint_glob_brancos_w , 
								ds_hint_glob_vermelhos_w , 
								ds_hint_cloro_w , 
								ds_hint_sodio_w , 
								ds_hint_potassio_serico_w, 
								ds_hint_sist_cardiaco_w , 
								ds_hint_sist_gastroint_w , 
								ds_hint_sist_geniturinario_w , 
								ds_hint_sist_musc_esq_w , 
								ds_hint_sist_neurologico_w , 
								ds_hint_sist_respiratorio_w , 
								ds_hint_reg_risco_queda_w , 
								ds_hint_sist_tegumentar_w , 
								ds_hint_sist_vasc_periferico_w , 
								ds_hint_psicossocial_comport_w, 
								qt_Morse_score_w, 
								dt_morse_score_w, 
								ds_hint_morse_score_w, 
								ie_ritmo_ecg_w, 
								dt_ritmo_ecg_w, 
								ds_hint_ritmo_ecg_w);
								 
								 
CALL Rothman_Envio_hl7(nr_sequencia_w,nr_atendimento_p,nm_usuario_p,ie_opcao_p);
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rothman_atend_dia ( nr_atendimento_p bigint, dt_registro_p timestamp, nm_usuario_p text, ie_opcao_p text default null, nr_seq_reg_p bigint default null, cd_perfil_p bigint default null) FROM PUBLIC;
