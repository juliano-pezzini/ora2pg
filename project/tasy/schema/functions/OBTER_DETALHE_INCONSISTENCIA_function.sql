-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_detalhe_inconsistencia (cd_inconsistencia_p bigint, nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(2000);	
ds_proc_mat_erro_w	varchar(2000);
ie_codigo_convenio_w	varchar(1);
cd_convenio_mat_w	integer;
cd_tipo_acomodacao_w	bigint;
ie_classificacao_w	varchar(05);
cd_estabelecimento_w	bigint;
dia_feriado_w		smallint	:= 0;
ie_feriado_w		varchar(1)	:= 'N';
qt_conversao_mat_conv_w	bigint;
ie_tipo_atendimento_w	smallint  	:= 0;
ie_tipo_material_w	varchar(3);
ds_tipo_w		varchar(10);
nr_atendimento_w	conta_paciente.nr_atendimento%type;

C01 CURSOR FOR 
	SELECT	'('||ie_proc_mat||cd_item||') ' 
	from (	SELECT 	to_char(a.cd_item) cd_item, 
			max(CASE WHEN a.ie_proc_mat=1 THEN 'P.'  ELSE 'M.' END ) ie_proc_mat 
		from	conta_paciente_consiste_v a, 
			conta_paciente b 
		where	a.nr_interno_conta = nr_interno_conta_p 
		and 	a.nr_interno_conta = b.nr_interno_conta 
		and	coalesce(a.nr_seq_proc_pacote,a.nr_sequencia) = a.nr_sequencia 
		and 	coalesce(b.ie_cancelamento::text, '') = '' 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
		and	a.vl_item < 0 
		group by a.cd_item) alias5;
		
C02 CURSOR FOR	 
	SELECT	'('||ie_proc_mat||cd_item||') ' 
	from (	SELECT 	to_char(a.cd_item) cd_item, 
			max(CASE WHEN a.ie_proc_mat=1 THEN 'P.'  ELSE 'M.' END ) ie_proc_mat 
		from	conta_paciente_consiste_v a, 
			conta_paciente b 
		where	a.nr_interno_conta = nr_interno_conta_p 
		and 	a.nr_interno_conta = b.nr_interno_conta 
		and	coalesce(a.nr_seq_proc_pacote,a.nr_sequencia) = a.nr_sequencia 
		and 	coalesce(b.ie_cancelamento::text, '') = '' 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
		group by a.cd_item 
		having sum(coalesce(a.vl_unitario * a.qt_item,0)) < 0) alias7;
		
C03 CURSOR FOR 
	SELECT	a.cd_material 
	from	material_atend_paciente a, 
		material c, 
		estrutura_material_v b 
	where	a.cd_material = c.cd_material 
	and	a.cd_material = b.cd_material 
	and	c.ie_tipo_material in (1,5) 
	and	b.cd_grupo_material <> 15 
	and	not exists (	SELECT	1 
				from	conversao_material_convenio x 
				where	a.cd_material = x.cd_material 
				and	x.cd_convenio = cd_convenio_mat_w 
				and	a.dt_atendimento between coalesce(x.dt_inicio_vigencia, a.dt_atendimento) and coalesce(x.dt_final_vigencia, a.dt_atendimento) 
				and	x.ie_situacao = 'A') 
	and	a.nr_interno_conta = nr_interno_conta_p 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
		
C04 CURSOR FOR 
	SELECT	a.cd_grupo_material cd_grupo, 
		a.cd_subgrupo_material cd_subgrupo, 
		a.cd_classe_material cd_classe, 
		a.ie_tipo_material ie_tipo_mat, 
		a.cd_material, 
		b.dt_atendimento, 
		b.cd_setor_atendimento, 
		b.cd_convenio, 
		coalesce(b.cd_cgc_fornecedor,'0') cd_cgc, 
		b.cd_categoria, 
		b.nr_seq_atepacu, 
		b.nr_sequencia 
	from 	estrutura_material_v a, 
		material_atend_paciente b 
	where 	a.cd_material = b.cd_material 
	and	b.nr_interno_conta = nr_interno_conta_p;

c05 CURSOR FOR 
	SELECT 	a.cd_material, 
		1 ie_tipo 
	from 	material_atend_paciente a, 
		material b 
	where 	a.nr_interno_conta = nr_interno_conta_p 
	and 	a.cd_material = b.cd_material 
	and	coalesce(cd_material_tuss,0) = 0  
	and	coalesce(cd_motivo_exc_conta::text, '') = '' 
	and 	b.ie_tipo_material in (1,5,7,10) 
	
union all
 
	SELECT 	a.cd_material, 
		2 ie_tipo 
	from 	material_atend_paciente a, 
		material b 
	where 	a.nr_interno_conta = nr_interno_conta_p 
	and 	a.cd_material = b.cd_material 
	and	coalesce(cd_material_tuss,0) = 0  
	and	coalesce(cd_motivo_exc_conta::text, '') = '' 
	and 	b.ie_tipo_material in (0,2,3,4,8,9) 
	order by 2;
	
c04_w	c04%rowtype;
c05_w	c05%rowtype;

C06 CURSOR FOR 
	SELECT '('||cd_item|| ') ' 
	from	Conta_Paciente_consiste_v 
	where	nr_interno_conta = nr_interno_conta_p 
	and	coalesce(nr_doc_convenio::text, '') = '';

C07 CURSOR FOR 
	SELECT	a.cd_procedimento 
	from	procedimento_paciente a 
	where	a.nr_interno_conta	= nr_interno_conta_p 
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
	and	obter_classificacao_proced(cd_procedimento,ie_origem_proced,'C')	= '1' 
	and	coalesce(coalesce(a.cd_medico_executor,a.cd_pessoa_fisica)::text, '') = '';

C08 CURSOR FOR 
	SELECT '('||to_char(b.cd_item)||') ' 
	from	Conta_Paciente_consiste_v b, 
			conta_paciente a 
	where	b.dt_conta not between a.dt_periodo_inicial and dt_periodo_final 
	and		b.nr_interno_conta = nr_interno_conta_p 
	and		a.nr_interno_conta = nr_interno_conta_p 
	and		coalesce(b.cd_motivo_exc_conta::text, '') = '';
	
C09 CURSOR FOR 
	SELECT '('||to_char(b.cd_item)||') ' 
	from	atendimento_paciente a, 
			Conta_Paciente_consiste_v b 
	where	b.nr_atendimento = a.nr_atendimento 
	and	b.dt_conta not between a.dt_entrada and coalesce(a.dt_alta,clock_timestamp()) 
	and	b.nr_atendimento = nr_atendimento_w 
	and	b.nr_interno_conta = nr_interno_conta_p 
	and	coalesce(b.cd_motivo_exc_conta::text, '') = '';
	

BEGIN 
 
ds_retorno_w:= '';
 
if (nr_interno_conta_p = 0) then 
	goto final;
end if;
	 
if (cd_inconsistencia_p = 2254) then 
	 
	--ds_retorno_w:= 'Existem itens com valores negativos na conta' ||chr(13) || chr(10); 
	ds_retorno_w:= wheb_mensagem_pck.get_texto(308686) ||chr(13) || chr(10);
	open C01;
	loop 
	fetch C01 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C01;
	 
end if;
 
if (cd_inconsistencia_p = 22) then 
		 
	ds_proc_mat_erro_w := Consiste_Valor_Conta(nr_interno_conta_p, ds_proc_mat_erro_w, 'S');	
	--ds_retorno_w:= 'Existem Procedimentos/Materiais Com Preco Zerado' ||chr(13) || chr(10); 
	ds_retorno_w:= wheb_mensagem_pck.get_texto(308688) ||chr(13) || chr(10);
	ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w;
	 
end if;
 
if (cd_inconsistencia_p = 25) then 
	 
	--ds_retorno_w:= 'Existem Procedimentos/Materiais com saldo negativo' ||chr(13) || chr(10); 
	ds_retorno_w:= wheb_mensagem_pck.get_texto(308690) ||chr(13) || chr(10);
	open C02;
	loop 
	fetch C02 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C02;
	 
end if;
 
if (cd_inconsistencia_p in (2245,2246)) then 
 
	select 	max(a.cd_convenio_parametro), 
		max(a.cd_estabelecimento), 
		max(b.ie_tipo_atendimento) 
	into STRICT	cd_convenio_mat_w, 
		cd_estabelecimento_w, 
		ie_tipo_atendimento_w 
	from 	conta_paciente a, 
		atendimento_paciente b 
	where 	a.nr_interno_conta = nr_interno_conta_p 
	and 	a.nr_atendimento = b.nr_atendimento;
 
	select 	max(ie_codigo_convenio) 
	into STRICT	ie_codigo_convenio_w 
	from 	convenio 
	where 	cd_convenio = cd_convenio_mat_w;
	 
	open C04;
	loop 
	fetch C04 into	 
		c04_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin 
		 
		select	max(cd_tipo_acomodacao) 
		into STRICT	cd_tipo_acomodacao_w 
		from	atend_paciente_unidade 
		where	nr_seq_interno	= c04_w.nr_seq_atepacu;
		 
		begin 
		select	max(ie_classificacao) 
		into STRICT	ie_classificacao_w 
		from	tipo_acomodacao 
		where	cd_tipo_acomodacao	= cd_tipo_acomodacao_w;
		exception 
			when others then 
				ie_classificacao_w	:= null;
		end;
		 
		 
				 
		select 	count(*) 
		into STRICT 	dia_feriado_w 
		from 	feriado 
		where 	cd_estabelecimento = coalesce(cd_estabelecimento_w, cd_estabelecimento) 
		and	to_char(dt_feriado,'dd/mm/yyyy') = to_char(c04_w.dt_atendimento,'dd/mm/yyyy');
		 
		if (dia_feriado_w > 0) then 
			ie_feriado_w:= 'S';
		else 
			ie_feriado_w:= 'N';
		end if;
					 
		if (ie_codigo_convenio_w = 'I') then 
		 
			select 	count(*) 
			into STRICT	qt_conversao_mat_conv_w 
			from 	mat_atend_pac_convenio a, 
				material_atend_paciente b 
			where 	a.nr_seq_material = b.nr_sequencia 
			and 	b.nr_interno_conta = nr_interno_conta_p 
			and 	b.nr_sequencia = c04_w.nr_sequencia;
			 
		else 
			 
			select	count(*) 
			into STRICT	qt_conversao_mat_conv_w 
			from	conversao_material_convenio 
			where	coalesce(cd_material, c04_w.cd_material) 			= c04_w.cd_material 
			and (coalesce(cd_categoria, c04_w.cd_categoria)			= c04_w.cd_categoria or c04_w.cd_categoria = '0') 
			and	coalesce(cd_grupo_material, c04_w.cd_grupo)			= c04_w.cd_grupo 
			and	coalesce(cd_subgrupo_material, c04_w.cd_subgrupo)		= c04_w.cd_subgrupo 
			and	coalesce(cd_classe_material, c04_w.cd_classe)		= c04_w.cd_classe 
			and	coalesce(ie_tipo_material,c04_w.ie_tipo_mat) 		= c04_w.ie_tipo_mat 
			and (coalesce(cd_setor_atendimento, c04_w.cd_setor_atendimento)	= c04_w.cd_setor_atendimento) 
			and (coalesce(cd_cgc, c04_w.cd_cgc)				= c04_w.cd_cgc) 
			and (coalesce(ie_classif_acomod, coalesce(ie_classificacao_w, 0))	= coalesce(ie_classificacao_w, 0)) 
			and (coalesce(cd_estabelecimento, cd_estabelecimento_w)		= cd_estabelecimento_w) 
			and	((coalesce(c04_w.dt_atendimento::text, '') = '') or (c04_w.dt_atendimento between coalesce(dt_inicio_vigencia, c04_w.dt_atendimento) 
														and coalesce(dt_final_vigencia, c04_w.dt_atendimento) + 86399/89400)) 
			and	cd_convenio = cd_convenio_mat_w 
			and	ie_situacao = 'A' 
			and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0)) = coalesce(ie_tipo_atendimento_w,0) 
			and	((coalesce(ie_feriado,'A') = ie_feriado_w ) or (coalesce(ie_feriado,'A')	='A'));
		end if;
								 
		select	max(ie_tipo_material) 
		into STRICT	ie_tipo_material_w 
		from	material 
		where	cd_material = c04_w.cd_material;
		 
		 
		if	((cd_inconsistencia_p = 2245) and (ie_tipo_material_w in (1,5))) then 
			if (qt_conversao_mat_conv_w = 0) then 
				ds_retorno_w:= ds_retorno_w || c04_w.cd_material || chr(13) || chr(10);
			end if;
		end if;
		 
		if	((cd_inconsistencia_p = 2246) and (ie_tipo_material_w in (2,3,4))) then 
			if (qt_conversao_mat_conv_w = 0) then 
				ds_retorno_w:= ds_retorno_w || c04_w.cd_material || chr(13) || chr(10);
			end if;
		end if;		
		 
		end;
	end loop;
	close C04;
		 
