-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_expired_date_status (nr_sequencia_p bigint, tipo_painel text default 'F') RETURNS varchar AS $body$
DECLARE


/* Tipo de Painel
Usado nos times do Clinical Pathway
P: quando for o painel pai - retorna se algum dos n elementos do painel filho contem um registro expirado
F: quando for o painel filho - retorna se o registro esta expirado ou ainda e valido
else: retorna a quantidade de validos para ser usado no filtro de validos ou expirados
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Validar a data de emissao da conta
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ x ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [   ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atencao:  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */			
			
ds_retorno_w		varchar(255) := 'Unexpired';
qt_validos_w		integer;
dt_validade_w		timestamp;


BEGIN

ds_retorno_w := obter_desc_expressao(307162); --Unexpired
select count(*)
into STRICT qt_validos_w
from protocolo_integrado_partic 
where nr_seq_equipe = nr_sequencia_p
and (coalesce(dt_validade::text, '') = '' 
or dt_validade > clock_timestamp());

if (tipo_painel = 'F') then

	select dt_validade
	into STRICT dt_validade_w
	from protocolo_integrado_partic
	where nr_sequencia = nr_sequencia_p;
	
	if (dt_validade_w IS NOT NULL AND dt_validade_w::text <> '') then
		if (dt_validade_w <= clock_timestamp()) then
			ds_retorno_w := obter_desc_expressao(309833); --Expired
		end if;
	end if;
	
elsif (tipo_painel = 'P') then

	if (qt_validos_w = 0) then
		ds_retorno_w := obter_desc_expressao(309833); --Expired
	else
		ds_retorno_w := obter_desc_expressao(307162); --Unexpired
	end if;	

else
  
  ds_retorno_w := qt_validos_w;
	
end if;
	
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_expired_date_status (nr_sequencia_p bigint, tipo_painel text default 'F') FROM PUBLIC;
