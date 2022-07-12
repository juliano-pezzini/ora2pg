-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_item_desc_conv_scs ( nr_seq_item_p bigint, ie_tipo_item_p text, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


/*IE_TIPO_RETORNO_P
C - Código do item
D - Descrição do item
*/
/*IE_TIPO_ITEM_P
P - Procedimento
M - Material
*/
/*IE_ORIGEM_ITEM_W
G - Guia
R - Requisição
E - Execução
*/
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar o código ou a descrição do item gerado através do De/Para
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);

ie_origem_item_w		varchar(255);
ds_procedimento_w		varchar(255);
cd_procedimento_w		varchar(255);

nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
nr_seq_execucao_w		bigint;
nr_seq_origem_w			bigint;
nr_seq_auditoria_w		bigint;


BEGIN

select	nr_seq_auditoria
into STRICT	nr_seq_auditoria_w
from	pls_auditoria_item
where	nr_sequencia = nr_seq_item_p;

select	nr_seq_guia,
	nr_seq_requisicao,
	nr_seq_execucao
into STRICT	nr_seq_guia_w,
	nr_seq_requisicao_w,
	nr_seq_execucao_w
from	pls_auditoria
where	nr_sequencia = nr_seq_auditoria_w;

--Verifica a origem do item    G - Guia / R - Requisição / E - Execução
if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
	ie_origem_item_w := 'G';
elsif (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
	ie_origem_item_w := 'R';
elsif (nr_seq_execucao_w IS NOT NULL AND nr_seq_execucao_w::text <> '') then
	ie_origem_item_w := 'E';
end if;


if (ie_tipo_item_p	= 'P') then

	select	nr_seq_proc_origem
	into STRICT	nr_seq_origem_w
	from	pls_auditoria_item
	where	nr_sequencia	= nr_seq_item_p;

	if (ie_tipo_retorno_p	= 'C') then
		begin
			if (ie_origem_item_w = 'G') then
				select	cd_procedimento_ptu
				into STRICT	ds_retorno_w
				from	pls_guia_plano_proc
				where	nr_sequencia	= nr_seq_origem_w;
			elsif (ie_origem_item_w = 'R') then
				select	cd_procedimento_ptu
				into STRICT	ds_retorno_w
				from	pls_requisicao_proc
				where	nr_sequencia	= nr_seq_origem_w;
			end if;
		exception
		when others then
			ds_retorno_w	:= '';
		end;
	elsif (ie_tipo_retorno_p	= 'D') then
		begin
			if (ie_origem_item_w = 'G') then
				select	substr(ds_procedimento_ptu,1,80)
				into STRICT	ds_retorno_w
				from	pls_guia_plano_proc
				where	nr_sequencia	= nr_seq_origem_w;
			elsif (ie_origem_item_w = 'R') then
				select	substr(ds_procedimento_ptu,1,80)
				into STRICT	ds_retorno_w
				from	pls_requisicao_proc
				where	nr_sequencia	= nr_seq_origem_w;
			end if;
		exception
		when others then
			ds_retorno_w	:= '';
		end;
	end if;
elsif (ie_tipo_item_p	= 'M') then

	select	nr_seq_mat_origem
	into STRICT	nr_seq_origem_w
	from	pls_auditoria_item
	where	nr_sequencia	= nr_seq_item_p;

	if (ie_tipo_retorno_p	= 'C') then
		begin
			if (ie_origem_item_w = 'G') then
				select	cd_material_ptu
				into STRICT	ds_retorno_w
				from	pls_guia_plano_mat
				where	nr_sequencia	= nr_seq_origem_w;
			elsif (ie_origem_item_w = 'R') then
				select	cd_material_ptu
				into STRICT	ds_retorno_w
				from	pls_requisicao_mat
				where	nr_sequencia	= nr_seq_origem_w;
			end if;
		exception
		when others then
			ds_retorno_w	:= '';
		end;
	elsif (ie_tipo_retorno_p	= 'D') then
		begin
			if (ie_origem_item_w = 'G') then
				select	substr(ds_material_ptu,1,80)
				into STRICT	ds_retorno_w
				from	pls_guia_plano_mat
				where	nr_sequencia	= nr_seq_origem_w;
			elsif (ie_origem_item_w = 'R') then
				select	substr(ds_material_ptu,1,80)
				into STRICT	ds_retorno_w
				from	pls_requisicao_mat
				where	nr_sequencia	= nr_seq_origem_w;
			end if;
		exception
		when others then
			ds_retorno_w	:= '';
		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_item_desc_conv_scs ( nr_seq_item_p bigint, ie_tipo_item_p text, ie_tipo_retorno_p text) FROM PUBLIC;

