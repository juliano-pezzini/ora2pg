-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hem_obter_nr_lesao_syntax ( nr_seq_lesao_p bigint, ie_opcao_p text default 'A') RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nr_seq_syntax_w	bigint;
nr_seq_lesao_w	bigint;
nr_controle_w	bigint;
qt_lesoes_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		(SELECT	count(b.nr_sequencia)
		from	hem_syntax_lesao b
		where	b.nr_seq_syntax = a.nr_seq_syntax)
	from	hem_syntax_lesao a
	where	a.nr_seq_syntax = nr_seq_syntax_w
	order by 1;


BEGIN
if (coalesce(nr_seq_lesao_p,0) > 0) then
	nr_controle_w := 0;

	select	max(nr_seq_syntax)
	into STRICT	nr_seq_syntax_w
	from	hem_syntax_lesao
	where	nr_sequencia = nr_seq_lesao_p;

	if (coalesce(nr_seq_syntax_w,0) > 0) then
		open C01;
		loop
		fetch C01 into
			nr_seq_lesao_w,
			qt_lesoes_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			nr_controle_w := nr_controle_w + 1;
			if (nr_seq_lesao_w = nr_seq_lesao_p) then
				if (ie_opcao_p = 'B') then
					begin
					ds_retorno_w := nr_controle_w||'° '||wheb_mensagem_pck.get_texto(802555)||' '||qt_lesoes_w;
					end;
				else
					ds_retorno_w := wheb_mensagem_pck.get_texto(802541) || ' '||nr_controle_w;
				end if;
			end if;
			end;
		end loop;
		close C01;
	end if;


end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hem_obter_nr_lesao_syntax ( nr_seq_lesao_p bigint, ie_opcao_p text default 'A') FROM PUBLIC;

