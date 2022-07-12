-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_audit_lib ( nr_seq_auditoria_p bigint, nr_interno_conta_p bigint, dt_liberacao_p timestamp, vl_auditoria_lib_p bigint) RETURNS bigint AS $body$
DECLARE

			
			
vl_item_w		double precision;
vl_total_w		double precision:=0;
qt_ajuste_w		double precision;
qt_original_w		double precision;
qt_dif_w		double precision;
ie_tipo_w		smallint;

vl_preco_w		double precision;
vl_unitario_w		double precision;
nr_interno_conta_w	bigint;

tx_proc_original_w	double precision;
tx_proc_ajuste_w	double precision;
tx_dif_w		double precision;
ie_tipo_auditoria_w	varchar(1);
ie_tipo_item_w		varchar(1);
nr_seq_audit_ext_w	bigint;
nr_seq_item_w		bigint;
nr_sequencia_w		bigint;
qt_procedimento_w	bigint;

c01 CURSOR FOR
	SELECT	coalesce(a.vl_material,0),
		b.qt_ajuste,
		b.qt_original,
		1,
		a.vl_unitario,
		null,
		null,
		'I',
		null,
		null
	from	material_atend_paciente a,
		auditoria_matpaci b
	where	a.nr_sequencia	    = b.nr_seq_matpaci
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and 	a.nr_interno_conta  = nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia
	
union all

	SELECT	coalesce(a.vl_procedimento,0),
		b.qt_ajuste,
		b.qt_original,
		2,
		null,
		b.tx_proc_original,
		b.tx_proc_ajuste,
		'I',
		null,
		a.nr_sequencia
	from	procedimento_paciente a,
		auditoria_propaci b
	where	a.nr_sequencia	    = b.nr_seq_propaci
	and 	a.nr_interno_conta  = nr_interno_conta_p
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia
	
union all

	select	coalesce(a.vl_material,0),
		b.qt_ajuste,
		b.qt_original,
		1,
		a.vl_unitario,
		null, 
		null,
		'E',
		b.nr_sequencia,
		a.nr_sequencia
	from	material_atend_paciente a,
		auditoria_externa_item  c,
		auditoria_externa 	b
	where	a.nr_sequencia	    = c.nr_seq_item
	and 	c.nr_seq_audit_ext  = b.nr_sequencia
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and 	a.nr_interno_conta  = nr_interno_conta_p
	and 	b.ie_tipo_item = 'M'
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia
	
union all

	select	coalesce(a.vl_procedimento,0),
		b.qt_ajuste,
		b.qt_original,
		2,
		null,
		null,
		null,
		'E',
		b.nr_sequencia,
		a.nr_sequencia
	from	procedimento_paciente   a,
		auditoria_externa_item  c,
		auditoria_externa 	b
	where	a.nr_sequencia	    = c.nr_seq_item
	and 	c.nr_seq_audit_ext  = b.nr_sequencia
	and 	a.nr_interno_conta  = nr_interno_conta_p
	and 	b.ie_tipo_item = 'P'
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia;
	
	
/*Cursor C02 is
	select	c.nr_seq_item
	from	auditoria_externa_item  c,
		auditoria_externa 	b
	where	c.nr_seq_audit_ext  = b.nr_sequencia
	and 	b.nr_seq_auditoria  = nr_seq_auditoria_p	
	and 	c.nr_seq_audit_ext  = nr_seq_audit_ext_w
	order by 1;*/
	
C02 CURSOR FOR
	SELECT	c.nr_seq_item
	from	material_atend_paciente a,
		auditoria_externa_item  c,
		auditoria_externa 	b
	where	a.nr_sequencia	    = c.nr_seq_item
	and 	c.nr_seq_audit_ext  = b.nr_sequencia
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and 	c.nr_seq_audit_ext  = nr_seq_audit_ext_w
	and 	b.ie_tipo_item = 'M'
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia
	and	a.vl_material > 0	
	
union all

	SELECT	c.nr_seq_item
	from	procedimento_paciente   a,
		auditoria_externa_item  c,
		auditoria_externa 	b
	where	a.nr_sequencia	    = c.nr_seq_item
	and 	c.nr_seq_audit_ext  = b.nr_sequencia
	and 	c.nr_seq_audit_ext  = nr_seq_audit_ext_w
	and 	b.ie_tipo_item = 'P'
	and	b.nr_seq_auditoria  = nr_seq_auditoria_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote,0)	<> a.nr_sequencia
	and 	a.vl_procedimento > 0;
	

