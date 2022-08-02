-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_minimo_coparticipacao ( nr_seq_tipo_copart_p bigint, qt_liberada_p bigint, qt_eventos_minimo_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_proc_p bigint, dt_inicio_contrato_p timestamp, dt_fim_contrato_p timestamp, nr_seq_regra_copartic_p bigint, cd_estabelecimento_p bigint, nr_seq_conta_mat_p bigint, ie_incidencia_proc_mat_p text, nr_seq_prestador_atend_p pls_regra_coparticipacao.nr_seq_prestador%type, qt_retorno_p INOUT bigint) AS $body$
DECLARE

						
qt_eventos_w      		double precision;
qt_procedimentos_w   		pls_conta_proc.qt_procedimento%type;
cd_procedimento_w    		pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w    		pls_conta_proc.ie_origem_proced%type;
nr_seq_clinica_w    		pls_conta.nr_seq_clinica%type;
nr_seq_saida_int_w		pls_conta.nr_seq_saida_int%type;
qt_eventos_ww      		double precision;
nr_seq_conta_w      		bigint;
var_w        			bigint;
ie_restringe_estab_w		varchar(1);
ie_data_base_coparticipacao_w	pls_parametros.ie_data_base_coparticipacao%type;
cd_material_w			pls_conta_mat.cd_material%type;
qt_material_w			pls_conta_mat.qt_material%type;
qt_liberada_copartic_w		pls_conta_coparticipacao.qt_liberada_copartic%type;
nr_seq_estrut_mat_w		pls_material.nr_seq_estrut_mat%type;
nr_seq_material_w		pls_material.nr_sequencia%type;
dt_inicio_contrato_w    	timestamp;
dt_fim_contrato_w    		timestamp;
ie_tipo_atendimento_w		pls_regra_coparticipacao.ie_tipo_atendimento%type;
ie_tipo_atendimento_conta_w	varchar(1);
nr_seq_prestador_atend_w	pls_protocolo_conta.nr_seq_prestador%type;

C01 CURSOR FOR
	SELECT 	coalesce(a.qt_procedimento,0),
		a.cd_procedimento,
		a.ie_origem_proced,
		b.nr_seq_clinica,
		b.nr_seq_saida_int,
		d.nr_seq_prestador nr_seq_prestador_atend		
	from  	pls_conta_proc  		a,
		pls_conta    			b,
		pls_segurado    		c,
		pls_protocolo_conta		d
	where  	a.nr_seq_conta    	= b.nr_sequencia
	and  	b.nr_seq_segurado	= c.nr_sequencia
	and 	b.nr_seq_protocolo = d.nr_sequencia
	and  	c.nr_sequencia    	= nr_seq_segurado_p
	and  	((b.ie_status in ('F','L')) or (b.nr_sequencia    = nr_seq_conta_w))
	and	a.ie_status		!= 'D'
	and  	a.nr_sequencia < nr_seq_conta_proc_p
	and  	((((trunc(coalesce(a.dt_procedimento,b.dt_atendimento_referencia),'month') between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'I')) or
		((trunc(coalesce(b.dt_atendimento_referencia, a.dt_procedimento),'month') between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'C')))or (coalesce(dt_inicio_contrato_p::text, '') = ''))
	and  	exists (	SELECT  1
				from  	pls_regra_coparticipacao	y,
					pls_conta_coparticipacao  	x
				where  	x.nr_seq_conta_proc  		= a.nr_sequencia
				and	x.nr_seq_regra			= y.nr_sequencia
				and	y.nr_seq_tipo_coparticipacao 	= nr_seq_tipo_copart_p);

