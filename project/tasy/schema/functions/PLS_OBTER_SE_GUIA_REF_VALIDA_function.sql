-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_guia_ref_valida ( cd_guia_ref_p pls_conta_v.cd_guia_ref%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, ie_tipo_guia_p pls_conta_v.ie_tipo_guia%type, ie_exige_ref_guia_p pls_oc_cta_val_guia_tiss.ie_exige_ref_guia%type, ie_val_guia_tiss_p pls_oc_cta_val_guia_tiss.ie_val_guia_tiss%type, ie_val_benef_p pls_oc_cta_val_guia_tiss.ie_val_benef%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type) RETURNS varchar AS $body$
DECLARE

--O retorno aqui se da ao contrario devido ao fato de quando estiver como 'N' não sera gerada a ocorrência e quando estiver como 'S' irá gerar a mesma
ie_retorno_w	varchar(1)	:= 'N';
qt_guia_w	integer;
qt_tot_guia_w	integer;

BEGIN

if (ie_val_guia_tiss_p = 'S') then
	if (ie_val_benef_p = 'S') then
		if (ie_tipo_guia_p	= 3) then
			--Se for guio de consulta somente será valido se estiver referênciando a própria guia caso contrário será inválido
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	nr_seq_segurado	= nr_seq_segurado_p
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		elsif (ie_tipo_guia_p = 4) then
			--Se for guia de SP/SADT, poderá referenciar guia de consulta SP/SADT e Resumo de internação
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	nr_seq_segurado	= nr_seq_segurado_p
			and	ie_tipo_guia	in ('3','6')
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		elsif (ie_tipo_guia_p in (5,6)) then
			--Quando for guia de resumo de internação ou honorário individual poderá referenciar apenas guia de Resumo de internação
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	nr_seq_segurado	= nr_seq_segurado_p
			and	ie_tipo_guia	in ('3','4','6')
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		end if;
	else
		if (ie_tipo_guia_p	= 3) then
			--Se for guio de consulta somente será valido se estiver referênciando a própria guia caso contrário será inválido
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		elsif (ie_tipo_guia_p = 4) then
			--Se for guia de SP/SADT, poderá referenciar guia de consulta SP/SADT e Resumo de internação
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	ie_tipo_guia	in ('3','6')
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		elsif (ie_tipo_guia_p in (5,6)) then
			--Quando for guia de resumo de internação ou honorário individual poderá referenciar apenas guia de Resumo de internação
			select	count(1)
			into STRICT	qt_guia_w
			from	pls_conta
			where	ie_status in ('A', 'F', 'L', 'P', 'U')
			and	nr_sequencia	!= nr_seq_conta_p
			and	ie_tipo_guia	in ('3','4','6')
			and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
		end if;
	end if;
end if;

if (ie_exige_ref_guia_p	= 'S') then
	if (ie_val_benef_p = 'S') then
		select	count(1)
		into STRICT	qt_tot_guia_w
		from	pls_conta
		where	ie_status in ('A', 'F', 'L', 'P', 'U')
		and	nr_sequencia	!= nr_seq_conta_p
		and	nr_seq_segurado	= nr_seq_segurado_p
		and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
	else
		select	count(1)
		into STRICT	qt_tot_guia_w
		from	pls_conta
		where	ie_status in ('A', 'F', 'L', 'P', 'U')
		and	nr_sequencia	!= nr_seq_conta_p
		and	((cd_guia = cd_guia_ref_p) or (cd_guia_imp	= cd_guia_ref_p));
	end if;
end if;

if	(qt_guia_w 		> 0 AND ie_val_guia_tiss_p 	= 'S')
	or
	(qt_tot_guia_w		= 0 AND ie_exige_ref_guia_p	= 'S') then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_guia_ref_valida ( cd_guia_ref_p pls_conta_v.cd_guia_ref%type, nr_seq_conta_p pls_conta_v.nr_sequencia%type, ie_tipo_guia_p pls_conta_v.ie_tipo_guia%type, ie_exige_ref_guia_p pls_oc_cta_val_guia_tiss.ie_exige_ref_guia%type, ie_val_guia_tiss_p pls_oc_cta_val_guia_tiss.ie_val_guia_tiss%type, ie_val_benef_p pls_oc_cta_val_guia_tiss.ie_val_benef%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type) FROM PUBLIC;