end if;
 
if (cd_inconsistencia_p = 2244) then 
	 
	select 	max(a.cd_convenio_parametro) 
	into STRICT	cd_convenio_mat_w 
	from 	conta_paciente a, 
		atendimento_paciente b 
	where 	a.nr_interno_conta = nr_interno_conta_p 
	and 	a.nr_atendimento = b.nr_atendimento;
	 
	ds_retorno_w:= '';
	open C03;
	loop 
	fetch C03 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C03;	
	 
end if;
 
 
 
if (cd_inconsistencia_p = 2261) then 
 
	ds_retorno_w:= '';	
	 
	open C05;
	loop 
	fetch C05 into	 
		c05_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin 
		 
		if (c05_w.ie_tipo = 1) then 
			ds_tipo_w  := Wheb_mensagem_pck.get_texto(309274); --'Mat: '; 
			ds_retorno_w:= ds_retorno_w || ds_tipo_w || c05_w.cd_material || chr(13) || chr(10);
		elsif (c05_w.ie_tipo = 2) then 
			ds_tipo_w  := Wheb_mensagem_pck.get_texto(309275); --'Med: '; 
			ds_retorno_w:= ds_retorno_w || ds_tipo_w || c05_w.cd_material || chr(13) || chr(10);
		end if;
			 
		end;
	end loop;
	close C05;
	 