C02 CURSOR FOR
	SELECT  coalesce(a.qt_procedimento,0),
		a.cd_procedimento,
		a.ie_origem_proced,
		b.nr_seq_clinica,
		b.nr_seq_saida_int,
		CASE WHEN substr(pls_obter_se_internado(b.nr_sequencia, 'C'),1,255)='S' THEN 'I'  ELSE 'E' END ,
		d.nr_seq_prestador nr_seq_prestador_atend
	from  	pls_segurado    		c,
		pls_conta_proc  		a,
		pls_conta    			b,
		pls_protocolo_conta		d
	where  	a.nr_seq_conta    	= b.nr_sequencia
	and  	b.nr_seq_segurado  	= c.nr_sequencia
	and 	b.nr_seq_protocolo = d.nr_sequencia
	and  	b.nr_seq_segurado  	= nr_seq_segurado_p
	and  	((b.ie_status in ('F','L')) or (b.nr_sequencia = nr_seq_conta_w and a.nr_sequencia < nr_seq_conta_proc_p))
	and	a.ie_status		!= 'D'
	and  	a.nr_sequencia < nr_seq_conta_proc_p
	and  	((((coalesce(a.dt_procedimento,b.dt_atendimento_referencia) between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'I')) or 
		((coalesce(b.dt_atendimento_referencia, a.dt_procedimento) between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'C'))) or (coalesce(dt_inicio_contrato_p::text, '') = ''))
	and  	not exists (  	SELECT  1
				from  	pls_conta_coparticipacao  x
				where  	x.nr_seq_conta_proc  	= a.nr_sequencia)
	and	exists (select	1 /* Verifica se o procedimento das contas abertas sao do mesmo tipo de coparticipacao. */
			from	pls_tipo_coparticipacao 			q,
				pls_coparticipacao_proc 			w,
				especialidade_proc				z,
				grupo_proc					y,
				procedimento					x
			where	q.nr_sequencia					= w.nr_seq_tipo_coparticipacao
			and	x.cd_procedimento 				= a.cd_procedimento
			and	x.ie_origem_proced				= a.ie_origem_proced
			and	x.cd_grupo_proc					= y.cd_grupo_proc
			and	z.cd_especialidade				= y.cd_especialidade
			and	coalesce(w.cd_procedimento, x.cd_procedimento)	= x.cd_procedimento
			and	coalesce(w.ie_origem_proced, x.ie_origem_proced) 	= x.ie_origem_proced
			and	coalesce(w.cd_grupo_proc, y.cd_grupo_proc)		= y.cd_grupo_proc
			and	coalesce(w.cd_especialidade, z.cd_especialidade)	= z.cd_especialidade
			and	coalesce(w.cd_area_procedimento, z.cd_area_procedimento) = z.cd_area_procedimento
			and (coalesce(w.nr_seq_clinica, b.nr_seq_clinica)	= b.nr_seq_clinica or coalesce(b.nr_seq_clinica::text, '') = '')
			and (coalesce(w.nr_seq_saida_int, b.nr_seq_saida_int)	= b.nr_seq_saida_int or coalesce(b.nr_seq_saida_int::text, '') = '')
			and (coalesce(w.nr_seq_grupo_servico::text, '') = '' or
				pls_se_grupo_preco_servico(w.nr_seq_grupo_servico, x.cd_procedimento, x.ie_origem_proced) = 'S')
			and	q.nr_sequencia	= nr_seq_tipo_copart_p
			and	w.ie_liberado	= 'S'
			and	q.ie_situacao	= 'A');

C03 CURSOR FOR
	SELECT 	coalesce(a.qt_material,0),
		a.cd_material,
		d.nr_seq_estrut_mat,
		d.nr_sequencia nr_seq_material,
		e.nr_seq_prestador nr_seq_prestador_atend
	from  	pls_material			d,
		pls_conta_mat  			a,
		pls_conta    			b,
		pls_segurado    		c,
		pls_protocolo_conta 		e
	where  	a.nr_seq_conta    	= b.nr_sequencia
	and  	b.nr_seq_segurado	= c.nr_sequencia
	and	a.nr_seq_material	= d.nr_sequencia
	and 	b.nr_seq_Protocolo = e.nr_sequencia
	and  	c.nr_sequencia    	= nr_seq_segurado_p
	and  	((b.ie_status in ('F','L')) or (b.nr_sequencia    = nr_seq_conta_w))
	and	a.ie_status		!= 'D'
	and  	a.nr_sequencia < nr_seq_conta_mat_p
	and  	a.ie_tipo_despesa <> 5 -- (MATER DIARIAS DOM 1854)
	and  	((((trunc(coalesce(a.dt_atendimento, b.dt_atendimento_referencia),'month') between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'I')) or
		((trunc(coalesce(b.dt_atendimento_referencia, a.dt_atendimento),'month') between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'C')))or (coalesce(dt_inicio_contrato_p::text, '') = ''))
	and  	exists (	SELECT  1
				from  	pls_regra_coparticipacao	y,
					pls_conta_coparticipacao  	x
				where  	x.nr_seq_conta_mat  		= a.nr_sequencia
				and	x.nr_seq_regra			= y.nr_sequencia
				and	y.nr_sequencia			= nr_seq_regra_copartic_p
				and	y.nr_seq_tipo_coparticipacao 	= nr_seq_tipo_copart_p);
				
