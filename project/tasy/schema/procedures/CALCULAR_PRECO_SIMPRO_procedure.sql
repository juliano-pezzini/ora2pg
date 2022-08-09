-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_preco_simpro ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_material_p bigint, tx_pfb_p bigint, tx_pmc_p bigint, dt_base_p timestamp, ie_tipo_preco_conv_p text, vl_preco_p INOUT bigint, dt_vigencia_p INOUT timestamp, tx_pmc_neg_p bigint, tx_pmc_pos_p bigint, tx_pfb_neg_p bigint, tx_pfb_pos_p bigint, ie_dividir_indice_pmc_p text, ie_dividir_indice_pfb_p text, nr_seq_marca_p bigint, nr_seq_mat_simpro_p INOUT bigint, nr_seq_simpro_preco_p INOUT bigint, nr_seq_conv_simpro_p bigint default null) AS $body$
DECLARE


vl_preco_w		double precision := 0;
cd_simpro_w		bigint;
qt_conversao_w		double precision;
dt_vigencia_w		timestamp;
ie_tipo_preco_w		varchar(01);
vl_pfb_w		double precision;
vl_pmc_w		double precision;
ie_fora_linha_w		varchar(1);
dt_fora_linha_w		timestamp;
ie_valor_simpro_w	varchar(1);	
ie_tipo_lista_w		varchar(1);
ie_tipo_convenio_w	smallint;
ie_div_indice_pmc_w	varchar(1);
ie_div_indice_pfb_w	varchar(1);
nr_seq_mat_simpro_w	bigint;
nr_seq_simpro_preco_w	bigint;
vl_minimo_simpro_w		CONVENIO_SIMPRO.VL_MINIMO%type;--number(15,2);
vl_maximo_simpro_w		CONVENIO_SIMPRO.VL_MAXIMO%type;--number(15,2);
ie_primeira_versao_w		CONVENIO_SIMPRO.IE_PRIMEIRA_VERSAO%type;--varchar(2);
c01 CURSOR FOR
	SELECT	coalesce(a.qt_conversao,1),
		coalesce(a.cd_simpro,0),
		c.dt_fora_linha_item,
		a.nr_sequencia
	from	simpro_cadastro b,
		material_simpro a,
		simpro_preco c
	where	a.cd_simpro						= c.cd_simpro
	and	a.cd_simpro						= b.cd_simpro
	and 	coalesce(a.nr_seq_marca, coalesce(nr_seq_marca_p, 0)) = coalesce(nr_seq_marca_p,0)
	and	a.cd_material						= cd_material_p
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(a.cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
	and	coalesce(a.ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0))	= coalesce(ie_tipo_convenio_w,0)
	--and	nvl(a.dt_vigencia, dt_base_p) <= dt_base_p
	and 	dt_base_p between coalesce(a.dt_vigencia, dt_base_p) and coalesce(a.dt_final_vigencia, dt_base_p)
	and	coalesce(a.ie_situacao,'A')					= 'A'
	order by	coalesce(a.nr_seq_marca,0),
		coalesce(a.cd_estabelecimento, 0),
		coalesce(a.cd_convenio,0),
		coalesce(a.ie_tipo_convenio,0),
		coalesce(a.dt_vigencia, dt_base_p - 5000),
		CASE WHEN ie_primeira_versao_w='S' THEN  c.dt_vigencia END  desc,
		c.dt_vigencia;
		
