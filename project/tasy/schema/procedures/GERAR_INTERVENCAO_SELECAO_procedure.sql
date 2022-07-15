-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_intervencao_selecao ( nr_sequencia_p bigint, ie_excluir_p text, nr_seq_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_intervalo_p text default null, nr_seq_diag_p bigint default null) AS $body$
DECLARE

					
nr_seq_diag_w		bigint;
nr_seq_diag_ww		bigint;
nr_seq_proc_w		bigint;
nr_sequencia_w		bigint;
qt_existe_w		bigint;
nr_seq_result_w		bigint;
cd_intervalo_w		varchar(7);
ds_horario_padrao_w	varchar(2000);
nr_seq_probl_colab_w	bigint;
ds_observacao_padr_w	varchar(255);
ie_adep_w		varchar(1);
vl_prim_hor_w		varchar(15);
hr_prim_horario_w		timestamp;
nr_intervalo_w		real;
ds_horarios_w		varchar(2000);
dt_prescricao_w		timestamp;
qt_horas_validade_w	bigint;
ds_prim_horario_w		varchar(255);
ie_se_necessario_w		varchar(1);
qt_reg_w			bigint;
ie_auxiliar_w       	varchar(10);
ie_encaminhar_w     	varchar(10);
ie_fazer_w          	varchar(10);
ie_orientar_w       	varchar(10);
ie_supervisionar_w   	varchar(10);
dt_primeiro_horario_w	timestamp;
ie_limpar_w				char(1) := 'N';
ie_agora_w				varchar(10);
ie_interv_espec_agora_w	varchar(10) := 'N';

c01 CURSOR FOR
SELECT	a.nr_seq_proc,
	coalesce(cd_intervalo_p, c.cd_intervalo),
	c.ds_horario_padrao,
	c.ds_observacao_padr,
	c.ie_adep,
	c.ie_auxiliar,
	c.ie_encaminhar,
	c.ie_fazer,
	c.ie_orientar,
	c.ie_supervisionar,
	a.nr_seq_diag
FROM pe_diagnostico_proc a
LEFT OUTER JOIN pe_procedimento c ON (a.nr_seq_proc = c.nr_sequencia)
WHERE a.nr_seq_diag	in (	SELECT	distinct(nr_seq_diag)
					from	pe_prescr_diag
					where	nr_seq_prescr	= nr_sequencia_p)  and coalesce(c.ie_situacao,'A') = 'A' and a.nr_seq_proc	= nr_seq_proc_p and not exists (	select	1
			from	pe_prescr_proc b
			where	b.nr_seq_prescr	= nr_sequencia_p
			and	b.nr_seq_proc	= a.nr_seq_proc);

c02 CURSOR FOR
SELECT	b.nr_seq_proc,
	coalesce(cd_intervalo_p, c.cd_intervalo),
	c.ds_horario_padrao,
	c.ds_observacao_padr,
	c.ie_adep,
	c.ie_auxiliar,
	c.ie_encaminhar,
	c.ie_fazer,
	c.ie_orientar,
	c.ie_supervisionar
from	pe_procedimento c,
	pe_item_result_proc b,
	pe_item_resultado a
where	c.nr_sequencia	= b.nr_seq_proc
and	a.nr_sequencia	= b.nr_seq_result
and	a.nr_sequencia	in (	SELECT	distinct(nr_seq_result)
					from	pe_prescr_item_result
					where	nr_seq_prescr = nr_sequencia_p)
and	coalesce(a.ie_situacao,'A')	= 'A'
and	coalesce(c.ie_situacao,'A')	= 'A'
and	b.nr_seq_proc	= nr_seq_proc_p
and	not exists (	select	1
			from	pe_prescr_proc x
			where	x.nr_seq_prescr	= nr_sequencia_p
			and	x.nr_seq_proc	= b.nr_seq_proc);
	
c03 CURSOR FOR
SELECT	b.nr_seq_proc,
	coalesce(cd_intervalo_p, c.cd_intervalo),
	c.ds_horario_padrao,
	c.ds_observacao_padr,
	c.ie_adep,
	c.ie_auxiliar,
	c.ie_encaminhar,
	c.ie_fazer,
	c.ie_orientar,
	c.ie_supervisionar
