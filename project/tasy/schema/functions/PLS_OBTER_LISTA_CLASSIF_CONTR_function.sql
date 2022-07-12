-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_lista_classif_contr ( ie_tipo_classificacao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(4000);
ds_lista_w			varchar(255);
pos_virgula_w			integer;
ie_acao_w			varchar(5);

function obter_descricao_classificacao(nr_seq_classificacao_p	text)
 		    	return text is

ds_classificacao_w	pls_classificacao_contrato.ds_classificacao%type;
			

BEGIN

select	max(ds_classificacao)
into STRICT	ds_classificacao_w
from	pls_classificacao_contrato
where	nr_sequencia = nr_seq_classificacao_p;

return	ds_classificacao_w;

end;

begin

begin

ds_lista_w	:= ie_tipo_classificacao_p || ',';

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
	begin
	
	select  position(',' in ds_lista_w)
	into STRICT    pos_virgula_w
	;
	
	if (pos_virgula_w > 0) then
		ie_acao_w	:= substr(ds_lista_w,1,pos_virgula_w-1);
		
		if (ie_acao_w IS NOT NULL AND ie_acao_w::text <> '') then
			ds_lista_w	:= substr(ds_lista_w,pos_virgula_w+1,length(ds_lista_w));
			
			if (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w	:= obter_descricao_classificacao(ie_acao_w);
			else
				ds_retorno_w	:= ds_retorno_w || ', ' || obter_descricao_classificacao(ie_acao_w);
			end if;
		else
			ds_lista_w	:= null;
		end if;
	end if;
	
	end;
end loop;

exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1072674);
end;

return	substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_lista_classif_contr ( ie_tipo_classificacao_p text) FROM PUBLIC;