/* 
  sql_mat := '1,5,7,10'; 
  sql_med := '0,2,3,4,8,9'; 
*/
 
 
end if;
 
if (cd_inconsistencia_p = 23) then 
	begin 
	open C06;
	loop 
	fetch C06 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C06;
	end;
end if;
 
if (cd_inconsistencia_p = 29) then 
	begin 
	open C07;
	loop 
	fetch C07 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin 
		ds_retorno_w:= ds_retorno_w || '(' || Wheb_mensagem_pck.get_texto(309276) || ':' /*'(Proc:'*/||ds_proc_mat_erro_w||')' || chr(13) || chr(10);
		end;
	end loop;
	close C07;
	end;
end if;
 
if (cd_inconsistencia_p = 21) then 
	begin 
	open C08;
	loop 
	fetch C08 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C08;
	end;
end if;
 
if (cd_inconsistencia_p = 20) then 
	begin 
	 
	select 	max(nr_atendimento) 
	into STRICT 	nr_atendimento_w 
	from 	conta_paciente 
	where	nr_interno_conta = nr_interno_conta_p;
	 
	open C09;
	loop 
	fetch C09 into	 
		ds_proc_mat_erro_w;
	EXIT WHEN NOT FOUND; /* apply on C09 */
		begin 
		ds_retorno_w:= ds_retorno_w || ds_proc_mat_erro_w || chr(13) || chr(10);
		end;
	end loop;
	close C09;
	end;
end if;
 
 
 
<< final >> 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_detalhe_inconsistencia (cd_inconsistencia_p bigint, nr_interno_conta_p bigint) FROM PUBLIC;

