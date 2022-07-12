-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_depend_repasse ( nr_seq_contr_repasse_p bigint, nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Verificar se o dependente do beneficiário é de repasse
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ds_retorno_w			varchar(10);
ie_titularidade_w		varchar(10);
ie_tipo_parentesco_w		varchar(10);
ie_titular_w			varchar(10);
ie_tipo_parentesco_seg_w	varchar(10);
nr_seq_parentesco_w		bigint;
nr_seq_titular_w		bigint;



BEGIN

ds_retorno_w	:= 'N';

select	coalesce(ie_titularidade,'A'),
	ie_tipo_parentesco
into STRICT	ie_titularidade_w,
	ie_tipo_parentesco_w
from	pls_contrato_regra_repasse
where	nr_sequencia	= nr_seq_contr_repasse_p;

select	CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN 'T'  ELSE 'D' END ,
	nr_seq_parentesco,
	nr_seq_titular
into STRICT	ie_titular_w,
	nr_seq_parentesco_w,
	nr_seq_titular_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;


if (nr_seq_parentesco_w IS NOT NULL AND nr_seq_parentesco_w::text <> '') then
	select	ie_tipo_parentesco
	into STRICT	ie_tipo_parentesco_seg_w
	from	grau_parentesco
	where	nr_sequencia	= nr_seq_parentesco_w;
end if;

if	((ie_titularidade_w = ie_titular_w) or (ie_titularidade_w = 'A')) and
	((nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') and (coalesce(ie_tipo_parentesco_w,ie_tipo_parentesco_seg_w)	= ie_tipo_parentesco_seg_w) or (coalesce(nr_seq_titular_w::text, '') = '')) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_depend_repasse ( nr_seq_contr_repasse_p bigint, nr_seq_segurado_p bigint) FROM PUBLIC;