C04 CURSOR FOR
	SELECT  coalesce(a.qt_material,0),
		a.cd_material,
		d.nr_seq_estrut_mat,
		d.nr_sequencia nr_seq_material,
		CASE WHEN substr(pls_obter_se_internado(b.nr_sequencia, 'C'),1,255)='S' THEN 'I'  ELSE 'E' END ,
		e.nr_seq_prestador nr_seq_prestador_atend
	from  	pls_material			d,
		pls_segurado    		c,
		pls_conta_mat 			a,
		pls_conta    			b,
		pls_protocolo_conta 		e
	where  	a.nr_seq_conta    	= b.nr_sequencia
	and  	b.nr_seq_segurado  	= c.nr_sequencia
	and	a.nr_seq_material	= d.nr_sequencia
	and 	b.nr_seq_Protocolo = e.nr_sequencia
	and  	b.nr_seq_segurado  	= nr_seq_segurado_p
	and  	((b.ie_status in ('F','L')) or (b.nr_sequencia = nr_seq_conta_w and a.nr_sequencia < nr_seq_conta_mat_p))
	and	a.ie_status		!= 'D'
	and  	a.nr_sequencia < nr_seq_conta_mat_p
	and  	a.ie_tipo_despesa  <> 5 --(PROC DIARIAS  DOMINIO  3796)
	and  	((((coalesce(a.dt_atendimento,b.dt_atendimento_referencia) between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'I')) or
		((coalesce(b.dt_atendimento_referencia, a.dt_atendimento) between dt_inicio_contrato_w and dt_fim_contrato_w) and (ie_data_base_coparticipacao_w = 'C'))) or (coalesce(dt_inicio_contrato_p::text, '') = ''))
	and  	not exists (  	SELECT  1
				from  	pls_conta_coparticipacao  x
				where  	x.nr_seq_conta_mat  	= a.nr_sequencia)
	and	exists (	select	1
				from	pls_tipo_coparticipacao x,
					pls_coparticipacao_mat y
				where	x.nr_sequencia					= y.nr_seq_tipo_coparticipacao
				and	coalesce(y.nr_seq_material, d.nr_sequencia) 		= d.nr_sequencia
				and	coalesce(y.nr_seq_estrut_mat, d.nr_seq_estrut_mat) 	= d.nr_seq_estrut_mat
				and	x.nr_sequencia					= nr_seq_tipo_copart_p
				and	x.ie_situacao					= 'A');


BEGIN		
ie_restringe_estab_w	:= pls_obter_se_controle_estab('CO');

select	coalesce(max(ie_data_base_coparticipacao),'C')
into STRICT	ie_data_base_coparticipacao_w
from	pls_parametros
where	((ie_restringe_estab_w	= 'S' AND cd_estabelecimento	= cd_estabelecimento_p)
or (ie_restringe_estab_w	= 'N'));

begin
select	coalesce(ie_tipo_atendimento,'E')
into STRICT	ie_tipo_atendimento_w
from	pls_regra_coparticipacao
where	nr_sequencia	= nr_seq_regra_copartic_p;
exception
when others then
	ie_tipo_atendimento_w	:= 'E';
end;

