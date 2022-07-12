-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_interno_valor ( nr_seq_interno_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_tipo_acomodacao_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p text default null) RETURNS varchar AS $body$
DECLARE

					

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_edicao_amb_w		integer;
ie_tipo_convenio_w		smallint;
cd_categoria_w		varchar(10);
vl_retorno_w		double precision;
ie_preco_informado_w	varchar(10);
ie_glosa_w		varchar(10);
cd_edicao_ajuste_w	integer;

cd_proced_conv_w		bigint;
ie_origem_proced_conv_w	bigint;
ie_autor_particular_w	varchar(1);
cd_convenio_glosa_ww	integer;
cd_categoria_glosa_ww	varchar(10);
nr_seq_ajuste_proc_ww	bigint;
ie_origem_proc_filtro_w	bigint;

nr_seq_grupo_dif_fat_w	bigint;
cd_edicao_amb_grupo_dif_w	integer;
dt_vigencia_w		timestamp;
ie_prioridade_edicao_w	varchar(01);	
VL_CH_HONORARIOS_W	double precision	:= 1;
VL_CH_CUSTO_OPER_W	double precision	:= 1;
VL_M2_FILME_W		double precision	:= 0;
tx_ajuste_geral_w		double precision	:= 1;
dt_inicio_vigencia_w	timestamp;
nr_seq_cbhpm_edicao_w		bigint;

ie_proc_interno_conv_w		varchar(1);
ie_regra_prior_edicao_w		varchar(3);
cd_edicao_amb_prior_w		integer;
qt_proc_edicao_w		bigint;
ie_encontrou_edicao_w		varchar(1);
nr_seq_proc_conv_w		bigint;
ie_prioridade_conv_w		bigint;
dt_inicio_vig_conv_w		timestamp;
nr_seq_cbhpm_edicao_regra_w	bigint;
qt_preco_w			bigint;

cd_proc_prior_w			procedimento.cd_procedimento%type;
ie_origem_proc_prior_w		procedimento.ie_origem_proced%type;
ie_origem_proced_edicao_w	edicao_amb.cd_edicao_amb%type;
nr_seq_cbhpm_edicao_prior_w	convenio_amb.nr_seq_cbhpm_edicao%type;

c01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced
from	proc_interno_conv
where	nr_seq_proc_interno		= nr_seq_interno_p
and (cd_convenio			= cd_convenio_p 		or coalesce(cd_convenio::text, '') = '')
and (cd_categoria			= coalesce(cd_categoria_p,'0')	or coalesce(cd_categoria::text, '') = '')
and (cd_edicao_amb			= cd_edicao_amb_w 		or coalesce(cd_edicao_amb::text, '') = '')
and 	((ie_origem_proc_filtro 	= ie_origem_proc_filtro_w) 	or (coalesce(ie_origem_proc_filtro::text, '') = ''))
and 	((cd_estabelecimento   		= coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
and	coalesce(cd_tipo_acomodacao, coalesce(cd_tipo_acomodacao_p,0)) = coalesce(cd_tipo_acomodacao_p,0)
and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) = coalesce(ie_tipo_atendimento_p,0)
and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_p,0)) = coalesce(cd_setor_atendimento_p,0)
and	dt_vigencia_w between coalesce(dt_inicio_vigencia, dt_vigencia_w) and coalesce(dt_final_vigencia, dt_vigencia_w)
order by
	coalesce(cd_edicao_amb,0),
	coalesce(cd_convenio,0),
	coalesce(cd_categoria,'0'),
	coalesce(cd_setor_atendimento,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(cd_estabelecimento,0),
	coalesce(cd_tipo_acomodacao,0);

c02 CURSOR FOR
	SELECT	cd_categoria
	from	categoria_convenio
	where	cd_convenio	= cd_convenio_p
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria_p::text, '') = ''));
	
C03 CURSOR FOR
	SELECT	coalesce(cd_edicao_amb,0)
	from	grupo_dif_fat_edicao_regra
	where	nr_seq_grupo_dif_fat = nr_seq_grupo_dif_fat_w
	and (coalesce(cd_convenio, coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0))
	and (coalesce(cd_categoria, coalesce(cd_categoria_p,'0')) = coalesce(cd_categoria_p,'0'))
	and (coalesce(cd_plano, coalesce(cd_plano_p,'0')) = coalesce(cd_plano_p,'0'))
	and	coalesce(ie_situacao,'A') = 'A'
	order by coalesce(cd_convenio,0),
		coalesce(cd_categoria,'0'),
		coalesce(cd_plano,'0');
		
