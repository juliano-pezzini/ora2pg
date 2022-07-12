-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_restring_loc_atend_repasee ( nr_seq_contr_repasse_p bigint, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Restringir local de atendimento de repasse
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ds_retorno_w		varchar(10);
ie_tipo_interc_regra_w	varchar(10);
sg_estado_w		pessoa_juridica.sg_estado%type;
sg_estado_int_w		pessoa_juridica.sg_estado%type;
ie_tipo_intercambio_w	varchar(10);
nr_seq_congenere_w	bigint;



BEGIN

ds_retorno_w	:= 'S';

select	coalesce(max(sg_estado),'X')
into STRICT	sg_estado_w
from	pessoa_juridica
where	cd_cgc	= (	SELECT	max(cd_cgc_outorgante)
			from	pls_outorgante
			where	cd_estabelecimento	= cd_estabelecimento_p);

if (coalesce(nr_seq_congenere_p::text, '') = '') then
	return	'S';
else
	select	coalesce(max(a.sg_estado),'X')
	into STRICT	sg_estado_int_w
	from	pessoa_juridica	a,
		pls_congenere	b
	where	a.cd_cgc	= b.cd_cgc
	and	b.nr_sequencia	= nr_seq_congenere_p;

	select	ie_tipo_intercambio,
		nr_seq_congenere
	into STRICT	ie_tipo_interc_regra_w,
		nr_seq_congenere_w
	from	PLS_CONTRATO_REGRA_REPASSE
	where	nr_sequencia	= nr_seq_contr_repasse_p;

	if (ie_tipo_interc_regra_w = 'A') then
		return	'S';
	end if;

	if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
		return	'S';
	end if;

	if (sg_estado_w <> 'X') and (sg_estado_int_w <> 'X') then
		if (sg_estado_w	= sg_estado_int_w) then
			ie_tipo_intercambio_w	:= 'E';
		else
			ie_tipo_intercambio_w	:= 'N';
		end if;
	else
		ie_tipo_intercambio_w	:= 'A';
	end if;

	if	((ie_tipo_intercambio_w = 'A') or (ie_tipo_intercambio_w <> ie_tipo_interc_regra_w)) then
		ds_retorno_w := 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_restring_loc_atend_repasee ( nr_seq_contr_repasse_p bigint, nr_seq_congenere_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