qt_eventos_w  		:= 0;
qt_eventos_ww  		:= 0;
dt_inicio_contrato_w  	:= trunc(dt_inicio_contrato_p,'Month');
dt_fim_contrato_w  	:= dt_fim_contrato_p-1;


if (coalesce(nr_seq_conta_proc_p,0) > 0) and (ie_incidencia_proc_mat_p in ('P','A')) then	
	select  nr_seq_conta,
		cd_procedimento,
		ie_origem_proced
	into STRICT  	nr_seq_conta_w,
		cd_procedimento_w,
		ie_origem_proced_w
	from  	pls_conta_proc
	where  	nr_sequencia  = nr_seq_conta_proc_p;
	
	open C01;
	loop
	fetch C01 into
		qt_procedimentos_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_clinica_w,
		nr_seq_saida_int_w,
		nr_seq_prestador_atend_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
	
		begin
		
		
			if ( (coalesce(nr_seq_prestador_atend_p::text, '') = '') or (nr_seq_prestador_atend_p = nr_seq_prestador_atend_w ) ) then
				if (pls_obter_se_copartic_proc_lib(nr_seq_tipo_copart_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_clinica_w, nr_seq_saida_int_w) = 'S') then
					qt_eventos_w  := qt_eventos_w + qt_procedimentos_w;
				end if;
			end if;
		end;
	end loop;
	close C01;

	select  nr_seq_conta,
		cd_procedimento,
		ie_origem_proced
	into STRICT  	nr_seq_conta_w,
		cd_procedimento_w,
		ie_origem_proced_w
	from  	pls_conta_proc
	where  	nr_sequencia  = nr_seq_conta_proc_p;		

	
	open C02;
	loop
	fetch C02 into
		qt_procedimentos_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_clinica_w,
		nr_seq_saida_int_w,
		ie_tipo_atendimento_conta_w,
		nr_seq_prestador_atend_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
		if (ie_tipo_atendimento_w = ie_tipo_atendimento_conta_w) or (ie_tipo_atendimento_w = 'A') then
			
			if ( (coalesce(nr_seq_prestador_atend_p::text, '') = '') or (nr_seq_prestador_atend_p = nr_seq_prestador_atend_w ) ) then
				if (pls_obter_se_copartic_proc_lib(nr_seq_tipo_copart_p, cd_procedimento_w, ie_origem_proced_w, nr_seq_clinica_w, nr_seq_saida_int_w) = 'S') then
					qt_eventos_ww  := qt_eventos_ww + qt_procedimentos_w;
				end if;
			end if;
		end if;
		
		end;
	end loop;
	close C02;
end if;

if (coalesce(nr_seq_conta_mat_p,0)  > 0) and (ie_incidencia_proc_mat_p in ('M','A')) then
	select  max(a.nr_seq_conta),
		max(b.nr_sequencia)
	into STRICT	nr_seq_conta_w,
		nr_seq_material_w
	from  	pls_conta_mat a,
		pls_material b
	where   b.nr_sequencia 	= a.nr_seq_material
	and 	a.nr_sequencia =  nr_seq_conta_mat_p;
	
	open C03;
	loop
	fetch C03 into
		qt_material_w,
		cd_material_w,
		nr_seq_estrut_mat_w,		
		nr_seq_material_w,
		nr_seq_prestador_atend_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */	
		begin
					
			if ( (coalesce(nr_seq_prestador_atend_p::text, '') = '') or (nr_seq_prestador_atend_p = nr_seq_prestador_atend_w ) ) then
				if (pls_obter_se_copartic_mat_lib(nr_seq_tipo_copart_p, cd_material_w, nr_seq_estrut_mat_w, nr_seq_material_w) = 'S') then
					qt_eventos_w  := qt_eventos_w + qt_material_w;
				end if;
			end if;
		end;
	end loop;
	close C03;
	
	open C04;
	loop
	fetch C04 into
		qt_material_w,
		cd_material_w,
		nr_seq_estrut_mat_w,		
		nr_seq_material_w,
		ie_tipo_atendimento_conta_w,
		nr_seq_prestador_atend_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		
			
		
		if (ie_tipo_atendimento_w = ie_tipo_atendimento_conta_w) or (ie_tipo_atendimento_w = 'A') then
		
			if ( (coalesce(nr_seq_prestador_atend_p::text, '') = '') or (nr_seq_prestador_atend_p = nr_seq_prestador_atend_w ) ) then
				if (pls_obter_se_copartic_mat_lib(nr_seq_tipo_copart_p, cd_material_w, nr_seq_estrut_mat_w, nr_seq_material_w) = 'S') then
					qt_eventos_ww  := qt_eventos_ww + qt_material_w;
				end if;
			end if;
		end if;
		end;
	end loop;
	close C04;
