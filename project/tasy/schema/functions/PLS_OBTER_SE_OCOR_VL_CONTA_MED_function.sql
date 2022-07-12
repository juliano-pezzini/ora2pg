-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_ocor_vl_conta_med ( nr_seq_guia_p bigint, nr_seq_origem_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Vrificar se existe nos itens, a ocorrência que permite informar valor para a conta médica
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_retorno_w			varchar(2)	:= 'N';
ie_exige_valor_conta_w		varchar(2)	:= 'N';
nr_seq_guia_proc_w		bigint;
nr_seq_guia_mat_w		bigint;


BEGIN

if (ie_tipo_item_p	= 'P') then
	begin
		select	ie_exige_valor_conta
		into STRICT	ie_exige_valor_conta_w
		from	pls_guia_plano_proc
		where	nr_sequencia	= nr_seq_origem_p;
	exception
	when others then
		ie_exige_valor_conta_w	:= 'N';
	end;

	if (ie_exige_valor_conta_w	= 'S') then
		ie_retorno_w	:= 'S';
	end if;

elsif (ie_tipo_item_p	= 'M') then
	begin
		select	ie_exige_valor_conta
		into STRICT	ie_exige_valor_conta_w
		from	pls_guia_plano_mat
		where	nr_sequencia	= nr_seq_origem_p;
	exception
	when others then
		ie_exige_valor_conta_w	:= 'N';
	end;

	if (ie_exige_valor_conta_w	= 'S') then
		ie_retorno_w	:= 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_ocor_vl_conta_med ( nr_seq_guia_p bigint, nr_seq_origem_p bigint, ie_tipo_item_p text) FROM PUBLIC;

