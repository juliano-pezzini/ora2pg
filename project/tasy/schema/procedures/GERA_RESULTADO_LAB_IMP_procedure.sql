-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_resultado_lab_imp ( nr_seq_resultado_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_idade_p bigint, ie_sexo_p text, nm_usuario_p text) AS $body$
DECLARE


qt_exames_result_w	bigint;
qt_exames_form		bigint;
nr_seq_exame_w		bigint;
nr_sequencia_w		bigint;
nr_seq_formato_w		bigint;
nr_seq_formato_red_w		bigint;
qt_refer_w			bigint;
qt_minima_w			double precision;
qt_maxima_w			double precision;
pr_minimo_w			double precision;
pr_maximo_w			double precision;
ds_unidade_medida_w		varchar(15);
nr_seq_unid_med_w    exame_laboratorio.nr_seq_unid_med%type;
ds_referencia_w		varchar(4000);
ie_formato_result_w		varchar(3);
qt_dec_exame_w		smallint;
qt_decimais_w			smallint;
ie_formato_pai_w		varchar(3);
ds_regra_w			varchar(255);
nr_seq_metodo_w			bigint;
ds_resultado_w		varchar(2000);
qt_resultado_w		double precision;
pr_resultado_w		double precision;
nr_seq_material_w	bigint;

dt_aprovacao_w		timestamp;
ie_campo_calculo_w	varchar(1);
qt_dias_w		double precision	:= 0;
qt_horas_w		bigint	:= 0;
ie_consiste_w		varchar(1);
ds_texto_padrao_w	varchar(255);
nr_linha_w		exame_lab_format_item.nr_linha%type;
nr_coluna_w		exame_lab_format_item.nr_coluna%type;
nr_seq_metodo_exame_w	bigint;
nr_seq_met_reag_w	bigint;
nr_seq_reagente_w	bigint;
cd_estabelecimento_w	smallint;
ie_amostra_diferente_w	varchar(1);
cd_pessoa_fisica_w		varchar(10);
ie_sexo_w				varchar(1);
ie_sexo_ww				varchar(1);
qt_casas_decimais_dias_w		bigint := 2;

C010 CURSOR FOR
SELECT	A.NR_SEQ_EXAME,
	coalesce(B.DS_UNIDADE_MEDIDA,C.DS_UNIDADE_MEDIDA) DS_UNIDADE_MEDIDA,
	coalesce(B.nr_seq_unid_med,C.nr_seq_unid_med) nr_seq_unid_med,
	obter_formato_result_exame(a.nr_seq_exame, b.nr_seq_material) ie_formato_result,
	coalesce(b.qt_decimais, coalesce(c.qt_decimais, qt_dec_exame_w)) qt_decimais,
	c.ds_regra,
	c.ds_texto_padrao,
	A.nr_coluna,
	A.nr_linha
FROM exame_laboratorio c, exame_lab_format_item a
LEFT OUTER JOIN exame_lab_material b ON (A.NR_SEQ_EXAME = B.NR_SEQ_EXAME AND nr_seq_material_w = B.NR_SEQ_MATERIAL)
WHERE A.NR_SEQ_FORMATO = nr_seq_formato_w AND (A.NR_SEQ_EXAME IS NOT NULL AND A.NR_SEQ_EXAME::text <> '') AND A.NR_SEQ_EXAME = C.NR_SEQ_EXAME
union all

SELECT	A.NR_SEQ_EXAME,
	coalesce(B.DS_UNIDADE_MEDIDA,C.DS_UNIDADE_MEDIDA) DS_UNIDADE_MEDIDA,
	coalesce(B.nr_seq_unid_med,C.nr_seq_unid_med) nr_seq_unid_med,
	obter_formato_result_exame(a.nr_seq_exame, b.nr_seq_material) ie_formato_result,
	coalesce(b.qt_decimais, coalesce(c.qt_decimais, qt_dec_exame_w)) qt_decimais,
	c.ds_regra,
	c.ds_texto_padrao,
	A.nr_coluna + 10,
	A.nr_linha + 10
