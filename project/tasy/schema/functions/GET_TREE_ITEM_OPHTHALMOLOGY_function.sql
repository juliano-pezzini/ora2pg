-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_tree_item_ophthalmology ( nr_sequencia_p bigint, cd_perfil_p bigint, ie_option_p text) RETURNS varchar AS $body$
DECLARE


ds_item_w	                varchar(40);
tree_node_w                  	bigint;
nr_seq_apresentacao_w	integer;
ds_retorno_w		varchar(40);


BEGIN
if (nr_sequencia_p > 0) then
	select	coalesce(b.ds_instituicao, obter_desc_expressao(a.cd_exp_desc_item,a.ds_item)),
               		a.nr_seq_painel,
               		coalesce(b.nr_seq_apresentacao, a.nr_seq_apresentacao)
	into STRICT	ds_item_w,
	                tree_node_w,
              		nr_seq_apresentacao_w
	from	oftalmologia_item a,
              		perfil_item_oftalmologia b
	where  	a.nr_sequencia 		= nr_sequencia_p
	and      	a.nr_sequencia 		= b.nr_seq_item
   	and    	b.cd_perfil 		= cd_perfil_p
   	and    	coalesce(a.ie_situacao_html5,'A') 	= 'A';
end if;

if (ie_option_p = 'D') then
	ds_retorno_w	:= ds_item_w;
elsif (ie_option_p = 'S') then
	ds_retorno_w	:= tree_node_w;
elsif (ie_option_p = 'A') then
	ds_retorno_w	:= nr_seq_apresentacao_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_tree_item_ophthalmology ( nr_sequencia_p bigint, cd_perfil_p bigint, ie_option_p text) FROM PUBLIC;

