-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION con_media_quesito_aval (cd_consultor_p text, nr_seq_proj_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_retorno_w		varchar(15);
qt_resultado_w		varchar(15);


BEGIN

select	round(coalesce((sum(qt_ponto)/count(qt_ponto)),0),2)
into STRICT	qt_resultado_w
from	proj_consultor_aval_quesito a
where	nr_seq_avaliacao in (	SELECT nr_sequencia
				from   proj_consultor_aval
				where  cd_consultor = cd_consultor_p
				and    nr_seq_proj  = nr_seq_proj_p)
and	exists (select	1
		from	proj_avaliacao b
		where	b.nr_sequencia = a.nr_seq_quesito
		and	coalesce(ie_nao_considerar_satisf,'N') = 'N')
and	qt_ponto > 0;
if (ie_opcao_p = 'D') then
	if (qt_resultado_w <= 0) then
	qt_retorno_w := '0';
	end if;
	if (qt_resultado_w > 1.00) and (qt_resultado_w <= 1.99) then
	qt_retorno_w := qt_resultado_w||' - Péssimo';
	end if;
	if (qt_resultado_w > 2.00) and (qt_resultado_w <= 2.99) then
	qt_retorno_w := qt_resultado_w||' - Ruim';
	end if;
	if (qt_resultado_w > 3.00) and (qt_resultado_w <= 3.99) then
	qt_retorno_w := qt_resultado_w||' - Regular';
	end if;
	if (qt_resultado_w > 4.00) and (qt_resultado_w <= 4.99) then
	qt_retorno_w := qt_resultado_w||' - Bom';
	end if;
	if (qt_resultado_w = 5.00) then
	qt_retorno_w := qt_resultado_w||' - Ótimo';
	end if;
elsif (ie_opcao_p = 'V') then
	qt_retorno_w := qt_resultado_w;
elsif (ie_opcao_p = 'VP') then
	if (qt_resultado_w <= 0) then
	qt_retorno_w := '0';
	end if;
	if (qt_resultado_w > 1.00) and (qt_resultado_w <= 1.99) then
	qt_retorno_w := qt_resultado_w;
	end if;
	if (qt_resultado_w > 2.00) and (qt_resultado_w <= 2.99) then
	qt_retorno_w := qt_resultado_w;
	end if;
	if (qt_resultado_w > 3.00) and (qt_resultado_w <= 3.99) then
	qt_retorno_w := qt_resultado_w;
	end if;
	if (qt_resultado_w > 4.00) and (qt_resultado_w <= 4.99) then
	qt_retorno_w := qt_resultado_w;
	end if;
	if (qt_resultado_w = 5.00) then
	qt_retorno_w := qt_resultado_w;
	end if;
end if;


return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION con_media_quesito_aval (cd_consultor_p text, nr_seq_proj_p bigint, ie_opcao_p text) FROM PUBLIC;