FROM exame_lab_format d, exame_laboratorio c, exame_lab_format_item a
LEFT OUTER JOIN exame_lab_material b ON (A.NR_SEQ_EXAME = B.NR_SEQ_EXAME AND nr_seq_material_w = B.NR_SEQ_MATERIAL)
WHERE D.NR_SEQ_SUPERIOR = nr_seq_formato_w AND D.NR_SEQ_FORMATO =  A.NR_SEQ_FORMATO AND (A.NR_SEQ_EXAME IS NOT NULL AND A.NR_SEQ_EXAME::text <> '') AND A.NR_SEQ_EXAME = C.NR_SEQ_EXAME   order by 9, 8;


BEGIN

select	coalesce(max(cd_estabelecimento),0),
		max(cd_pessoa_fisica)
into STRICT	cd_estabelecimento_w,
		cd_pessoa_fisica_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select 	coalesce(max(ie_amostras_diferente),'N'),
	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
into STRICT	ie_amostra_diferente_w,
	qt_casas_decimais_dias_w
from	lab_parametro
where	cd_estabelecimento = cd_estabelecimento_w;

select	Obter_Mat_Exame_Lab_prescr(nr_prescricao_p, nr_seq_prescr_p,1)
into STRICT	nr_seq_material_w
;

ie_sexo_w := ie_sexo_p;

select	max(ie_sexo)
into STRICT	ie_sexo_ww
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_w;

if (ie_sexo_w <> ie_sexo_ww) then
	ie_sexo_w := ie_sexo_ww;
end if;

select	coalesce(max(qt_decimais),0),
	max(substr(obter_formato_result_exame(nr_seq_exame_p, nr_seq_material_w),1,3)),
	Max(ie_campo_calculo)
into STRICT	qt_dec_exame_w,
	ie_formato_pai_w,
	ie_campo_calculo_w
from exame_laboratorio
where nr_seq_exame = nr_seq_exame_p;

select	coalesce(max(nr_seq_metodo),0),
 	max(dt_aprovacao)
into STRICT 	nr_seq_metodo_w,
	dt_aprovacao_w
