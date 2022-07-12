-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_existe_area_preparo ( nr_seq_area_p bigint, dt_opcao_p timestamp, nr_seq_local_p bigint, nr_seq_preparo_p bigint, nr_seq_servico_p bigint, cd_setor_atendimento_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);			
qtd_w		integer;
nr_seq_local_w	bigint;

BEGIN

/*SELECT  decode(COUNT(*),0,'N','S')
into	ie_retorno_w
FROM    Nut_Resumo_Dia_v a
WHERE   TRUNC(dt_opcao)    	= dt_opcao_p
AND     nr_seq_area 		= nr_seq_area_p
AND     ((nr_seq_local_p = 0)     	OR (a.nr_seq_local = nr_seq_local_p))
AND     ((nr_seq_servico_p = 0)   	OR (a.nr_seq_servico = nr_seq_servico_p))
AND     ((cd_setor_atendimento_p = 0)   OR (a.cd_setor_atendimento = cd_setor_atendimento_p))
AND     ((nr_seq_preparo_p = 0) 	OR (nut_existe_receita_preparo(a.nr_seq_receita, nr_seq_preparo_p) = 'S'));*/
nr_seq_local_w :=  nut_obter_local_paciente;

--Paciente
SELECT 	COUNT(*)
into STRICT	qtd_w
FROM   	nut_area_prod_rec d,
	nut_receita c,
	nut_pac_opcao_rec b,
	nut_atend_serv_dia a
WHERE	b.nr_seq_receita	   = c.nr_sequencia
AND	c.nr_sequencia		   = d.nr_seq_receita
AND	a.nr_sequencia		   = b.nr_seq_servico_dia
AND	TRUNC(a.dt_servico)    	   = trunc(dt_opcao_p)
AND     nr_seq_area 		   = nr_seq_area_p
AND     ((nr_seq_local_p = 0)     	OR (nr_seq_local_w = nr_seq_local_p))
AND     ((nr_seq_servico_p = 0)   	OR (a.nr_seq_servico = nr_seq_servico_p))
AND     ((cd_setor_atendimento_p = 0)   OR (a.cd_setor_atendimento = cd_setor_atendimento_p))
AND     ((nr_seq_preparo_p = 0) 	OR (nut_existe_receita_preparo(b.nr_seq_receita, nr_seq_preparo_p) = 'S'))
AND	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

--Restaurante
if (qtd_w = 0) then

	SELECT 	COUNT(*)
	into STRICT	qtd_w
	FROM	nut_area_prod_rec d,
		nut_receita c,
		nut_pac_opcao_rec b,
		nut_cardapio_dia a
	WHERE 	b.nr_seq_receita	   = c.nr_sequencia
	AND	c.nr_sequencia	   	   = d.nr_seq_receita
	AND	a.nr_sequencia		   = b.nr_seq_cardapio_dia
	AND	TRUNC(a.dt_cardapio)   	   = trunc(dt_opcao_p)
	AND     nr_seq_area 		   = nr_seq_area_p
	AND     ((nr_seq_local_p = 0)     	OR (a.nr_seq_local = nr_seq_local_p))
	AND     ((nr_seq_servico_p = 0)   	OR (a.nr_seq_servico = nr_seq_servico_p))
	AND     ((nr_seq_preparo_p = 0) 	OR (nut_existe_receita_preparo(b.nr_seq_receita, nr_seq_preparo_p) = 'S'))
	AND	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

end if;


if (qtd_w > 0) then
	ie_retorno_w := 'S';
else	
	ie_retorno_w := 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_existe_area_preparo ( nr_seq_area_p bigint, dt_opcao_p timestamp, nr_seq_local_p bigint, nr_seq_preparo_p bigint, nr_seq_servico_p bigint, cd_setor_atendimento_p bigint ) FROM PUBLIC;
