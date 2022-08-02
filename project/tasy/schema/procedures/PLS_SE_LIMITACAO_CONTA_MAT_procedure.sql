-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_se_limitacao_conta_mat ( nr_seq_segurado_p bigint, nr_seq_tipo_limitacao_p bigint, qt_permitida_p bigint, qt_intervalo_p bigint, ie_periodo_p text, qt_solicitada_p bigint, nr_seq_conta_mat_p bigint, ie_retorno_p INOUT text, ie_tipo_periodo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_conta_ww			varchar(4000);				
ie_limitacao_w			varchar(1);
ie_tipo_incidencia_w		varchar(1);
qt_material_w			double precision;
nr_seq_titular_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_segurado_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_regra_limitacao_w	bigint;
qt_permitida_w			double precision;
qt_liberada_w			double precision	:= 0;
dt_mat_w			timestamp;
dt_contratacao_w		timestamp;
dt_atual_w			timestamp;
dt_inicio_w			timestamp;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_final_fim_w			timestamp;

C01 CURSOR FOR
	SELECT	c.nr_sequencia nr_seq_conta_mat,		
		case	when(c.ie_status('A','P', 'C')) then coalesce(c.qt_material_imp,0)	--Diego 21/06/2011 -Tratamento para maximar a quantiadade liberada,
			else coalesce(c.qt_material,0)
		end qt_material,
		pls_obter_regra_limitacao(null, c.nr_seq_material, null, a.nr_sequencia, null) nr_seq_regra_limitacao
	from	pls_conta_mat 	c,
		pls_conta	b,
		pls_segurado 	a		
	where	a.nr_sequencia	= b.nr_seq_segurado	
	and	c.nr_seq_conta	= b.nr_sequencia
	and	a.nr_sequencia	= nr_seq_segurado_p
	and	b.ie_glosa	= 'N'
	and 	coalesce(ie_tipo_incidencia_w,'B')	= 'B'
	and	coalesce(c.dt_atendimento,b.dt_emissao) between dt_inicial_w and dt_final_fim_w --fim_dia(dt_final_w)	
	--and	pls_obter_regra_limitacao(null, c.nr_seq_material, null, a.nr_sequencia, null) = nr_seq_tipo_limitacao_p
	and	((not exists ( SELECT	1
				  from		pls_conta_glosa x,
			  			tiss_motivo_glosa y
				  where		x.nr_seq_conta_mat	  = c.nr_sequencia
				  and		x.nr_seq_motivo_glosa 	  = y.nr_sequencia
				  and		y.cd_motivo_tiss	  = '1423')) or (c.ie_status in ('L', 'S')))
	
union

	select	c.nr_sequencia nr_seq_conta_mat,
		case	when(c.ie_status in ('A','P', 'C')) then coalesce(c.qt_material_imp,0)	--Diego 21/06/2011 -Tratamento para maximizar a quantidade liberada,
			else coalesce(c.qt_material,0)
		end qt_material,
		pls_obter_regra_limitacao(null, c.nr_seq_material, null, a.nr_sequencia, null) nr_seq_regra_limitacao
	from	pls_conta_mat 	c,
		pls_conta	b,
		pls_segurado 	a		
	where	a.nr_sequencia		= b.nr_seq_segurado
	and	c.nr_seq_conta		= b.nr_sequencia
	and	a.nr_seq_contrato	= nr_seq_contrato_w
	and	b.ie_glosa	= 'N'
	and 	coalesce(ie_tipo_incidencia_w,'B') = 'T'
	and	coalesce(c.dt_atendimento,b.dt_emissao) between dt_inicial_w and dt_final_fim_w --fim_dia(dt_final_w)
	and	((a.nr_sequencia = nr_seq_segurado_p and coalesce(a.nr_Seq_titular::text, '') = '') or (a.nr_seq_titular = nr_seq_segurado_p and pls_obter_se_parente_legal(a.nr_sequencia) = 'S'))
	--and	pls_obter_regra_limitacao(null, c.nr_seq_material, null, a.nr_sequencia, null) = nr_seq_tipo_limitacao_p
	and	((not exists ( select	1
				  from		pls_conta_glosa x,
			  			tiss_motivo_glosa y
				  where		x.nr_seq_conta_mat	  = c.nr_sequencia
				  and		x.nr_seq_motivo_glosa 	  = y.nr_sequencia
				  and		y.cd_motivo_tiss	  = '1423')) or (c.ie_status in ('L', 'S')));	
				
TYPE 		fetch_array IS TABLE OF C01%ROWTYPE;
s_array 	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c01_w			Vetor;

BEGIN
ie_limitacao_w	:= 'N';
qt_permitida_w	:= coalesce(qt_permitida_p,0);

select	coalesce(coalesce(a.dt_atendimento,b.dt_emissao),clock_timestamp())
into STRICT	dt_mat_w
from	pls_conta_mat a,
	pls_conta b
where	a.nr_sequencia	= nr_seq_conta_mat_p
and	b.nr_sequencia	= a.nr_seq_conta;

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	select	nr_seq_titular,
		nr_seq_contrato
	into STRICT	nr_seq_titular_w,
		nr_seq_contrato_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
	
	if (ie_periodo_p = 'CO') then
		begin
		select	trunc(a.dt_contrato,'dd'),
			trunc(dt_mat_w)
		into STRICT	dt_contratacao_w,
			dt_atual_w
		from	pls_contrato a
		where	a.nr_sequencia	= nr_seq_contrato_w;
		exception
		when others then
			dt_contratacao_w	:= null;
			dt_atual_w		:= null;
		end;
		
		dt_inicio_w	:= dt_contratacao_w;
		
		if (ie_tipo_periodo_p = 'M') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	add_months(dt_inicio_w,qt_intervalo_p)
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	add_months(dt_inicio_w, -qt_intervalo_p),
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		elsif (ie_tipo_periodo_p = 'S') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + (qt_intervalo_p*7)
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - (qt_intervalo_p*7),
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		elsif (ie_tipo_periodo_p = 'D') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + qt_intervalo_p
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - qt_intervalo_p,
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;			
		end if;
	elsif (ie_periodo_p = 'CA') then
		dt_atual_w	:= trunc(dt_mat_w);
		dt_inicio_w	:= trunc(dt_mat_w,'year');
		
		if (ie_tipo_periodo_p = 'M') then
			if (qt_intervalo_p = 1) then
				dt_inicial_w	:= trunc(dt_mat_w,'month');
				dt_final_w	:= last_day(trunc(dt_mat_w,'month'));	
			elsif (qt_intervalo_p in (2,3,4,6)) then
				dt_inicio_w	:= trunc(dt_mat_w,'year');
				
				while(dt_inicio_w < dt_atual_w) loop
					begin
					select	add_months(dt_inicio_w,qt_intervalo_p)
					into STRICT	dt_inicio_w
					;
					end;
				end loop;
				
				select	add_months(dt_inicio_w,-qt_intervalo_p),
					dt_inicio_w
				into STRICT	dt_inicial_w,
					dt_final_w
				;
				
			elsif (qt_intervalo_p = 12) then
				dt_inicial_w	:= trunc(dt_mat_w,'year');
				dt_final_w	:= last_day(add_months(trunc(dt_mat_w,'year'),qt_intervalo_p));
			end if;
		elsif (ie_tipo_periodo_p = 'S') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + (qt_intervalo_p*7)
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - (qt_intervalo_p*7),
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		elsif (ie_tipo_periodo_p = 'D') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + qt_intervalo_p
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - qt_intervalo_p,
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		end if;
	elsif (ie_periodo_p = 'A') then
		select	trunc(a.dt_contratacao)
		into STRICT	dt_inicio_w
		from	pls_segurado a
		where	a.nr_sequencia	= nr_seq_segurado_p;
		
		dt_atual_w := trunc(dt_mat_w);
		
		if (ie_tipo_periodo_p = 'M') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	add_months(dt_inicio_w,qt_intervalo_p)
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	add_months(dt_inicio_w, -qt_intervalo_p),
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		elsif (ie_tipo_periodo_p = 'S') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + (qt_intervalo_p*7)
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - (qt_intervalo_p*7),
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;
		elsif (ie_tipo_periodo_p = 'D') then
			while(dt_inicio_w < dt_atual_w) loop	
				select	dt_inicio_w + qt_intervalo_p
				into STRICT	dt_inicio_w
				;
			end loop;
			
			select	dt_inicio_w - qt_intervalo_p,
				dt_inicio_w
			into STRICT	dt_inicial_w,
				dt_final_w
			;			
		end if;	
	end if;	
	
	select	ie_tipo_incidencia
	into STRICT	ie_tipo_incidencia_w
	from	pls_tipo_limitacao
	where	nr_sequencia	= nr_seq_tipo_limitacao_p;
	
	dt_final_fim_w	:= trunc(coalesce(dt_final_w,clock_timestamp()),'dd') + 86399/86400;--fim_dia(dt_final)
	
	open C01;
	loop
	FETCH C01 BULK COLLECT INTO s_array LIMIT 1000;
		Vetor_c01_w(i) := s_array;
		i := i + 1;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	END LOOP;
	CLOSE C01;
	
	for i in 1..Vetor_c01_w.COUNT loop
		s_array := Vetor_c01_w(i);
		for z in 1..s_array.COUNT loop
			begin
			nr_seq_conta_mat_w		:= s_array[z].nr_seq_conta_mat;
			qt_material_w			:= s_array[z].qt_material;
			nr_seq_regra_limitacao_w	:= s_array[z].nr_seq_regra_limitacao;
			
			if (nr_seq_tipo_limitacao_p = nr_seq_regra_limitacao_w) then
				qt_liberada_w	:= coalesce(qt_liberada_w,0) + coalesce(qt_material_w,0);	
			end if;	
			end;
		end loop;
	end loop;
	
	/*open C01;
	loop
	fetch C01 into	
		nr_seq_conta_mat_w,
		qt_material_w,
		nr_seq_regra_limitacao_w;
	exit when C01%notfound;
		begin
		if	(nr_seq_tipo_limitacao_p = nr_seq_regra_limitacao_w) then
			qt_liberada_w	:= nvl(qt_liberada_w,0) + nvl(qt_material_w,0);	
		end if;			
		end;
	end loop;
	close C01;*/
	
		
	qt_liberada_w	:= qt_liberada_w + coalesce(qt_solicitada_p,0);
		
	if (qt_permitida_w < qt_liberada_w) then
		ie_limitacao_w	:= 'S';
	end if;
end if;

ie_retorno_p	:= ie_limitacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_se_limitacao_conta_mat ( nr_seq_segurado_p bigint, nr_seq_tipo_limitacao_p bigint, qt_permitida_p bigint, qt_intervalo_p bigint, ie_periodo_p text, qt_solicitada_p bigint, nr_seq_conta_mat_p bigint, ie_retorno_p INOUT text, ie_tipo_periodo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

