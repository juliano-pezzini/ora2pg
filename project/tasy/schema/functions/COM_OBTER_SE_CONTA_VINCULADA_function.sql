-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_se_conta_vinculada ( nr_seq_cliente_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255) := 'N';
ie_vinculado_w		varchar(15);
nr_seq_cliente_w		bigint;
ie_produto_atual_w		varchar(15);
ie_produto_origem_w	varchar(15);

/*	Tipo de cliente 
cv	- Cliente Matriz 
v	- Vinculado 
N	- não possui vinculos */
 
 

BEGIN 
ie_vinculado_w := substr(obter_dados_com_cliente(nr_seq_cliente_p,'V'),1,2);
if (ie_vinculado_w = 'N') then 
	ds_retorno_w := 'S';
elsif (ie_vinculado_w = 'V') then 
	ds_retorno_w := 'S';
elsif (ie_vinculado_w = 'CV') then 
	begin 
	select	coalesce(max(a.ie_produto),'X') 
	into STRICT	ie_produto_atual_w 
	from	com_cliente a 
	where	a.nr_sequencia = nr_seq_cliente_p;
 
	select	coalesce(max(a.nr_seq_cliente),0) 
	into STRICT	nr_seq_cliente_w 
	from	com_cliente_vinculo a 
	where	nr_seq_cliente_vinculo = nr_seq_cliente_p;
 
	select	max(a.ie_produto) 
	into STRICT	ie_produto_origem_w 
	from	com_cliente a 
	where	a.nr_sequencia = nr_seq_cliente_w;
 
	if (trim(both ie_produto_atual_w) <> trim(both ie_produto_origem_w)) then 
		ds_retorno_w := 'S';
	end if;
	end;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_se_conta_vinculada ( nr_seq_cliente_p bigint) FROM PUBLIC;

