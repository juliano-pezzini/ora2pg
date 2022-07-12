-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_conta_mat (nr_seq_conta_mat_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_seq_material_w		bigint;
cd_material_imp_w		varchar(20);
ds_material_imp_w		varchar(255);

--	IE_OPCAO_P 

-- C	Nr sequencia do material

-- D	Descrição

-- V	Valor liberado

-- O	Código material OPS

-- UN	Unidade de medida do material

-- EC	Estágio complemento

-- QT	Quantidade do item

-- CM	Código material

-- CMI	Código material imp

-- TT	Tipo tabela TISS

-- DA	Descrição mat A900

-- DI	Dados da importação A500

-- DT	Data do material

-- QL	Quantidade liberada

-- CD	Código material OPS 

-- VLM	Valor Calculado

-- VML	Valor Liberado

-- VG 	Valor glosa

-- VLA	Valor apresentado

-- QTA	Quantidade apresentada

-- QTL	Quantidade liberada

-- UN	Unidade medida

-- VTA  Valor Total Avisado
BEGIN
if (upper(ie_opcao_p) = 'CD') then
	begin
		SELECT	pls_obter_dados_material(nr_seq_material,'CO')
		into STRICT	ds_retorno_w
		from	pls_conta_mat
		where	nr_sequencia	= nr_seq_conta_mat_p;
	exception
	when others then
		ds_retorno_w	:= null;
	end;
elsif (upper(ie_opcao_p) = 'C') then
	select	max(nr_seq_material)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'D') then
	begin
	select	substr(obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',nr_seq_material),1,255)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	exception
	when others then
		ds_retorno_w := null;
	end;
elsif (upper(ie_opcao_p) = 'V') then
	select	coalesce(max(vl_liberado),0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;

elsif (upper(ie_opcao_p) = 'O') then
	begin
	select	pls_obter_seq_codigo_material(nr_seq_material,null)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	exception
	when others then
		ds_retorno_w := null;
	end;
elsif (upper(ie_opcao_p) = 'UN') then
	select (select	max(z.ds_unidade_medida)
		from 	unidade_medida z
		where 	z.cd_unidade_medida = b.cd_unidade_medida) cd_unidade_medida
	into STRICT	ds_retorno_w
	from 	pls_material b,
		pls_conta_mat a
	where 	b.nr_sequencia	= a.nr_seq_material
	and	a.nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'EC') then
	select	max(ie_estagio_complemento)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'QT') then
	select	coalesce(max(qt_material_imp),0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'CM') then
	select	max(cd_material)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'CMI') then
	select	max(cd_material_imp)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'TT') then
	select	max(cd_tabela_xml)
	into STRICT	ds_retorno_w
	from	pls_conta_mat	x,
		tiss_tipo_tabela w
	where	x.nr_seq_tiss_tabela	= w.nr_sequencia
	and	x.nr_sequencia		= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'DA') then
	select	coalesce(trim(both max(ds_material_imp)), pls_obter_dados_material_a900(max(cd_material_imp), null, 'NM')),
		max(nr_seq_material)
	into STRICT	ds_retorno_w,
		nr_seq_material_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
	if (coalesce(ds_retorno_w::text, '') = '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then		
		begin
		select	substr(pls_obter_dados_material_a900(null,nr_seq_material_unimed,'NM'),1,245)
		into STRICT	ds_retorno_w
		from	pls_material
		where	nr_sequencia = nr_seq_material_w;
		exception
		when others then
			ds_retorno_w := null;
		end;
	end if;
	
elsif (upper(ie_opcao_p) = 'DI') then
	select	max(cd_material_imp),
		max(ds_material_imp)
	into STRICT	cd_material_imp_w,
		ds_material_imp_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_conta_mat_p;
	
	if (cd_material_imp_w IS NOT NULL AND cd_material_imp_w::text <> '') and (ds_material_imp_w IS NOT NULL AND ds_material_imp_w::text <> '') then
		ds_retorno_w := cd_material_imp_w ||' - '|| substr(ds_material_imp_w,1,230);
	
	elsif (ds_material_imp_w IS NOT NULL AND ds_material_imp_w::text <> '') then
		ds_retorno_w := substr(ds_material_imp_w,1,255);
	
	elsif (cd_material_imp_w IS NOT NULL AND cd_material_imp_w::text <> '') then
		ds_retorno_w := cd_material_imp_w;
	else
		ds_retorno_w := '';
	end if;
elsif (upper(ie_opcao_p) = 'DT') then
	select	to_char(max(dt_atendimento),'dd/mm/yyyy')
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where	nr_sequencia = nr_seq_conta_mat_p;
elsif (upper(ie_opcao_p) = 'QL') then
	select	coalesce(max(a.qt_material),0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat a
	where	a.nr_sequencia	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'VLM') then
	select	coalesce(vl_material,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;

elsif (upper(ie_opcao_p) = 'VML') then
	select	coalesce(vl_liberado,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'VG') then
	select	coalesce(vl_glosa,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'VLA') then
	select	coalesce(vl_material_imp,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'QTA') then
	select	coalesce(qt_material_imp,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'QTL') then
	select	coalesce(qt_material,0)
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
elsif (upper(ie_opcao_p) = 'UN') then
	select	cd_unidade_medida,
		nr_seq_material
	into STRICT	ds_retorno_w,
		nr_seq_material_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;
	
	if (coalesce(ds_retorno_w::text, '') = '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
		select	max(cd_unidade_medida)
		into STRICT	ds_retorno_w
		from	pls_material
		where	nr_sequencia	= nr_seq_material_w;
	end if;
	
elsif (upper(ie_opcao_p) = 'DTR') then
	select	to_char(dt_atendimento_referencia, 'dd/mm/yyyy')
	into STRICT	ds_retorno_w
	from	pls_conta_mat
	where 	nr_sequencia 	= nr_seq_conta_mat_p;

elsif (upper(ie_opcao_p) = 'VTA') then
	-- Vai obter somente valor do aviso de cobrança Recebido
	select	coalesce(max(a.vl_total),0)
	into STRICT    ds_retorno_w
	from	ptu_aviso_material	a,
		ptu_nota_servico	s
	where	a.nr_sequencia		= s.nr_seq_aviso_material
	and	s.nr_seq_conta_mat	= nr_seq_conta_mat_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_conta_mat (nr_seq_conta_mat_p bigint, ie_opcao_p text) FROM PUBLIC;

