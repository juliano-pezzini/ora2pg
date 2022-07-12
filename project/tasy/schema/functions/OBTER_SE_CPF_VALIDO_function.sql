-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cpf_valido ( nr_cpf_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
i_w			bigint;
j_w			bigint := 0;
nr_digito_calc_w		bigint;
vl_soma_w		bigint := 0;
nr_cpf_w			smallint;
ie_numeros_iguais_w	varchar(1) := 'S';


BEGIN

if (length(nr_cpf_p) > 0) then
	for i_w in 1..length(nr_cpf_p) loop
		if not((substr(nr_cpf_p, i_w, 1) < '0') or (substr(nr_cpf_p, i_w, 1) > '9')) then
			j_w := j_w + 1;
		end if;
	end loop;

	if (j_w = 11) then
		for i_w in 1..9 loop
			vl_soma_w := vl_soma_w + ((substr(nr_cpf_p, i_w, 1))::numeric  * i_w);
		end loop;
		nr_digito_calc_w := vl_soma_w - (trunc(vl_soma_w/11) * 11);
		if (nr_digito_calc_w > 9) then
			nr_digito_calc_w := 0;
		end if;
		if (nr_digito_calc_w = (substr(nr_cpf_p, 10, 1))::numeric ) then
			vl_soma_w := 0;
			for i_w in 2..10 loop
				vl_soma_w := vl_soma_w + ((substr(nr_cpf_p, i_w, 1))::numeric  * (i_w-1));
			end loop;
			nr_digito_calc_w := vl_soma_w - (trunc(vl_soma_w/11)*11);
			if (nr_digito_calc_w > 9) then
				nr_digito_calc_w := 0;
			end if;
			if (nr_digito_calc_w = (substr(nr_cpf_p, 11, 1))::numeric ) then
				ds_retorno_w := 'S';
			end if;
		end if;

		nr_cpf_w := (substr(nr_cpf_p, 1, 1))::numeric;
		for i_w in 2..11 loop
			if (nr_cpf_w <> (substr(nr_cpf_p, i_w, 1))::numeric ) then
				ie_numeros_iguais_w := 'N';
			end if;
		end loop;

		if (ie_numeros_iguais_w = 'S') then
			ds_retorno_w := 'N';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cpf_valido ( nr_cpf_p text) FROM PUBLIC;