from	pe_procedimento c,
	pe_probl_col_proc b,
	pe_problema_colab a
where	c.nr_sequencia	= b.nr_seq_proc
and	coalesce(c.ie_situacao,'A')	= 'A'
and	a.nr_sequencia	= b.nr_seq_probl_colab
and	a.nr_sequencia	in (	SELECT	distinct(nr_seq_probl_colab)
					from	pe_prescr_probl_col
					where	nr_prescricao	= nr_sequencia_p)
and	b.nr_seq_proc	= nr_seq_proc_p
and	not exists (	select	1
			from	pe_prescr_proc x
			where	x.nr_seq_prescr	= nr_sequencia_p
			and	x.nr_seq_proc	= b.nr_seq_proc);
			
C04 CURSOR FOR
	SELECT	distinct(nr_seq_diag)
	from	pe_prescr_diag
	where	nr_seq_prescr = nr_sequencia_p;


BEGIN

vl_prim_hor_w := obter_param_usuario(281, 325, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, vl_prim_hor_w);

if (ie_excluir_p = 'S') then
	delete	FROM pe_prescr_proc
	where	nr_seq_prescr = nr_sequencia_p;
end if;

select	dt_prescricao,
		qt_horas_validade,
		DT_INICIO_PRESCR,
		ie_agora
into STRICT	dt_prescricao_w,
		qt_horas_validade_w,
		dt_primeiro_horario_w,
		ie_agora_w
from	pe_prescricao
where	nr_sequencia = nr_sequencia_p
and	coalesce(ie_situacao,'A') = 'A';

if (ie_agora_w	= 'S') then
	ie_interv_espec_agora_w	:= 'S';
end if;

open c04;
loop
fetch c04 into
	nr_seq_diag_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
	--begin
	open c01;
	loop
	fetch c01 into
		nr_seq_proc_w,
		cd_intervalo_w,
		ds_horario_padrao_w,
		ds_observacao_padr_w,
		ie_adep_w,
		ie_auxiliar_w    ,
		ie_encaminhar_w  ,     
		ie_fazer_w       ,     
		ie_orientar_w    ,     
		ie_supervisionar_w,
		nr_seq_diag_ww;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	count(*)
		into STRICT	qt_reg_w
		from	pe_prescr_proc
		where	nr_seq_prescr	= nr_sequencia_p
		and	nr_seq_proc	= nr_seq_proc_w;
		
		if (qt_reg_w	= 0) then
			select	nextval('pe_prescr_proc_seq')
			into STRICT	nr_sequencia_w
			;

			select	count(*)
			into STRICT	qt_existe_w
			from	pe_diagnostico_proc c,
				pe_diagnostico b,
				pe_prescr_diag a
			where	a.nr_seq_prescr = nr_sequencia_p
			and	a.nr_seq_diag   = b.nr_sequencia
			and	b.nr_sequencia  = c.nr_seq_diag
			and	c.nr_seq_proc   = nr_seq_proc_w;
			
			if (vl_prim_hor_w = '1') then
				hr_prim_horario_w	:=	to_date(to_char(clock_timestamp(),'dd/mm/yyyy') || obter_primeiro_horario_sae(cd_intervalo_w,	nr_sequencia_p),'dd/mm/yyyy hh24:mi:ss');
			elsif (vl_prim_hor_w = '2') then
				hr_prim_horario_w	:=	trunc(dt_prescricao_w + (1/24),'hh24');
			end if;			
			
			if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
				select	max(To_char(hr_prim_horario_w,'hh24:mi'))
				into STRICT	ds_prim_horario_w
				;
				--ds_prim_horario_w := To_char(hr_prim_horario_w,'hh24:mi');
				SELECT * FROM calcular_horario_intervencao(cd_intervalo_w, hr_prim_horario_w, coalesce(qt_horas_validade_w,24), nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w, nr_sequencia_p) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w;
				if (coalesce(ds_horario_padrao_w::text, '') = '') then					
					ds_horario_padrao_w	:= ds_horarios_w;
				end if;
			end if;			
			
			if (coalesce(nr_seq_diag_p,0) > 0) then
				nr_seq_diag_ww := nr_seq_diag_p;
			end if;
			
			ie_limpar_w := obter_se_limpa_prim_hor_sae(cd_intervalo_w);
				
			if	((ie_interv_espec_agora_w = 'S') and (coalesce(cd_intervalo_w::text, '') = '')) or (ie_limpar_w = 'S') then
				hr_prim_horario_w	:= null;
				ds_horario_padrao_w := null;
			end if;	
			
			insert into pe_prescr_proc(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_proc,
				nr_seq_prescr,
				qt_pontuacao,
				ds_origem,
				nr_seq_apres,
				cd_intervalo,
				ds_horarios,
				qt_intervencao,
				ie_se_necessario,
				ds_observacao,
				ie_suspenso,
				ie_adep,
				hr_prim_horario,
				nr_seq_diag,
				ie_auxiliar    ,
				ie_encaminhar  ,     
				ie_fazer       ,     
				ie_orientar    ,     
				ie_supervisionar)
			values (	nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_w,
				nr_sequencia_p,
				qt_existe_w,
				'A',
				1,
				cd_intervalo_w,
				ds_horario_padrao_w,
				1,
				'N',
				ds_observacao_padr_w,
				'N',
				ie_adep_w,
				to_char(hr_prim_horario_w,'hh24:mi'),
				nr_seq_diag_ww,
				ie_auxiliar_w    ,     
				ie_encaminhar_w  ,     
				ie_fazer_w       ,     
				ie_orientar_w    ,     
				ie_supervisionar_w);
				
				commit;
			
		end if;

	end;		
	end loop;
	close c01;
	--end;

