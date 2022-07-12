-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_consist_grau_partic_duplic ( nr_seq_duplic_grau_part_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint) RETURNS varchar AS $body$
DECLARE


ie_grau_duplicado_w	varchar(1)	:= 'N';
qt_participante_w	bigint;
qt_existe_partic_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_grau_part1,
		nr_seq_grau_part2
	from	pls_duplic_grau_part_item
	where	nr_seq_duplic_grau_part = nr_seq_duplic_grau_part_p
	and	ie_situacao = 'A';

C02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_grau_partic
	from	pls_proc_participante
	where	nr_seq_conta_proc = nr_seq_conta_proc_p;
BEGIN

if (coalesce(nr_seq_conta_proc_p,0) > 0)	then
	select	count(1)
	into STRICT 	qt_participante_w
	from 	pls_proc_participante
	where	nr_seq_conta_proc = nr_seq_conta_proc_p
	and	(nr_seq_grau_partic IS NOT NULL AND nr_seq_grau_partic::text <> '');


	/*Se houver mais de um participante com grau de participação informado*/

	if (qt_participante_w > 1)	then
		for r_c01 in C01 loop
			for r_C02 in c02 loop

				if (r_c01.nr_seq_grau_part1 = r_c02.nr_seq_grau_partic)	then
					/*Verifica se existe um grau de participação duplicado*/

					select	count(1)
					into STRICT	qt_existe_partic_w
					from 	pls_proc_participante
					where	nr_sequencia <> r_c02.nr_sequencia
					and	nr_seq_conta_proc  = nr_seq_conta_proc_p
					and	nr_seq_grau_partic = r_C01.nr_seq_grau_part2;

					if (qt_existe_partic_w > 0)	then
						ie_grau_duplicado_w	:= 'S';
						goto final;
					end if;


				elsif (r_c01.nr_seq_grau_part2 = r_c02.nr_seq_grau_partic)	then
					/*Verifica se existe um grau de participação duplicado*/

					select	count(1)
					into STRICT	qt_existe_partic_w
					from 	pls_proc_participante
					where	nr_sequencia <> r_c02.nr_sequencia
					and	nr_seq_conta_proc  = nr_seq_conta_proc_p
					and	nr_seq_grau_partic = r_C01.nr_seq_grau_part1;

					if (qt_existe_partic_w > 0)	then
						ie_grau_duplicado_w	:= 'S';
						goto final;
					end if;
				end if;

			end loop;
		end loop;


	/*Se houver somente um participante verifica com o grau de participação da conta*/

	elsif (qt_participante_w = 1)	then
		for r_c01 in C01 loop
			for r_C02 in c02 loop
				if (r_c01.nr_seq_grau_part1 = r_c02.nr_seq_grau_partic)	then
					/*Verifica se existe um grau de participação duplicado*/

					select	count(1)
					into STRICT	qt_existe_partic_w
					from	pls_conta
					where	nr_sequencia = nr_seq_conta_p
					and	nr_seq_grau_partic = r_c01.nr_seq_grau_part2;

					if (qt_existe_partic_w > 0)	then
						ie_grau_duplicado_w	:= 'S';
						goto final;
					end if;


				elsif (r_c01.nr_seq_grau_part2 = r_c02.nr_seq_grau_partic)	then
					/*Verifica se existe um grau de participação duplicado*/

					select	count(1)
					into STRICT	qt_existe_partic_w
					from	pls_conta
					where	nr_sequencia = nr_seq_conta_p
					and	nr_seq_grau_partic = r_c01.nr_seq_grau_part2;

					if (qt_existe_partic_w > 0)	then
						ie_grau_duplicado_w	:= 'S';
						goto final;
					end if;
				end if;
			end loop;
		end loop;
	end if;
end if;

<<final>>

return	ie_grau_duplicado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consist_grau_partic_duplic ( nr_seq_duplic_grau_part_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint) FROM PUBLIC;

