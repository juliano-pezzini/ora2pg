-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_acomodac_plano_ptu ( nr_seq_plano_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1000);
nr_seq_tipo_acomodacao_w	bigint;
ds_acomodacao_w			varchar(1000);
ie_tipo_acomod_w		varchar(2);
i_w				bigint;
ds_acomodacao_ptu_w		varchar(255);
ie_tipo_acomodacao_ptu_w	varchar(2);

C01 CURSOR FOR
	SELECT	nr_seq_tipo_acomodacao,
		'T'
	from	pls_plano_acomodacao
	where	nr_seq_plano	= nr_seq_plano_p
	and	(nr_seq_tipo_acomodacao IS NOT NULL AND nr_seq_tipo_acomodacao::text <> '')
	and	ie_acomod_padrao	= 'S'
	
UNION ALL

	SELECT	nr_seq_categoria,
		'C'
	from	pls_plano_acomodacao
	where	nr_seq_plano	= nr_seq_plano_p
	and	(nr_seq_categoria IS NOT NULL AND nr_seq_categoria::text <> '')
	and	ie_acomod_padrao	= 'S';


BEGIN

i_w	:= 0;

open C01;
loop
fetch C01 into
	nr_seq_tipo_acomodacao_w,
	ie_tipo_acomod_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_acomodacao_w	:= '';
	ds_acomodacao_ptu_w := '';
	ie_tipo_acomodacao_ptu_w := 'X';
	i_w	:= i_w + 1;

	if (i_w < 5) then
		if (ie_tipo_acomod_w = 'T') then
			select	ds_tipo_acomodacao,
				ie_tipo_acomodacao_ptu
			into STRICT	ds_acomodacao_w,
				ie_tipo_acomodacao_ptu_w
			from	pls_tipo_acomodacao
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;
		elsif (ie_tipo_acomod_w = 'C') then

			select	max(b.nr_seq_tipo_acomodacao),
				max(a.ds_categoria)
			into STRICT	nr_seq_tipo_acomodacao_w,
				ds_acomodacao_w
			from	pls_regra_categoria	b,
				pls_categoria		a
			where	a.nr_sequencia		= nr_seq_tipo_acomodacao_w
			and	b.nr_seq_categoria	= a.nr_sequencia;
			/*-----------------------------------------------------------------------------------------------------------------------------
			OS 453133 - Dalira - 16/07/2012
			Removida o select ds_tipo_acomodacao por se tratar deum valor que estava sobrescrevendo o valor
			correto do retorno da function, que é a descrição da categoria (conforme utiulizado no dossiê).
			>>>>>>>>VISTO COM DGKORZ
			*/
			select	--ds_tipo_acomodacao,
				ie_tipo_acomodacao_ptu
			into	--ds_acomodacao_w,
				ie_tipo_acomodacao_ptu_w
			from	pls_tipo_acomodacao
			where	nr_sequencia	= nr_seq_tipo_acomodacao_w;

		end if;
		if (coalesce(ie_tipo_acomodacao_ptu_w,'X') = 'A')	 then
			ds_acomodacao_ptu_w := ' ( Enfermaria Intercâmbio - Plano A  )';
		elsif (coalesce(ie_tipo_acomodacao_ptu_w,'X') = 'B')	 then
			ds_acomodacao_ptu_w := ' ( Apartamento Intercâmbio - Plano B  )';
		end if;

		ds_retorno_w	:= ds_retorno_w || ds_acomodacao_w ||ds_acomodacao_ptu_w|| ', ';
	end if;

	end;
end loop;
close C01;

return	substr(ds_retorno_w,1,length(ds_retorno_w)-2);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_acomodac_plano_ptu ( nr_seq_plano_p bigint) FROM PUBLIC;
