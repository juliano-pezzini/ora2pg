-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_item_aut ( nr_seq_guia_p bigint, ie_origem_proced_p text, cd_procedimento_p text, nr_seq_material_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*
	ie_opcao_p:
	QA = Quantidade autorizada
*/
qt_autorizada_w		bigint;
qt_proc_aut_w		bigint := 0;
qt_mat_aut_w		bigint := 0;
vl_retorno_w		bigint := 0;


BEGIN

	/*Procedimento*/

if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	begin
	select 	count(1)
	into STRICT 	qt_proc_aut_w
	from	pls_guia_plano_proc
	where	nr_seq_guia	 	= coalesce(nr_seq_guia_p,0)
	and	ie_origem_proced 	= ie_origem_proced_p
	and	cd_procedimento  	= cd_procedimento_p;
	exception
	when others then
		qt_proc_aut_w	:= 0;
	end;

	/*Verificar se os procedimentos foram autorizados e verificar a quantidade deles, se não houver procedimentos autorizados
	  não gera ocorrência de quantidade pois o procedimento não estava autorizado Demitrius - 03/01/2013*/
	if (qt_proc_aut_w	> 0)	then
		select coalesce(sum(a.qt_autorizada),0)
		into STRICT	qt_autorizada_w
		from  	pls_guia_plano_proc a
		where  	a.nr_seq_guia 		= coalesce(nr_seq_guia_p,0)
		and	a.ie_origem_proced 	= ie_origem_proced_p
		and	a.cd_procedimento  	= cd_procedimento_p;
	elsif (qt_proc_aut_w	 = 0)	then
		/*Recebe 1 para não gerar ocorrência  Demitrius - 03/01/2013*/

		qt_autorizada_w	:= 0;
	end if;
	/*Material*/

elsif (coalesce(nr_seq_material_p,0) > 0 ) then
	begin
	select	count(1)
	into STRICT	qt_mat_aut_w
	from   	pls_guia_plano_mat a
	where 	a.nr_seq_guia 	 = coalesce(nr_seq_guia_p,0)
	and    	a.nr_seq_material = nr_seq_material_p;
	exception
	when others then
		qt_mat_aut_w	:= 0;
	end;

	if (qt_mat_aut_w	> 0)	then
		select	coalesce(sum(a.qt_autorizada),0)
		into STRICT	qt_autorizada_w
		from   	pls_guia_plano_mat a
		where 	a.nr_seq_guia 	 = coalesce(nr_seq_guia_p,0)
		and    	a.nr_seq_material = nr_seq_material_p;
	elsif (qt_mat_aut_w	= 0)	then
		qt_autorizada_w	:= 0;
	end if;

end if;

if (ie_opcao_p = 'QA') then
	vl_retorno_w	:=  qt_autorizada_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_item_aut ( nr_seq_guia_p bigint, ie_origem_proced_p text, cd_procedimento_p text, nr_seq_material_p bigint, ie_opcao_p text) FROM PUBLIC;