c04 CURSOR FOR
	SELECT	x.ie_prioridade,
		x.dt_inicio_vigencia,
		x.cd_edicao_amb,
		x.nr_seq_cbhpm_edicao
	from	edicao_amb y,
		convenio_amb x
	where	x.cd_edicao_amb = y.cd_edicao_amb
	and	x.cd_estabelecimento = cd_estabelecimento_p
	and	x.cd_convenio = cd_convenio_p
	and	((x.cd_categoria = coalesce(cd_categoria_p,cd_categoria)) or (coalesce(cd_categoria_p,'0') = '0'))
	and	coalesce(x.ie_situacao,'A')	= 'A'
	and	ie_regra_prior_edicao_w	= 'DT'
	and	(x.dt_inicio_vigencia =	(SELECT	max(dt_inicio_vigencia)
					from	convenio_amb a
					where	a.cd_estabelecimento = cd_estabelecimento_p
					and	a.cd_convenio = cd_convenio_p
					and	((a.cd_categoria = coalesce(cd_categoria_p,cd_categoria)) or (coalesce(cd_categoria_p,'0') = '0'))
					and	coalesce(a.ie_situacao,'A')= 'A'
					and	dt_vigencia_w between a.dt_inicio_vigencia and coalesce(a.dt_final_vigencia,dt_vigencia_w)))
	
union

	select 	x.ie_prioridade,
		x.dt_inicio_vigencia,
		x.cd_edicao_amb,
		x.nr_seq_cbhpm_edicao
	from	edicao_amb y,
		convenio_amb x
	where	x.cd_edicao_amb = y.cd_edicao_amb
	and	x.cd_estabelecimento = cd_estabelecimento_p
	and	x.cd_convenio = cd_convenio_p
	and	((x.cd_categoria = coalesce(cd_categoria_p,cd_categoria)) or (coalesce(cd_categoria_p,'0') = '0'))
	and 	coalesce(x.ie_situacao,'A')	= 'A'
	and	ie_regra_prior_edicao_w	= 'PR'
	and	((coalesce(x.dt_final_vigencia::text, '') = '') or (dt_vigencia_w <= x.dt_final_vigencia))
	order by	1, 2;
	
/*Este cursor deve ser igual ao C01, porem para verificar se existem as regras para as prioridades do C04*/

