-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mdc_obter_pontuacao_escala ( ie_escala_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE

nm_tabela_w         varchar(255);
ds_retorno_w        bigint;


BEGIN

nm_tabela_w := obter_tabela_escala(ie_escala_p);

case nm_tabela_w
	when 'ESCALA_SAPS' then
		select max(qt_saps)
        into STRICT ds_retorno_w 
        from escala_saps 
        where nr_sequencia = nr_sequencia_p;
	when 'TISS_INTERV_TERAPEUTICA_10' then
		select max(qt_pontuacao)
        into STRICT ds_retorno_w
        from tiss_interv_terapeutica_10
        where nr_sequencia = nr_sequencia_p;
end case;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mdc_obter_pontuacao_escala ( ie_escala_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