end if;

/*Caso ja possua alguma cobranca de coparticipacao, o sistema ja fez o desconto de cobertura*/

if (qt_eventos_minimo_p > 0) then--Se existir quantidade minima de coparticipacoes geradas para comecar a cobrar coparticipacao
	if (coalesce(nr_seq_conta_proc_p,0) <> 0) then
		select	coalesce(sum(qt_liberada_copartic),0)
		into STRICT	qt_liberada_copartic_w
		from	pls_conta_coparticipacao
		where	nr_seq_conta_proc = nr_seq_conta_proc_p;	
	elsif (coalesce(nr_seq_conta_mat_p,0) <> 0) then
		select	coalesce(sum(qt_liberada_copartic),0)
		into STRICT	qt_liberada_copartic_w
		from	pls_conta_coparticipacao
		where	nr_seq_conta_mat = nr_seq_conta_mat_p;
	end if;
	
	if (qt_eventos_w > 0 and qt_eventos_ww = 0) then--Se a quantidade de eventos cobrados for maior que zero e a quantidade de eventos nao cobrados for igual a zero
		if (qt_eventos_minimo_p <= qt_eventos_w) then
			qt_retorno_p  := qt_liberada_p - qt_liberada_copartic_w;
		else
			qt_retorno_p  := qt_liberada_p - ((qt_eventos_minimo_p - qt_eventos_w) - qt_liberada_copartic_w) + 1;
		end if;
	elsif (qt_eventos_w = 0 and qt_eventos_ww > 0) then--Se a quantidade de eventos cobrados for zero e a quantidade de eventos nao cobrados for maior que zero
	
		if (qt_eventos_minimo_p <= qt_eventos_ww) then
			qt_retorno_p  := qt_liberada_p;
		else
			qt_retorno_p  := qt_liberada_p - (qt_eventos_minimo_p - qt_eventos_ww) + 1;
		end if;
				
	elsif (qt_eventos_w > 0 and qt_eventos_ww > 0) then--Se a quantidade de eventos cobrados for maior que zero e a quantidade de eventos nao cobrados for maior que zero
		
		if (qt_eventos_minimo_p <= qt_eventos_w + qt_eventos_ww) then
			qt_retorno_p  := qt_liberada_p;
		else
			qt_retorno_p  := qt_liberada_p - ( qt_eventos_minimo_p - (qt_eventos_w + qt_eventos_ww)) + 1;
		end if;
	elsif (qt_eventos_w = 0 and qt_eventos_ww = 0) then--Se a quantidade de eventos cobrados for zero e a quantidade de eventos nao cobrados for zero
		qt_retorno_p  := qt_liberada_p - qt_eventos_minimo_p + 1;
	end if;

else
	qt_retorno_p  := qt_liberada_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_minimo_coparticipacao ( nr_seq_tipo_copart_p bigint, qt_liberada_p bigint, qt_eventos_minimo_p bigint, nr_seq_segurado_p bigint, nr_seq_conta_proc_p bigint, dt_inicio_contrato_p timestamp, dt_fim_contrato_p timestamp, nr_seq_regra_copartic_p bigint, cd_estabelecimento_p bigint, nr_seq_conta_mat_p bigint, ie_incidencia_proc_mat_p text, nr_seq_prestador_atend_p pls_regra_coparticipacao.nr_seq_prestador%type, qt_retorno_p INOUT bigint) FROM PUBLIC;