from exame_lab_result_item
where nr_seq_resultado = nr_seq_resultado_p
  and nr_seq_prescr = nr_seq_prescr_p
  and (nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

select	coalesce(max(obter_formato_exame(nr_seq_exame_p, nr_seq_material_w, nr_seq_metodo_w, 'L')),0),
	coalesce(max(obter_formato_exame(nr_seq_exame_p, nr_seq_material_w, nr_seq_metodo_w, 'R')),0)
into STRICT	nr_seq_formato_w,
	nr_seq_formato_red_w
;

select 	obter_dias_entre_datas_lab(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp()),
	Obter_Hora_Entre_datas(obter_nascimento_prescricao(nr_prescricao_p),clock_timestamp())
into STRICT 	qt_dias_w,
	qt_horas_w
;

begin

select count(*)
into STRICT qt_exames_form
from exame_lab_format_item
where nr_seq_formato = nr_seq_formato_w
  and ((coalesce(ds_texto::text, '') = '') or (ds_texto not like '@%'));
exception
	when others then
		qt_exames_form := 0;
end;

if (qt_exames_form = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(186930,'NR_SEQ_EXAME='||to_char(nr_seq_exame_p)||';'||'NR_SEQ_MATERIAL='||to_char(nr_seq_material_p)||';'||'NR_SEQ_FORMATO='||to_char(nr_seq_formato_w));
	--' Exame não possui formato ! ' || chr(10) || 'Exame: '|| nr_seq_exame_p ||'Material: ' || nr_seq_material_w || ' Formato : ' || nr_seq_formato_w);
end if;

if (coalesce(nr_seq_formato_w,0) > 0) and (coalesce(dt_aprovacao_w::text, '') = '') then
	begin

	begin
	select coalesce(max(nr_sequencia),0)
	into STRICT nr_sequencia_w
	from exame_lab_result_item
	where nr_seq_resultado = nr_seq_resultado_p;
	exception
		when others then
			nr_sequencia_w := 0;
	end;

	begin
	select count(*)
	into STRICT qt_exames_result_w
	from exame_lab_result_item
	where nr_seq_resultado = nr_seq_resultado_p
	  and nr_seq_prescr = nr_seq_prescr_p;
	exception
		when others then
			nr_sequencia_w := 0;
	end;

	update exame_lab_result_item
	set	nr_seq_formato		= nr_seq_formato_w,
		nr_seq_formato_red	= CASE WHEN nr_seq_formato_red_w=0 THEN null  ELSE nr_seq_formato_red_w END
	where nr_seq_resultado	= nr_seq_resultado_p
	  and nr_seq_prescr	= nr_seq_prescr_p
	  and (nr_seq_material IS NOT NULL AND nr_seq_material::text <> '')
	  and coalesce(nr_seq_formato_w,0) > 0;

	OPEN C010;
	LOOP
	FETCH C010 into	nr_seq_exame_w,
				ds_unidade_medida_w,
				nr_seq_unid_med_w,
				ie_formato_result_w,
				qt_decimais_w,
				ds_regra_w,
				ds_texto_padrao_w,
				nr_coluna_w,
				nr_linha_w;
		if C010%FOUND then
			begin

			select	coalesce(max(a.nr_sequencia),0),
					coalesce(max(b.nr_sequencia),null)
			into STRICT	nr_seq_met_reag_w,
					nr_seq_reagente_w
			FROM lab_reagente b, metodo_reagente_lab a
LEFT OUTER JOIN lab_reagente_estab c ON (a.nr_seq_reagente = c.nr_seq_reagente)
WHERE a.nr_seq_metodo = nr_seq_metodo_w and a.nr_seq_reagente = b.nr_sequencia  and coalesce(c.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;			
			
			begin

			select 	qt_minima,
			       	qt_maxima,
			  	qt_percent_min,
				qt_percent_max,
				ds_observacao,
				CASE WHEN ie_tipo_valor=3 THEN 'N'  ELSE 'S' END
			into STRICT	qt_minima_w,
				qt_maxima_w,
				pr_minimo_w,
				pr_maximo_w,
				ds_referencia_w,
				ie_consiste_w
			from (
			SELECT qt_minima,
				 qt_maxima,
				 qt_percent_min,
				 qt_percent_max,
				 ds_observacao,
				 ie_tipo_valor
			from exame_lab_padrao
			where ((ie_sexo = ie_sexo_w) or (ie_sexo = '0'))
			  and nr_seq_exame = nr_seq_exame_w
			  and coalesce(nr_seq_material,nr_seq_material_w) = nr_seq_material_w
			  and coalesce(nr_seq_metodo, nr_seq_metodo_w) = nr_seq_metodo_w
			  and (((trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
			       ((trunc(((qt_dias_w / 365.25) * 12), qt_casas_decimais_dias_w) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
			  	(qt_dias_w between qt_idade_min and qt_idade_max AND ie_periodo = 'D') or
				(qt_horas_w between qt_idade_min and qt_idade_max AND ie_periodo = 'H'))
			  and ie_tipo_valor in (0,3)
			  and coalesce(ie_situacao,'A') = 'A'
			order by coalesce(nr_seq_material, 9999999999), coalesce(nr_seq_metodo, 9999999999), ie_sexo,

CASE WHEN ie_periodo='D' THEN 1 WHEN ie_periodo='M' THEN 2  ELSE 3 END ) alias23 LIMIT 1;
			exception
				when others then
					qt_minima_w 	:= null;
					qt_maxima_w 	:= null;
					pr_minimo_w 	:= null;
					pr_maximo_w 	:= null;
					ds_referencia_w	:= null;
					ie_consiste_w	:= 'N';
			end;

			select	count(*)
			into STRICT	qt_exames_result_w
			from	exame_lab_result_item
			where	nr_seq_resultado	= nr_seq_resultado_p
			  and	nr_seq_prescr		= nr_seq_prescr_p
			  and	nr_seq_exame		= nr_seq_exame_w;

			ds_resultado_w	:= coalesce(lab_obter_valor_padrao(ds_regra_w),ds_texto_padrao_w);

			if (qt_exames_result_w = 1) then

				update 	exame_lab_result_item
				set 	pr_minimo = pr_minimo_w,
					pr_maximo = pr_maximo_w,
					qt_minima = qt_minima_w,
					qt_maxima = qt_maxima_w,
					ds_referencia = ds_referencia_w,
					ie_consiste = ie_consiste_w,
					ds_unidade_medida = coalesce(ds_unidade_medida_w,' '),
					nr_seq_unid_med = nr_seq_unid_med_w,
					qt_decimais = qt_decimais_w,
					ds_regra = ds_regra_w,
					nr_seq_reagente = coalesce(nr_seq_reagente_w, nr_seq_reagente)
				where nr_seq_resultado	= nr_seq_resultado_p
				  and nr_seq_prescr	= nr_seq_prescr_p
				  and nr_seq_exame	= nr_seq_exame_w;

				if (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
					if (ie_formato_result_w = 'V') or (ie_formato_result_w = 'VP' and ie_campo_calculo_w = 'P') then
						update exame_lab_result_item
						set	qt_resultado = ds_resultado_w
						where nr_seq_resultado	= nr_seq_resultado_p
						  and nr_seq_prescr	= nr_seq_prescr_p
						  and nr_seq_exame	= nr_seq_exame_w;

					elsif (ie_formato_result_w = 'P') or (ie_formato_result_w = 'VP' and ie_campo_calculo_w = 'V') then
						update exame_lab_result_item
						set	pr_resultado = ds_resultado_w
						where nr_seq_resultado	= nr_seq_resultado_p
						  and nr_seq_prescr	= nr_seq_prescr_p
						  and nr_seq_exame	= nr_seq_exame_w;
					else
						update exame_lab_result_item
						set	ds_resultado = ds_resultado_w
						where nr_seq_resultado	= nr_seq_resultado_p
						  and nr_seq_prescr	= nr_seq_prescr_p
						  and nr_seq_exame	= nr_seq_exame_w;
					end if;
				end if;
			else
				qt_resultado_w := 0;
				pr_resultado_w := 0;

				select 	obter_metodo_regra_item(nr_prescricao_p,nr_seq_exame_w)
				into STRICT	nr_seq_metodo_exame_w
				;

				if (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
					if (ie_formato_result_w = 'V') or (ie_formato_result_w = 'VP' and ie_campo_calculo_w = 'P') then
						qt_resultado_w	:= ds_resultado_w;
						ds_resultado_w	:= '';
					elsif (ie_formato_result_w = 'P') or (ie_formato_result_w = 'VP' and ie_campo_calculo_w = 'V') then
						pr_resultado_w	:= ds_resultado_w;
						ds_resultado_w	:= '';
					end if;
				end if;

				if (ie_formato_pai_w = 'CV') and (nr_seq_exame_w = -1) then
					select coalesce(max(qt_volume),0)
					into STRICT qt_resultado_w
					from prescr_proc_material
					where nr_prescricao = nr_prescricao_p
					  and nr_seq_material = nr_seq_material_w;
				end if;

				nr_sequencia_w := nr_sequencia_w + 1;
				insert into exame_lab_result_item(nr_seq_resultado, nr_sequencia, nr_seq_exame, dt_atualizacao,
				 nm_usuario, qt_resultado, ds_resultado, nr_seq_metodo,
				 nr_seq_material, pr_resultado, ie_status, dt_aprovacao,
				 nm_usuario_aprovacao, nr_seq_prescr,pr_minimo,pr_maximo,
				 qt_minima,qt_maxima,ds_referencia,ds_unidade_medida, nr_seq_unid_med,
				qt_decimais, ds_regra, ie_consiste,nr_seq_metodo_exame,nr_seq_reagente)
				values (nr_seq_resultado_p,
		  		 nr_sequencia_w,
			  	 nr_seq_exame_w,
			  	 clock_timestamp(),
			  	 nm_usuario_p,
		  		 CASE WHEN ie_formato_result_w='V' THEN qt_resultado_w WHEN ie_formato_result_w='VP' THEN qt_resultado_w WHEN ie_formato_result_w='CV' THEN qt_resultado_w END ,

ds_resultado_w, null, null,
			  	 CASE WHEN ie_formato_result_w='P' THEN pr_resultado_w WHEN ie_formato_result_w='VP' THEN pr_resultado_w END , '', null, '',
				 nr_seq_prescr_p,pr_minimo_w,pr_maximo_w,
				 qt_minima_w,qt_maxima_w,ds_referencia_w,coalesce(ds_unidade_medida_w,' '), nr_seq_unid_med_w,
				 qt_decimais_w, ds_regra_w, ie_consiste_w, nr_seq_metodo_exame_w,nr_seq_reagente_w);
			end if;

/*			Elemar - 25/10/2004 - Troquei pelo if acima
			if	(ie_formato_result_w <> 'SM') and ((qt_exames_form = 1) or
				((qt_exames_form > 1) and (nr_seq_exame_p = nr_seq_exame_w))) then
				update exame_lab_result_item
				set pr_minimo = pr_minimo_w,
				    pr_maximo = pr_maximo_w,
				    qt_minima = qt_minima_w,
				    qt_maxima = qt_maxima_w,
				    ds_referencia = ds_referencia_w,
				    ds_unidade_medida = nvl(ds_unidade_medida_w,' '),
				    nr_seq_unid_med = nr_seq_unid_med_w,
				    qt_decimais = qt_decimais_w,
				    ds_regra = ds_regra_w
				where nr_seq_resultado = nr_seq_resultado_p
				  and nr_seq_prescr = nr_seq_prescr_p;
			elsif (qt_exames_result_w <= 1) then
				begin
				qt_volume_w := 0;
				if (ie_formato_pai_w = 'CV') and
				   (nr_seq_exame_w = -1) then
					select nvl(max(qt_volume),0)
					into qt_volume_w
					from prescr_proc_material
					where nr_prescricao = nr_prescricao_p
					  and nr_seq_material = nr_seq_material_p;
				end if;
				nr_sequencia_w := nr_sequencia_w + 1;
				insert into exame_lab_result_item
				(nr_seq_resultado, nr_sequencia, nr_seq_exame, dt_atualizacao,
				 nm_usuario, qt_resultado, ds_resultado, nr_seq_metodo,
				 nr_seq_material, pr_resultado, ie_status, dt_aprovacao,
				 nm_usuario_aprovacao, nr_seq_prescr,pr_minimo,pr_maximo,
				 qt_minima,qt_maxima,ds_referencia,ds_unidade_medida, nr_seq_unid_med, qt_decimais, ds_regra)
				values
				(nr_seq_resultado_p,
		  		 nr_sequencia_w,
			  	 nr_seq_exame_w,
			  	 sysdate,
			  	 nm_usuario_p,
		  		 decode(ie_formato_result_w,'V',qt_volume_w,'VP',qt_volume_w,'CV',qt_volume_w), '', null,

null,
			  	 decode(ie_formato_result_w,'P',0,'VP',0), '', null, '',
				 nr_seq_prescr_p,pr_minimo_w,pr_maximo_w,
				 qt_minima_w,qt_maxima_w,ds_referencia_w,nvl(ds_unidade_medida_w,' '), nr_seq_unid_med_w,

qt_decimais_w, ds_regra_w);
				end;
			end if;
*/
			end;

		else
			exit;
		end if;
	END LOOP;
	CLOSE C010;
	end;
end if;

begin

if (ie_amostra_diferente_w = 'S') then
	update 	prescr_procedimento a
	set	a.ie_status_atend = CASE WHEN nm_usuario_p='ADMINIST' THEN  35  ELSE 30 END ,
		a.ie_amostra = 'S',
		a.nm_usuario = nm_usuario_p,
		a.dt_atualizacao = clock_timestamp()
	where 	a.nr_prescricao	= nr_prescricao_p
	and 	a.nr_sequencia	= nr_seq_prescr_p
	and 	a.ie_status_atend < 30
	and not exists (SELECT 	1
			from 	prescr_proc_mat_item b
			where 	b.nr_prescricao = a.nr_prescricao
			and	b.nr_seq_prescr = a.nr_sequencia
			and	b.ie_status <= 20);
else
	update 	prescr_procedimento
	set	ie_status_atend = CASE WHEN nm_usuario_p='ADMINIST' THEN  35  ELSE 30 END ,
		ie_amostra = 'S',
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where 	nr_prescricao	= nr_prescricao_p
	and 	nr_sequencia	= nr_seq_prescr_p
	and 	ie_status_atend < 30;
end if;

exception
	when others then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(186929);
		--' Erro ao atualizar prescrição ! 
end;


COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_resultado_lab_imp ( nr_seq_resultado_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_idade_p bigint, ie_sexo_p text, nm_usuario_p text) FROM PUBLIC;

