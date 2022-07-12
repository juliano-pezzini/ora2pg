-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_formula_wavaliar ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, ds_prefixo_p text, ie_funcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);
ds_formula_w	varchar(4000);
ds_search_w	varchar(50);
ds_replace_w	varchar(50);
nr_seq_item_w	varchar(10);
vl_pos_w		smallint;
ie_resultado_w	varchar(2);
ds_mascara_w	med_item_avaliar.ds_mascara%type;


BEGIN

select	ds_formula
into STRICT	ds_formula_w
from	med_item_avaliar
where	nr_sequencia = nr_seq_item_p;

vl_pos_w	:= position(ds_prefixo_p in ds_formula_w);
while(vl_pos_w > 0)  loop
	begin

	nr_seq_item_w	:= substr(ds_formula_w, (vl_pos_w + length(ds_prefixo_p)), position('#' in ds_formula_w) - (vl_pos_w + length(ds_prefixo_p)));
	ds_search_w	:= ds_prefixo_p || nr_seq_item_w || '#';
	
	-- Boletim de Ocorrencia
	if (ie_funcao_p = 'B') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	sac_pesquisa_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric 
		and	nr_seq_pesquisa	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'Q') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	qua_avaliacao_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_avaliacao	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'T') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	qua_doc_tr_pf_aval_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_trein_pf_aval	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'P') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	PESSOA_AVALIACAO_RESULT
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_avaliacao	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'O') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	man_ordem_serv_aval_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_ordem_serv_aval	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'G') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	gpi_projeto_aval_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_gpi_aval	= nr_seq_avaliacao_p;
		
		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'E') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	qua_evento_pac_aval_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_evento_aval 	= nr_seq_avaliacao_p;

		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'A') then
		
		select	qt_resultado
		into STRICT	ds_replace_w
		from	mat_aval_quest_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_quest 	= nr_seq_avaliacao_p;

		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'C') then
		
		select	qt_resultado
		into STRICT	ds_replace_w
		from	mat_aval_quest_set_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_quest_setor 	= nr_seq_avaliacao_p;

		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
	elsif (ie_funcao_p = 'N') then

		select	qt_resultado
		into STRICT	ds_replace_w
		from	orientacao_alta_enf_result
		where	nr_seq_item	= (nr_seq_item_w)::numeric
		and	nr_seq_orientacao 	= nr_seq_avaliacao_p;

		ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));			
	elsif (ie_funcao_p = 'F') then

		select	ie_resultado,
			ds_mascara
		into STRICT	ie_resultado_w,
			ds_mascara_w
		from	med_item_avaliar
		where	nr_sequencia = (nr_seq_item_w)::numeric;
		
		select	max(CASE WHEN ie_resultado_w='A' THEN substr(ds_resultado,1,50)  ELSE ds_resultado END )
		into STRICT	ds_replace_w
		from	med_avaliacao_result
		where	nr_seq_item		= (nr_seq_item_w)::numeric
		and	nr_seq_avaliacao	= nr_seq_avaliacao_p;
	
		if (ie_resultado_w in ('V','B')
		         and coalesce(ds_replace_w::text, '') = '') then
		   ds_replace_w	:= 0;
		end if;
		
		if (ie_resultado_w = 'C') then
			ds_formula_w := substituir_primeira_string(ds_formula_w,ds_search_w, ds_replace_w );
		elsif ( ie_resultado_w = 'A' ) then
			if ( ds_replace_w = '  /  /    ') then
				ds_replace_w	:= 'to_date(null,'||chr(39)||ds_mascara_w||chr(39)||')';
			else
				ds_replace_w	:= 'to_date('||chr(39)||ds_replace_w||chr(39)||','||chr(39)||ds_mascara_w||chr(39)||')';
			end if;
			ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, ds_replace_w);
		else
			ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
		end if;	
		
	else
		
		select	ie_resultado,
			ds_mascara
		into STRICT	ie_resultado_w,
			ds_mascara_w
		from	med_item_avaliar
		where	nr_sequencia = (nr_seq_item_w)::numeric;		
		
		begin
		
		select	CASE WHEN ie_resultado_w='A' THEN substr(ds_resultado,1,50) WHEN ie_resultado_w='C' THEN  ds_resultado WHEN ie_resultado_w='E' THEN  ds_resultado  ELSE qt_resultado END
		into STRICT	ds_replace_w
		from	med_avaliacao_result
		where	nr_seq_item		= (nr_seq_item_w)::numeric 
		and	nr_seq_avaliacao	= nr_seq_avaliacao_p;				
		
		exception
		when others then
	
			if (ie_resultado_w in ('V','B')) then
				ds_replace_w	:= 0;
			end	if;
		end;
		
		if (ie_resultado_w = 'C') then
			ds_formula_w := substituir_primeira_string(ds_formula_w,ds_search_w, ds_replace_w );
		elsif ( ie_resultado_w = 'A' ) then
			if ( ds_replace_w = '  /  /    ') then
				ds_replace_w	:= 'to_date(null,'||chr(39)||ds_mascara_w||chr(39)||')';		
			else
				ds_replace_w	:= 'to_date('||chr(39)||ds_replace_w||chr(39)||','||chr(39)||ds_mascara_w||chr(39)||')';		
			end if;
			ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, ds_replace_w);
		else
			ds_formula_w	:= Substituir_Primeira_String(ds_formula_w, ds_search_w, replace(ds_replace_w,',','.'));
		end if;
	end	if;
	
	vl_pos_w	:= position(ds_prefixo_p in ds_formula_w);

	end;
end	loop;

if (position(chr(39) in ds_formula_w) > 0) then
	ds_formula_w :=	obter_select_concatenado_bv('select '|| ds_formula_w || ' from dual','','');	
elsif (ie_resultado_w = 'C') then
	return ds_formula_w;
else
	ds_formula_w := obter_valor_dinamico('select ' || ds_formula_w || ' from dual', ds_formula_w);
end if;

return	ds_formula_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_formula_wavaliar ( nr_seq_avaliacao_p bigint, nr_seq_item_p bigint, ds_prefixo_p text, ie_funcao_p text) FROM PUBLIC;