--end;
end loop;
close c04;
	
open c02;
loop
fetch c02 into
	nr_seq_proc_w,
	cd_intervalo_w,
	ds_horario_padrao_w,
	ds_observacao_padr_w,
	ie_adep_w,
	ie_auxiliar_w    ,
	ie_encaminhar_w  ,     
	ie_fazer_w       ,     
	ie_orientar_w    ,     
	ie_supervisionar_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	
	select	count(*)
	into STRICT	qt_reg_w
	from	pe_prescr_proc
	where	nr_seq_prescr	= nr_sequencia_p
	and	nr_seq_proc	= nr_seq_proc_w;
	
	if (qt_reg_w	= 0) then
	
	
	
		select	nextval('pe_prescr_proc_seq')
		into STRICT	nr_sequencia_w
		;

		if (vl_prim_hor_w = '1') then
			hr_prim_horario_w	:= to_date(to_char(clock_timestamp(),'dd/mm/yyyy') || obter_primeiro_horario_sae(cd_intervalo_w,	nr_sequencia_p),'dd/mm/yyyy hh24:mi:ss');
		elsif (vl_prim_hor_w = '2') then
			hr_prim_horario_w 	:= trunc(dt_prescricao_w + (1/24),'hh24');
		end if;
		
		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
				select	max(To_char(hr_prim_horario_w,'hh24:mi'))
				into STRICT	ds_prim_horario_w
				;
				--ds_prim_horario_w := To_char(hr_prim_horario_w,'hh24:mi');
				SELECT * FROM calcular_horario_intervencao(cd_intervalo_w, hr_prim_horario_w, coalesce(qt_horas_validade_w,24), nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w, nr_sequencia_p) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w;
				if (coalesce(ds_horario_padrao_w::text, '') = '') then					
					ds_horario_padrao_w	:= ds_horarios_w;
				end if;
			end if;
			
		ie_limpar_w := obter_se_limpa_prim_hor_sae(cd_intervalo_w);
				
		if	((ie_interv_espec_agora_w = 'S') and (coalesce(cd_intervalo_w::text, '') = '')) or (ie_limpar_w = 'S') then
			hr_prim_horario_w	:= null;
			ds_horario_padrao_w := null;
		end if;	
			
		insert into pe_prescr_proc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_proc,
			nr_seq_prescr,
			qt_pontuacao,
			ds_origem,
			nr_seq_apres,
			cd_intervalo,
			ds_horarios,
			qt_intervencao,
			ie_se_necessario,
			ds_observacao,
			ie_suspenso,
			ie_adep,
			hr_prim_horario,
			ie_auxiliar    ,
			ie_encaminhar  ,     
			ie_fazer       ,     
			ie_orientar    ,     
			ie_supervisionar)
		values (	nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_proc_w,
			nr_sequencia_p,
			1,
			'A',
			1,
			cd_intervalo_w,
			ds_horario_padrao_w,
			1,
			'N',
			ds_observacao_padr_w,
			'N',
			ie_adep_w,
			to_char(hr_prim_horario_w,'hh24:mi'),
			ie_auxiliar_w    ,     
			ie_encaminhar_w  ,     
			ie_fazer_w       ,     
			ie_orientar_w    ,     
			ie_supervisionar_w);
	end if;
