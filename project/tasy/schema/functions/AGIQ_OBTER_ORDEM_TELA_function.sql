-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION agiq_obter_ordem_tela ( nr_seq_ageint_p bigint, ie_tipo_quest_p text, nr_seq_ageint_resp_quest_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_ordem_w			bigint;
lvl_w				bigint;
nr_seq_estrutura_root_w		ageint_resp_quest.nr_seq_estrutura%type;

BEGIN

select	max(x.ordem),
	max(x.lvl),
	max(x.nr_seq_estrutura_root)
into STRICT	nr_seq_ordem_w,
	lvl_w,
	nr_seq_estrutura_root_w
from (WITH RECURSIVE cte AS (
	SELECT	row_number() OVER () AS ordem,1 lvl,a.nr_sequencia,CONNECT_BY_ROOT a.nr_seq_estrutura nr_seq_estrutura_root,ARRAY[ row_number() OVER (ORDER BY (select y.nr_seq_ordem_apres from ageint_quest_estrutura y where y.nr_sequencia = a.nr_seq_estrutura), a.nr_seq_estrutura) ] as hierarchy
	from	ageint_resp_quest a WHERE coalesce(a.nr_seq_superior::text, '') = ''
  UNION ALL
	SELECT	row_number() OVER () AS ordem,(c.level+1) lvl,a.nr_sequencia,CONNECT_BY_ROOT a.nr_seq_estrutura nr_seq_estrutura_root, array_append(c.hierarchy, row_number() OVER (ORDER BY (select y.nr_seq_ordem_apres from ageint_quest_estrutura y where y.nr_sequencia = a.nr_seq_estrutura), a.nr_seq_estrutura))  as hierarchy
	from	ageint_resp_quest a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_superior)

) SELECT * FROM cte WHERE nr_seq_ageint = nr_seq_ageint_p
	and	ie_tipo_quest = ie_tipo_quest_p ORDER BY hierarchy;
) x
where x.nr_sequencia = nr_seq_ageint_resp_quest_p;

if (coalesce(ie_opcao_p,'O') = 'O') then
	return	nr_seq_ordem_w;
elsif (coalesce(ie_opcao_p,'O') = 'L') then
	return	lvl_w;
elsif (coalesce(ie_opcao_p,'O') = 'ER') then
	return	nr_seq_estrutura_root_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agiq_obter_ordem_tela ( nr_seq_ageint_p bigint, ie_tipo_quest_p text, nr_seq_ageint_resp_quest_p bigint, ie_opcao_p text) FROM PUBLIC;

