-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (dt_hora		timestamp);


CREATE OR REPLACE FUNCTION obter_horario_imp_prescricao ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_proc_mat_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000)	:= null;
ds_horario_w		varchar(2000);
ds_hora_w		varchar(255);
ds_hor_res_w		varchar(255);
ds_pos_res_w		varchar(255);
ds_cor_res_w		varchar(255);
ds_estilo_res_w	varchar(255);
type Vetor is table of campos index by integer;
horarios_w		Vetor;
horario_w		Vetor;
i			integer	:= 0;
k			integer := 0;
z			integer;
dt_hora_w		timestamp;
dt_inic_w		timestamp;
dt_fim_w		timestamp;
ie_separador_w	varchar(1)	:= '';
ds_noturno_w		varchar(5)	:= '19/06';
ie_cor_fonte_w		varchar(2)	:= 'V';
ie_Estilo_w		varchar(1)	:= '';
ie_Cor_w		varchar(5)	:= '';
qt_reg_w		integer;
nr_seq_w		integer;
ie_horarios_w		varchar(10);
ie_se_necessario_w	varchar(1);
ie_estilo_padrao_w	varchar(1);
ie_operacao_w		varchar(1);
nr_atendimento_w	bigint;
cd_material_w		integer;
dt_horario_w		timestamp;
dt_inicio_prescr_w	timestamp;
dt_fim_prescr_w		timestamp;
ie_urgencia_w		prescr_material.ie_urgencia%type;

