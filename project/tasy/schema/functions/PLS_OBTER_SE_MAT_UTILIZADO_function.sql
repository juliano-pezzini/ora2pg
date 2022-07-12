-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_mat_utilizado (nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

/*
ie_retorno_w
C - Já foi gerada a conta médica para esta Guia, o material não pode ser reprovado
G - Este material / medicamento já está na Guia, e o mesmo será excluído
N - Não utilizado
*/
ie_retorno_w			varchar(2);
qt_reg_guia_w			bigint;
qt_reg_conta_w			bigint;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;


BEGIN
select 	nr_seq_segurado
into STRICT	nr_seq_segurado_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_p;

if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
	select	count(*)
	into STRICT	qt_reg_guia_w
	from	pls_guia_plano_mat 	a,
			pls_guia_plano		b
	where	a.nr_seq_guia	= b.nr_sequencia
	and		nr_seq_guia 	= nr_seq_guia_p
	and		nr_seq_segurado	= nr_seq_segurado_w
	and		a.nr_seq_material	= nr_seq_material_p;

	if (qt_reg_guia_w > 0) then
		ie_retorno_w	:= 'G';

			select  count(1)
			into STRICT	qt_reg_conta_w
			from    pls_protocolo_conta b,
					pls_conta a,
					pls_conta_mat c
			where   a.nr_seq_protocolo	= b.nr_sequencia
			and		c.nr_seq_conta		= a.nr_sequencia
			and		a.nr_seq_guia 		= nr_seq_guia_p
			and		a.nr_seq_segurado	= nr_seq_segurado_w
			and		c.nr_seq_material	= nr_seq_material_p;

		if (qt_reg_conta_w	> 0) then

			select  count(1)
			into STRICT	qt_reg_conta_w
			from    pls_protocolo_conta b,
					pls_conta a,
					pls_conta_mat c
			where   a.nr_seq_protocolo	= b.nr_sequencia
			and		c.nr_seq_conta		= a.nr_sequencia
			and		a.nr_seq_guia 		= nr_seq_guia_p
			and		a.nr_seq_segurado	= nr_seq_segurado_w
			and		c.nr_seq_material	= nr_seq_material_p
			and		c.ie_status			<> 'D'; -- cancelado
			if (qt_reg_conta_w	> 0) then
				ie_retorno_w	:= 'C';
			end if;
		end if;
	else
		ie_retorno_w	:= 'N';
	end if;
else
	ie_retorno_w	:= 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_mat_utilizado (nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type) FROM PUBLIC;