C02 CURSOR FOR
	SELECT 	coalesce(c.vl_preco_fabrica,0),
		coalesce(c.vl_preco_venda,0),
		coalesce(c.ie_tipo_preco,'X'),
		c.dt_vigencia,
		coalesce(a.qt_conversao,1),
		coalesce(a.cd_simpro,0),
		c.dt_fora_linha_item,
		coalesce(ie_tipo_lista,'T'),
		a.nr_sequencia,
		c.nr_sequencia
	from 	simpro_preco c,
		simpro_cadastro b,
		material_simpro a
	where	a.cd_simpro						= b.cd_simpro
	and coalesce(a.nr_seq_marca, coalesce(nr_seq_marca_p, 0)) = coalesce(nr_seq_marca_p,0)
	and	a.cd_simpro						= c.cd_simpro
	and	a.cd_material						= cd_material_p
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(c.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(a.cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
	and	coalesce(a.ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0))	= coalesce(ie_tipo_convenio_w,0)
	and 	dt_base_p between coalesce(a.dt_vigencia, dt_base_p) and coalesce(a.dt_final_vigencia, dt_base_p)
	and 	c.dt_vigencia 						<= coalesce(dt_base_p,clock_timestamp())
	and	coalesce(a.ie_situacao,'A')					= 'A'
	order by	coalesce(vl_preco_fabrica,0) asc,
		coalesce(vl_preco_venda,0) asc,
		c.dt_vigencia;
		
C03 CURSOR FOR
	SELECT 	coalesce(c.vl_preco_fabrica,0),
		coalesce(c.vl_preco_venda,0),
		coalesce(c.ie_tipo_preco,'X'),
		c.dt_vigencia,
		coalesce(a.qt_conversao,1),
		coalesce(a.cd_simpro,0),
		c.dt_fora_linha_item,
		coalesce(ie_tipo_lista,'T'),
		a.nr_sequencia,
		c.nr_sequencia
	from 	simpro_preco c,
		simpro_cadastro b,
		material_simpro a
	where	a.cd_simpro						= b.cd_simpro
	and coalesce(a.nr_seq_marca, coalesce(nr_seq_marca_p, 0)) = coalesce(nr_seq_marca_p,0)
	and	a.cd_simpro						= c.cd_simpro
	and	a.cd_material						= cd_material_p
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(c.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(a.cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
	and	coalesce(a.ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0))	= coalesce(ie_tipo_convenio_w,0)
	and 	dt_base_p between coalesce(a.dt_vigencia, dt_base_p) and coalesce(a.dt_final_vigencia, dt_base_p)
	and 	c.dt_vigencia 						<= coalesce(dt_base_p,clock_timestamp())
	and	coalesce(a.ie_situacao,'A')					= 'A'
	order by	coalesce(dividir(vl_preco_fabrica, a.qt_conversao),0) asc,
		coalesce(dividir(vl_preco_venda, a.qt_conversao),0) asc,
		c.dt_vigencia;
		
		
C04 CURSOR FOR
	SELECT	coalesce(a.qt_conversao,1),
		coalesce(a.cd_simpro,0),
		c.dt_fora_linha_item,
		a.nr_sequencia
	from	simpro_cadastro b,
		material_simpro a,
		simpro_preco c
	where	a.cd_simpro						= b.cd_simpro
	and	a.cd_simpro						= c.cd_simpro
	and coalesce(a.nr_seq_marca, coalesce(nr_seq_marca_p, 0)) = coalesce(nr_seq_marca_p,0)
	and	a.cd_material						= cd_material_p
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	coalesce(a.cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
	and	coalesce(a.ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0))	= coalesce(ie_tipo_convenio_w,0)
	and 	dt_base_p between coalesce(a.dt_vigencia, dt_base_p) and coalesce(a.dt_final_vigencia, dt_base_p)
	and	coalesce(a.ie_situacao,'A')					= 'A'
	order by	coalesce(a.nr_seq_marca, coalesce(nr_seq_marca_p, 0)),
		coalesce(a.cd_estabelecimento, 0),
		coalesce(a.cd_convenio,0),
		coalesce(a.ie_tipo_convenio,0),
		coalesce(obter_valor_preco_simpro(	cd_estabelecimento_p,
						cd_convenio_p,
						cd_material_p,
						a.cd_simpro,
						tx_pfb_p,
						tx_pmc_p,
						dt_base_p,
						ie_tipo_preco_conv_p,
						tx_pmc_neg_p,
						tx_pmc_pos_p,
						tx_pfb_neg_p,
						tx_pfb_pos_p,
						ie_dividir_indice_pmc_p,
						ie_dividir_indice_pfb_p,
						nr_seq_marca_p),0),
		coalesce(a.dt_vigencia, dt_base_p - 5000),
		c.dt_vigencia;
		

BEGIN

if (coalesce(nr_seq_conv_simpro_p, 0) > 0) then
	select 	max(vl_minimo),
		max(vl_maximo),
		max(ie_primeira_versao)
	into STRICT 	vl_minimo_simpro_w,
		vl_maximo_simpro_w,
		ie_primeira_versao_w
	from 	convenio_simpro
	where	nr_sequencia = nr_seq_conv_simpro_p;
end if;


ie_div_indice_pmc_w	:= coalesce(ie_dividir_indice_pmc_p,'N');
ie_div_indice_pfb_w	:= coalesce(ie_dividir_indice_pfb_p,'N');

select	coalesce(max(ie_fora_linha_simpro),'S'),
	coalesce(max(ie_valor_simpro),'N')
into STRICT	ie_fora_linha_w,
	ie_valor_simpro_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(cd_convenio_p,0) > 0) then
	select	coalesce(max(ie_tipo_convenio),0)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio = cd_convenio_p;
end if;

/*select	nvl(max(a.qt_conversao),1),
	nvl(max(a.cd_simpro),0),
	nvl(max(b.dt_fora_linha),sysdate + 1000)
into	qt_conversao_w,
	cd_simpro_w,
	dt_fora_linha_w
from	simpro_cadastro b,
	material_simpro a
where	a.cd_simpro						= b.cd_simpro
and	a.cd_material						= cd_material_p
and	nvl(a.cd_estabelecimento, nvl(cd_estabelecimento_p, 0))			= nvl(cd_estabelecimento_p, 0)
and	nvl(a.cd_convenio, nvl(cd_convenio_p,0)) 				= nvl(cd_convenio_p,0)
and	nvl(a.dt_vigencia, dt_base_p) <= dt_base_p;*/


-- Alterado pelo Cursor abaixo, OS 184095, Fabr?cio em 10/12/2009
qt_conversao_w	:= 1;
cd_simpro_w	:= 0;
dt_fora_linha_w	:= clock_timestamp() + interval '1000 days';

if (ie_valor_simpro_w = 'N') then

	open C01;
	loop
	fetch C01 into	
		qt_conversao_w,
		cd_simpro_w,
		dt_fora_linha_w,
		nr_seq_mat_simpro_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_conversao_w		:= qt_conversao_w;
		cd_simpro_w		:= cd_simpro_w;
		dt_fora_linha_w		:= dt_fora_linha_w;
		nr_seq_mat_simpro_w	:= nr_seq_mat_simpro_w;
		end;
	end loop;
	close C01;
	
	if (cd_simpro_w > 0) then

		dt_vigencia_w		:= clock_timestamp() - interval '2000 days';
		select CASE WHEN ie_primeira_versao_w='S' THEN  min(dt_vigencia)  ELSE max(dt_vigencia) END
		into STRICT   dt_vigencia_w
		from   simpro_preco
		where  cd_simpro = cd_simpro_w
		and    dt_vigencia <= coalesce(dt_base_p,clock_timestamp())
		and    coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0);
	
		if 	((ie_fora_linha_w = 'S') or
			 ((coalesce(dt_fora_linha_w::text, '') = '') or (coalesce(dt_base_p,clock_timestamp()) <= dt_fora_linha_w))) then
		 
			select coalesce(max(vl_preco_fabrica),0),
				coalesce(max(vl_preco_venda),0),
				coalesce(max(ie_tipo_preco),'X'),
				coalesce(max(ie_tipo_lista),'T'),
				max(nr_sequencia)
			into STRICT 	vl_pfb_w,
				vl_pmc_w,
				ie_tipo_preco_w,
				ie_tipo_lista_w,
				nr_seq_simpro_preco_w
			from 	simpro_preco
			where 	cd_simpro	= cd_simpro_w
			and 	dt_vigencia	= dt_vigencia_w
			and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0);
			
	
			if (coalesce(ie_tipo_preco_conv_p, 'C') = 'C') then
		
				if (ie_tipo_preco_w = 'F') then
					if (ie_div_indice_pfb_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
						else
							vl_preco_w	:= vl_pfb_w;
						end if;

					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pfb_w * tx_pfb_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
						else
							vl_preco_w	:= vl_pfb_w;
						end if;
					end if;
				else
					if (ie_div_indice_pmc_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pmc_w * tx_pmc_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					end if;
				end if;
			else
				begin
	
				if (coalesce(ie_tipo_preco_conv_p, ie_tipo_preco_w) = 'F') then
					if (ie_div_indice_pfb_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
						else
							vl_preco_w	:= vl_pfb_w;
						end if;

					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pfb_w * tx_pfb_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
						else
							vl_preco_w	:= vl_pfb_w;
						end if;
					end if;
				else	
					if (ie_div_indice_pmc_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pmc_w * tx_pmc_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					end if;
				end if;
	
	
				end;
			end if;
			vl_preco_w		:= trunc(dividir_sem_round(vl_preco_w,qt_conversao_w),4);
		end if;
	end if;

elsif (ie_valor_simpro_w in ('S','C')) then

	if (ie_valor_simpro_w = 'S') then
	
		open C02;
		loop
		fetch C02 into	
			vl_pfb_w,
			vl_pmc_w,
			ie_tipo_preco_w,
			dt_vigencia_w,
			qt_conversao_w,
			cd_simpro_w,
			dt_fora_linha_w,
			ie_tipo_lista_w,
			nr_seq_mat_simpro_w,
			nr_seq_simpro_preco_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		end loop;
		close C02;
		
	elsif (ie_valor_simpro_w = 'C') then
	
		open C03;
		loop
		fetch C03 into	
			vl_pfb_w,
			vl_pmc_w,
			ie_tipo_preco_w,
			dt_vigencia_w,
			qt_conversao_w,
			cd_simpro_w,
			dt_fora_linha_w,
			ie_tipo_lista_w,
			nr_seq_mat_simpro_w,
			nr_seq_simpro_preco_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		end loop;
		close C03;
		
	end if;
	
	if 	((ie_fora_linha_w = 'S') or
		 ((coalesce(dt_fora_linha_w::text, '') = '') or (coalesce(dt_base_p,clock_timestamp()) <= dt_fora_linha_w))) then
	
		if (coalesce(ie_tipo_preco_conv_p, 'C') = 'C') then
			if (ie_tipo_preco_w = 'F') then
				if (ie_div_indice_pfb_w = 'S') then
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
					else
						vl_preco_w	:= vl_pfb_w;
					end if;
				else
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= vl_pfb_w * tx_pfb_p;
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
					else
						vl_preco_w	:= vl_pfb_w;
					end if;
				end if;
			else
				if (ie_div_indice_pmc_w = 'S') then
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
					else
						vl_preco_w	:= vl_pmc_w;
					end if;
				else
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= vl_pmc_w * tx_pmc_p;
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
					else
						vl_preco_w	:= vl_pmc_w;
					end if;				
				end if;
			end if;
		else
			begin
	
			if (coalesce(ie_tipo_preco_conv_p, ie_tipo_preco_w) = 'F') then
				if (ie_div_indice_pfb_w = 'S') then
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
					else
						vl_preco_w	:= vl_pfb_w;
					end if;
				else
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= vl_pfb_w * tx_pfb_p;
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
					else
						vl_preco_w	:= vl_pfb_w;
					end if;
				end if;

			else	
				if (ie_div_indice_pmc_w = 'S') then
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
					else
						vl_preco_w	:= vl_pmc_w;
					end if;

				else
					if (ie_tipo_lista_w in ('T','Q')) then
						vl_preco_w	:= vl_pmc_w * tx_pmc_p;
					elsif (ie_tipo_lista_w = 'S') then
						vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
					elsif (ie_tipo_lista_w = 'N') then
						vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
					else
						vl_preco_w	:= vl_pmc_w;
					end if;
				end if;
			end if;	
	
			end;
		end if;
		vl_preco_w		:= trunc(dividir_sem_round(vl_preco_w,qt_conversao_w),4);
	end if;

elsif (ie_valor_simpro_w = 'V') then

	open C04;
	loop
	fetch C04 into	
		qt_conversao_w,
		cd_simpro_w,
		dt_fora_linha_w,
		nr_seq_mat_simpro_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		qt_conversao_w		:= qt_conversao_w;
		cd_simpro_w		:= cd_simpro_w;
		dt_fora_linha_w		:= dt_fora_linha_w;
		nr_seq_mat_simpro_w	:= nr_seq_mat_simpro_w;
		end;
	end loop;
	close C04;
	
	
	if (cd_simpro_w > 0) then
		dt_vigencia_w		:= clock_timestamp() - interval '2000 days';
		select max(dt_vigencia)
		into STRICT   dt_vigencia_w
		from   simpro_preco
		where  cd_simpro = cd_simpro_w
		and    dt_vigencia <= coalesce(dt_base_p,clock_timestamp())
		and    coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0);
	
		if 	((ie_fora_linha_w = 'S') or
			 ((coalesce(dt_fora_linha_w::text, '') = '') or (coalesce(dt_base_p,clock_timestamp()) <= dt_fora_linha_w))) then
			 
			select coalesce(max(vl_preco_fabrica),0),
				coalesce(max(vl_preco_venda),0),
				coalesce(max(ie_tipo_preco),'X'),
				coalesce(max(ie_tipo_lista),'T'),
				max(nr_sequencia)
			into STRICT 	vl_pfb_w,
				vl_pmc_w,
				ie_tipo_preco_w,
				ie_tipo_lista_w,
				nr_seq_simpro_preco_w
			from 	simpro_preco
			where 	cd_simpro	= cd_simpro_w
			and 	dt_vigencia	= dt_vigencia_w
			and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0);
			
	
			if (coalesce(ie_tipo_preco_conv_p, 'C') = 'C') then
				if (ie_tipo_preco_w = 'F') then
					if (ie_div_indice_pfb_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
						else
							vl_preco_w	:= vl_pfb_w;
						end if;
					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pfb_w * tx_pfb_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
						else
							vl_preco_w	:= vl_pfb_w;
						end if;
					end if;
				else
					if (ie_div_indice_pmc_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pmc_w * tx_pmc_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					end if;
				end if;
			else
				begin
	
				if (coalesce(ie_tipo_preco_conv_p, ie_tipo_preco_w) = 'F') then
					if (ie_div_indice_pfb_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pfb_w,tx_pfb_neg_p);
						else
							vl_preco_w	:= vl_pfb_w;
						end if;

					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pfb_w * tx_pfb_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pfb_w * tx_pfb_neg_p;
						else
							vl_preco_w	:= vl_pfb_w;
						end if;
					end if;
				else	
					if (ie_div_indice_pmc_w = 'S') then
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_p);
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_pos_p);
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= dividir(vl_pmc_w,tx_pmc_neg_p);
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					else
						if (ie_tipo_lista_w in ('T','Q')) then
							vl_preco_w	:= vl_pmc_w * tx_pmc_p;
						elsif (ie_tipo_lista_w = 'S') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_pos_p;
						elsif (ie_tipo_lista_w = 'N') then
							vl_preco_w	:= vl_pmc_w * tx_pmc_neg_p;
						else
							vl_preco_w	:= vl_pmc_w;
						end if;
					end if;
				end if;
	
	
				end;
			end if;
			vl_preco_w		:= trunc(dividir_sem_round(vl_preco_w,qt_conversao_w),4);
		end if;
	end if;
	
end if;

if ((coalesce(vl_minimo_simpro_w, 0) > 0) or (coalesce(vl_maximo_simpro_w, 0) > 0)) then
	if ((vl_preco_w < coalesce(vl_minimo_simpro_w, vl_preco_w)) or (vl_preco_w > coalesce(vl_maximo_simpro_w, vl_preco_w))) then 
		vl_preco_w		:= 0;
		dt_vigencia_w	:= clock_timestamp();
	end if;
end if;

vl_preco_p		:= vl_preco_w;
dt_vigencia_p		:= dt_vigencia_w;
nr_seq_mat_simpro_p	:= nr_seq_mat_simpro_w;
nr_seq_simpro_preco_p	:= nr_seq_simpro_preco_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_preco_simpro ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_material_p bigint, tx_pfb_p bigint, tx_pmc_p bigint, dt_base_p timestamp, ie_tipo_preco_conv_p text, vl_preco_p INOUT bigint, dt_vigencia_p INOUT timestamp, tx_pmc_neg_p bigint, tx_pmc_pos_p bigint, tx_pfb_neg_p bigint, tx_pfb_pos_p bigint, ie_dividir_indice_pmc_p text, ie_dividir_indice_pfb_p text, nr_seq_marca_p bigint, nr_seq_mat_simpro_p INOUT bigint, nr_seq_simpro_preco_p INOUT bigint, nr_seq_conv_simpro_p bigint default null) FROM PUBLIC;