C01 CURSOR FOR
	SELECT 	--padroniza_horario_prescr(decode(nvl(c.ie_operacao,''),'F',Reordenar_Horarios(nvl(to_date('01/01/2000'||b.hr_prim_horario||':00','dd/mm/yyyy hh24:mi:ss'), a.dt_primeiro_horario),b.ds_horarios),b.ds_horarios), decode(substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,b.hr_prim_horario),1,1),'N','01/01/2000 23:59:59', to_char(nvl(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss')))
		padroniza_horario_prescr(CASE WHEN coalesce(c.ie_operacao,'')='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000 '||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'), a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ),
		a.nr_atendimento,
		a.dt_inicio_prescr,
		a.dt_validade_prescr,
		b.ie_urgencia
	FROM prescr_medica a, prescr_material b
LEFT OUTER JOIN intervalo_prescricao c ON (b.cd_intervalo = c.cd_intervalo)
WHERE b.nr_prescricao	= nr_prescricao_p  and a.nr_prescricao = b.nr_prescricao and ie_proc_mat_p	= 'M' and b.ie_agrupador	= 1 and padroniza_horario_prescr(CASE WHEN coalesce(c.ie_operacao,'')='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000'||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'), a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END )  is not null --and	padroniza_horario_prescr(decode(nvl(c.ie_operacao,''),'F',Reordenar_Horarios(nvl(to_date('01/01/2000'||b.hr_prim_horario||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios),b.ds_horarios), decode(substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,b.hr_prim_horario),1,1),'N','01/01/2000 23:59:59', to_char(nvl(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss'))) is not null
Union

	SELECT	padroniza_horario_prescr(CASE WHEN coalesce(c.ie_operacao,'')='F' THEN Reordenar_Horarios(coalesce(a.dt_primeiro_horario,a.dt_prescricao),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,to_char(b.dt_prev_execucao,'hh24:mi')),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END ),
		a.nr_atendimento,
		a.dt_inicio_prescr,
		a.dt_validade_prescr,
		b.ie_urgencia
	FROM prescr_medica a, prescr_procedimento b
LEFT OUTER JOIN intervalo_prescricao c ON (b.cd_intervalo = c.cd_intervalo)
WHERE a.nr_prescricao	= nr_prescricao_p  and a.nr_prescricao = b.nr_prescricao and padroniza_horario_prescr(CASE WHEN coalesce(c.ie_operacao,'')='F' THEN Reordenar_Horarios(coalesce(a.dt_primeiro_horario,a.dt_prescricao),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,to_char(b.dt_prev_execucao,'hh24:mi')),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END ) is not null and ie_proc_mat_p	= 'P';


BEGIN

select	a.ie_operacao,
	b.cd_material
into STRICT	ie_operacao_w,
	cd_material_w
FROM prescr_material b
LEFT OUTER JOIN intervalo_prescricao a ON (b.cd_intervalo = a.cd_intervalo)
WHERE b.nr_prescricao	= nr_prescricao_p and b.nr_sequencia	= nr_sequencia_p;

select	coalesce(vl_parametro, vl_parametro_padrao)
into STRICT	ie_horarios_w
from	funcao_parametro
where	cd_funcao = 924
and	nr_sequencia = 70;

select	coalesce(coalesce(vl_parametro, vl_parametro_padrao),'V')
into STRICT	ie_cor_fonte_w
from	funcao_parametro
where	cd_funcao = 924
and	nr_sequencia = 86;


select	coalesce(coalesce(vl_parametro, vl_parametro_padrao),'N')
into STRICT	ie_estilo_padrao_w
from	funcao_parametro
where	cd_funcao = 924
and	nr_sequencia = 132;

select	count(*),
	min(nr_sequencia)
into STRICT	qt_reg_w,
	nr_seq_w
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
  and	ie_agrupador		= 1
  and	nr_agrupamento	=
	(SELECT nr_agrupamento
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p
	  and	nr_sequencia	= nr_sequencia_p);
if (qt_reg_w > 1) and (nr_sequencia_p <> nr_seq_w) then
	ds_retorno_w		:= '';
	ds_horario_w		:= '';
elsif (ie_proc_mat_p = 'M') then
	select	CASE WHEN ie_operacao_w='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000'||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END ,
		--padroniza_horario_prescr(decode(ie_operacao_w,'F',Reordenar_Horarios(nvl(to_date('01/01/2000'||b.hr_prim_horario||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios),b.ds_horarios), decode(substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,b.hr_prim_horario),1,1),'N','01/01/2000 23:59:59', to_char(nvl(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss'))),
		padroniza_horario_prescr(CASE WHEN ie_operacao_w='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000'||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ),
		b.ie_se_necessario,
		a.dt_inicio_prescr,
		a.dt_validade_prescr,
		b.ie_urgencia
	into STRICT	ds_retorno_w,
		ds_horario_w,
		ie_se_necessario_w,
		dt_inicio_prescr_w,
		dt_fim_prescr_w,
		ie_urgencia_w
	from	Prescr_material b,
		prescr_medica a
	where	b.nr_prescricao	= nr_prescricao_p
	  and	b.nr_sequencia	= nr_sequencia_p
	  and	b.ie_agrupador	= 1
	  and	b.nr_prescricao = a.nr_prescricao;
else
	select	CASE WHEN ie_operacao_w='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000'||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END ,
		--padroniza_horario_prescr(decode(ie_operacao_w,'F',Reordenar_Horarios(nvl(to_date('01/01/2000'||b.hr_prim_horario||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios),b.ds_horarios), decode(substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,b.hr_prim_horario),1,1),'N','01/01/2000 23:59:59', to_char(nvl(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss'))),
		padroniza_horario_prescr(CASE WHEN ie_operacao_w='F' THEN Reordenar_Horarios(coalesce(to_date('01/01/2000'||CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ||':00','dd/mm/yyyy hh24:mi:ss'),a.dt_primeiro_horario),b.ds_horarios)  ELSE b.ds_horarios END , CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_prescricao,a.dt_primeiro_horario,CASE WHEN b.hr_prim_horario='  :  ' THEN to_char(a.dt_primeiro_horario,'hh24:mi')  ELSE b.hr_prim_horario END ),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_primeiro_horario,a.dt_prescricao),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ),
		b.ie_se_necessario,
		a.dt_inicio_prescr,
		a.dt_validade_prescr,
		b.ie_urgencia
	into STRICT	ds_retorno_w,
		ds_horario_w,
		ie_se_necessario_w,
		dt_inicio_prescr_w,
		dt_fim_prescr_w,
		ie_urgencia_w
	from	Prescr_material b,
		prescr_medica a
	where	b.nr_prescricao	= nr_prescricao_p
	  and	b.nr_sequencia	= nr_sequencia_p
	  and	b.ie_agrupador	= 1
	  and	b.nr_prescricao = a.nr_prescricao;
end if;

if (coalesce(ds_horario_w::text, '') = '') or (ie_se_necessario_w = 'S') then
	ds_retorno_w		:= '1#1#'  || ds_retorno_w || '#1#;#;';
else
	begin
	
	begin
		select	coalesce(vl_parametro, vl_parametro_padrao)
		into STRICT	ds_noturno_w
		from	funcao_parametro
		where	cd_funcao	= 924
		and	nr_sequencia	= 71;
		--dt_inic_w	:= To_date('01/01/2000 ' || substr(ds_noturno_w,1,2), 'dd/mm/yyyy hh24');

		--dt_fim_w	:= To_date('02/01/2000 ' || substr(ds_noturno_w,4,2), 'dd/mm/yyyy hh24');
		dt_inic_w	:= To_date(to_char(dt_inicio_prescr_w, 'dd/mm/yyyy')  || substr(ds_noturno_w,1,2), 'dd/mm/yyyy hh24');
		dt_fim_w	:= To_date(to_char(dt_fim_prescr_w, 'dd/mm/yyyy') || substr(ds_noturno_w,4,2), 'dd/mm/yyyy hh24');
	exception
		when others then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(182566);
	end;	
	
	i	:= 0;
	while	(ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') LOOP
		begin
		select position(' ' in ds_horario_w) into STRICT k;
		if (k > 1) then
			ds_hora_w	:= substr(ds_horario_w, 1, k-1);
			ds_horario_w	:= substr(ds_horario_w, k + 1, 2000);
		elsif (ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') then
			ds_hora_w 	:= replace(ds_horario_w, ' ','');
			ds_horario_w	:= '';
		end if;
		
		i	:= i + 1;
		
		if (substr(upper(ds_hora_w),1,1) = 'A') and (ie_urgencia_w = 'N') then
			--horario_w(i).dt_hora	:= To_date('01/01/2000 ' || replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi') + 1;
			horario_w[i].dt_hora	:= to_date(to_char(dt_fim_prescr_w, 'dd/mm/yyyy')||replace(ds_hora_w,'A',''),'dd/mm/yyyy hh24:mi');
		else
			--horario_w(i).dt_hora	:= To_date('01/01/2000 ' || ds_hora_w, 'dd/mm/yyyy hh24:mi');
			horario_w[i].dt_hora	:= to_date(to_char(dt_inicio_prescr_w, 'dd/mm/yyyy')||replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi');
		end if;
		end;
	END LOOP;
/* Selecionar os horarios de toda prescricao */

	i	:= 0;
	OPEN C01;
	LOOP
	FETCH C01 into
		ds_horario_w,
		nr_atendimento_w,
		dt_inicio_prescr_w,
		dt_fim_prescr_w,
		ie_urgencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		while	(ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') LOOP
			begin
			select	position(' ' in ds_horario_w)
			into STRICT	k
			;
			

			
			if (k > 1) then
				ds_hora_w	:= substr(ds_horario_w, 1, k-1);
				ds_horario_w	:= substr(ds_horario_w, k + 1, 2000);
			elsif (ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') then
				if (position('A' in ds_horario_w) > 0) then
					ds_hora_w 	:= replace(substr(ds_horario_w, 1, 6), ' ','');
				else
					ds_hora_w 	:= replace(substr(ds_horario_w, 1, 5), ' ','');
				end if;
				
				ds_horario_w	:= '';
			end if;

			select	length(substr(ds_hora_w, position(':' in ds_hora_w)+1, length(ds_hora_w)))
			into STRICT	k
			;
			
			if (k = 1) then
				ds_hora_w := ds_hora_w ||'0';
			end if;
			/*  Victor 21/10/2009  OS 173774  fim*/

			z			:= 0;
			k			:= 1;
			if (substr(upper(ds_hora_w),1,1) = 'A') and (ie_urgencia_w = 'N') then
				--dt_hora_w	:= To_date('02/01/2000 ' || replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi');
				dt_hora_w	:= to_date(to_char(dt_fim_prescr_w, 'dd/mm/yyyy')||replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi');
			else
				dt_hora_w	:= to_date(to_char(dt_inicio_prescr_w, 'dd/mm/yyyy')||replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi');
				--dt_hora_w	:= To_date('01/01/2000 ' || ds_hora_w, 'dd/mm/yyyy hh24:mi');
			end if;
			
			FOR k in 1..Horarios_w.count LOOP
				if (horarios_w[k].dt_hora = dt_hora_w) then
					z	:= k;
				end if;
			END LOOP;
			if (z = 0) then
				i	:= i + 1;
				horarios_w[i].dt_hora	:= dt_hora_w;
			end if;
			end;
		END LOOP;
	END LOOP;
	CLOSE C01;	
/* Classificar os horarios */

	k		:= 1;
	z		:= 0;
	while	z = 0 LOOP
		z	:= 1;
		FOR k in 1..Horarios_w.count LOOP
			if (k < Horarios_w.count) and (horarios_w[k].dt_hora > horarios_w[k+ 1].dt_hora) then
				dt_hora_w		:= horarios_w[k].dt_hora;
				horarios_w[k].dt_hora	:= horarios_w[K + 1].dt_hora;
				horarios_w[k+1].dt_hora	:= dt_hora_w;
				z			:= 0;
			end if;
		END LOOP;
	END LOOP;
	
/* Retorno dos horarios na sequencia */

	k	:= 1;
	FOR k in 1..Horario_w.count LOOP
		begin
		i	:= 1;
		for i in 1..horarios_w.count LOOP
			if (to_char(horario_w[k].dt_hora, 'dd/mm/yyyy hh24:mi') = to_char(horarios_w[i].dt_hora, 'dd/mm/yyyy hh24:mi')) then
				z	:= i;
			end if;
	
		END LOOP;
		ds_hora_w	:= to_char(horario_w[k].dt_hora,'hh24:mi');		
		dt_horario_w	:= horario_w[k].dt_hora;
		
		ie_estilo_w := '';
		
		--OS714398

		--if	(obter_se_horario_adm(nr_atendimento_w, nr_prescricao_p, cd_material_w, ds_hora_w) = 'S') then

		--	ie_estilo_w	:= 'K';

		--end if;
		
		if (obter_se_horario_adm_data(nr_atendimento_w, nr_prescricao_p, cd_material_w, dt_horario_w) = 'S') then
			ie_estilo_w	:= 'K';
		end if;
		
		if (substr(ds_hora_w,1,2) = '00') then
			ds_hora_w	:= '24:' || substr(ds_hora_w,4,2);
		end if;
		if (substr(ds_hora_w,4,2) = '00') then
			ds_hora_w	:= substr(ds_hora_w,1,2);
		end if;
		
		ie_cor_w := '';

		if (horario_w[k].dt_hora >= dt_inic_w) and (horario_w[k].dt_hora <= dt_fim_w) and (coalesce(ie_estilo_w,'0')	<> 'O') then
			ie_Cor_w	:= ie_cor_fonte_w;
			if	((ie_estilo_padrao_w <> 'T')   and (coalesce(ie_estilo_w,'0') = '0')) then
				ie_estilo_w	:= ie_estilo_padrao_w;
			elsif (ie_estilo_w <> 'K') then
				ie_estilo_w	:= '';
			end if;
		elsif (ie_estilo_w <> 'K') then
			ie_Cor_w	:= '';
			ie_estilo_w	:= '';
		end if;
		
		ds_hor_res_w		:= substr(ds_hor_res_w || ie_separador_w || ds_hora_w,1,255);
		ds_pos_res_w		:= substr(ds_pos_res_w || ie_separador_w || z,1,255);
		ds_cor_res_w		:= substr(ds_cor_res_w  || ie_separador_w || ie_cor_w,1,255);
		ds_estilo_res_w		:= substr(ds_estilo_res_w || ie_separador_w || ie_estilo_w,1,255);
		ie_separador_w		:= ';';
		end;
	END LOOP;
	ds_retorno_w	:= horarios_w.count || '#' || horario_w.count || '#' ||
			   ds_hor_res_w || '#' || ds_pos_res_w ||
			   '#' || ds_estilo_res_w || '#' || ds_cor_res_w;
	end;
end if;

return substr(ds_retorno_w,1,2000);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_imp_prescricao ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_proc_mat_p text) FROM PUBLIC;

