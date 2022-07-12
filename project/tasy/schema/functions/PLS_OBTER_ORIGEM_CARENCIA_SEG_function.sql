-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_origem_carencia_seg (nr_seq_segurado_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter a origem da carência

DO - Descrição origem
TO -  Tipo origem
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  x ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(255);
ds_origem_carencia_w	varchar(255);
ie_tipo_carencia_w	varchar(1);
cont_w			bigint;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;
nr_seq_plano_w		pls_plano.nr_sequencia%type;


BEGIN

begin
	select 	nr_sequencia,
		nr_seq_contrato,
		nr_seq_plano
	into STRICT	nr_seq_segurado_w,
		nr_seq_contrato_w,
		nr_seq_plano_w
	from	pls_segurado
	where 	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	nr_seq_segurado_w	:= null;
end;

if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
	select	count(1)
	into STRICT	cont_w
	from	pls_carencia
	where	nr_seq_segurado		= nr_seq_segurado_w
	and	ie_cpt			= 'N'  LIMIT 1;

	if (cont_w > 0) then
		ie_tipo_carencia_w	:= 'B';
		ds_origem_carencia_w	:= 'Beneficiario';
	else
		select	count(1)
		into STRICT	cont_w
		from	pls_carencia
		where	nr_seq_contrato		= nr_seq_contrato_w
		and	((nr_seq_plano_contrato = nr_seq_plano_w) or (coalesce(nr_seq_plano_contrato::text, '') = ''))  LIMIT 1;

		if (cont_w > 0) then
			ie_tipo_carencia_w	:= 'C';
			ds_origem_carencia_w	:= 'Contrato';
		else
			select	count(1)
			into STRICT	cont_w
			from	pls_carencia
			where	nr_seq_plano	= nr_seq_plano_w  LIMIT 1;

			if (cont_w > 0) then
				ie_tipo_carencia_w	:= 'P';
				ds_origem_carencia_w	:= 'Produto';
			end if;
		end if;
	end if;
end if;
if (ie_opcao_p = 'DO') then
	ds_retorno_w	:= ds_origem_carencia_w;
elsif (ie_opcao_p = 'TO') then
	ds_retorno_w	:= ie_tipo_carencia_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_origem_carencia_seg (nr_seq_segurado_p bigint, ie_opcao_p text) FROM PUBLIC;

