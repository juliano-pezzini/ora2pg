-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_funda_trafega_wsd ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar se a fundação do beneficiário vai trafegar via WSD
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_congenere_w		pls_congenere.nr_sequencia%type;
nr_seq_congenere_sup_w		pls_congenere.nr_seq_congenere%type;
cd_empresa_w			pessoa_juridica.cd_cgc%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
qt_registros_w			bigint;
ie_retorno_w			varchar(1)	:= 'S';


BEGIN

begin
	select	nr_seq_intercambio
	into STRICT	nr_seq_intercambio_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	nr_seq_intercambio_w	:= null;
end;

if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
	begin
		select	nr_seq_congenere,
			cd_cgc
		into STRICT	nr_seq_congenere_w,
			cd_empresa_w
		from	pls_intercambio
		where	nr_sequencia	= nr_seq_intercambio_w;
	exception
	when others then
		nr_seq_congenere_w	:= null;
		cd_empresa_w		:= null;
	end;

	begin
		select	nr_seq_congenere
		into STRICT	nr_seq_congenere_sup_w
		from	pls_congenere
		where	nr_sequencia	= nr_seq_congenere_w;
	exception
	when others then
		nr_seq_congenere_sup_w	:= null;
	end;

	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_envio_fundac_scs
	where	(coalesce(nr_seq_congenere::text, '') = ''	or ((coalesce(ie_superior,'N') = 'N' and nr_seq_congenere	= nr_seq_congenere_w) or (coalesce(ie_superior,'N') = 'S' and nr_seq_congenere	= nr_seq_congenere_sup_w)))
	and (coalesce(cd_cgc::text, '') = ''	or cd_cgc	= cd_empresa_w)
	and (ie_envia_scs		= 'N');

	if (qt_registros_w	> 0) then
		ie_retorno_w	:= 'N';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_funda_trafega_wsd ( nr_seq_segurado_p bigint) FROM PUBLIC;