BEGIN

if (dt_liberacao_p IS NOT NULL AND dt_liberacao_p::text <> '' AND vl_auditoria_lib_p IS NOT NULL AND vl_auditoria_lib_p::text <> '') then
	return vl_auditoria_lib_p;
end if;

open C01;
loop
fetch C01 into	
	vl_item_w,
	qt_ajuste_w,
	qt_original_w,
	ie_tipo_w,
	vl_unitario_w,
	tx_proc_original_w,
	tx_proc_ajuste_w,
	ie_tipo_auditoria_w,
	nr_seq_audit_ext_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin		
	vl_total_w	:= vl_total_w + vl_item_w;
	
	if (ie_tipo_auditoria_w = 'I') then -- Auditoria Interna
	
		if (qt_ajuste_w IS NOT NULL AND qt_ajuste_w::text <> '') then
			qt_dif_w:= qt_ajuste_w - qt_original_w;
		
			if (ie_tipo_w = 1) then
					
				vl_total_w	:=  vl_total_w + (vl_unitario_w * qt_dif_w);
			
			elsif (ie_tipo_w = 2) then
				
				if (qt_original_w = 0) and (vl_item_w = 0) then					
					select 	coalesce(max(obter_preco_procedimento(a.cd_estabelecimento, a.cd_convenio_parametro, a.cd_categoria_parametro, coalesce(b.dt_conta, b.dt_procedimento),
									      b.cd_procedimento, b.ie_origem_proced, 0, 0, 0, b.cd_medico_executor, b.ie_funcao_medico, null,null, 0,0,'P')),0)
					into STRICT	vl_item_w
					from	procedimento_paciente b,
					 	conta_paciente a
					where 	a.nr_interno_conta = nr_interno_conta_p
					and 	a.nr_interno_conta = b.nr_interno_conta
					and 	b.nr_sequencia = nr_sequencia_w;
					
					vl_preco_w:= vl_item_w;
				else
		
					vl_preco_w	:=  dividir(vl_item_w, qt_original_w);
				
				end if;				
				
				vl_total_w	:=  vl_total_w + (vl_preco_w * qt_dif_w);
		
			end if;
		
		elsif (tx_proc_ajuste_w IS NOT NULL AND tx_proc_ajuste_w::text <> '') then
			tx_dif_w:= tx_proc_ajuste_w - tx_proc_original_w;
				
			vl_total_w:= vl_total_w + (vl_item_w * tx_dif_w / 100);
		end if;
		
	elsif (ie_tipo_auditoria_w = 'E') then -- Auditoria Externa
	
		if (qt_ajuste_w IS NOT NULL AND qt_ajuste_w::text <> '') then
			qt_dif_w:= qt_ajuste_w - qt_original_w;
		
			open C02;
			loop
			fetch C02 into	
				nr_seq_item_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				nr_seq_item_w:= nr_seq_item_w;
				end;
			end loop;
			close C02;
			
			if (nr_seq_item_w = nr_sequencia_w) then
		
				if (ie_tipo_w = 1) then
					
					vl_total_w	:=  vl_total_w + (vl_unitario_w * qt_dif_w);
			
				elsif (ie_tipo_w = 2) then
										
					if (vl_item_w < 0) then
						vl_item_w:= vl_item_w * -1;
					end if;
					
					select	a.qt_procedimento
					into STRICT	qt_procedimento_w
					from	procedimento_paciente a
					where	a.nr_sequencia = nr_sequencia_w;
					
					vl_preco_w	:=  dividir(vl_item_w, qt_procedimento_w); /* troquei o qt_original_w pelo qt_procedimento_w e adicionei o 
												select para buscar a qtd do procedimento, OS 186694*/
					vl_total_w	:=  vl_total_w + (vl_preco_w * qt_dif_w);
		
				end if;
				
			end if;
		
		end if;
	
	end if;
	
	end;
end loop;
close C01;

return	vl_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_audit_lib ( nr_seq_auditoria_p bigint, nr_interno_conta_p bigint, dt_liberacao_p timestamp, vl_auditoria_lib_p bigint) FROM PUBLIC;

