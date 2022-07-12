-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cme_obter_se_conj_contido (nr_seq_classif_conj_p bigint, nr_seq_classif_p bigint, nr_seq_conjunto_p bigint, nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


c01 CURSOR FOR
	SELECT 	nr_sequencia
	  from 	cm_conjunto
	  where nr_seq_classif = nr_seq_classif_conj_p
	
union

	  SELECT nr_sequencia
	  from 	cm_item
	  where nr_seq_classif = nr_seq_classif_p;

nr_sequencia_w		cm_conjunto.nr_sequencia%type;
ds_lista_w			varchar(4000) := null;


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		if (coalesce(ds_lista_w::text, '') = '') then
			ds_lista_w := substr(nr_sequencia_w,1,2000);
		else
			ds_lista_w := substr(ds_lista_w || ','|| nr_sequencia_w,1,2000);
		end if;
	end if;

end loop;
close c01;

if (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
	if (nr_seq_conjunto_p IS NOT NULL AND nr_seq_conjunto_p::text <> '') then
		return obter_se_contido(nr_seq_conjunto_p, ds_lista_w);
	elsif (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
		return obter_se_contido(nr_seq_item_p, ds_lista_w);
	end if;
end if;

return	'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cme_obter_se_conj_contido (nr_seq_classif_conj_p bigint, nr_seq_classif_p bigint, nr_seq_conjunto_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