c05 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced
from	proc_interno_conv
where	nr_seq_proc_interno		= nr_seq_interno_p
and (cd_convenio			= cd_convenio_p 		or coalesce(cd_convenio::text, '') = '')
and (cd_edicao_amb = cd_edicao_amb_prior_w)
and (ie_tipo_atendimento	= ie_tipo_atendimento_p	or coalesce(ie_tipo_atendimento::text, '') = '')
and 	((ie_origem_proc_filtro = ie_origem_proc_filtro_w) or (coalesce(ie_origem_proc_filtro::text, '') = ''))
and 	((cd_estabelecimento   = coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento)) or (coalesce(cd_estabelecimento::text, '') = ''))
and (coalesce(cd_categoria, coalesce(cd_categoria_p,'0')) = coalesce(cd_categoria_p,'0'))
and	coalesce(cd_tipo_acomodacao, coalesce(cd_tipo_acomodacao_p,0)) = coalesce(cd_tipo_acomodacao_p,0)
and	dt_vigencia_w between coalesce(dt_inicio_vigencia, dt_vigencia_w) and coalesce(dt_final_vigencia, dt_vigencia_w)
and 	coalesce(nr_seq_cbhpm_edicao, coalesce(nr_seq_cbhpm_edicao_prior_w,0)) = coalesce(nr_seq_cbhpm_edicao_prior_w,0)
and	coalesce(ie_situacao,'A') = 'A'
order by
	coalesce(cd_edicao_amb,0),
	coalesce(nr_seq_cbhpm_edicao,0),
	coalesce(cd_convenio,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(cd_estabelecimento,0),
	coalesce(cd_categoria,'0'),
	coalesce(cd_tipo_acomodacao,0);


BEGIN

dt_vigencia_w	:= trunc(clock_timestamp());

select	max(cd_procedimento),
	max(ie_origem_proced),
	max(nr_seq_grupo_dif_fat)
into STRICT	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_grupo_dif_fat_w
from	proc_interno
where	nr_sequencia = nr_seq_interno_p;

select	coalesce(max(ie_prioridade_edicao_amb), 'N'),
	coalesce(max(ie_proc_interno_conv), 'N')
into STRICT	ie_prioridade_edicao_w,
	ie_proc_interno_conv_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

select	coalesce(max(ie_regra_prior_edicao), 'DT')
into STRICT	ie_regra_prior_edicao_w
from	convenio_estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_convenio = cd_convenio_p;

if (cd_convenio_p > 0) then
	begin
	
	select	max(ie_tipo_convenio)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio = cd_convenio_p;
	
	if (coalesce(nr_seq_grupo_dif_fat_w,0) > 0) then
		
		CD_EDICAO_AMB_W:= 0;
		
		open C03;
		loop
		fetch C03 into	
			cd_edicao_amb_grupo_dif_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			CD_EDICAO_AMB_W:= cd_edicao_amb_grupo_dif_w;
			end;
		end loop;
		close C03;

	end if;
	
	if	((coalesce(nr_seq_grupo_dif_fat_w,0) = 0) or
		((coalesce(nr_seq_grupo_dif_fat_w,0) > 0) and (CD_EDICAO_AMB_W = 0))) then

		
		if (ie_prioridade_edicao_w = 'N') then

			SELECT	coalesce(max(CD_EDICAO_AMB),0)
			INTO STRICT	CD_EDICAO_AMB_W
			FROM 	CONVENIO_AMB
			WHERE (CD_ESTABELECIMENTO     = cd_estabelecimento_p)
			AND (CD_CONVENIO            = cd_convenio_p)
			AND (CD_CATEGORIA		= coalesce(cd_categoria_p, CD_CATEGORIA))
			AND (coalesce(IE_SITUACAO,'A')   = 'A')
			AND 	(DT_INICIO_VIGENCIA     = 
					(SELECT	MAX(DT_INICIO_VIGENCIA)
					FROM 	CONVENIO_AMB A	
					WHERE (A.CD_ESTABELECIMENTO  	= cd_estabelecimento_p)
					AND (A.CD_CONVENIO         	= CD_CONVENIO_p)
					AND (CD_CATEGORIA		= coalesce(cd_categoria_p, CD_CATEGORIA))
					AND (coalesce(A.IE_SITUACAO,'A')	= 'A')
					AND (A.DT_INICIO_VIGENCIA 	<=  clock_timestamp())));
					
		else
		
			if (coalesce(cd_categoria_p,'0') = '0') then
		
				select	min(cd_categoria)
				into STRICT	cd_categoria_w
				from	categoria_convenio
				where	cd_convenio	= cd_convenio_p
				and	ie_situacao	= 'A';
				
				cd_categoria_w:= null;
				
			else
			
				cd_categoria_w:= cd_categoria_p;
			
			end if;
			
			if (ie_proc_interno_conv_w = 'S') then
			
				ie_encontrou_edicao_w	:= 'N';
			
				open C04;
				loop
				fetch C04 into
					ie_prioridade_conv_w,
					dt_inicio_vig_conv_w,
					cd_edicao_amb_prior_w,
					nr_seq_cbhpm_edicao_prior_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin
					
					if (ie_encontrou_edicao_w = 'N') then
						cd_proc_prior_w		:= null;
						ie_origem_proc_prior_w	:= null;
					
						open C05;
						loop
						fetch C05 into	
							cd_proc_prior_w,
							ie_origem_proc_prior_w;
						EXIT WHEN NOT FOUND; /* apply on C05 */
							begin
							ie_encontrou_edicao_w	:= 'S';
							cd_proc_prior_w		:= cd_proc_prior_w;
							ie_origem_proc_prior_w	:= ie_origem_proc_prior_w;
							end;
						end loop;
						close C05;
					
						if (coalesce(cd_proc_prior_w,0) > 0) then
							
							select	coalesce(max(ie_origem_proced), ie_origem_proc_prior_w)
							into STRICT	ie_origem_proced_edicao_w
							from	edicao_amb
							where	cd_edicao_amb	= cd_edicao_amb_prior_w;
							
							if (ie_origem_proced_edicao_w = 5) then
								select	count(*)
								into STRICT	qt_preco_w
								from	cbhpm_preco
								where	cd_procedimento		= cd_proc_prior_w
								and	ie_origem_proced	= ie_origem_proc_prior_w;
							else
								select	count(*)
								into STRICT	qt_preco_w
								from	preco_amb
								where	cd_edicao_amb		= cd_edicao_amb_prior_w
								and	cd_procedimento		= cd_proc_prior_w
								and	ie_origem_proced	= coalesce(ie_origem_proc_prior_w, ie_origem_proced)
								and	trunc(coalesce(dt_vigencia_w,clock_timestamp()),'dd') between coalesce(dt_inicio_vigencia,clock_timestamp() - interval '3650 days') and coalesce(dt_final_vigencia, coalesce(dt_vigencia_w,clock_timestamp()));
							end if;
							
							if (coalesce(qt_preco_w,0) = 0) then
								ie_encontrou_edicao_w	:= 'N';
							else
								cd_procedimento_w	:= cd_proc_prior_w;
								ie_origem_proced_w	:= ie_origem_proc_prior_w;
							end if;
							

						end if;
					end if;
					
					end;
				end loop;
				close C04;
			
			end if;
		
			SELECT * FROM Obter_Edicao_Proc_Conv(cd_estabelecimento_p, CD_CONVENIO_p, CD_CATEGORIA_p, dt_vigencia_w, cd_procedimento_w, CD_EDICAO_AMB_W, VL_CH_HONORARIOS_W, VL_CH_CUSTO_OPER_W, VL_M2_FILME_W, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w) INTO STRICT CD_EDICAO_AMB_W, VL_CH_HONORARIOS_W, VL_CH_CUSTO_OPER_W, VL_M2_FILME_W, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w;
				
		end if;
		
	
		cd_edicao_ajuste_w := 0;

		open	c02;
		loop
		fetch	c02 into cd_categoria_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			if (cd_edicao_ajuste_w = 0) then
				begin
				SELECT * FROM obter_regra_ajuste_proc(cd_estabelecimento_p, cd_convenio_p, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), 0, coalesce(ie_tipo_atendimento_p,0), 0, null, 0, 0, null, nr_seq_interno_p, null, cd_plano_p, null, null, null, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, ie_preco_informado_w, ie_glosa_w, vl_retorno_w, vl_retorno_w, cd_edicao_ajuste_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, null, 0, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, nr_seq_ajuste_proc_ww, null, null, null, null, null, null, null, null, vl_retorno_w, null, null, null, null, null, null, null, null, null, null) INTO STRICT vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, ie_preco_informado_w, ie_glosa_w, vl_retorno_w, vl_retorno_w, cd_edicao_ajuste_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, vl_retorno_w, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, nr_seq_ajuste_proc_ww, vl_retorno_w;
				exception
					when others then
					cd_edicao_ajuste_w	:= 0;
				end;
				
			end if;
			end;
		end loop;
		close	c02;
		
		if (cd_edicao_ajuste_w IS NOT NULL AND cd_edicao_ajuste_w::text <> '') and (cd_edicao_ajuste_w <> 0) then
			cd_edicao_amb_w		:= cd_edicao_ajuste_w;
		end if;
		
	end if;
	
	ie_origem_proc_filtro_w:= Obter_Origem_Proced_Cat(cd_estabelecimento_p, null, ie_tipo_convenio_w, cd_convenio_p, cd_categoria_p);

	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') or (cd_edicao_amb_w IS NOT NULL AND cd_edicao_amb_w::text <> '') then
		open c01;
		loop
		fetch c01 into	cd_proced_conv_w,
					ie_origem_proced_conv_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			cd_procedimento_w	:= cd_proced_conv_w;
			ie_origem_proced_w	:= ie_origem_proced_conv_w;
			end;
		end loop;
		close c01;
		
	end if;
	end;
end if;

return Obter_Se_Proc_Convenio(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_interno_p, null, ie_tipo_atendimento_p, cd_plano_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_interno_valor ( nr_seq_interno_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_tipo_acomodacao_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p text default null) FROM PUBLIC;

