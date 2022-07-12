-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_equip_analito_fibria (nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE

nm_exame_w exame_laboratorio.nm_exame%TYPE;
nr_seq_exame_w exame_laboratorio.nr_seq_exame%TYPE;


BEGIN
	select 	upper(max(nm_exame))
	into STRICT 	nm_exame_w
	from 	exame_laboratorio
	where 	nr_seq_exame = nr_seq_exame_p;

	if (nm_exame_w = 'RESULTADO') then
		nr_seq_exame_w := nr_seq_exame_p;
	end if;

	if (nm_exame_w <> 'RESULTADO') then
		select 	max(e.nr_seq_exame)
		into STRICT  	nr_seq_exame_w
		from	exame_laboratorio e
		where 	e.ie_solicitacao = 'N'
		and   	upper(e.nm_exame) = 'RESULTADO'
		and   	nr_seq_superior = nr_seq_exame_p
		and   	e.nr_seq_exame = (	SELECT 	nr_seq_exame
									from 	equipamento_lab b,
											lab_exame_equip a
									where 	a.cd_equipamento = b.cd_equipamento
									and		upper(b.ds_sigla) = 'FIBRIA'
									and		a.nr_seq_exame = e.nr_seq_exame);
	end if;

	return obter_equipamento_exame(coalesce(nr_seq_exame_w, nr_seq_exame_p), null, 'FIBRIA');
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_equip_analito_fibria (nr_seq_exame_p bigint) FROM PUBLIC;