end;
end loop;
close c02;
	
open c03;
loop
fetch c03 into
	nr_seq_proc_w,
	cd_intervalo_w,
	ds_horario_padrao_w,
	ds_observacao_padr_w,
	ie_adep_w,
	ie_auxiliar_w    ,
	ie_encaminhar_w  ,     
	ie_fazer_w       ,     
	ie_orientar_w    ,     
	ie_supervisionar_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	
	select	count(*)
	into STRICT	qt_reg_w
	from	pe_prescr_proc
	where	nr_seq_prescr	= nr_sequencia_p
	and	nr_seq_proc	= nr_seq_proc_w;
	
	if (qt_reg_w	= 0) then
	
		
		select	nextval('pe_prescr_proc_seq')
		into STRICT	nr_sequencia_w
		;
		
		if (vl_prim_hor_w = '1') then
			hr_prim_horario_w	:= to_date(to_char(clock_timestamp(),'dd/mm/yyyy') || obter_primeiro_horario_sae(cd_intervalo_w,	nr_sequencia_p),'dd/mm/yyyy hh24:mi:ss');
		elsif (vl_prim_hor_w = '2') then
			hr_prim_horario_w 	:= trunc(dt_prescricao_w + (1/24),'hh24');
		end if;
		
		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') then
				select	max(To_char(hr_prim_horario_w,'hh24:mi'))
				into STRICT	ds_prim_horario_w
				;
			--ds_prim_horario_w := To_char(hr_prim_horario_w,'hh24:mi');
				SELECT * FROM calcular_horario_intervencao(cd_intervalo_w, hr_prim_horario_w, coalesce(qt_horas_validade_w,24), nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w, nr_sequencia_p) INTO STRICT nr_intervalo_w, ds_horarios_w, ds_prim_horario_w, ie_se_necessario_w;
				if (coalesce(ds_horario_padrao_w::text, '') = '') then					
					ds_horario_padrao_w	:= ds_horarios_w;
				end if;
			end if;		

		ie_limpar_w := obter_se_limpa_prim_hor_sae(cd_intervalo_w);
				
		if	((ie_interv_espec_agora_w = 'S') and (coalesce(cd_intervalo_w::text, '') = '')) or (ie_limpar_w = 'S') then
			hr_prim_horario_w	:= null;
			ds_horario_padrao_w := null;
		end if;	

		insert into pe_prescr_proc(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_proc,
			nr_seq_prescr,
			qt_pontuacao,
			ds_origem,
			nr_seq_apres,
			cd_intervalo,
			ds_horarios,
			qt_intervencao,
			ie_se_necessario,
			ds_observacao,
			ie_suspenso,
			ie_adep,
			hr_prim_horario,
			ie_auxiliar    ,
			ie_encaminhar  ,     
			ie_fazer       ,     
			ie_orientar    ,     
			ie_supervisionar)
		values (	nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_proc_w,
			nr_sequencia_p,
			1,
			'A',
			1,
			cd_intervalo_w,
			ds_horario_padrao_w,
			1,
			'N',
			ds_observacao_padr_w,
			'N',
			ie_adep_w,
			to_char(hr_prim_horario_w,'hh24:mi'),
			ie_auxiliar_w    ,     
			ie_encaminhar_w  ,     
			ie_fazer_w       ,     
			ie_orientar_w    ,     
			ie_supervisionar_w);
	end if;
		
	end;
end loop;
close c03;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_intervencao_selecao ( nr_sequencia_p bigint, ie_excluir_p text, nr_seq_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_intervalo_p text default null, nr_seq_diag_p bigint default null) FROM PUBLIC;

